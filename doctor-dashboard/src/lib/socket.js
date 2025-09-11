import { io } from "socket.io-client";
import { API_CONFIG } from "./apiConfig.js";

class SocketService {
  constructor() {
    this.socket = null;
    this.isConnected = false;
    this.user = null;
    this.listeners = new Map();
  }

  // Initialize socket connection to telemedicine backend
  connect(user) {
    if (this.socket) {
      this.disconnect();
    }

    this.user = user;
    // Use telemedicine backend URL instead of old signaling server
    this.socket = io(API_CONFIG.SOCKET_URL, {
      transports: ["websocket", "polling"],
      timeout: 10000,
      reconnection: true,
      reconnectionAttempts: 5,
      reconnectionDelay: 1000,
    });

    this.setupEventListeners();
    return this.socket;
  }

  // Setup socket event listeners
  setupEventListeners() {
    if (!this.socket) return;

    this.socket.on("connect", () => {
      console.log("Connected to telemedicine backend:", API_CONFIG.SOCKET_URL);
      this.isConnected = true;

      // Authenticate with backend
      this.socket.emit("authenticate", {
        token: localStorage.getItem("auth_token"),
        userType: this.user?.role || "doctor",
        userId: this.user?.id,
        userName: this.user?.name,
      });
    });

    this.socket.on("disconnect", () => {
      console.log("Disconnected from telemedicine backend");
      this.isConnected = false;
    });

    this.socket.on("connect_error", (error) => {
      console.error("Socket connection error:", error);
      this.isConnected = false;
    });

    this.socket.on("authenticated", (data) => {
      console.log("Socket authenticated:", data);
    });

    this.socket.on("authError", (data) => {
      console.error("Socket auth error:", data);
    });
  }

  // Update doctor status
  updateDoctorStatus(status, isAvailable) {
    if (this.isConnected && this.user?.role === "doctor") {
      this.socket.emit("doctorStatusChange", {
        status,
        isAvailable,
      });
    }
  }

  // Join consultation room
  joinConsultationRoom(consultationId) {
    if (this.isConnected) {
      this.socket.emit("joinConsultationRoom", {
        consultationId,
        userType: this.user?.role,
      });
    }
  }

  // Send chat message
  sendConsultationMessage(consultationId, message, messageType = "text") {
    if (this.isConnected) {
      this.socket.emit("consultationMessage", {
        consultationId,
        message,
        messageType,
      });
    }
  }

  // Listen to events
  on(event, callback) {
    if (this.socket) {
      this.socket.on(event, callback);
    }
  }

  // Emit event
  emit(event, data) {
    if (this.isConnected && this.socket) {
      this.socket.emit(event, data);
    }
  }

  // Disconnect
  disconnect() {
    if (this.socket) {
      this.socket.disconnect();
      this.socket = null;
    }
    this.isConnected = false;
    this.user = null;
  }
}

// Create singleton instance
export const socketService = new SocketService();

// For backward compatibility with old socket usage
const URL = import.meta.env.VITE_API_URL || API_CONFIG.SOCKET_URL;
export const socket = io(URL, {
  autoConnect: false,
  transports: ["websocket", "polling"],
});

export default socketService;

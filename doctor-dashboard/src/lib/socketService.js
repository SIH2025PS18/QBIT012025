import { io } from "socket.io-client";
import { socketEvents } from "./api";

class SocketService {
  constructor() {
    this.socket = null;
    this.isConnected = false;
    this.listeners = new Map();
    this.reconnectAttempts = 0;
    this.maxReconnectAttempts = 5;
  }

  // Initialize socket connection
  connect(serverUrl, userData) {
    try {
      if (this.socket) {
        this.disconnect();
      }

      this.socket = io(serverUrl, {
        transports: ["websocket", "polling"],
        autoConnect: false,
        reconnection: true,
        reconnectionDelay: 1000,
        reconnectionAttempts: this.maxReconnectAttempts,
        timeout: 20000,
      });

      this.setupEventListeners();
      this.socket.connect();

      // Register user after connection
      this.socket.on("connect", () => {
        this.isConnected = true;
        this.reconnectAttempts = 0;
        console.log("Connected to socket server");

        if (userData) {
          this.registerUser(userData);
        }

        this.emit("connection_established");
      });

      return Promise.resolve();
    } catch (error) {
      console.error("Socket connection failed:", error);
      return Promise.reject(error);
    }
  }

  // Setup socket event listeners
  setupEventListeners() {
    if (!this.socket) return;

    this.socket.on("connect", () => {
      this.isConnected = true;
      console.log("Socket connected");
    });

    this.socket.on("disconnect", () => {
      this.isConnected = false;
      console.log("Socket disconnected");
      this.emit("connection_lost");
    });

    this.socket.on("connect_error", (error) => {
      console.error("Socket connection error:", error);
      this.reconnectAttempts++;

      if (this.reconnectAttempts >= this.maxReconnectAttempts) {
        this.emit("connection_failed", error);
      }
    });

    this.socket.on("reconnect", () => {
      this.reconnectAttempts = 0;
      console.log("Socket reconnected");
      this.emit("connection_restored");
    });

    // Doctor-related events
    this.socket.on(socketEvents.DOCTOR_ADDED, (data) => {
      this.emit("doctor_added", data);
    });

    this.socket.on(socketEvents.DOCTOR_UPDATED, (data) => {
      this.emit("doctor_updated", data);
    });

    this.socket.on(socketEvents.DOCTOR_DELETED, (data) => {
      this.emit("doctor_deleted", data);
    });

    this.socket.on(socketEvents.DOCTOR_STATUS_CHANGED, (data) => {
      this.emit("doctor_status_changed", data);
    });

    // Patient-related events
    this.socket.on(socketEvents.PATIENT_ADDED, (data) => {
      this.emit("patient_added", data);
    });

    this.socket.on(socketEvents.PATIENT_UPDATED, (data) => {
      this.emit("patient_updated", data);
    });

    this.socket.on(socketEvents.PATIENT_DELETED, (data) => {
      this.emit("patient_deleted", data);
    });

    this.socket.on(socketEvents.PATIENT_STATUS_CHANGED, (data) => {
      this.emit("patient_status_changed", data);
    });

    this.socket.on(socketEvents.PATIENT_ASSIGNED, (data) => {
      this.emit("patient_assigned", data);
    });

    // Consultation-related events
    this.socket.on(socketEvents.CONSULTATION_CREATED, (data) => {
      this.emit("consultation_created", data);
    });

    this.socket.on(socketEvents.CONSULTATION_STARTED, (data) => {
      this.emit("consultation_started", data);
    });

    this.socket.on(socketEvents.CONSULTATION_ENDED, (data) => {
      this.emit("consultation_ended", data);
    });

    // Queue-related events
    this.socket.on(socketEvents.QUEUE_UPDATED, (data) => {
      this.emit("queue_updated", data);
    });

    // Notification events
    this.socket.on(socketEvents.NOTIFICATION, (data) => {
      this.emit("notification", data);
    });

    // Error handling
    this.socket.on("error", (error) => {
      console.error("Socket error:", error);
      this.emit("socket_error", error);
    });
  }

  // Register user with the server
  registerUser(userData) {
    if (!this.isConnected || !this.socket) {
      console.warn("Cannot register user: socket not connected");
      return;
    }

    this.socket.emit("register_user", {
      userId: userData.userId || userData.id,
      userType: userData.userType || userData.role,
      name: userData.name,
      ...userData,
    });

    console.log("User registered with socket server:", userData);
  }

  // Send data to server
  send(event, data) {
    if (!this.isConnected || !this.socket) {
      console.warn(`Cannot send ${event}: socket not connected`);
      return false;
    }

    this.socket.emit(event, data);
    return true;
  }

  // Add event listener
  on(event, callback) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, []);
    }
    this.listeners.get(event).push(callback);
  }

  // Remove event listener
  off(event, callback) {
    if (!this.listeners.has(event)) return;

    const callbacks = this.listeners.get(event);
    const index = callbacks.indexOf(callback);
    if (index > -1) {
      callbacks.splice(index, 1);
    }
  }

  // Emit event to local listeners
  emit(event, data) {
    if (!this.listeners.has(event)) return;

    this.listeners.get(event).forEach((callback) => {
      try {
        callback(data);
      } catch (error) {
        console.error(`Error in ${event} listener:`, error);
      }
    });
  }

  // Join a room
  joinRoom(roomId) {
    if (!this.isConnected || !this.socket) {
      console.warn("Cannot join room: socket not connected");
      return false;
    }

    this.socket.emit("join_room", { roomId });
    return true;
  }

  // Leave a room
  leaveRoom(roomId) {
    if (!this.isConnected || !this.socket) {
      console.warn("Cannot leave room: socket not connected");
      return false;
    }

    this.socket.emit("leave_room", { roomId });
    return true;
  }

  // Send notification to specific user
  sendNotification(targetUserId, message, type = "info") {
    return this.send("send_notification", {
      targetUserId,
      message,
      type,
    });
  }

  // Broadcast doctor status change
  broadcastDoctorStatus(doctorId, status) {
    return this.send("doctor_status_change", {
      doctorId,
      status,
    });
  }

  // Get connection status
  getConnectionStatus() {
    return {
      isConnected: this.isConnected,
      reconnectAttempts: this.reconnectAttempts,
      socketId: this.socket?.id,
    };
  }

  // Disconnect from server
  disconnect() {
    if (this.socket) {
      this.socket.disconnect();
      this.socket = null;
    }
    this.isConnected = false;
    this.listeners.clear();
    console.log("Socket disconnected");
  }

  // Cleanup
  destroy() {
    this.disconnect();
    this.listeners.clear();
  }
}

// Create singleton instance
const socketService = new SocketService();

export default socketService;

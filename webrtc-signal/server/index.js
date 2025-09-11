const express = require("express");
const http = require("http");
const cors = require("cors");
const { Server } = require("socket.io");
const axios = require("axios");

const app = express();
app.use(cors());
app.use(express.json());

const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: "*", methods: ["GET", "POST"], credentials: true },
});

// Store connected users with enhanced data
const users = new Map();
const doctorSessions = new Map(); // Track doctor online sessions
const patientSessions = new Map(); // Track patient sessions
const consultationRooms = new Map(); // Track active consultation rooms

// Backend API configuration
const BACKEND_URL = process.env.BACKEND_URL || "http://localhost:5000";

// Helper function to update doctor status in backend
const updateDoctorStatus = async (doctorId, status) => {
  try {
    await axios.patch(`${BACKEND_URL}/api/doctors/${doctorId}/status`, {
      status: status,
    });
    console.log(`Updated doctor ${doctorId} status to ${status}`);
  } catch (error) {
    console.error(`Failed to update doctor status:`, error.message);
  }
};

// Helper function to broadcast doctor status to patients
const broadcastDoctorStatus = (doctorId, status, isAvailable) => {
  io.emit("doctor_status_changed", {
    doctorId,
    status,
    isAvailable,
    timestamp: Date.now(),
  });
  console.log(
    `Broadcasting doctor ${doctorId} status: ${status} (available: ${isAvailable})`
  );
};

// Helper function to broadcast queue updates
const broadcastQueueUpdate = (doctorId) => {
  io.emit("queue_updated", {
    doctorId,
    timestamp: Date.now(),
  });
};

io.on("connection", (socket) => {
  console.log("User connected:", socket.id);

  // Enhanced user registration with role-based handling
  socket.on("register", async (data) => {
    try {
      const { userId, role, name, doctorId, speciality } = data;
      if (!userId || !role) {
        console.error("Invalid registration data:", data);
        socket.emit("error", { message: "Invalid registration data" });
        return;
      }

      const userInfo = {
        userId,
        role,
        name,
        socketId: socket.id,
        connectedAt: Date.now(),
      };

      // Add role-specific data
      if (role === "doctor") {
        userInfo.doctorId = doctorId || userId;
        userInfo.speciality = speciality;

        // Track doctor session
        doctorSessions.set(userId, {
          ...userInfo,
          patients: [],
          isInConsultation: false,
        });

        // Update doctor status to online in backend
        await updateDoctorStatus(userInfo.doctorId, "online");

        // Broadcast doctor coming online to all patients
        broadcastDoctorStatus(userInfo.doctorId, "online", true);

        // Join doctors room
        socket.join("doctors");

        console.log(
          `Doctor registered: ${name} (${userInfo.doctorId}) - ${speciality}`
        );
      } else if (role === "patient") {
        patientSessions.set(userId, userInfo);
        socket.join("patients");
        console.log(`Patient registered: ${name} (${userId})`);
      } else if (role === "admin") {
        socket.join("admins");
        console.log(`Admin registered: ${name} (${userId})`);
      }

      users.set(socket.id, userInfo);

      // Notify others about new user (excluding sensitive info)
      const publicUserInfo = { userId, role, name };
      socket.broadcast.emit("user_registered", publicUserInfo);

      // Send current online doctors to newly connected patient
      if (role === "patient") {
        const onlineDoctors = Array.from(doctorSessions.values()).map(
          (doc) => ({
            doctorId: doc.doctorId,
            name: doc.name,
            speciality: doc.speciality,
            status: "online",
            isAvailable: !doc.isInConsultation,
          })
        );

        socket.emit("online_doctors", onlineDoctors);
      }
    } catch (error) {
      console.error("Error registering user:", error);
      socket.emit("error", { message: "Failed to register user" });
    }
  });

  // Join consultation room
  socket.on("join_consultation", (data) => {
    try {
      const { consultationId, userId, role } = data;
      if (!consultationId || !userId || !role) {
        console.error("Invalid join_consultation data:", data);
        socket.emit("error", { message: "Invalid consultation data" });
        return;
      }

      socket.join(consultationId);
      console.log(`User ${userId} joined consultation ${consultationId}`);

      // Notify others in the room
      socket.to(consultationId).emit("user_joined", { userId, role });
    } catch (error) {
      console.error("Error joining consultation:", error);
      socket.emit("error", { message: "Failed to join consultation" });
    }
  });

  // Handle call initiation
  socket.on("initiate_call", (data) => {
    try {
      console.log("Call initiation request:", data);

      if (!data.to || !data.from) {
        console.error("Invalid call initiation data:", data);
        socket.emit("error", { message: "Invalid call initiation data" });
        return;
      }

      // Find target user and notify them
      const targetUser = Array.from(users.values()).find(
        (user) => user.userId === data.to
      );
      if (targetUser) {
        io.to(targetUser.socketId).emit("incoming_call", data);
      } else {
        console.warn(`Target user ${data.to} not found for call initiation`);
        socket.emit("error", { message: "Target user not found" });
      }
    } catch (error) {
      console.error("Error initiating call:", error);
      socket.emit("error", { message: "Failed to initiate call" });
    }
  });

  // Handle call acceptance
  socket.on("accept_call", (data) => {
    try {
      console.log("Call accepted:", data);

      if (!data.from || !data.to) {
        console.error("Invalid call acceptance data:", data);
        socket.emit("error", { message: "Invalid call acceptance data" });
        return;
      }

      // Notify both parties
      const caller = Array.from(users.values()).find(
        (user) => user.userId === data.from
      );
      const callee = Array.from(users.values()).find(
        (user) => user.userId === data.to
      );

      if (caller) {
        io.to(caller.socketId).emit("call_accepted", data);
      }

      if (callee) {
        io.to(callee.socketId).emit("call_accepted", data);
      }
    } catch (error) {
      console.error("Error accepting call:", error);
      socket.emit("error", { message: "Failed to accept call" });
    }
  });

  // Handle call rejection
  socket.on("reject_call", (data) => {
    try {
      console.log("Call rejected:", data);

      if (!data.from || !data.to) {
        console.error("Invalid call rejection data:", data);
        socket.emit("error", { message: "Invalid call rejection data" });
        return;
      }

      const caller = Array.from(users.values()).find(
        (user) => user.userId === data.from
      );
      if (caller) {
        io.to(caller.socketId).emit("call_rejected", data);
      }
    } catch (error) {
      console.error("Error rejecting call:", error);
      socket.emit("error", { message: "Failed to reject call" });
    }
  });

  // Handle WebRTC signaling
  socket.on("webrtc-signal", (payload) => {
    try {
      console.log("WebRTC signal received:", payload);

      if (!payload.to || !payload.from || !payload.signal) {
        console.error("Invalid WebRTC signal payload:", payload);
        socket.emit("error", { message: "Invalid WebRTC signal payload" });
        return;
      }

      // Find target user and send signal directly
      const targetUser = Array.from(users.values()).find(
        (user) => user.userId === payload.to
      );
      if (targetUser) {
        io.to(targetUser.socketId).emit("webrtc-signal", payload);
      } else {
        // Fallback: broadcast to all (less efficient)
        socket.broadcast.emit("webrtc-signal", payload);
        console.warn(
          `Target user ${payload.to} not found, broadcasting signal`
        );
      }
    } catch (error) {
      console.error("Error handling WebRTC signal:", error);
      socket.emit("error", { message: "Failed to handle WebRTC signal" });
    }
  });

  // Handle call end
  socket.on("webrtc-end", (payload) => {
    try {
      console.log("WebRTC call ended:", payload);

      if (!payload.to || !payload.from) {
        console.error("Invalid call end payload:", payload);
        socket.emit("error", { message: "Invalid call end payload" });
        return;
      }

      // Find target user and send end signal
      const targetUser = Array.from(users.values()).find(
        (user) => user.userId === payload.to
      );
      if (targetUser) {
        io.to(targetUser.socketId).emit("webrtc-end", payload);
      } else {
        socket.broadcast.emit("webrtc-end", payload);
        console.warn(
          `Target user ${payload.to} not found, broadcasting end signal`
        );
      }
    } catch (error) {
      console.error("Error ending call:", error);
      socket.emit("error", { message: "Failed to end call" });
    }
  });

  // Handle prescription submission
  socket.on("prescription_submitted", (payload) => {
    try {
      console.log("Prescription submitted:", payload);

      if (!payload.patientId) {
        console.error("Invalid prescription data:", payload);
        socket.emit("error", { message: "Invalid prescription data" });
        return;
      }

      // Find target user (patient) and send prescription
      const targetUser = Array.from(users.values()).find(
        (user) => user.userId === payload.patientId
      );
      if (targetUser) {
        io.to(targetUser.socketId).emit("prescription_submitted", payload);
      } else {
        console.warn(
          `Target patient ${payload.patientId} not found for prescription`
        );
        socket.emit("error", { message: "Target patient not found" });
      }
    } catch (error) {
      console.error("Error submitting prescription:", error);
      socket.emit("error", { message: "Failed to submit prescription" });
    }
  });

  // Handle chat messages
  socket.on("chat_message", (payload) => {
    try {
      console.log("Chat message:", payload);

      if (!payload.consultationId) {
        console.error("Invalid chat message data:", payload);
        socket.emit("error", { message: "Invalid chat message data" });
        return;
      }

      // Send to all users in the consultation room except sender
      socket.to(payload.consultationId).emit("chat_message", payload);
    } catch (error) {
      console.error("Error handling chat message:", error);
      socket.emit("error", { message: "Failed to send chat message" });
    }
  });

  // Handle recording events
  socket.on("recording_started", (payload) => {
    try {
      console.log("Recording started:", payload);

      if (!payload.consultationId) {
        console.error("Invalid recording start data:", payload);
        socket.emit("error", { message: "Invalid recording data" });
        return;
      }

      socket.to(payload.consultationId).emit("recording_started", payload);
    } catch (error) {
      console.error("Error handling recording start:", error);
      socket.emit("error", { message: "Failed to start recording" });
    }
  });

  socket.on("recording_stopped", (payload) => {
    try {
      console.log("Recording stopped:", payload);

      if (!payload.consultationId) {
        console.error("Invalid recording stop data:", payload);
        socket.emit("error", { message: "Invalid recording data" });
        return;
      }

      socket.to(payload.consultationId).emit("recording_stopped", payload);
    } catch (error) {
      console.error("Error handling recording stop:", error);
      socket.emit("error", { message: "Failed to stop recording" });
    }
  });

  // Handle user disconnection
  socket.on("disconnect", () => {
    try {
      console.log("User disconnected:", socket.id);

      const user = users.get(socket.id);
      if (user) {
        // Notify others about disconnection
        socket.broadcast.emit("user_disconnected", { userId: user.userId });
        users.delete(socket.id);
      }
    } catch (error) {
      console.error("Error handling user disconnection:", error);
    }
  });

  // Handle general errors
  socket.on("error", (error) => {
    console.error("Socket error:", error);
  });
});

const PORT = process.env.PORT || 4000;
server.listen(PORT, () => {
  console.log(`WebRTC Signaling Server listening on port ${PORT}`);
});

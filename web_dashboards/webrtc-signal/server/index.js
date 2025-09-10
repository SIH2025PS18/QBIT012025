const express = require("express");
const http = require("http");
const cors = require("cors");
const { Server } = require("socket.io");

const app = express();
app.use(cors());
app.use(express.json());

const server = http.createServer(app);
const io = new Server(server, {
  cors: { 
    origin: "*", 
    methods: ["GET","POST"], 
    credentials: true 
  }
});

// Store connected users
const users = new Map();

io.on("connection", (socket) => {
  console.log("User connected:", socket.id);

  // Register user with their ID and role
  socket.on("register", (data) => {
    try {
      const { userId, role, name } = data;
      if (!userId || !role) {
        console.error("Invalid registration data:", data);
        return;
      }
      
      users.set(socket.id, { userId, role, name, socketId: socket.id });
      console.log(`User registered: ${userId} as ${role}`);
      
      // Notify others about new user
      socket.broadcast.emit("user_registered", { userId, role, name });
    } catch (error) {
      console.error("Error registering user:", error);
    }
  });

  // Join consultation room
  socket.on("join_consultation", (data) => {
    try {
      const { consultationId, userId, role } = data;
      if (!consultationId || !userId || !role) {
        console.error("Invalid join_consultation data:", data);
        return;
      }
      
      socket.join(consultationId);
      console.log(`User ${userId} joined consultation ${consultationId}`);
      
      // Notify others in the room
      socket.to(consultationId).emit("user_joined", { userId, role });
    } catch (error) {
      console.error("Error joining consultation:", error);
    }
  });

  // Handle WebRTC signaling
  socket.on("webrtc-signal", (payload) => {
    try {
      console.log("WebRTC signal received:", payload);
      
      if (!payload.to || !payload.from || !payload.signal) {
        console.error("Invalid WebRTC signal payload:", payload);
        return;
      }
      
      // Find target user and send signal directly
      const targetUser = Array.from(users.values()).find(user => user.userId === payload.to);
      if (targetUser) {
        io.to(targetUser.socketId).emit("webrtc-signal", payload);
      } else {
        // Fallback: broadcast to all (less efficient)
        socket.broadcast.emit("webrtc-signal", payload);
        console.warn(`Target user ${payload.to} not found, broadcasting signal`);
      }
    } catch (error) {
      console.error("Error handling WebRTC signal:", error);
    }
  });

  // Handle call initiation
  socket.on("initiate_call", (data) => {
    try {
      console.log("Call initiation request:", data);
      
      if (!data.to || !data.from) {
        console.error("Invalid call initiation data:", data);
        return;
      }
      
      // Find target user and notify them
      const targetUser = Array.from(users.values()).find(user => user.userId === data.to);
      if (targetUser) {
        io.to(targetUser.socketId).emit("incoming_call", data);
      } else {
        console.warn(`Target user ${data.to} not found for call initiation`);
      }
    } catch (error) {
      console.error("Error initiating call:", error);
    }
  });

  // Handle call acceptance
  socket.on("accept_call", (data) => {
    try {
      console.log("Call accepted:", data);
      
      if (!data.from || !data.to) {
        console.error("Invalid call acceptance data:", data);
        return;
      }
      
      // Notify both parties
      const caller = Array.from(users.values()).find(user => user.userId === data.from);
      const callee = Array.from(users.values()).find(user => user.userId === data.to);
      
      if (caller) {
        io.to(caller.socketId).emit("call_accepted", data);
      }
      
      if (callee) {
        io.to(callee.socketId).emit("call_accepted", data);
      }
    } catch (error) {
      console.error("Error accepting call:", error);
    }
  });

  // Handle call rejection
  socket.on("reject_call", (data) => {
    try {
      console.log("Call rejected:", data);
      
      if (!data.from || !data.to) {
        console.error("Invalid call rejection data:", data);
        return;
      }
      
      const caller = Array.from(users.values()).find(user => user.userId === data.from);
      if (caller) {
        io.to(caller.socketId).emit("call_rejected", data);
      }
    } catch (error) {
      console.error("Error rejecting call:", error);
    }
  });

  // Handle call end
  socket.on("webrtc-end", (payload) => {
    try {
      console.log("WebRTC call ended:", payload);
      
      if (!payload.to || !payload.from) {
        console.error("Invalid call end payload:", payload);
        return;
      }
      
      // Find target user and send end signal
      const targetUser = Array.from(users.values()).find(user => user.userId === payload.to);
      if (targetUser) {
        io.to(targetUser.socketId).emit("webrtc-end", payload);
      } else {
        socket.broadcast.emit("webrtc-end", payload);
        console.warn(`Target user ${payload.to} not found, broadcasting end signal`);
      }
    } catch (error) {
      console.error("Error ending call:", error);
    }
  });

  // Handle prescription submission
  socket.on("prescription_submitted", (payload) => {
    try {
      console.log("Prescription submitted:", payload);
      
      if (!payload.patientId) {
        console.error("Invalid prescription data:", payload);
        return;
      }
      
      // Find target user (patient) and send prescription
      const targetUser = Array.from(users.values()).find(user => user.userId === payload.patientId);
      if (targetUser) {
        io.to(targetUser.socketId).emit("prescription_submitted", payload);
      } else {
        console.warn(`Target patient ${payload.patientId} not found for prescription`);
      }
    } catch (error) {
      console.error("Error submitting prescription:", error);
    }
  });

  // Handle chat messages
  socket.on("chat_message", (payload) => {
    try {
      console.log("Chat message:", payload);
      
      if (!payload.consultationId) {
        console.error("Invalid chat message data:", payload);
        return;
      }
      
      // Send to all users in the consultation room except sender
      socket.to(payload.consultationId).emit("chat_message", payload);
    } catch (error) {
      console.error("Error handling chat message:", error);
    }
  });

  // Handle recording events
  socket.on("recording_started", (payload) => {
    try {
      console.log("Recording started:", payload);
      
      if (!payload.consultationId) {
        console.error("Invalid recording start data:", payload);
        return;
      }
      
      socket.to(payload.consultationId).emit("recording_started", payload);
    } catch (error) {
      console.error("Error handling recording start:", error);
    }
  });

  socket.on("recording_stopped", (payload) => {
    try {
      console.log("Recording stopped:", payload);
      
      if (!payload.consultationId) {
        console.error("Invalid recording stop data:", payload);
        return;
      }
      
      socket.to(payload.consultationId).emit("recording_stopped", payload);
    } catch (error) {
      console.error("Error handling recording stop:", error);
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
});

const PORT = process.env.PORT || 4000;
server.listen(PORT, () => {
  console.log(`WebRTC Signaling Server listening on port ${PORT}`);
});
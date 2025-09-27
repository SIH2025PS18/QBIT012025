const jwt = require("jsonwebtoken");
const Doctor = require("../models/Doctor");
const Patient = require("../models/Patient");
const Consultation = require("../models/Consultation");

// Store connected users
const connectedUsers = new Map();
const doctorSessions = new Map();
const patientSessions = new Map();
const consultationRooms = new Map();

const socketAuth = async (socket, token) => {
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    let user;
    let Model;

    switch (decoded.userType) {
      case "patient":
        Model = Patient;
        break;
      case "doctor":
        Model = Doctor;
        break;
      default:
        return null;
    }

    user = await Model.findById(decoded.id).select("-password");
    if (!user) return null;

    return {
      ...user.toObject(),
      userType: decoded.userType,
    };
  } catch (error) {
    return null;
  }
};

const socketHandlers = (io) => {
  io.use(async (socket, next) => {
    try {
      const token = socket.handshake.auth.token || socket.handshake.query.token;

      // Allow guest patient connections for testing
      if (!token && socket.handshake.query.userRole === 'patient') {
        console.log("🧪 Allowing guest patient connection for testing");
        socket.user = {
          _id: `guest_patient_${Date.now()}`,
          name: socket.handshake.query.userName || 'Guest Patient',
          userType: 'patient'
        };
        return next();
      }

      if (!token) {
        return next(new Error("Authentication error: No token provided"));
      }

      const user = await socketAuth(socket, token);
      if (!user) {
        return next(new Error("Authentication error: Invalid token"));
      }

      socket.user = user;
      next();
    } catch (error) {
      next(new Error("Authentication error"));
    }
  });

  io.on("connection", async (socket) => {
    console.log(
      `✅ User connected: ${socket.user.name} (${socket.user.userType})`
    );

    const userId = socket.user._id.toString();
    const userType = socket.user.userType;

    // Store connected user
    connectedUsers.set(socket.id, {
      userId,
      userType,
      user: socket.user,
      connectedAt: new Date(),
    });

    // Join user to their personal room
    socket.join(`user_${userId}`);

    // Handle doctor-specific connections
    if (userType === "doctor") {
      doctorSessions.set(userId, {
        socketId: socket.id,
        status: "online",
        connectedAt: new Date(),
      });

      // Update doctor status in database
      await Doctor.findByIdAndUpdate(userId, {
        status: "online",
        lastActive: new Date(),
      });

      // Join doctor to their specialty room
      socket.join(`specialty_${socket.user.speciality}`);

      // Broadcast doctor status change
      socket.broadcast.emit("doctor_status_changed", {
        doctorId: userId,
        status: "online",
        isAvailable: socket.user.isAvailable,
        timestamp: new Date(),
      });

      console.log(`🩺 Doctor ${socket.user.name} is now online`);
    }

    // Handle patient-specific connections
    if (userType === "patient") {
      patientSessions.set(userId, {
        socketId: socket.id,
        connectedAt: new Date(),
      });

      console.log(`👤 Patient ${socket.user.name} connected`);
    }

    // Handle doctor status updates
    socket.on("update_doctor_status", async (data) => {
      if (userType !== "doctor") return;

      try {
        const { status, isAvailable } = data;

        await Doctor.findByIdAndUpdate(userId, {
          status,
          isAvailable,
          lastActive: new Date(),
        });

        // Update session
        if (doctorSessions.has(userId)) {
          doctorSessions.get(userId).status = status;
        }

        // Broadcast to all clients
        io.emit("doctor_status_changed", {
          doctorId: userId,
          status,
          isAvailable,
          timestamp: new Date(),
        });

        socket.emit("status_updated", { success: true, status, isAvailable });
        console.log(
          `🔄 Doctor ${socket.user.name} status updated: ${status} (available: ${isAvailable})`
        );
      } catch (error) {
        console.error("Error updating doctor status:", error);
        socket.emit("status_update_error", {
          message: "Failed to update status",
        });
      }
    });

    // Handle consultation room join
    socket.on("join_consultation", async (data) => {
      try {
        const { consultationId } = data;

        // Verify consultation exists and user has access
        const consultation = await Consultation.findOne({
          consultationId,
          $or: [
            { patient: userType === "patient" ? userId : undefined },
            { doctor: userType === "doctor" ? userId : undefined },
          ],
        }).populate("patient doctor");

        if (!consultation) {
          socket.emit("consultation_error", {
            message: "Consultation not found or access denied",
          });
          return;
        }

        // Join consultation room
        socket.join(`consultation_${consultationId}`);

        // Store room info
        if (!consultationRooms.has(consultationId)) {
          consultationRooms.set(consultationId, {
            consultation,
            participants: new Set(),
            createdAt: new Date(),
          });
        }

        const room = consultationRooms.get(consultationId);
        room.participants.add({
          userId,
          userType,
          socketId: socket.id,
          joinedAt: new Date(),
        });

        // Notify other participants
        socket
          .to(`consultation_${consultationId}`)
          .emit("user_joined_consultation", {
            userId,
            userType,
            userName: socket.user.name,
            timestamp: new Date(),
          });

        socket.emit("consultation_joined", {
          consultationId,
          consultation: {
            id: consultation._id,
            consultationId: consultation.consultationId,
            status: consultation.status,
            patient: consultation.patient,
            doctor: consultation.doctor,
            scheduledAt: consultation.scheduledAt,
          },
        });

        console.log(
          `💬 ${socket.user.name} joined consultation ${consultationId}`
        );
      } catch (error) {
        console.error("Error joining consultation:", error);
        socket.emit("consultation_error", {
          message: "Failed to join consultation",
        });
      }
    });

    // Handle chat messages in consultation
    socket.on("consultation_message", async (data) => {
      try {
        const { consultationId, message, type = "text", attachmentUrl } = data;

        // Verify user is in consultation
        const rooms = Array.from(socket.rooms);
        if (!rooms.includes(`consultation_${consultationId}`)) {
          socket.emit("message_error", { message: "Not in consultation room" });
          return;
        }

        // Save message to database
        const consultation = await Consultation.findOne({ consultationId });
        if (!consultation) {
          socket.emit("message_error", { message: "Consultation not found" });
          return;
        }

        await consultation.addChatMessage(
          userType,
          message,
          type,
          attachmentUrl
        );

        // Broadcast message to consultation room
        const messageData = {
          consultationId,
          sender: userType,
          senderName: socket.user.name,
          message,
          type,
          attachmentUrl,
          timestamp: new Date(),
        };

        io.to(`consultation_${consultationId}`).emit(
          "new_consultation_message",
          messageData
        );
        console.log(
          `💬 Message in consultation ${consultationId}: ${socket.user.name} (${userType})`
        );
      } catch (error) {
        console.error("Error sending consultation message:", error);
        socket.emit("message_error", { message: "Failed to send message" });
      }
    });

    // Handle consultation status updates
    socket.on("update_consultation_status", async (data) => {
      if (userType !== "doctor") return;

      try {
        const { consultationId, status } = data;

        const consultation = await Consultation.findOneAndUpdate(
          { consultationId, doctor: userId },
          { status, updatedAt: new Date() },
          { new: true }
        ).populate("patient doctor");

        if (!consultation) {
          socket.emit("consultation_error", {
            message: "Consultation not found",
          });
          return;
        }

        // Broadcast status update
        io.to(`consultation_${consultationId}`).emit(
          "consultation_status_updated",
          {
            consultationId,
            status,
            updatedBy: socket.user.name,
            timestamp: new Date(),
          }
        );

        // Notify patient specifically
        io.to(`user_${consultation.patient._id}`).emit("consultation_update", {
          consultationId,
          status,
          message: `Dr. ${socket.user.name} ${status} the consultation`,
        });

        console.log(
          `🔄 Consultation ${consultationId} status updated to: ${status}`
        );
      } catch (error) {
        console.error("Error updating consultation status:", error);
        socket.emit("consultation_error", {
          message: "Failed to update consultation status",
        });
      }
    });

    // Handle video call signaling
    socket.on("call_offer", (data) => {
      const { consultationId, offer, targetUserId } = data;

      socket.to(`user_${targetUserId}`).emit("call_offer", {
        consultationId,
        offer,
        from: {
          userId,
          userType,
          name: socket.user.name,
        },
      });
    });

    socket.on("call_answer", (data) => {
      const { consultationId, answer, targetUserId } = data;

      socket.to(`user_${targetUserId}`).emit("call_answer", {
        consultationId,
        answer,
        from: {
          userId,
          userType,
          name: socket.user.name,
        },
      });
    });

    socket.on("ice_candidate", (data) => {
      const { consultationId, candidate, targetUserId } = data;

      socket.to(`user_${targetUserId}`).emit("ice_candidate", {
        consultationId,
        candidate,
        from: {
          userId,
          userType,
          name: socket.user.name,
        },
      });
    });

    // Handle queue updates
    socket.on("get_queue_status", async (data) => {
      if (userType !== "doctor") return;

      try {
        const queue = await Consultation.findInQueue(userId);

        socket.emit("queue_status", {
          queue: queue.map((consultation) => ({
            consultationId: consultation.consultationId,
            patient: consultation.patient,
            scheduledAt: consultation.scheduledAt,
            priority: consultation.priority,
            symptoms: consultation.symptoms,
            waitTime: Math.round(
              (new Date() - consultation.scheduledAt) / (1000 * 60)
            ), // minutes
          })),
          totalWaiting: queue.length,
        });
      } catch (error) {
        console.error("Error getting queue status:", error);
        socket.emit("queue_error", { message: "Failed to get queue status" });
      }
    });

    // Handle patient joining doctor queue
    socket.on("join_queue", (data) => {
      console.log("📋 Patient joining queue:", data);
      
      const { doctorId, patientId, patientName, symptoms, timestamp } = data;
      
      // Find the doctor's socket and send the queue event
      for (let [socketId, userData] of connectedUsers) {
        if (userData.userType === 'doctor' && userData.userId === doctorId) {
          const doctorSocket = io.sockets.sockets.get(socketId);
          if (doctorSocket) {
            doctorSocket.emit('join_queue', {
              patientId,
              patientName,
              symptoms,
              timestamp
            });
            console.log(`✅ Forwarded join_queue event to doctor ${doctorId}`);
          }
          break;
        }
      }
    });

    // Handle patient leaving doctor queue  
    socket.on("leave_queue", (data) => {
      console.log("📋 Patient leaving queue:", data);
      
      const { doctorId, patientId } = data;
      
      // Find the doctor's socket and send the leave queue event
      for (let [socketId, userData] of connectedUsers) {
        if (userData.userType === 'doctor' && userData.userId === doctorId) {
          const doctorSocket = io.sockets.sockets.get(socketId);
          if (doctorSocket) {
            doctorSocket.emit('leave_queue', {
              patientId
            });
            console.log(`✅ Forwarded leave_queue event to doctor ${doctorId}`);
          }
          break;
        }
      }
    });

    // Handle patient starting video call
    socket.on("patient_start_call", (data) => {
      console.log("📞 Patient starting video call:", data);
      
      const { doctorId, patientId, patientName, channelName, symptoms, timestamp } = data;
      
      // Find the doctor's socket and send the video call event
      for (let [socketId, userData] of connectedUsers) {
        if (userData.userType === 'doctor' && userData.userId === doctorId) {
          const doctorSocket = io.sockets.sockets.get(socketId);
          if (doctorSocket) {
            doctorSocket.emit('patient_start_call', {
              patientId,
              patientName,
              channelName,
              symptoms,
              timestamp
            });
            console.log(`✅ Forwarded patient_start_call event to doctor ${doctorId}`);
          }
          break;
        }
      }
    });

    // Handle patient ending video call
    socket.on("patient_end_call", (data) => {
      console.log("📞 Patient ending video call:", data);
      
      const { doctorId, patientId, channelName } = data;
      
      // Find the doctor's socket and send the end call event
      for (let [socketId, userData] of connectedUsers) {
        if (userData.userType === 'doctor' && userData.userId === doctorId) {
          const doctorSocket = io.sockets.sockets.get(socketId);
          if (doctorSocket) {
            doctorSocket.emit('patient_end_call', {
              patientId,
              channelName
            });
            console.log(`✅ Forwarded patient_end_call event to doctor ${doctorId}`);
          }
          break;
        }
      }
    });

    // Handle disconnection
    socket.on("disconnect", async () => {
      console.log(
        `❌ User disconnected: ${socket.user.name} (${socket.user.userType})`
      );

      // Clean up connected users
      connectedUsers.delete(socket.id);

      // Handle doctor disconnection
      if (userType === "doctor") {
        doctorSessions.delete(userId);

        // Update doctor status to offline
        await Doctor.findByIdAndUpdate(userId, {
          status: "offline",
          lastActive: new Date(),
        });

        // Broadcast doctor status change
        socket.broadcast.emit("doctor_status_changed", {
          doctorId: userId,
          status: "offline",
          isAvailable: false,
          timestamp: new Date(),
        });

        console.log(`🩺 Doctor ${socket.user.name} is now offline`);
      }

      // Handle patient disconnection
      if (userType === "patient") {
        patientSessions.delete(userId);
        console.log(`👤 Patient ${socket.user.name} disconnected`);
      }

      // Clean up consultation rooms
      consultationRooms.forEach((room, consultationId) => {
        room.participants.forEach((participant) => {
          if (participant.socketId === socket.id) {
            room.participants.delete(participant);

            // Notify other participants
            socket
              .to(`consultation_${consultationId}`)
              .emit("user_left_consultation", {
                userId,
                userType,
                userName: socket.user.name,
                timestamp: new Date(),
              });
          }
        });

        // Remove empty rooms
        if (room.participants.size === 0) {
          consultationRooms.delete(consultationId);
        }
      });
    });

    // Send current online status
    socket.emit("connection_established", {
      user: {
        id: socket.user._id,
        name: socket.user.name,
        userType: socket.user.userType,
      },
      onlineUsers: {
        doctors: doctorSessions.size,
        patients: patientSessions.size,
        total: connectedUsers.size,
      },
      timestamp: new Date(),
    });
  });

  // Utility function to broadcast to all connected users
  io.broadcastToAll = (event, data) => {
    io.emit(event, data);
  };

  // Utility function to send to specific user
  io.sendToUser = (userId, event, data) => {
    io.to(`user_${userId}`).emit(event, data);
  };

  // Utility function to send to doctors by specialty
  io.sendToSpecialty = (specialty, event, data) => {
    io.to(`specialty_${specialty}`).emit(event, data);
  };
};

module.exports = socketHandlers;

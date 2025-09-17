const express = require("express");
const cors = require("cors");
const dotenv = require("dotenv");
const path = require("path");
const http = require("http");
const socketIo = require("socket.io");
const connectDB = require("./config/database");

// Load environment variables
dotenv.config();

// Connect to database
connectDB();

// Import all routes
const authRoutes = require("./routes/auth");
const doctorRoutes = require("./routes/doctors");
const patientRoutes = require("./routes/patients");
const consultationRoutes = require("./routes/consultations");
const medicineRoutes = require("./routes/medicines");
const orderRoutes = require("./routes/orders");
const pharmacyRoutes = require("./routes/pharmacies");
const queueRoutes = require("./routes/queue");
const chatRoutes = require("./routes/chat");
const callRoutes = require("./routes/calls");
const adminRoutes = require("./routes/admin");
const familyRoutes = require("./routes/family");
const smartPharmacyRoutes = require("./routes/smart_pharmacy");

const app = express();
const server = http.createServer(app);

// Socket.IO setup
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

// Middleware
app.use(cors());
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true, limit: "10mb" }));
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/doctors", doctorRoutes);
app.use("/api/patients", patientRoutes);
app.use("/api/consultations", consultationRoutes);
app.use("/api/medicines", medicineRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/pharmacies", pharmacyRoutes);
app.use("/api/queue", queueRoutes);
app.use("/api/chat", chatRoutes);
app.use("/api/calls", callRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/family", familyRoutes);
app.use("/api/smart-pharmacy", smartPharmacyRoutes);

// API info endpoint
app.get("/api", (req, res) => {
  res.json({
    success: true,
    message: "Telemed Unified Backend API",
    version: "2.0.0",
    endpoints: {
      auth: "/api/auth",
      doctors: "/api/doctors",
      patients: "/api/patients",
      consultations: "/api/consultations",
      medicines: "/api/medicines",
      orders: "/api/orders",
      pharmacies: "/api/pharmacies",
      queue: "/api/queue",
      chat: "/api/chat",
      calls: "/api/calls",
      admin: "/api/admin",
      family: "/api/family",
      "smart-pharmacy": "/api/smart-pharmacy",
      health: "/api/health",
    },
    documentation: "Complete telemedicine platform API",
  });
});

// Health check endpoint
app.get("/api/health", (req, res) => {
  res.json({
    success: true,
    message: "Unified Backend is running successfully!",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    services: {
      database: "connected",
      socket: "active",
      api: "operational",
    },
  });
});

// Socket.IO connection handling
require("./sockets/socketHandlers")(io);

// Make socket.IO available to other modules
module.exports.io = io;

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);

  if (err.name === "MulterError") {
    if (err.code === "LIMIT_FILE_SIZE") {
      return res
        .status(400)
        .json({ message: "File too large. Maximum size is 5MB." });
    }
  }

  if (err.message === "Only image files are allowed!") {
    return res.status(400).json({ message: err.message });
  }

  res.status(500).json({
    success: false,
    message: "Something went wrong!",
    error:
      process.env.NODE_ENV === "development"
        ? err.message
        : "Internal server error",
  });
});

// Handle 404 errors
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: "API endpoint not found",
    availableEndpoints: "/api",
  });
});

const PORT = process.env.PORT || 5001;

server.listen(PORT, () => {
  console.log(`🚀 Unified Telemedicine Backend Server running on port ${PORT}`);
  console.log(`📊 Health Check: http://localhost:${PORT}/api/health`);
  console.log(`📋 API Endpoints: http://localhost:${PORT}/api`);
  console.log(`🔌 Socket.IO ready for real-time connections`);
});

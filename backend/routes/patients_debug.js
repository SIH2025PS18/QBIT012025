const express = require("express");
const { auth, authorize } = require("../middleware/auth");
const Patient = require("../models/Patient");

const router = express.Router();

// Get socket.io instance for real-time updates
let io;
setTimeout(() => {
  try {
    io = require("../server.js").io;
  } catch (e) {
    console.log("Socket.IO not ready yet, will emit events when available");
  }
}, 1000);

// @desc    Update patient profile
// @route   PUT /api/patients/profile
// @access  Private (Patient only)
router.put("/profile", async (req, res) => {
  console.log("🔥 Profile update endpoint hit");
  console.log("Headers:", req.headers);
  console.log("Body:", req.body);
  
  try {
    // Manual authentication check
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.log("❌ No valid auth header");
      return res.status(401).json({
        success: false,
        message: "No valid authorization header"
      });
    }

    const token = authHeader.split(' ')[1];
    console.log("🔑 Token extracted:", token.substring(0, 20) + "...");

    const jwt = require('jsonwebtoken');
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log("✅ Token decoded:", decoded);

    const patient = await Patient.findById(decoded.id);
    if (!patient) {
      console.log("❌ Patient not found for ID:", decoded.id);
      return res.status(404).json({
        success: false,
        message: "Patient not found"
      });
    }

    console.log("✅ Patient found:", patient.name);

    const updatedPatient = await Patient.findByIdAndUpdate(
      decoded.id,
      { ...req.body, updatedAt: new Date() },
      { new: true, runValidators: true }
    ).select("-password");

    console.log("✅ Profile updated successfully");

    res.json({
      success: true,
      message: "Patient profile updated successfully",
      data: updatedPatient,
    });

  } catch (error) {
    console.error("❌ Error updating patient profile:", error);
    res.status(500).json({
      success: false,
      message: "Server error updating patient profile",
      error: error.message,
    });
  }
});

module.exports = router;
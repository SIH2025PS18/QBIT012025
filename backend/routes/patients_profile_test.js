const express = require("express");
const jwt = require("jsonwebtoken");
const { auth, authorize } = require("../middleware/auth");
const Patient = require("../models/Patient");

const router = express.Router();

// @desc    Update patient profile
// @route   PUT /api/patients/profile
// @access  Private (Patient only)
router.put("/profile", async (req, res) => {
  console.log('🔥 CLEAN PROFILE ROUTE HIT!');
  console.log('Body:', req.body);
  console.log('Auth:', req.headers.authorization?.substring(0, 30));
  
  try {
    // Manual authentication
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.log('❌ No auth header');
      return res.status(401).json({
        success: false,
        message: "No valid authorization header"
      });
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    console.log('✅ Token verified for:', decoded.id);

    if (decoded.userType !== 'patient') {
      return res.status(403).json({
        success: false,
        message: "Patient access required"
      });
    }

    const patient = await Patient.findById(decoded.id);
    if (!patient) {
      return res.status(404).json({
        success: false,
        message: "Patient not found"
      });
    }

    console.log('🔄 Updating patient...');
    const updatedPatient = await Patient.findByIdAndUpdate(
      decoded.id,
      { ...req.body, updatedAt: new Date() },
      { new: true, runValidators: true }
    ).select("-password");

    console.log('✅ Patient updated successfully');
    res.json({
      success: true,
      message: "Patient profile updated successfully",
      data: updatedPatient,
    });

  } catch (error) {
    console.error("❌ Profile update error:", error);
    res.status(500).json({
      success: false,
      message: "Server error updating patient profile",
      error: error.message,
    });
  }
});

module.exports = router;
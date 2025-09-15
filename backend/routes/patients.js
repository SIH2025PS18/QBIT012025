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

// @desc    Get all patients (for admin)
// @route   GET /api/patients
// @access  Private (Admin only)
router.get("/", auth, authorize("admin"), async (req, res) => {
  try {
    const { page = 1, limit = 10, search } = req.query;

    const query = {};
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: "i" } },
        { email: { $regex: search, $options: "i" } },
        { phone: { $regex: search, $options: "i" } },
        { patientId: { $regex: search, $options: "i" } },
      ];
    }

    const patients = await Patient.find(query)
      .select("-password")
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });

    const total = await Patient.countDocuments(query);

    res.json({
      success: true,
      count: patients.length,
      total,
      page: parseInt(page),
      pages: Math.ceil(total / limit),
      data: patients,
    });
  } catch (error) {
    console.error("Error fetching patients:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching patients",
    });
  }
});

// @desc    Get single patient by ID
// @route   GET /api/patients/:id
// @access  Private (Admin or Patient themselves)
router.get("/:id", auth, async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id).select("-password");

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: "Patient not found",
      });
    }

    // Check if user is admin or the patient themselves
    if (
      req.user.userType !== "admin" &&
      req.user._id.toString() !== patient._id.toString()
    ) {
      return res.status(403).json({
        success: false,
        message: "Not authorized to view this patient",
      });
    }

    res.json({
      success: true,
      data: patient,
    });
  } catch (error) {
    console.error("Error fetching patient:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching patient",
    });
  }
});

// @desc    Update patient
// @route   PUT /api/patients/:id
// @access  Private (Admin or Patient themselves)
router.put("/:id", auth, async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: "Patient not found",
      });
    }

    // Check if user is admin or the patient themselves
    if (
      req.user.userType !== "admin" &&
      req.user._id.toString() !== patient._id.toString()
    ) {
      return res.status(403).json({
        success: false,
        message: "Not authorized to update this patient",
      });
    }

    const updatedPatient = await Patient.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updatedAt: new Date() },
      { new: true, runValidators: true }
    ).select("-password");

    res.json({
      success: true,
      message: "Patient updated successfully",
      data: updatedPatient,
    });
  } catch (error) {
    console.error("Error updating patient:", error);
    res.status(500).json({
      success: false,
      message: "Server error updating patient",
    });
  }
});

// @desc    Delete patient (Admin only)
// @route   DELETE /api/patients/:id
// @access  Private (Admin only)
router.delete("/:id", auth, authorize("admin"), async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: "Patient not found",
      });
    }

    await Patient.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: "Patient deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting patient:", error);
    res.status(500).json({
      success: false,
      message: "Server error deleting patient",
    });
  }
});

// @desc    Get patient profile
// @route   GET /api/patients/profile
// @access  Private (Patient only)
router.get("/profile", auth, authorize("patient"), async (req, res) => {
  try {
    const patient = await Patient.findById(req.user._id).select("-password");

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: "Patient profile not found",
      });
    }

    res.json({
      success: true,
      data: patient,
    });
  } catch (error) {
    console.error("Error fetching patient profile:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching profile",
    });
  }
});

// @desc    Update patient profile
// @route   PUT /api/patients/profile
// @access  Private (Patient only)
router.put("/profile", auth, authorize("patient"), async (req, res) => {
  try {
    console.log("Updating patient profile for user:", req.user._id);
    console.log("Update data:", req.body);

    const patient = await Patient.findById(req.user._id);

    if (!patient) {
      return res.status(404).json({
        success: false,
        message: "Patient profile not found",
      });
    }

    const updatedPatient = await Patient.findByIdAndUpdate(
      req.user._id,
      { ...req.body, updatedAt: new Date() },
      { new: true, runValidators: true }
    ).select("-password");

    console.log("Updated patient:", updatedPatient);

    res.json({
      success: true,
      message: "Patient profile updated successfully",
      data: updatedPatient,
    });
  } catch (error) {
    console.error("Error updating patient profile:", error);
    res.status(500).json({
      success: false,
      message: "Server error updating patient profile",
      error: error.message,
    });
  }
});

// @desc    Get patient consultations
// @route   GET /api/patients/consultations
// @access  Private (Patient only)
router.get("/consultations", auth, authorize("patient"), async (req, res) => {
  try {
    // TODO: Implement consultation model and fetch patient's consultations
    res.json({
      success: true,
      message: "Patient consultations endpoint",
      data: [],
    });
  } catch (error) {
    console.error("Error fetching patient consultations:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching consultations",
    });
  }
});

module.exports = router;

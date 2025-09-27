const express = require("express");
const { auth, authorize, verifiedDoctor } = require("../middleware/auth");
const Doctor = require("../models/Doctor");

const router = express.Router();

// @desc    Get all doctors (for admin)
// @route   GET /api/doctors
// @access  Private (Admin only)
router.get("/", auth, authorize("admin"), async (req, res) => {
  try {
    const { page = 1, limit = 10, speciality, status } = req.query;

    const query = {};
    if (speciality) query.speciality = speciality;
    if (status) query.status = status;

    const doctors = await Doctor.find(query)
      .select("-password")
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ createdAt: -1 });

    const total = await Doctor.countDocuments(query);

    res.json({
      success: true,
      count: doctors.length,
      total,
      page: parseInt(page),
      pages: Math.ceil(total / limit),
      data: doctors,
    });
  } catch (error) {
    console.error("Error fetching doctors:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching doctors",
    });
  }
});

// @desc    Get available doctors
// @route   GET /api/doctors/available
// @access  Public
router.get("/available", async (req, res) => {
  try {
    const { speciality } = req.query;

    const doctors = await Doctor.findAvailable(speciality);

    res.json({
      success: true,
      count: doctors.length,
      data: doctors.map((doctor) => ({
        id: doctor._id,
        doctorId: doctor.doctorId,
        name: doctor.name,
        speciality: doctor.speciality,
        qualification: doctor.qualification,
        experience: doctor.experience,
        consultationFee: doctor.consultationFee,
        rating: doctor.rating,
        totalConsultations: doctor.totalConsultations,
        languages: doctor.languages,
        status: doctor.status,
        isAvailable: doctor.isAvailable,
      })),
    });
  } catch (error) {
    console.error("Error fetching available doctors:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching doctors",
    });
  }
});

// @desc    Get live/online doctors
// @route   GET /api/doctors/live
// @access  Public
router.get("/live", async (req, res) => {
  try {
    const { speciality } = req.query;

    const query = {
      isAvailable: true,
      isVerified: true,
      status: "online"  // Only get doctors who are currently online
    };

    if (speciality) {
      query.speciality = speciality;
    }

    const doctors = await Doctor.find(query)
      .select("-password")
      .sort({ lastActive: -1 });  // Sort by most recently active

    res.json({
      success: true,
      count: doctors.length,
      data: doctors.map((doctor) => ({
        id: doctor._id,
        doctorId: doctor.doctorId,
        name: doctor.name,
        speciality: doctor.speciality,
        qualification: doctor.qualification,
        experience: doctor.experience,
        consultationFee: doctor.consultationFee,
        rating: doctor.rating,
        totalConsultations: doctor.totalConsultations,
        languages: doctor.languages,
        status: doctor.status,
        isAvailable: doctor.isAvailable,
        lastActive: doctor.lastActive,
      })),
    });
  } catch (error) {
    console.error("Error fetching live doctors:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching live doctors",
    });
  }
});

// @desc    Get all doctors for appointment booking (includes offline doctors)
// @route   GET /api/doctors/booking
// @access  Public
router.get("/booking", async (req, res) => {
  try {
    const { speciality } = req.query;

    const query = {
      isAvailable: true,
      isVerified: true,
      // Include all doctors regardless of online status for appointment booking
    };

    if (speciality) {
      query.speciality = speciality;
    }

    const doctors = await Doctor.find(query)
      .select("-password")
      .sort({ 
        // Online doctors first, then by rating
        status: -1,
        rating: -1, 
        totalConsultations: -1 
      });

    res.json({
      success: true,
      count: doctors.length,
      data: doctors.map((doctor) => ({
        id: doctor._id,
        doctorId: doctor.doctorId,
        name: doctor.name,
        speciality: doctor.speciality,
        qualification: doctor.qualification,
        experience: doctor.experience,
        consultationFee: doctor.consultationFee,
        rating: doctor.rating,
        totalConsultations: doctor.totalConsultations,
        languages: doctor.languages || doctor.languagesSpoken,
        status: doctor.status,
        isAvailable: doctor.isAvailable,
        lastActive: doctor.lastActive,
      })),
    });
  } catch (error) {
    console.error("Error fetching doctors for booking:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching doctors for booking",
    });
  }
});

// @desc    Get single doctor by ID
// @route   GET /api/doctors/:id
// @access  Public
router.get("/:id", async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.params.id).select("-password");

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: "Doctor not found",
      });
    }

    res.json({
      success: true,
      data: doctor,
    });
  } catch (error) {
    console.error("Error fetching doctor:", error);
    res.status(500).json({
      success: false,
      message: "Server error fetching doctor",
    });
  }
});

// @desc    Create new doctor (Admin only)
// @route   POST /api/doctors
// @access  Private (Admin only)
router.post("/", auth, authorize("admin"), async (req, res) => {
  try {
    console.log("🏥 Creating new doctor with data:", req.body);
    
    const {
      name,
      email,
      phone,
      speciality,
      qualification,
      experience,
      licenseNumber,
      consultationFee,
      languages,
      address,
      workingHours,
      isAvailable,
      isVerified,
      // Admin management fields
      employeeId,
      department,
      emergencyContact,
      licenseExpiryDate,
      permissions,
    } = req.body;

    // Validate required fields
    if (!name || !email || !phone || !speciality || !qualification || 
        experience === undefined || !licenseNumber || consultationFee === undefined) {
      console.log("❌ Missing required fields in request");
      console.log("Request body keys:", Object.keys(req.body));
      console.log("Detailed field check:", {
        name: { value: name, type: typeof name, valid: !!name },
        email: { value: email, type: typeof email, valid: !!email },
        phone: { value: phone, type: typeof phone, valid: !!phone },
        speciality: { value: speciality, type: typeof speciality, valid: !!speciality },
        qualification: { value: qualification, type: typeof qualification, valid: !!qualification },
        experience: { value: experience, type: typeof experience, valid: experience !== undefined },
        licenseNumber: { value: licenseNumber, type: typeof licenseNumber, valid: !!licenseNumber },
        consultationFee: { value: consultationFee, type: typeof consultationFee, valid: consultationFee !== undefined }
      });
      return res.status(400).json({
        success: false,
        message: "Missing required fields",
        required: ["name", "email", "phone", "speciality", "qualification", "experience", "licenseNumber", "consultationFee"]
      });
    }

    // Map specialities to valid enum values
    const specialityMap = {
      "General Medicine": "General Practitioner",
      "General Practitioner": "General Practitioner",
      "Cardiologist": "Cardiologist",
      "Dermatologist": "Dermatologist",
      "Pediatrician": "Pediatrician",
      "Neurologist": "Neurologist",
      "Psychiatrist": "Psychiatrist",
      "Orthopedic": "Orthopedic",
      "Gynecologist": "Gynecologist",
      "ENT Specialist": "ENT Specialist",
      "Ophthalmologist": "Ophthalmologist"
    };
    
    const mappedSpeciality = specialityMap[speciality] || speciality;
    console.log(`🔄 Mapped speciality "${speciality}" to "${mappedSpeciality}"`);

    // Check if doctor already exists
    const existingDoctor = await Doctor.findOne({
      $or: [{ email }, { phone }, { licenseNumber }],
    });

    if (existingDoctor) {
      console.log("⚠️ Doctor already exists:", existingDoctor.email);
      return res.status(400).json({
        success: false,
        message:
          "Doctor already exists with this email, phone, or license number",
      });
    }

    // Generate unique doctor ID
    const doctorCount = await Doctor.countDocuments();
    const doctorId = `D${String(doctorCount + 1).padStart(6, "0")}`;
    console.log("🆔 Generated doctor ID:", doctorId);

    // Generate firstName@123 password format
    const bcrypt = require("bcryptjs");
    let cleanName = name.replace(/^dr\.?\s*/i, '').trim();
    const firstName = cleanName.split(' ')[0].toLowerCase();
    const cleanFirstName = firstName.replace(/[^a-z]/g, '');
    const defaultPassword = `${cleanFirstName}@123`;
    console.log("🔐 Generated password format:", defaultPassword);
    
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(defaultPassword, salt);

    const doctor = new Doctor({
      doctorId,
      name,
      email,
      password: hashedPassword,
      phone,
      speciality: mappedSpeciality,
      qualification,
      experience: Number(experience),
      licenseNumber,
      consultationFee: Number(consultationFee),
      languages: languages || ["en"],
      address,
      workingHours,
      isVerified: isVerified !== undefined ? isVerified : true, // Admin-created doctors are auto-verified
      status: "offline", // Start as offline
      isAvailable: isAvailable !== undefined ? isAvailable : true,
      // Admin management fields
      employeeId: employeeId || undefined,
      department: department || undefined,
      emergencyContact: emergencyContact || undefined,
      licenseExpiryDate: licenseExpiryDate || undefined,
      permissions: permissions && Array.isArray(permissions) ? permissions : ["consultation"],
    });

    console.log("💾 Saving doctor to database...");
    await doctor.save();
    console.log("✅ Doctor saved successfully with ID:", doctor._id);

    // Remove password from response
    const doctorResponse = doctor.toObject();
    delete doctorResponse.password;

    console.log("📤 Sending success response");
    res.status(201).json({
      success: true,
      message: "Doctor created successfully",
      data: doctorResponse,
      defaultPassword, // Send default password to admin
    });
  } catch (error) {
    console.error("❌ Error creating doctor:", error);
    console.error("📍 Stack trace:", error.stack);
    
    // Handle validation errors specifically
    if (error.name === 'ValidationError') {
      const validationErrors = Object.values(error.errors).map(err => err.message);
      console.log("🚫 Validation errors:", validationErrors);
      return res.status(400).json({
        success: false,
        message: "Validation error",
        errors: validationErrors,
        details: error.errors
      });
    }
    
    // Handle duplicate key errors
    if (error.code === 11000) {
      console.log("🔄 Duplicate key error:", error.keyValue);
      return res.status(400).json({
        success: false,
        message: "Doctor already exists with this information",
        field: Object.keys(error.keyValue)[0]
      });
    }
    
    res.status(500).json({
      success: false,
      message: "Server error creating doctor",
      error: process.env.NODE_ENV === "development" ? error.message : "Internal server error"
    });
  }
});

// @desc    Update doctor (Admin or Doctor)
// @route   PUT /api/doctors/:id
// @access  Private
router.put("/:id", auth, async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.params.id);

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: "Doctor not found",
      });
    }

    // Check if user is admin or the doctor themselves
    if (
      req.user.userType !== "admin" &&
      req.user._id.toString() !== doctor._id.toString()
    ) {
      return res.status(403).json({
        success: false,
        message: "Not authorized to update this doctor",
      });
    }

    const updatedDoctor = await Doctor.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updatedAt: new Date() },
      { new: true, runValidators: true }
    ).select("-password");

    res.json({
      success: true,
      message: "Doctor updated successfully",
      data: updatedDoctor,
    });
  } catch (error) {
    console.error("Error updating doctor:", error);
    res.status(500).json({
      success: false,
      message: "Server error updating doctor",
    });
  }
});

// @desc    Delete doctor (Admin only)
// @route   DELETE /api/doctors/:id
// @access  Private (Admin only)
router.delete("/:id", auth, authorize("admin"), async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.params.id);

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: "Doctor not found",
      });
    }

    await Doctor.findByIdAndDelete(req.params.id);

    res.json({
      success: true,
      message: "Doctor deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting doctor:", error);
    res.status(500).json({
      success: false,
      message: "Server error deleting doctor",
    });
  }
});

// @desc    Verify doctor (Admin only)
// @route   PUT /api/doctors/:id/verify
// @access  Private (Admin only)
router.put("/:id/verify", auth, authorize("admin"), async (req, res) => {
  try {
    const { isVerified } = req.body;

    const doctor = await Doctor.findByIdAndUpdate(
      req.params.id,
      { isVerified, updatedAt: new Date() },
      { new: true }
    ).select("-password");

    if (!doctor) {
      return res.status(404).json({
        success: false,
        message: "Doctor not found",
      });
    }

    res.json({
      success: true,
      message: `Doctor ${isVerified ? "verified" : "unverified"} successfully`,
      data: doctor,
    });
  } catch (error) {
    console.error("Error verifying doctor:", error);
    res.status(500).json({
      success: false,
      message: "Server error verifying doctor",
    });
  }
});

// @desc    Update doctor status
// @route   PUT /api/doctors/status
// @access  Private (Doctor only)
router.put(
  "/status",
  auth,
  authorize("doctor"),
  verifiedDoctor,
  async (req, res) => {
    try {
      const { status, isAvailable } = req.body;

      const doctor = await Doctor.findByIdAndUpdate(
        req.user._id,
        { status, isAvailable, lastActive: new Date() },
        { new: true }
      );

      res.json({
        success: true,
        message: "Status updated successfully",
        data: {
          status: doctor.status,
          isAvailable: doctor.isAvailable,
          lastActive: doctor.lastActive,
        },
      });
    } catch (error) {
      console.error("Error updating doctor status:", error);
      res.status(500).json({
        success: false,
        message: "Server error updating status",
      });
    }
  }
);

module.exports = router;

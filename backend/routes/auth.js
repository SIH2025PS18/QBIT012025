const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { body, validationResult } = require("express-validator");
const Doctor = require("../models/Doctor");
const Patient = require("../models/Patient");
const Admin = require("../models/Admin");

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

// Generate JWT token
const generateToken = (user, userType) => {
  return jwt.sign(
    {
      id: user._id,
      userType,
      email: user.email,
      name: user.name,
    },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRE || "7d" }
  );
};

router.get("/", async (req, res) => {
  res.json({
    success: true,
    message: "Auth endpoint",
    data: [],
  });
});

// @desc    Simple mobile registration for patients
// @route   POST /api/auth/patient/register-mobile
// @access  Public
router.post(
  "/patient/register-mobile",
  [
    body("name")
      .trim()
      .isLength({ min: 2 })
      .withMessage("Name must be at least 2 characters"),
    body("phone")
      .isMobilePhone("en-IN")
      .withMessage("Please provide a valid Indian phone number"),
    body("password")
      .isLength({ min: 6 })
      .withMessage("Password must be at least 6 characters"),
    body("age")
      .isInt({ min: 1, max: 150 })
      .withMessage("Age must be between 1 and 150"),
    body("gender")
      .isIn(["male", "female", "other"])
      .withMessage("Gender must be male, female, or other"),
  ],
  async (req, res) => {
    try {
      console.log("📱 POST /api/auth/patient/register-mobile called");
      console.log("📥 Request Body:", req.body);
      
      const startTime = new Date();
      console.log("🕒 Request received at:", startTime.toISOString());
      
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        console.log("❌ Validation errors:", errors.array());
        return res.status(400).json({
          success: false,
          message: "Validation errors",
          errors: errors.array(),
        });
      }

      const { name, phone, password, age, gender } = req.body;
      console.log("👤 Registration details:");
      console.log("   Name:", name);
      console.log("   Phone:", phone);
      console.log("   Age:", age);
      console.log("   Gender:", gender);
      console.log("   Password length:", password.length);

      // Check if patient already exists
      console.log("🔍 Checking if patient already exists with phone:", phone);
      const existingPatient = await Patient.findOne({ phone });

      if (existingPatient) {
        console.log("⚠️ Patient already exists with this phone number:", phone);
        return res.status(400).json({
          success: false,
          message: "Patient already exists with this phone number",
        });
      }
      console.log("✅ No existing patient found with this phone number");

      // Hash password
      console.log("🔒 Hashing password...");
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash(password, salt);
      console.log("✅ Password hashed successfully");

      // Generate unique patient ID
      console.log("🔢 Generating unique patient ID...");
      const patientCount = await Patient.countDocuments();
      const patientId = `P${String(patientCount + 1).padStart(6, "0")}`;
      console.log("✅ Generated patient ID:", patientId);

      // Create patient with minimal info
      console.log("🆕 Creating new patient record...");
      const patient = new Patient({
        patientId,
        name,
        email: `${phone}@telemed.local`, // Temporary email
        password: hashedPassword,
        phone,
        age,
        gender,
        dateOfBirth: new Date(Date.now() - age * 365 * 24 * 60 * 60 * 1000), // Approximate DOB
        preferredLanguage: "en",
      });

      await patient.save();
      console.log("✅ Patient saved to database");
      console.log("🆔 Patient ID in DB:", patient._id);

      // Emit real-time event to admin dashboard
      if (io) {
        console.log("📡 Emitting patient_registered event to admin dashboard");
        io.emit("patient_registered", {
          type: "patient_registered",
          patient: {
            id: patient._id,
            patientId: patient.patientId,
            name: patient.name,
            phone: patient.phone,
            age: patient.age,
            gender: patient.gender,
            createdAt: patient.createdAt,
          },
          timestamp: new Date(),
        });
        console.log("✅ Event emitted successfully");
      }

      // Generate token
      console.log("🔑 Generating JWT token...");
      const token = generateToken(patient, "patient");
      console.log("✅ Token generated, length:", token.length);

      const endTime = new Date();
      const duration = endTime - startTime;
      console.log("⏱️ Request processing time:", duration, "ms");
      console.log("✅ Patient registered successfully");

      res.status(201).json({
        success: true,
        message: "Patient registered successfully",
        data: {
          user: {
            id: patient._id,
            patientId: patient.patientId,
            name: patient.name,
            phone: patient.phone,
            age: patient.age,
            gender: patient.gender,
            role: "patient",
            userType: "patient",
          },
          token,
          userType: "patient",
        },
      });
    } catch (error) {
      console.error("💥 Patient mobile registration error:", error);
      console.error("📍 Stack trace:", error.stack);
      res.status(500).json({
        success: false,
        message: "Server error during registration",
      });
    }
  }
);

// @route   POST /api/auth/patient/register
// @access  Public
router.post(
  "/patient/register",
  [
    body("name")
      .trim()
      .isLength({ min: 2 })
      .withMessage("Name must be at least 2 characters"),
    body("email")
      .isEmail()
      .normalizeEmail()
      .withMessage("Please provide a valid email"),
    body("password")
      .isLength({ min: 6 })
      .withMessage("Password must be at least 6 characters"),
    body("phone")
      .isMobilePhone("en-IN")
      .withMessage("Please provide a valid Indian phone number"),
    body("age")
      .isInt({ min: 1, max: 150 })
      .withMessage("Age must be between 1 and 150"),
    body("gender")
      .isIn(["male", "female", "other"])
      .withMessage("Gender must be male, female, or other"),
    body("dateOfBirth")
      .isISO8601()
      .withMessage("Please provide a valid date of birth"),
  ],
  async (req, res) => {
    try {
      console.log("👥 POST /api/auth/patient/register called");
      console.log("📥 Request Body:", req.body);
      
      const startTime = new Date();
      console.log("🕒 Request received at:", startTime.toISOString());
      
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        console.log("❌ Validation errors:", errors.array());
        return res.status(400).json({
          success: false,
          message: "Validation errors",
          errors: errors.array(),
        });
      }

      const {
        name,
        email,
        password,
        phone,
        age,
        gender,
        dateOfBirth,
        preferredLanguage,
      } = req.body;

      console.log("👤 Patient registration details:");
      console.log("   Name:", name);
      console.log("   Email:", email);
      console.log("   Phone:", phone);
      console.log("   Age:", age);
      console.log("   Gender:", gender);
      console.log("   Date of Birth:", dateOfBirth);
      console.log("   Preferred Language:", preferredLanguage);
      console.log("   Password length:", password.length);

      // Check if patient already exists
      console.log("🔍 Checking if patient already exists with email or phone:", email, phone);
      const existingPatient = await Patient.findOne({
        $or: [{ email }, { phone }],
      });

      if (existingPatient) {
        console.log("⚠️ Patient already exists with email or phone:", 
          existingPatient.email, existingPatient.phone);
        return res.status(400).json({
          success: false,
          message: "Patient already exists with this email or phone number",
        });
      }
      console.log("✅ No existing patient found with this email or phone");

      // Hash password
      console.log("🔒 Hashing password...");
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash(password, salt);
      console.log("✅ Password hashed successfully");

      // Generate unique patient ID
      console.log("🔢 Generating unique patient ID...");
      const patientCount = await Patient.countDocuments();
      const patientId = `P${String(patientCount + 1).padStart(6, "0")}`;
      console.log("✅ Generated patient ID:", patientId);

      // Create patient
      console.log("🆕 Creating new patient record...");
      const patient = new Patient({
        patientId,
        name,
        email,
        password: hashedPassword,
        phone,
        age,
        gender,
        dateOfBirth: new Date(dateOfBirth),
        preferredLanguage: preferredLanguage || "en",
      });

      await patient.save();
      console.log("✅ Patient saved to database");
      console.log("🆔 Patient ID in DB:", patient._id);

      // Emit real-time event to admin dashboard
      if (io) {
        console.log("📡 Emitting patient_registered event to admin dashboard");
        io.emit("patient_registered", {
          type: "patient_registered",
          patient: {
            id: patient._id,
            patientId: patient.patientId,
            name: patient.name,
            email: patient.email,
            phone: patient.phone,
            age: patient.age,
            gender: patient.gender,
            preferredLanguage: patient.preferredLanguage,
            createdAt: patient.createdAt,
          },
          timestamp: new Date(),
        });
        console.log("✅ Event emitted successfully");
      }

      // Generate token
      console.log("🔑 Generating JWT token...");
      const token = generateToken(patient, "patient");
      console.log("✅ Token generated, length:", token.length);

      const endTime = new Date();
      const duration = endTime - startTime;
      console.log("⏱️ Request processing time:", duration, "ms");
      console.log("✅ Patient registered successfully");

      res.status(201).json({
        success: true,
        message: "Patient registered successfully",
        data: {
          patient: {
            id: patient._id,
            patientId: patient.patientId,
            name: patient.name,
            email: patient.email,
            phone: patient.phone,
            age: patient.age,
            gender: patient.gender,
            preferredLanguage: patient.preferredLanguage,
          },
          token,
          userType: "patient",
        },
      });
    } catch (error) {
      console.error("💥 Patient registration error:", error);
      console.error("📍 Stack trace:", error.stack);
      res.status(500).json({
        success: false,
        message: "Server error during registration",
      });
    }
  }
);

// @desc    Register doctor
// @route   POST /api/auth/doctor/register
// @access  Public
router.post(
  "/doctor/register",
  [
    body("name")
      .trim()
      .isLength({ min: 2 })
      .withMessage("Name must be at least 2 characters"),
    body("email")
      .isEmail()
      .normalizeEmail()
      .withMessage("Please provide a valid email"),
    body("password")
      .isLength({ min: 6 })
      .withMessage("Password must be at least 6 characters"),
    body("phone")
      .isMobilePhone("en-IN")
      .withMessage("Please provide a valid Indian phone number"),
    body("speciality").notEmpty().withMessage("Speciality is required"),
    body("qualification").notEmpty().withMessage("Qualification is required"),
    body("experience")
      .isInt({ min: 0 })
      .withMessage("Experience must be a positive number"),
    body("licenseNumber").notEmpty().withMessage("License number is required"),
    body("consultationFee")
      .isFloat({ min: 0 })
      .withMessage("Consultation fee must be a positive number"),
  ],
  async (req, res) => {
    try {
      console.log("👨‍⚕️ POST /api/auth/doctor/register called");
      console.log("📥 Request Body:", req.body);
      
      const startTime = new Date();
      console.log("🕒 Request received at:", startTime.toISOString());
      
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        console.log("❌ Validation errors:", errors.array());
        return res.status(400).json({
          success: false,
          message: "Validation errors",
          errors: errors.array(),
        });
      }

      const {
        name,
        email,
        password,
        phone,
        speciality,
        qualification,
        experience,
        licenseNumber,
        consultationFee,
        languages,
      } = req.body;

      console.log("👨‍⚕️ Doctor registration details:");
      console.log("   Name:", name);
      console.log("   Email:", email);
      console.log("   Phone:", phone);
      console.log("   Speciality:", speciality);
      console.log("   Qualification:", qualification);
      console.log("   Experience:", experience);
      console.log("   License Number:", licenseNumber);
      console.log("   Consultation Fee:", consultationFee);
      console.log("   Languages:", languages);
      console.log("   Password length:", password.length);

      // Check if doctor already exists
      let existingDoctor;
      try {
        console.log("🔍 Checking if doctor already exists with email, phone, or license number:", email, phone, licenseNumber);
        existingDoctor = await Doctor.findOne({
          $or: [{ email }, { phone }, { licenseNumber }],
        });
      } catch (dbError) {
        console.log("Database not available, using in-memory check");
        // In development mode without DB, allow registration
        existingDoctor = null;
      }

      if (existingDoctor) {
        console.log("⚠️ Doctor already exists with email, phone, or license number:", 
          existingDoctor.email, existingDoctor.phone, existingDoctor.licenseNumber);
        return res.status(400).json({
          success: false,
          message:
            "Doctor already exists with this email, phone, or license number",
        });
      }
      console.log("✅ No existing doctor found with this email, phone, or license number");

      // Hash password
      console.log("🔒 Hashing password...");
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash(password, salt);
      console.log("✅ Password hashed successfully");

      // Generate unique doctor ID
      let doctorCount = 0;
      try {
        console.log("🔢 Counting existing doctors...");
        doctorCount = await Doctor.countDocuments();
      } catch (dbError) {
        console.log("Database not available, using default count");
        doctorCount = Math.floor(Math.random() * 100); // Random count for demo
      }
      const doctorId = `D${String(doctorCount + 1).padStart(6, "0")}`;
      console.log("✅ Generated doctor ID:", doctorId);

      // Create doctor
      const doctorData = {
        doctorId,
        name,
        email,
        password: hashedPassword,
        phone,
        speciality,
        qualification,
        experience,
        licenseNumber,
        consultationFee,
        languages: languages || ["en"],
        isVerified: false, // Doctors need admin verification
      };

      let doctor;
      try {
        console.log("🆕 Creating new doctor record...");
        doctor = new Doctor(doctorData);
        await doctor.save();
        console.log("✅ Doctor saved to database");
        console.log("🆔 Doctor ID in DB:", doctor._id);
      } catch (dbError) {
        console.log("Database not available, using mock doctor data");
        // Create mock doctor for development
        doctor = {
          _id: `mock_${Date.now()}`,
          ...doctorData,
          toObject: () => doctorData,
        };
      }

      const endTime = new Date();
      const duration = endTime - startTime;
      console.log("⏱️ Request processing time:", duration, "ms");
      console.log("✅ Doctor registration submitted successfully");

      res.status(201).json({
        success: true,
        message:
          "Doctor registration submitted successfully. Please wait for admin verification.",
        data: {
          doctor: {
            id: doctor._id,
            doctorId: doctor.doctorId,
            name: doctor.name,
            email: doctor.email,
            phone: doctor.phone,
            speciality: doctor.speciality,
            qualification: doctor.qualification,
            experience: doctor.experience,
            consultationFee: doctor.consultationFee,
            isVerified: doctor.isVerified,
          },
        },
      });
    } catch (error) {
      console.error("💥 Doctor registration error:", error);
      console.error("📍 Stack trace:", error.stack);
      res.status(500).json({
        success: false,
        message: "Server error during registration",
      });
    }
  }
);

// @desc    Login user (patient, doctor, or admin)
// @route   POST /api/auth/login
// @access  Public
router.post(
  "/login",
  [
    body("loginId")
      .notEmpty()
      .withMessage("Please provide email or mobile number"),
    body("password").notEmpty().withMessage("Password is required"),
    body("userType")
      .isIn(["patient", "doctor", "admin"])
      .withMessage("User type must be patient, doctor, or admin"),
  ],
  async (req, res) => {
    try {
      console.log("🔐 POST /api/auth/login called");
      console.log("📥 Request Body:", req.body);
      
      const startTime = new Date();
      console.log("🕒 Login request received at:", startTime.toISOString());
      
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        console.log("❌ Validation errors:", errors.array());
        return res.status(400).json({
          success: false,
          message: "Validation errors",
          errors: errors.array(),
        });
      }

      const { loginId, password, userType } = req.body;
      console.log("👤 Login attempt:");
      console.log("   Login ID:", loginId);
      console.log("   User Type:", userType);
      console.log("   Password length:", password.length);

      let user;
      let Model;

      // Determine which model to use based on user type
      console.log("🔍 Determining user model for type:", userType);
      switch (userType) {
        case "patient":
          Model = Patient;
          console.log("   Using Patient model");
          break;
        case "doctor":
          Model = Doctor;
          console.log("   Using Doctor model");
          break;
        case "admin":
          Model = Admin;
          console.log("   Using Admin model");
          break;
        default:
          console.log("❌ Invalid user type:", userType);
          return res.status(400).json({
            success: false,
            message: "Invalid user type",
          });
      }

      // Find user by email or phone
      const isEmail = loginId.includes("@");
      const query = isEmail ? { email: loginId } : { phone: loginId };
      console.log("🔍 Searching for user with query:", query);
      user = await Model.findOne(query);

      if (!user) {
        console.log("❌ User not found with query:", query);
        return res.status(401).json({
          success: false,
          message: "Invalid credentials",
        });
      }
      console.log("✅ User found:", user._id);

      // Check password
      console.log("🔒 Comparing passwords...");
      const isMatch = await bcrypt.compare(password, user.password);

      if (!isMatch) {
        console.log("❌ Password mismatch for user:", user._id);
        return res.status(401).json({
          success: false,
          message: "Invalid credentials",
        });
      }
      console.log("✅ Password matched");

      // Check if doctor is verified
      if (userType === "doctor" && !user.isVerified) {
        console.log("⚠️ Doctor account not verified:", user._id);
        return res.status(401).json({
          success: false,
          message:
            "Doctor account is pending verification. Please contact admin.",
        });
      }

      // Update last active for doctors
      if (userType === "doctor") {
        console.log("🕒 Updating doctor last active time:", user._id);
        user.lastActive = new Date();
        await user.save();
        console.log("✅ Doctor last active time updated");
      }

      // Generate token
      console.log("🔑 Generating JWT token...");
      const token = generateToken(user, userType);
      console.log("✅ Token generated, length:", token.length);

      // Prepare user data (exclude password)
      console.log("📋 Preparing user data for response...");
      const userData = {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        userType,
      };

      // Add type-specific fields
      if (userType === "patient") {
        userData.patientId = user.patientId;
        userData.age = user.age;
        userData.gender = user.gender;
        userData.preferredLanguage = user.preferredLanguage;
        userData.role = "patient";
        console.log("   Added patient-specific fields");
      } else if (userType === "doctor") {
        userData.doctorId = user.doctorId;
        userData.speciality = user.speciality;
        userData.qualification = user.qualification;
        userData.experience = user.experience;
        userData.consultationFee = user.consultationFee;
        userData.rating = user.rating;
        userData.status = user.status;
        userData.isAvailable = user.isAvailable;
        userData.role = "doctor";
        console.log("   Added doctor-specific fields");
      } else if (userType === "admin") {
        userData.role = user.role || "admin";
        userData.permissions = user.permissions;
        console.log("   Added admin-specific fields");
      }

      const endTime = new Date();
      const duration = endTime - startTime;
      console.log("⏱️ Login request processing time:", duration, "ms");
      console.log("✅ Login successful for user:", user._id);

      res.json({
        success: true,
        message: "Login successful",
        data: {
          user: userData,
          token,
          userType,
        },
      });
    } catch (error) {
      console.error("💥 Login error:", error);
      console.error("📍 Stack trace:", error.stack);
      res.status(500).json({
        success: false,
        message: "Server error during login",
      });
    }
  }
);

// @desc    Get current user profile
// @route   GET /api/auth/profile
// @access  Private
router.get("/profile", async (req, res) => {
  try {
    console.log("👤 GET /api/auth/profile called");
    console.log("📥 Request headers:", req.headers);
    
    // This route requires authentication middleware
    // The middleware should set req.user with user data from token
    if (!req.user) {
      console.log("❌ User not authenticated");
      return res.status(401).json({
        success: false,
        message: "Unauthorized access",
      });
    }
    
    console.log("✅ User authenticated:", req.user.id);
    console.log("📄 User data:", req.user);

    res.json({
      success: true,
      message: "Profile retrieved successfully",
      data: {
        user: req.user,
      },
    });
  } catch (error) {
    console.error("💥 Profile fetch error:", error);
    console.error("📍 Stack trace:", error.stack);
    res.status(500).json({
      success: false,
      message: "Server error fetching profile",
    });
  }
});

// @desc    Change password
// @route   PUT /api/auth/change-password
// @access  Private
router.put(
  "/change-password",
  [
    body("currentPassword")
      .notEmpty()
      .withMessage("Current password is required"),
    body("newPassword")
      .isLength({ min: 6 })
      .withMessage("New password must be at least 6 characters"),
  ],
  async (req, res) => {
    try {
      console.log("🔑 PUT /api/auth/change-password called");
      console.log("📥 Request Body:", req.body);
      
      const startTime = new Date();
      console.log("🕒 Request received at:", startTime.toISOString());
      
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        console.log("❌ Validation errors:", errors.array());
        return res.status(400).json({
          success: false,
          message: "Validation errors",
          errors: errors.array(),
        });
      }

      const { currentPassword, newPassword } = req.body;
      console.log("🔐 Password change request:");
      console.log("   Current password length:", currentPassword.length);
      console.log("   New password length:", newPassword.length);

      // This requires authentication middleware to set req.user
      const userId = req.user.id;
      const userType = req.user.userType;
      console.log("👤 User requesting password change:", userId);
      console.log("   User type:", userType);

      let Model;
      switch (userType) {
        case "patient":
          Model = Patient;
          console.log("   Using Patient model");
          break;
        case "doctor":
          Model = Doctor;
          console.log("   Using Doctor model");
          break;
        case "admin":
          Model = Admin;
          console.log("   Using Admin model");
          break;
      }

      const user = await Model.findById(userId);

      if (!user) {
        console.log("❌ User not found:", userId);
        return res.status(404).json({
          success: false,
          message: "User not found",
        });
      }

      // Verify current password
      console.log("🔒 Verifying current password...");
      const isMatch = await bcrypt.compare(currentPassword, user.password);

      if (!isMatch) {
        console.log("❌ Current password mismatch for user:", userId);
        return res.status(400).json({
          success: false,
          message: "Current password is incorrect",
        });
      }
      console.log("✅ Current password verified");

      // Hash new password
      console.log("🔒 Hashing new password...");
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash(newPassword, salt);
      console.log("✅ New password hashed successfully");

      // Update password
      console.log("🔄 Updating password for user:", userId);
      user.password = hashedPassword;
      await user.save();
      console.log("✅ Password updated successfully");

      const endTime = new Date();
      const duration = endTime - startTime;
      console.log("⏱️ Password change processing time:", duration, "ms");
      console.log("✅ Password changed successfully for user:", userId);

      res.json({
        success: true,
        message: "Password changed successfully",
      });
    } catch (error) {
      console.error("💥 Password change error:", error);
      console.error("📍 Stack trace:", error.stack);
      res.status(500).json({
        success: false,
        message: "Server error changing password",
      });
    }
  }
);

// @desc    Logout user
// @route   POST /api/auth/logout
// @access  Private
router.post("/logout", async (req, res) => {
  try {
    console.log("🚪 POST /api/auth/logout called");
    
    // For JWT, we typically just tell the client to remove the token
    // In a more advanced setup, you might maintain a blacklist of tokens

    // If it's a doctor, update their status to offline
    if (req.user && req.user.userType === "doctor") {
      console.log("🕒 Updating doctor status to offline:", req.user.id);
      await Doctor.findByIdAndUpdate(req.user.id, {
        status: "offline",
        lastActive: new Date(),
      });
      console.log("✅ Doctor status updated to offline");
    }

    console.log("✅ Logout successful");
    res.json({
      success: true,
      message: "Logout successful",
    });
  } catch (error) {
    console.error("Logout error:", error);
    res.status(500).json({
      success: false,
      message: "Server error during logout",
    });
  }
});

// @desc    Reset admin password (development helper)
// @route   POST /api/auth/reset-admin
// @access  Public (for development only)
router.post("/reset-admin", async (req, res) => {
  try {
    console.log("🔧 POST /api/auth/reset-admin called");
    
    // Clear all existing admins
    await Admin.deleteMany({});
    console.log("🗑️ Cleared all existing admins");

    // Create new admin with proper password hash
    const hashedPassword = await bcrypt.hash("password", 12);
    
    const adminData = {
      name: "System Admin",
      email: "admin@telemed.com",
      password: hashedPassword,
      phone: "+91-9876543000",
      role: "superadmin",
      permissions: ["all"],
    };

    const newAdmin = await Admin.create(adminData);
    console.log("✅ New admin created successfully with ID:", newAdmin._id);

    // Test the password
    const testMatch = await bcrypt.compare("password", newAdmin.password);
    console.log("🧪 Password test result:", testMatch);

    res.json({
      success: true,
      message: "Admin reset successfully",
      data: {
        admin: {
          id: newAdmin._id,
          name: newAdmin.name,
          email: newAdmin.email,
          role: newAdmin.role,
        },
        passwordTest: testMatch,
        credentials: "admin@telemed.com / password"
      },
    });
  } catch (error) {
    console.error("💥 Admin reset error:", error);
    res.status(500).json({
      success: false,
      message: "Server error resetting admin",
      error: error.message,
    });
  }
});

module.exports = router;
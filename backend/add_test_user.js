const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const dotenv = require("dotenv");

// Load environment variables
dotenv.config();

// Import Patient model
const Patient = require("./models/Patient");

// Connect to MongoDB
const connectDB = async () => {
  try {
    const mongoURI = process.env.MONGODB_URI || "mongodb://localhost:27017/telemed_unified";
    await mongoose.connect(mongoURI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("✅ MongoDB Connected");
  } catch (error) {
    console.error("❌ Error connecting to MongoDB:", error.message);
    process.exit(1);
  }
};

// Add test user
const addTestUser = async () => {
  try {
    await connectDB();

    // Check if user already exists
    const existingUser = await Patient.findOne({ phone: "9026508435" });
    if (existingUser) {
      console.log("✅ User already exists with phone: 9026508435");
      console.log("User details:", {
        name: existingUser.name,
        email: existingUser.email,
        phone: existingUser.phone,
        patientId: existingUser.patientId
      });
      process.exit(0);
    }

    // Hash password
    const hashedPassword = await bcrypt.hash("shaurya", 12);

    // Create new patient
    const newPatient = new Patient({
      patientId: "p_test_" + Date.now(),
      name: "Test User",
      email: "testuser@example.com",
      password: hashedPassword,
      phone: "9026508435",
      age: 25,
      gender: "male",
      dateOfBirth: new Date("1999-01-01"),
      preferredLanguage: "en",
      profileComplete: true,
      emergencyContact: {
        name: "Emergency Contact",
        phone: "9876543210",
        relationship: "family"
      }
    });

    await newPatient.save();
    console.log("✅ Test user created successfully!");
    console.log("Login credentials:");
    console.log("  Phone: 9026508435");
    console.log("  Password: shaurya");
    console.log("  User Type: patient");

    process.exit(0);
  } catch (error) {
    console.error("❌ Error creating test user:", error);
    process.exit(1);
  }
};

addTestUser();
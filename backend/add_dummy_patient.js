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

// Add dummy patient user
const addDummyPatient = async () => {
  try {
    await connectDB();

    console.log("🔍 Checking if dummy patient already exists...");

    // Check if patient with phone 9026508435 already exists
    const existingPatient = await Patient.findOne({ phone: "9026508435" });

    if (existingPatient) {
      console.log("⚠️ Patient already exists with phone 9026508435");
      console.log("📋 Existing patient details:");
      console.log("   Name:", existingPatient.name);
      console.log("   Email:", existingPatient.email);
      console.log("   Phone:", existingPatient.phone);
      console.log("   Patient ID:", existingPatient.patientId);
      
      // Update password to "shaurya" if needed
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash("shaurya", salt);
      
      await Patient.findByIdAndUpdate(existingPatient._id, {
        password: hashedPassword
      });
      
      console.log("🔐 Password updated to 'shaurya'");
      console.log("\n✅ DUMMY PATIENT LOGIN CREDENTIALS:");
      console.log("📱 Phone: 9026508435");
      console.log("🔑 Password: shaurya");
      
    } else {
      console.log("✅ No existing patient found, creating new dummy patient...");

      // Generate unique patient ID
      const patientCount = await Patient.countDocuments();
      const patientId = `P${String(patientCount + 1).padStart(6, "0")}`;

      // Hash password
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash("shaurya", salt);

      // Create dummy patient
      const dummyPatient = new Patient({
        patientId: patientId,
        name: "Shaurya Test",
        email: "shaurya@telemed.local",
        password: hashedPassword,
        phone: "9026508435",
        age: 25,
        gender: "male",
        dateOfBirth: new Date("1999-01-01"),
        preferredLanguage: "en",
        address: {
          street: "Test Street",
          city: "Nabha",
          state: "Punjab",
          pincode: "147201",
          country: "India"
        },
        emergencyContact: {
          name: "Test Emergency Contact",
          phone: "9876543210",
          relationship: "Friend"
        }
      });

      await dummyPatient.save();

      console.log("✅ Dummy patient created successfully!");
      console.log("📋 Patient details:");
      console.log("   Name:", dummyPatient.name);
      console.log("   Email:", dummyPatient.email);
      console.log("   Phone:", dummyPatient.phone);
      console.log("   Patient ID:", dummyPatient.patientId);
      console.log("   Age:", dummyPatient.age);
      console.log("   Gender:", dummyPatient.gender);
      
      console.log("\n✅ DUMMY PATIENT LOGIN CREDENTIALS:");
      console.log("📱 Phone: 9026508435");
      console.log("🔑 Password: shaurya");
    }

    console.log("\n🎯 Login Instructions:");
    console.log("1. Open patient mobile app");
    console.log("2. Use phone number: 9026508435");
    console.log("3. Use password: shaurya");
    console.log("4. Select userType: patient");

    process.exit(0);
  } catch (error) {
    console.error("❌ Error creating dummy patient:", error);
    process.exit(1);
  }
};

// Run the function
addDummyPatient();
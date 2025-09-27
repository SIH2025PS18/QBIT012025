const mongoose = require("mongoose");
const dotenv = require("dotenv");

// Load environment variables
dotenv.config();

const checkUser = async () => {
  try {
    const mongoURI = process.env.MONGODB_URI || "mongodb://localhost:27017/telemed_unified";
    await mongoose.connect(mongoURI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("✅ MongoDB Connected");

    // Define Patient schema (minimal)
    const patientSchema = new mongoose.Schema({}, { strict: false });
    const Patient = mongoose.model('Patient', patientSchema, 'patients');

    // Check for user with phone 9026508435
    const user = await Patient.findOne({ phone: "9026508435" });
    if (user) {
      console.log("✅ User found!");
      console.log("Name:", user.name);
      console.log("Phone:", user.phone);
      console.log("Email:", user.email);
    } else {
      console.log("❌ No user found with phone: 9026508435");
      
      // List all patients to see what phones exist
      const allPatients = await Patient.find({}, { name: 1, phone: 1, email: 1 });
      console.log("\n📋 All patients in database:");
      allPatients.forEach((patient, index) => {
        console.log(`${index + 1}. ${patient.name} - ${patient.phone} - ${patient.email}`);
      });
    }

    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error);
    process.exit(1);
  }
};

checkUser();
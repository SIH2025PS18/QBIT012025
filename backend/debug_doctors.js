const mongoose = require("mongoose");
const dotenv = require("dotenv");
const Doctor = require("./models/Doctor");

dotenv.config();

const debugDoctors = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI || "mongodb://localhost:27017/telemed_unified");
    console.log("✅ Connected to database");
    
    // Get all doctors first
    const allDoctors = await Doctor.find({});
    console.log(`\n📊 Total doctors in database: ${allDoctors.length}`);
    
    // Check isAvailable and isVerified doctors
    const availableAndVerified = await Doctor.find({
      isAvailable: true,
      isVerified: true
    });
    console.log(`📋 Available and verified doctors: ${availableAndVerified.length}`);
    
    // Show details of each doctor
    console.log("\n🔍 Doctor details:");
    for (const doctor of allDoctors) {
      console.log(`- ${doctor.name}: available=${doctor.isAvailable}, verified=${doctor.isVerified}, status="${doctor.status}"`);
    }
    
    // Test findAvailable method
    console.log("\n🧪 Testing findAvailable method...");
    const availableDoctors = await Doctor.findAvailable();
    console.log(`✅ findAvailable returned: ${availableDoctors.length} doctors`);
    
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error);
    process.exit(1);
  }
};

debugDoctors();
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const Doctor = require("./models/Doctor");

dotenv.config();

const checkDoctors = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI || "mongodb://localhost:27017/telemed_unified");
    console.log("✅ Connected to database");
    
    const doctors = await Doctor.find({}, 'name email speciality employeeId');
    console.log("\n📋 Existing doctors in database:");
    console.log("==========================================");
    doctors.forEach(d => {
      console.log(`👨‍⚕️ ${d.name} (${d.speciality}) - ID: ${d.employeeId}`);
    });
    console.log(`\n📊 Total doctors: ${doctors.length}`);
    
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error);
    process.exit(1);
  }
};

checkDoctors();
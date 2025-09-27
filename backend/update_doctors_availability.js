const mongoose = require("mongoose");
const dotenv = require("dotenv");
const Doctor = require("./models/Doctor");

dotenv.config();

const updateDoctorsAvailability = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI || "mongodb://localhost:27017/telemed_unified");
    console.log("✅ Connected to database");
    
    // Update all doctors to be available and verified
    const result = await Doctor.updateMany(
      {}, // Update all doctors
      { 
        $set: {
          isAvailable: true,
          isVerified: true,
          // Keep status as offline - they'll go online when they login
          status: "offline"
        }
      }
    );
    
    console.log(`✅ Updated ${result.modifiedCount} doctors to be available and verified`);
    
    // Show updated doctors
    const doctors = await Doctor.find({}, 'name email speciality isAvailable isVerified status');
    console.log("\n📋 Updated doctors status:");
    console.log("==========================================");
    doctors.forEach(d => {
      const statusIcon = d.status === 'online' ? '🟢' : '🔴';
      const availableIcon = d.isAvailable ? '✅' : '❌';
      const verifiedIcon = d.isVerified ? '☑️' : '❓';
      console.log(`${statusIcon} ${availableIcon} ${verifiedIcon} ${d.name} (${d.speciality})`);
    });
    
    console.log("\n🎯 Legend:");
    console.log("🟢/🔴 = Online/Offline status");
    console.log("✅/❌ = Available for appointments");  
    console.log("☑️/❓ = Verified status");
    
    console.log("\n✨ All doctors are now available for appointment booking!");
    console.log("📱 They will show in patient app even when offline");
    console.log("🟢 They will show as online only when they login to dashboard");
    
    process.exit(0);
  } catch (error) {
    console.error("❌ Error:", error);
    process.exit(1);
  }
};

updateDoctorsAvailability();
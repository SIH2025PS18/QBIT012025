const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const dotenv = require("dotenv");

// Load environment variables
dotenv.config();

// Import Doctor model
const Doctor = require("./models/Doctor");

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

// Add/Update dummy doctor
const addDummyDoctor = async () => {
  try {
    await connectDB();

    console.log("🔍 Checking if dummy doctor already exists...");

    // Check if doctor with email dr.rahul.sharma@sehatsakhi.com already exists
    const existingDoctor = await Doctor.findOne({ email: "dr.rahul.sharma@sehatsakhi.com" });

    if (existingDoctor) {
      console.log("⚠️ Doctor already exists with email dr.rahul.sharma@sehatsakhi.com");
      console.log("📋 Existing doctor details:");
      console.log("   Name:", existingDoctor.name);
      console.log("   Email:", existingDoctor.email);
      console.log("   Phone:", existingDoctor.phone);
      console.log("   Doctor ID:", existingDoctor.doctorId);
      console.log("   Speciality:", existingDoctor.speciality);
      
      // Update password to "rahul@123" if needed
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash("rahul@123", salt);
      
      await Doctor.findByIdAndUpdate(existingDoctor._id, {
        password: hashedPassword,
        isVerified: true,
        status: "offline"
      });
      
      console.log("🔐 Password updated to 'rahul@123'");
      console.log("✅ Doctor verified and set to offline (will show online only after login)");
      
    } else {
      console.log("✅ No existing doctor found, creating new dummy doctor...");

      // Generate unique doctor ID
      const doctorCount = await Doctor.countDocuments();
      const doctorId = `D${String(doctorCount + 1).padStart(6, "0")}`;

      // Hash password
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash("rahul@123", salt);

      // Create dummy doctor
      const dummyDoctor = new Doctor({
        doctorId: doctorId,
        name: "Dr. Rahul Sharma",
        email: "dr.rahul.sharma@sehatsakhi.com",
        password: hashedPassword,
        phone: "+91-9876543210",
        speciality: "Cardiologist",
        qualification: "MBBS, MD (Cardiology)",
        experience: 8,
        licenseNumber: "MH/DOC/2024/001",
        consultationFee: 1200,
        department: "Cardiology",
        employeeId: "EMP001",
        languagesSpoken: ["Hindi", "English"],
        address: {
          street: "Civil Lines",
          city: "Mumbai",
          state: "Maharashtra",
          pincode: "400001",
          country: "India"
        },
        isVerified: true,
        status: "offline",
        isAvailable: false,
        permissions: ["consultation", "profile_update", "patient_management", "reports"],
        workingHours: {
          monday: { start: "09:00", end: "17:00", isWorking: true },
          tuesday: { start: "09:00", end: "17:00", isWorking: true },
          wednesday: { start: "09:00", end: "17:00", isWorking: true },
          thursday: { start: "09:00", end: "17:00", isWorking: true },
          friday: { start: "09:00", end: "17:00", isWorking: true },
          saturday: { start: "09:00", end: "13:00", isWorking: true },
          sunday: { start: "10:00", end: "12:00", isWorking: false }
        }
      });

      await dummyDoctor.save();

      console.log("✅ Dummy doctor created successfully!");
      console.log("📋 Doctor details:");
      console.log("   Name:", dummyDoctor.name);
      console.log("   Email:", dummyDoctor.email);
      console.log("   Phone:", dummyDoctor.phone);
      console.log("   Doctor ID:", dummyDoctor.doctorId);
      console.log("   Speciality:", dummyDoctor.speciality);
      console.log("   Department:", dummyDoctor.department);
      console.log("   Consultation Fee: ₹" + dummyDoctor.consultationFee);
    }

    console.log("\n✅ DUMMY DOCTOR LOGIN CREDENTIALS:");
    console.log("📧 Email: dr.rahul.sharma@sehatsakhi.com");
    console.log("🔑 Password: rahul@123");
    console.log("🏢 Department: Cardiology");
    
    console.log("\n🎯 Login Instructions:");
    console.log("1. Open doctor dashboard");
    console.log("2. Use email: dr.rahul.sharma@sehatsakhi.com");
    console.log("3. Use password: rahul@123");
    console.log("4. Select userType: doctor");

    process.exit(0);
  } catch (error) {
    console.error("❌ Error creating dummy doctor:", error);
    process.exit(1);
  }
};

// Run the function
addDummyDoctor();
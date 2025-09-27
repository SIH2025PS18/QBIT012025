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

// Add multiple doctors
const addMoreDoctors = async () => {
  try {
    await connectDB();

    console.log("🏥 Adding multiple doctors to the database...");

    // Array of doctor data (using correct enum values from Doctor model)
    const doctorsData = [
      {
        name: "Dr. Priya Sharma",
        email: "dr.priya.sharma@sehatsakhi.com",
        speciality: "Pediatrician",
        qualification: "MBBS, MD (Pediatrics)",
        experience: 6,
        consultationFee: 800,
        department: "Pediatrics"
      },
      {
        name: "Dr. Amit Kumar",
        email: "dr.amit.kumar@sehatsakhi.com",
        speciality: "Neurologist", 
        qualification: "MBBS, DM (Neurology)",
        experience: 10,
        consultationFee: 1500,
        department: "Neurology"
      },
      {
        name: "Dr. Sunita Rani",
        email: "dr.sunita.rani@sehatsakhi.com",
        speciality: "Gynecologist",
        qualification: "MBBS, MS (Gynecology)",
        experience: 8,
        consultationFee: 1000,
        department: "Obstetrics & Gynecology"
      },
      {
        name: "Dr. Rajesh Singh",
        email: "dr.rajesh.singh@sehatsakhi.com",
        speciality: "Orthopedic",
        qualification: "MBBS, MS (Orthopedics)",
        experience: 12,
        consultationFee: 1300,
        department: "Orthopedics"
      },
      {
        name: "Dr. Meera Gupta",
        email: "dr.meera.gupta@sehatsakhi.com",
        speciality: "Dermatologist",
        qualification: "MBBS, MD (Dermatology)",
        experience: 7,
        consultationFee: 900,
        department: "Dermatology"
      },
      {
        name: "Dr. Vikram Patel",
        email: "dr.vikram.patel@sehatsakhi.com",
        speciality: "General Practitioner",
        qualification: "MBBS, MD (Internal Medicine)",
        experience: 9,
        consultationFee: 700,
        department: "General Medicine"
      }
    ];

    // Create doctors one by one
    for (let i = 0; i < doctorsData.length; i++) {
      const doctorData = doctorsData[i];
      
      // Check if doctor already exists
      const existingDoctor = await Doctor.findOne({ email: doctorData.email });
      
      if (existingDoctor) {
        console.log(`⚠️ Doctor already exists: ${doctorData.name}`);
        continue;
      }

      // Generate unique doctor ID
      const doctorCount = await Doctor.countDocuments();
      const doctorId = `D${String(doctorCount + 1).padStart(6, "0")}`;

      // Generate password based on first name
      const firstName = doctorData.name.split(' ')[1].toLowerCase(); // Dr. Priya -> priya
      const password = `${firstName}@123`;
      
      // Hash password
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash(password, salt);

      // Create new doctor
      const newDoctor = new Doctor({
        doctorId: doctorId,
        name: doctorData.name,
        email: doctorData.email,
        password: hashedPassword,
        phone: `+91-98765${43210 + i}`, // Generate unique phone numbers
        speciality: doctorData.speciality,
        qualification: doctorData.qualification,
        experience: doctorData.experience,
        licenseNumber: `MH/DOC/2024/00${i + 2}`,
        consultationFee: doctorData.consultationFee,
        department: doctorData.department,
        employeeId: `EMP00${i + 2}`,
        languagesSpoken: ["Hindi", "English"],
        address: {
          street: "Medical Complex",
          city: "Mumbai",
          state: "Maharashtra", 
          pincode: "400001",
          country: "India"
        },
        isVerified: true,
        status: "offline", // Default offline until login
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

      await newDoctor.save();

      console.log(`✅ Created doctor: ${doctorData.name}`);
      console.log(`   📧 Email: ${doctorData.email}`);
      console.log(`   🔑 Password: ${password}`);
      console.log(`   🏥 Speciality: ${doctorData.speciality}`);
      console.log(`   💰 Fee: ₹${doctorData.consultationFee}`);
      console.log(`   ─────────────────────────────`);
    }

    console.log("\n🎯 ALL DOCTOR CREDENTIALS:");
    console.log("dr.rahul.sharma@sehatsakhi.com / rahul@123 (Cardiologist)");
    console.log("dr.priya.sharma@sehatsakhi.com / priya@123 (Pediatrician)");
    console.log("dr.amit.kumar@sehatsakhi.com / amit@123 (Neurologist)");
    console.log("dr.sunita.rani@sehatsakhi.com / sunita@123 (Gynecologist)");
    console.log("dr.rajesh.singh@sehatsakhi.com / rajesh@123 (Orthopedic)");
    console.log("dr.meera.gupta@sehatsakhi.com / meera@123 (Dermatologist)");
    console.log("dr.vikram.patel@sehatsakhi.com / vikram@123 (General Practitioner)");

    console.log("\n✅ All doctors added successfully!");
    console.log("📋 Now you have a comprehensive list of doctors across specialties");
    console.log("🎯 All doctors are initially offline - they will show online after login");

    process.exit(0);
  } catch (error) {
    console.error("❌ Error adding doctors:", error);
    process.exit(1);
  }
};

// Run the function
addMoreDoctors();
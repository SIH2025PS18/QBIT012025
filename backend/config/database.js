const mongoose = require("mongoose");

const connectDB = async () => {
  try {
    const mongoURI =
      process.env.MONGODB_URI || "mongodb://localhost:27017/telemed_unified";

    const conn = await mongoose.connect(mongoURI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log(`✅ MongoDB Connected: ${conn.connection.host}`);
    console.log(`📊 Database: ${conn.connection.name}`);

    // Seed initial data if needed
    await seedInitialData();

    return conn;
  } catch (error) {
    console.error("❌ Error connecting to MongoDB:", error.message);
    console.log(
      "⚠️  Server will continue without database. Please start MongoDB to enable full functionality."
    );
    // Don't exit - let server run without database for now
    // process.exit(1);
  }
};

// Function to seed initial data
const seedInitialData = async () => {
  try {
    const Doctor = require("../models/Doctor");
    const Patient = require("../models/Patient");
    const Admin = require("../models/Admin");

    // Check if any data already exists
    const doctorCount = await Doctor.countDocuments();
    const patientCount = await Patient.countDocuments();
    const adminCount = await Admin.countDocuments();

    // Clean up any problematic indexes first
    try {
      await Doctor.collection.dropIndex("registration_1");
      console.log("✅ Cleaned up problematic registration index");
    } catch (indexError) {
      // Index doesn't exist, which is fine
    }

    if (doctorCount === 0) {
      console.log("🌱 Seeding initial doctor data...");

      const initialDoctors = [
        {
          doctorId: "d1",
          name: "Dr. Arjun Mehta",
          email: "arjun.mehta@telemed.com",
          password:
            "$2a$12$LQv3c1yqBTVHaYbUU6JY1u5JnDJByfUhyjh9cVy/3KXHJ8X2fH4Te", // password
          phone: "+91-9876543210",
          speciality: "Cardiologist",
          qualification: "MBBS, MD (Cardiology)",
          experience: 8,
          licenseNumber: "DL/2015/001",
          consultationFee: 500,
          status: "online",
          isAvailable: true,
          languages: ["en", "hi"],
          rating: 4.5,
          isVerified: true,
        },
        {
          doctorId: "d2",
          name: "Dr. Riya Kapoor",
          email: "riya.kapoor@telemed.com",
          password:
            "$2a$12$LQv3c1yqBTVHaYbUU6JY1u5JnDJByfUhyjh9cVy/3KXHJ8X2fH4Te", // password
          phone: "+91-9876543211",
          speciality: "Dermatologist",
          qualification: "MBBS, MD (Dermatology)",
          experience: 6,
          licenseNumber: "DL/2017/002",
          consultationFee: 400,
          status: "offline",
          isAvailable: false,
          languages: ["en", "hi", "pa"],
          rating: 4.2,
          isVerified: true,
        },
      ];

      // Use upsert to avoid duplicate key errors
      for (const doctorData of initialDoctors) {
        await Doctor.findOneAndUpdate(
          { doctorId: doctorData.doctorId },
          doctorData,
          { upsert: true, new: true }
        );
      }
      console.log("✅ Initial doctors seeded successfully");
    } else {
      console.log(`ℹ️  Found ${doctorCount} existing doctors, skipping seed`);
    }

    if (patientCount === 0) {
      console.log("🌱 Seeding initial patient data...");

      const initialPatients = [
        {
          patientId: "p1",
          name: "John Doe",
          email: "john.doe@example.com",
          password:
            "$2a$12$LQv3c1yqBTVHaYbUU6JY1u5JnDJByfUhyjh9cVy/3KXHJ8X2fH4Te", // password
          phone: "+91-9876543301",
          age: 35,
          gender: "male",
          dateOfBirth: new Date("1988-05-15"),
          preferredLanguage: "en",
        },
        {
          patientId: "p2",
          name: "Priya Sharma",
          email: "priya.sharma@example.com",
          password:
            "$2a$12$LQv3c1yqBTVHaYbUU6JY1u5JnDJByfUhyjh9cVy/3KXHJ8X2fH4Te", // password
          phone: "+91-9876543302",
          age: 28,
          gender: "female",
          dateOfBirth: new Date("1995-08-22"),
          preferredLanguage: "hi",
        },
      ];

      // Use upsert to avoid duplicate key errors
      for (const patientData of initialPatients) {
        await Patient.findOneAndUpdate(
          { patientId: patientData.patientId },
          patientData,
          { upsert: true, new: true }
        );
      }
      console.log("✅ Initial patients seeded successfully");
    } else {
      console.log(`ℹ️  Found ${patientCount} existing patients, skipping seed`);
    }

    if (adminCount === 0) {
      console.log("🌱 Seeding admin user...");

      const adminData = {
        name: "System Admin",
        email: "admin@telemed.com",
        password:
          "$2a$12$LQv3c1yqBTVHaYbUU6JY1u5JnDJByfUhyjh9cVy/3KXHJ8X2fH4Te", // password
        phone: "+91-9876543000",
        role: "superadmin",
        permissions: ["all"],
      };

      await Admin.findOneAndUpdate({ email: adminData.email }, adminData, {
        upsert: true,
        new: true,
      });

      console.log("✅ Admin user created successfully");
      console.log("📧 Admin credentials: admin@telemed.com / password");
    } else {
      console.log(`ℹ️  Found ${adminCount} existing admins, skipping seed`);
    }
  } catch (error) {
    console.error("❌ Error seeding initial data:", error);
  }
};

module.exports = connectDB;

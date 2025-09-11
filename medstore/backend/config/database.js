const mongoose = require("mongoose");

const connectDB = async () => {
  try {
    const mongoURI =
      process.env.MONGODB_URI || "mongodb://localhost:27017/telemed";

    const conn = await mongoose.connect(mongoURI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log(`MongoDB Connected: ${conn.connection.host}`);

    // Seed initial data if needed
    await seedInitialData();
  } catch (error) {
    console.error("Error connecting to MongoDB:", error.message);
    process.exit(1);
  }
};

// Function to seed initial data
const seedInitialData = async () => {
  try {
    const Doctor = require("../models/Doctor");
    const Patient = require("../models/Patient");

    // Check if doctors already exist
    const doctorCount = await Doctor.countDocuments();
    if (doctorCount === 0) {
      console.log("Seeding initial doctor data...");

      const initialDoctors = [
        {
          doctorId: "d1",
          name: "Dr. Arjun Mehta",
          speciality: "Cardiologist",
          qualification: "MBBS, MD (Cardiology)",
          experience: 8,
          email: "arjun.mehta@telemed.com",
          phone: "+91-9876543210",
          status: "online",
          isAvailable: true,
          languages: ["en", "hi"],
          consultationFee: 500,
          rating: 4.5,
        },
        {
          doctorId: "d2",
          name: "Dr. Riya Kapoor",
          speciality: "Dermatologist",
          qualification: "MBBS, MD (Dermatology)",
          experience: 6,
          email: "riya.kapoor@telemed.com",
          phone: "+91-9876543211",
          status: "offline",
          isAvailable: false,
          languages: ["en", "hi", "pa"],
          consultationFee: 400,
          rating: 4.2,
        },
        {
          doctorId: "d3",
          name: "Dr. Mehta Roy",
          speciality: "Child Specialist",
          qualification: "MBBS, MD (Pediatrics)",
          experience: 10,
          email: "mehta.roy@telemed.com",
          phone: "+91-9876543212",
          status: "online",
          isAvailable: true,
          languages: ["en", "hi"],
          consultationFee: 450,
          rating: 4.7,
        },
        {
          doctorId: "d4",
          name: "Dr. Sneha Sharma",
          speciality: "Pediatrician",
          qualification: "MBBS, MD (Pediatrics)",
          experience: 5,
          email: "sneha.sharma@telemed.com",
          phone: "+91-9876543213",
          status: "offline",
          isAvailable: false,
          languages: ["en", "hi", "pa"],
          consultationFee: 350,
          rating: 4.0,
        },
        {
          doctorId: "d5",
          name: "Dr. Karan Singh",
          speciality: "Neurologist",
          qualification: "MBBS, MD (Neurology)",
          experience: 12,
          email: "karan.singh@telemed.com",
          phone: "+91-9876543214",
          status: "online",
          isAvailable: true,
          languages: ["en", "hi", "pa"],
          consultationFee: 600,
          rating: 4.8,
        },
      ];

      await Doctor.insertMany(initialDoctors);
      console.log("Initial doctors seeded successfully");
    }

    // Check if patients already exist
    const patientCount = await Patient.countDocuments();
    if (patientCount === 0) {
      console.log("Seeding initial patient data...");

      const initialPatients = [
        {
          patientId: "p1",
          name: "John Doe",
          age: 35,
          gender: "male",
          phone: "+91-9876543301",
          condition: "Heart Pain",
          symptoms: ["chest pain", "shortness of breath"],
          priority: "high",
          status: "waiting",
          assignedDoctorId: "d1",
        },
        {
          patientId: "p2",
          name: "Priya Sharma",
          age: 28,
          gender: "female",
          phone: "+91-9876543302",
          condition: "Skin Allergy",
          symptoms: ["rash", "itching"],
          priority: "normal",
          status: "waiting",
          assignedDoctorId: "d2",
        },
        {
          patientId: "p3",
          name: "Amit Verma",
          age: 42,
          gender: "male",
          phone: "+91-9876543303",
          condition: "General Checkup",
          symptoms: ["routine checkup"],
          priority: "low",
          status: "waiting",
        },
      ];

      await Patient.insertMany(initialPatients);
      console.log("Initial patients seeded successfully");
    }
  } catch (error) {
    console.error("Error seeding initial data:", error);
  }
};

module.exports = connectDB;

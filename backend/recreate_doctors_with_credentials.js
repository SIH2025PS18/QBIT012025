// Clear all doctors and recreate with proper credentials
const mongoose = require('mongoose');
require('dotenv').config();

// Import the Doctor model
const Doctor = require('./models/Doctor');

const doctorsData = [
  {
    name: 'Dr. Rahul Sharma',
    email: 'dr.rahul.sharma@sehatsakhi.com',
    phone: '+91-9876543210',
    speciality: 'Cardiologist',
    qualification: 'MBBS, MD Cardiology',
    experience: 8,
    licenseNumber: 'MH/DOC/2024/001',
    consultationFee: 1200,
    isAvailable: true,
    isVerified: true,
    languages: ['hi', 'en'],
    employeeId: 'EMP001',
    department: 'Cardiology',
    permissions: ['consultation', 'patient_management', 'reports'],
    address: {
      street: 'Civil Lines',
      city: 'Mumbai',
      state: 'Maharashtra',
      country: 'India'
    }
  },
  {
    name: 'Dr. Preet Kaur',
    email: 'dr.preet.kaur@sehatsakhi.com',
    phone: '+91-9876543211',
    speciality: 'Pediatrician',
    qualification: 'MBBS, MD Pediatrics',
    experience: 6,
    licenseNumber: 'PB/DOC/2024/002',
    consultationFee: 1000,
    isAvailable: true,
    isVerified: true,
    languages: ['pa', 'hi', 'en'],
    employeeId: 'EMP002',
    department: 'Pediatrics',
    permissions: ['consultation', 'patient_management', 'reports', 'admin'],
    address: {
      street: 'Model Town',
      city: 'Ludhiana',
      state: 'Punjab',
      country: 'India'
    }
  },
  {
    name: 'Dr. Amit Patel',
    email: 'dr.amit.patel@sehatsakhi.com',
    phone: '+91-9876543212',
    speciality: 'Orthopedic',
    qualification: 'MBBS, MS Orthopedics',
    experience: 12,
    licenseNumber: 'GJ/DOC/2024/003',
    consultationFee: 1500,
    isAvailable: true,
    isVerified: true,
    languages: ['hi', 'en'],
    employeeId: 'EMP003',
    department: 'Orthopedics',
    permissions: ['consultation', 'patient_management', 'reports'],
    address: {
      street: 'Satellite',
      city: 'Ahmedabad',
      state: 'Gujarat',
      country: 'India'
    }
  },
  {
    name: 'Dr. Harjeet Singh',
    email: 'dr.harjeet.singh@sehatsakhi.com',
    phone: '+91-9876543213',
    speciality: 'General Practitioner',
    qualification: 'MBBS, MD General Medicine',
    experience: 10,
    licenseNumber: 'PB/DOC/2024/004',
    consultationFee: 800,
    isAvailable: true,
    isVerified: true,
    languages: ['pa', 'hi', 'en'],
    employeeId: 'EMP004',
    department: 'General Medicine',
    permissions: ['consultation', 'patient_management', 'reports'],
    address: {
      street: 'Green Avenue',
      city: 'Amritsar',
      state: 'Punjab',
      country: 'India'
    }
  },
  {
    name: 'Dr. Sunita Gupta',
    email: 'dr.sunita.gupta@sehatsakhi.com',
    phone: '+91-9876543214',
    speciality: 'Gynecologist',
    qualification: 'MBBS, MD Gynecology',
    experience: 9,
    licenseNumber: 'UP/DOC/2024/005',
    consultationFee: 1300,
    isAvailable: true,
    isVerified: true,
    languages: ['hi', 'en'],
    employeeId: 'EMP005',
    department: 'Gynecology',
    permissions: ['consultation', 'patient_management', 'reports'],
    address: {
      street: 'Hazratganj',
      city: 'Lucknow',
      state: 'Uttar Pradesh',
      country: 'India'
    }
  },
  {
    name: 'Dr. Ravi Dhaliwal',
    email: 'dr.ravi.dhaliwal@sehatsakhi.com',
    phone: '+91-9876543215',
    speciality: 'Dermatologist',
    qualification: 'MBBS, MD Dermatology',
    experience: 7,
    licenseNumber: 'PB/DOC/2024/006',
    consultationFee: 1100,
    isAvailable: true,
    isVerified: true,
    languages: ['pa', 'hi', 'en'],
    employeeId: 'EMP006',
    department: 'Dermatology',
    permissions: ['consultation', 'patient_management', 'reports'],
    address: {
      street: 'Urban Estate',
      city: 'Patiala',
      state: 'Punjab',
      country: 'India'
    }
  }
];

async function clearAndRecreateDoubts() {
  try {
    console.log('🔌 Connecting to MongoDB...');
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/telemed_db');
    console.log('✅ Connected to MongoDB');

    console.log('🗑️  Clearing existing doctors...');
    const deleteResult = await Doctor.deleteMany({});
    console.log(`🗑️  Deleted ${deleteResult.deletedCount} existing doctors`);

    console.log('👨‍⚕️ Creating new doctors with proper credentials...');
    const bcrypt = require('bcryptjs');

    let createdCount = 0;
    for (const doctorData of doctorsData) {
      try {
        // Generate unique doctor ID
        const doctorCount = await Doctor.countDocuments();
        const doctorId = `D${String(doctorCount + 1).padStart(6, "0")}`;

        // Generate password in firstName@123 format
        let cleanName = doctorData.name.replace(/^dr\.?\s*/i, '').trim();
        const firstName = cleanName.split(' ')[0].toLowerCase();
        const cleanFirstName = firstName.replace(/[^a-z]/g, '');
        const defaultPassword = `${cleanFirstName}@123`;
        
        console.log(`🔐 Doctor: ${doctorData.name} | Email: ${doctorData.email} | Password: ${defaultPassword}`);
        
        const salt = await bcrypt.genSalt(12);
        const hashedPassword = await bcrypt.hash(defaultPassword, salt);

        const doctor = new Doctor({
          doctorId,
          name: doctorData.name,
          email: doctorData.email,
          password: hashedPassword,
          phone: doctorData.phone,
          speciality: doctorData.speciality,
          qualification: doctorData.qualification,
          experience: doctorData.experience,
          licenseNumber: doctorData.licenseNumber,
          consultationFee: doctorData.consultationFee,
          languages: doctorData.languages,
          address: doctorData.address,
          isVerified: doctorData.isVerified,
          isAvailable: doctorData.isAvailable,
          employeeId: doctorData.employeeId,
          department: doctorData.department,
          permissions: doctorData.permissions,
          status: "offline",
          workingHours: {
            start: "09:00",
            end: "17:00",
            timezone: "Asia/Kolkata"
          }
        });

        await doctor.save();
        console.log(`✅ Created doctor: ${doctorData.name} (${doctorId})`);
        createdCount++;
      } catch (error) {
        console.error(`❌ Error creating doctor ${doctorData.name}:`, error.message);
      }
    }

    console.log(`\n🎉 Successfully created ${createdCount} doctors with proper credentials!`);
    console.log('\n📋 Login Credentials Summary:');
    console.log('=' * 50);
    
    // Display all credentials
    for (const doctorData of doctorsData) {
      let cleanName = doctorData.name.replace(/^dr\.?\s*/i, '').trim();
      const firstName = cleanName.split(' ')[0].toLowerCase();
      const cleanFirstName = firstName.replace(/[^a-z]/g, '');
      const defaultPassword = `${cleanFirstName}@123`;
      
      console.log(`👨‍⚕️ ${doctorData.name}`);
      console.log(`   📧 Email: ${doctorData.email}`);
      console.log(`   🔑 Password: ${defaultPassword}`);
      console.log(`   🏢 Department: ${doctorData.department}`);
      console.log(`   🆔 Employee ID: ${doctorData.employeeId}`);
      console.log(`   ⚕️  Speciality: ${doctorData.speciality}`);
      console.log(`   💰 Fee: ₹${doctorData.consultationFee}`);
      console.log('   ---');
    }

  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    console.log('🔌 Closing database connection...');
    await mongoose.disconnect();
    console.log('✅ Database connection closed');
    process.exit(0);
  }
}

clearAndRecreateDoubts();
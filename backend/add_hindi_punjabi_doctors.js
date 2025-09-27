require('dotenv').config();
const mongoose = require('mongoose');
const Doctor = require('./models/Doctor');
const bcrypt = require('bcryptjs');

const hindiPunjabiDoctors = [
  {
    name: 'डॉ. राहुल शर्मा',
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
    password: 'Doctor@123',
    department: 'Cardiology',
    employeeId: 'EMP001',
    permissions: ['consultation', 'patient_management', 'reports']
  },
  {
    name: 'ਡਾ. ਪ੍ਰੀਤ ਕੌਰ',
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
    password: 'Preet@456',
    department: 'Pediatrics',
    employeeId: 'EMP002',
    permissions: ['consultation', 'patient_management', 'reports', 'admin']
  },
  {
    name: 'डॉ. अमित पटेल',
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
    password: 'Amit@789',
    department: 'Orthopedics',
    employeeId: 'EMP003',
    permissions: ['consultation', 'patient_management', 'reports']
  },
  {
    name: 'ਡਾ. ਹਰਜੀਤ ਸਿੰਘ',
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
    password: 'Harjeet@101',
    department: 'General Medicine',
    employeeId: 'EMP004',
    permissions: ['consultation', 'patient_management', 'reports']
  },
  {
    name: 'डॉ. सुनीता गुप्ता',
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
    password: 'Sunita@202',
    department: 'Gynecology',
    employeeId: 'EMP005',
    permissions: ['consultation', 'patient_management', 'reports']
  },
  {
    name: 'ਡਾ. ਰਵਿ ਧਾਲੀਵਾਲ',
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
    password: 'Ravi@303',
    department: 'Dermatology',
    employeeId: 'EMP006',
    permissions: ['consultation', 'patient_management', 'reports']
  }
];

const addHindiPunjabiDoctors = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('📱 Connected to MongoDB');

    for (const doctorData of hindiPunjabiDoctors) {
      try {
        // Hash the password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(doctorData.password, salt);

        // Create doctor with hashed password
        const doctor = new Doctor({
          ...doctorData,
          password: hashedPassword,
          doctorId: `DOC${Date.now()}${Math.floor(Math.random() * 1000)}`,
          joinedAt: new Date(),
          workingHours: {
            start: '09:00',
            end: '17:00',
            days: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
          }
        });

        await doctor.save();
        console.log(`✅ Added Dr. ${doctorData.name} - Email: ${doctorData.email} - Password: ${doctorData.password}`);
      } catch (error) {
        console.error(`❌ Error adding ${doctorData.name}:`, error.message);
      }
    }

    console.log('\n🎉 Successfully added all Hindi and Punjabi doctors!');
    console.log('\n📋 Doctor Login Credentials:');
    hindiPunjabiDoctors.forEach(doc => {
      console.log(`👨‍⚕️  ${doc.name}: ${doc.email} / ${doc.password}`);
    });
    
    process.exit(0);
  } catch (error) {
    console.error('❌ Error adding doctors:', error);
    process.exit(1);
  }
};

addHindiPunjabiDoctors();
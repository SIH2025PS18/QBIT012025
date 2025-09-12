const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
require('dotenv').config();

// Import models
const Doctor = require('../models/Doctor');

// Connect to database
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Connected to MongoDB');
  } catch (error) {
    console.error('❌ MongoDB connection error:', error);
    process.exit(1);
  }
};

// Function to generate firstName@123 password
const generatePassword = (name) => {
  // Remove "Dr." prefix and clean up the name
  let cleanName = name.replace(/^dr\.?\s*/i, '').trim();
  // Get the first word as first name
  const firstName = cleanName.split(' ')[0].toLowerCase();
  // Remove any non-alphabetic characters
  const cleanFirstName = firstName.replace(/[^a-z]/g, '');
  return `${cleanFirstName}@123`;
};

// Update doctor passwords
const updateDoctorPasswords = async () => {
  try {
    console.log('🔄 Starting doctor password update...');
    
    // Get all doctors
    const doctors = await Doctor.find({}).select('_id name email');
    console.log(`📋 Found ${doctors.length} doctors to update`);
    
    for (const doctor of doctors) {
      try {
        // Generate new password
        const newPassword = generatePassword(doctor.name);
        console.log(`🔐 Updating password for ${doctor.name} (${doctor.email}) to: ${newPassword}`);
        
        // Hash the new password
        const salt = await bcrypt.genSalt(12);
        const hashedPassword = await bcrypt.hash(newPassword, salt);
        
        // Update the doctor
        await Doctor.findByIdAndUpdate(doctor._id, {
          password: hashedPassword
        });
        
        console.log(`✅ Updated password for ${doctor.name}`);
      } catch (error) {
        console.error(`❌ Error updating password for ${doctor.name}:`, error);
      }
    }
    
    console.log('🎉 Password update completed!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error updating doctor passwords:', error);
    process.exit(1);
  }
};

// Run the script
const run = async () => {
  await connectDB();
  await updateDoctorPasswords();
};

run();
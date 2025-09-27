const bcrypt = require('bcryptjs');
const mongoose = require('mongoose');
const Patient = require('./models/Patient');

require('dotenv').config();

// Script to check and reset patient password for testing

async function checkAndResetPatientPassword() {
  try {
    console.log('🔍 Checking Patient Database...\n');

    // Connect to MongoDB
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Connected to MongoDB');

    // Find a patient
    const testPatient = await Patient.findOne();
    if (!testPatient) {
      console.error('❌ No patients found in database');
      return;
    }

    console.log('👤 Found patient:');
    console.log(`   ID: ${testPatient._id}`);
    console.log(`   Name: ${testPatient.name}`);
    console.log(`   Phone: ${testPatient.phone}`);
    console.log(`   Email: ${testPatient.email}`);
    console.log(`   Current password hash: ${testPatient.password.substring(0, 20)}...`);

    // Reset password to a known value for testing
    const newPassword = 'patient123';
    const hashedPassword = await bcrypt.hash(newPassword, 12);

    console.log(`\n🔄 Resetting password to: ${newPassword}`);
    
    await Patient.findByIdAndUpdate(testPatient._id, {
      password: hashedPassword
    });

    console.log('✅ Password reset successful');
    console.log('\n📋 Test credentials:');
    console.log(`   Phone: ${testPatient.phone}`);
    console.log(`   Email: ${testPatient.email}`);
    console.log(`   Password: ${newPassword}`);
    console.log(`   User Type: patient`);

  } catch (error) {
    console.error('💥 Error:', error);
  } finally {
    mongoose.connection.close();
  }
}

checkAndResetPatientPassword();
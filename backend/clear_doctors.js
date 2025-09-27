require('dotenv').config();
const mongoose = require('mongoose');
const Doctor = require('./models/Doctor');

const clearAllDoctors = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('📱 Connected to MongoDB');

    // Count existing doctors
    const count = await Doctor.countDocuments();
    console.log(`🔍 Found ${count} doctors in database`);

    if (count > 0) {
      // Delete all doctors
      const result = await Doctor.deleteMany({});
      console.log(`🗑️  Deleted ${result.deletedCount} doctors`);
    } else {
      console.log('ℹ️  No doctors found to delete');
    }

    console.log('✅ Successfully cleared all doctors from database');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error clearing doctors:', error);
    process.exit(1);
  }
};

clearAllDoctors();
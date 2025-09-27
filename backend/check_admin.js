require('dotenv').config();
const mongoose = require('mongoose');
const Admin = require('./models/Admin');

const checkAdmin = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('📱 Connected to MongoDB');

    const admins = await Admin.find({});
    console.log(`🔍 Found ${admins.length} admin(s)`);
    
    admins.forEach((admin, index) => {
      console.log(`Admin ${index + 1}:`);
      console.log(`  Email: ${admin.email}`);
      console.log(`  Name: ${admin.name}`);
      console.log(`  Role: ${admin.role}`);
      console.log(`  Created: ${admin.createdAt}`);
      console.log('---');
    });

    process.exit(0);
  } catch (error) {
    console.error('❌ Error checking admin:', error);
    process.exit(1);
  }
};

checkAdmin();
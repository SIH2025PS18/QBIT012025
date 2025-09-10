require('dotenv').config();
const mongoose = require('mongoose');
const User = require('./models/User');

const seedAdmin = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    
    console.log('Connected to MongoDB');
    
    // Check if admin already exists
    const existingAdmin = await User.findOne({ email: 'admin@medstore.com' });
    if (existingAdmin) {
      console.log('Admin user already exists');
      console.log('Email: admin@medstore.com');
      return;
    }
    
    // Create admin user with plain text password
    const adminUser = new User({
      name: 'Admin User',
      email: 'admin@medstore.com',
      password: 'admin123', // Will be hashed by pre-save hook
      role: 'admin',
      phone: '+1234567890'
    });
    
    await adminUser.save();
    console.log('Admin user created successfully');
    console.log('Email: admin@medstore.com');
    console.log('Password: admin123');
    
  } catch (error) {
    console.error('Error seeding admin:', error);
  } finally {
    await mongoose.connection.close();
    process.exit(0);
  }
};

seedAdmin();
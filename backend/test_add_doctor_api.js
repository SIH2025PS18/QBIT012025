require('dotenv').config();
const axios = require('axios');

const testAddDoctor = async () => {
  try {
    const baseUrl = 'http://localhost:5002/api';
    
    // Test doctor data
    const doctorData = {
      name: 'डॉ. विकास कुमार',
      email: 'dr.vikas.kumar@sehatsakhi.com',
      phone: '+91-9876543220',
      speciality: 'Neurologist',
      qualification: 'MBBS, MD Neurology',
      experience: 15,
      licenseNumber: 'DL/DOC/2024/010',
      consultationFee: 1800,
      isAvailable: true,
      languages: ['hi', 'en'],
      isVerified: true
    };

    console.log('🧪 Testing Add Doctor API...');
    console.log('📋 Doctor Data:', JSON.stringify(doctorData, null, 2));

    const response = await axios.post(`${baseUrl}/doctors`, doctorData, {
      headers: {
        'Content-Type': 'application/json',
        // Note: In real scenario, you would need admin JWT token here
      }
    });

    if (response.status === 200 || response.status === 201) {
      console.log('✅ Doctor created successfully!');
      console.log('📄 Response:', JSON.stringify(response.data, null, 2));
      
      if (response.data.defaultPassword) {
        console.log(`🔑 Login Credentials:`);
        console.log(`📧 Email: ${doctorData.email}`);
        console.log(`🔒 Password: ${response.data.defaultPassword}`);
      }
    } else {
      console.log('❌ Failed to create doctor');
      console.log('Status:', response.status);
      console.log('Response:', response.data);
    }
    
  } catch (error) {
    console.error('❌ Error testing add doctor:', error.response?.data || error.message);
    
    if (error.response?.status === 401) {
      console.log('ℹ️  This is expected - API requires admin authentication');
      console.log('ℹ️  The admin panel should handle authentication automatically');
    }
  }
};

testAddDoctor();
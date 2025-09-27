const axios = require('axios');

const baseURL = 'http://localhost:5002/api';

const testData = {
  loginId: 'admin@telemed.com',
  password: 'password',
  userType: 'admin'
};

const doctorData = {
  name: 'Test Doctor New',
  email: 'testnewdoctor@example.com',
  phone: '+91-1234567890',
  speciality: 'General Practitioner',
  qualification: 'MBBS',
  experience: 5,
  licenseNumber: 'TEST-12345',
  consultationFee: 500,
  isAvailable: true,
  languages: ['en', 'hi'],
  isVerified: true,
  address: {
    street: 'Test Street',
    city: 'Test City',
    state: 'Test State',
    country: 'India'
  }
};

async function testAddDoctor() {
  try {
    console.log('🔐 Logging in as admin...');
    const loginResponse = await axios.post(`${baseURL}/auth/login`, testData);
    
    if (loginResponse.data.success) {
      console.log('✅ Admin login successful');
      const token = loginResponse.data.data.token;
      console.log('🔑 Token received:', !!token ? 'Yes' : 'No');
      
      console.log('🧪 Testing Add Doctor API with auth...');
      console.log('📋 Doctor Data:', JSON.stringify(doctorData, null, 2));
      
      const response = await axios.post(`${baseURL}/doctors`, doctorData, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      });
      
      console.log('✅ Doctor created successfully:', response.data);
      
    } else {
      console.log('❌ Admin login failed:', loginResponse.data);
    }
    
  } catch (error) {
    if (error.response) {
      console.log('❌ Error testing add doctor:', error.response.data);
      console.log('📍 Request failed at:', error.config.url);
      console.log('ℹ️  Status:', error.response.status, error.response.statusText);
    } else {
      console.log('❌ Network error:', error.message);
    }
  }
}

testAddDoctor();
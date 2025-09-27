require('dotenv').config();
const axios = require('axios');

const testAddDoctorWithAuth = async () => {
  try {
    const baseUrl = 'http://localhost:5002/api';
    
    // First, login as admin to get auth token
    console.log('🔐 Logging in as admin...');
    const loginResponse = await axios.post(`${baseUrl}/auth/login`, {
      loginId: 'admin@telemed.com',
      password: 'password',
      userType: 'admin'
    });

    if (loginResponse.data.success) {
      const token = loginResponse.data.data.token;
      console.log('✅ Admin login successful');
      console.log('🔑 Token received:', token ? 'Yes' : 'No');
      
      // Test doctor data with correct format
      const doctorData = {
        name: 'डॉ. अनिल शर्मा',
        email: 'dr.anil.sharma@sehatsakhi.com',
        phone: '+91-9876543230',
        speciality: 'Neurologist',
        qualification: 'MBBS, MD Neurology',
        experience: 12,
        licenseNumber: 'DL/DOC/2024/020',
        consultationFee: 1600,
        isAvailable: true,
        languages: ['hi', 'en'], // Use language codes
        isVerified: true,
        address: {
          full: 'Delhi, India'
        }
      };

      console.log('🧪 Testing Add Doctor API with auth...');
      console.log('📋 Doctor Data:', JSON.stringify(doctorData, null, 2));

      const response = await axios.post(`${baseUrl}/doctors`, doctorData, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`
        }
      });

      if (response.status === 200 || response.status === 201) {
        console.log('✅ Doctor created successfully!');
        console.log('📄 Response:', JSON.stringify(response.data, null, 2));
        
        if (response.data.defaultPassword) {
          console.log(`\n🔑 Login Credentials:`);
          console.log(`📧 Email: ${doctorData.email}`);
          console.log(`🔒 Password: ${response.data.defaultPassword}`);
        }
      } else {
        console.log('❌ Failed to create doctor');
        console.log('Status:', response.status);
        console.log('Response:', response.data);
      }
    } else {
      console.log('❌ Admin login failed');
    }
    
  } catch (error) {
    console.error('❌ Error testing add doctor:', error.response?.data || error.message);
    console.error('📍 Request failed at:', error.config?.url);
    
    if (error.response?.status === 400) {
      console.log('ℹ️  Bad request - check data format');
    }
  }
};

testAddDoctorWithAuth();
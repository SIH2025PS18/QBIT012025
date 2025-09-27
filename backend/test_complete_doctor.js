const axios = require('axios');

const baseURL = 'http://localhost:5002/api';

const testData = {
  loginId: 'admin@telemed.com',
  password: 'password',
  userType: 'admin'
};

const doctorData = {
  name: 'Dr. Complete Test',
  email: 'completetest@example.com',
  phone: '+91-9876543299',
  speciality: 'General Practitioner',
  qualification: 'MBBS, MD',
  experience: 7,
  licenseNumber: 'COMPLETE-123',
  consultationFee: 800,
  isAvailable: true,
  languages: ['en', 'hi', 'pa'],
  isVerified: true,
  address: {
    street: 'Complete Test Street',
    city: 'Test City',
    state: 'Test State',
    country: 'India'
  },
  // New admin management fields
  employeeId: 'EMP12345',
  department: 'General Medicine',
  emergencyContact: '+91-9876543298',
  licenseExpiryDate: '2025-12-31',
  permissions: ['consultation', 'profile_update', 'reports']
};

async function testCompleteDoctor() {
  try {
    console.log('🔐 Logging in as admin...');
    const loginResponse = await axios.post(`${baseURL}/auth/login`, testData);
    
    if (loginResponse.data.success) {
      console.log('✅ Admin login successful');
      const token = loginResponse.data.data.token;
      
      console.log('🧪 Testing Complete Doctor Creation with All Fields...');
      console.log('📋 Doctor Data:', JSON.stringify(doctorData, null, 2));
      
      const response = await axios.post(`${baseURL}/doctors`, doctorData, {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      });
      
      console.log('✅ Doctor created successfully with all fields!');
      console.log('🏥 Created Doctor Data:', JSON.stringify(response.data.data, null, 2));
      console.log('🔑 Generated Password:', response.data.defaultPassword);
      
      // Verify all fields are present
      const createdDoctor = response.data.data;
      console.log('📋 Field Verification:');
      console.log('  Employee ID:', createdDoctor.employeeId);
      console.log('  Department:', createdDoctor.department);
      console.log('  Emergency Contact:', createdDoctor.emergencyContact);
      console.log('  License Expiry:', createdDoctor.licenseExpiryDate);
      console.log('  Permissions:', createdDoctor.permissions);
      
    } else {
      console.log('❌ Admin login failed:', loginResponse.data);
    }
    
  } catch (error) {
    if (error.response) {
      console.log('❌ Error testing complete doctor creation:', error.response.data);
      console.log('📍 Status:', error.response.status, error.response.statusText);
    } else {
      console.log('❌ Network error:', error.message);
    }
  }
}

testCompleteDoctor();
const axios = require('axios');
const mongoose = require('mongoose');
const Patient = require('./models/Patient');

require('dotenv').config();

// Test script to verify phone + password login functionality

async function testPhonePasswordLogin() {
  try {
    console.log('🔐 Testing Phone + Password Login Functionality\n');

    // Connect to MongoDB to find a test patient
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Connected to MongoDB');

    // Find a patient to test with
    const testPatient = await Patient.findOne().select('-password');
    if (!testPatient) {
      console.error('❌ No test patient found in database');
      return;
    }

    console.log('👤 Test patient found:');
    console.log(`   ID: ${testPatient._id}`);
    console.log(`   Name: ${testPatient.name}`);
    console.log(`   Phone: ${testPatient.phone}`);
    console.log(`   Email: ${testPatient.email}`);

    // Test data for login
    const loginTests = [
      {
        name: 'Phone + Password Login',
        loginId: testPatient.phone,
        password: 'patient123', // Assuming this is the default password
        userType: 'patient'
      },
      {
        name: 'Email + Password Login',
        loginId: testPatient.email,
        password: 'patient123',
        userType: 'patient'
      }
    ];

    console.log('\n🧪 Running Login Tests...\n');

    for (const test of loginTests) {
      console.log(`\n📱 Testing: ${test.name}`);
      console.log(`   Login ID: ${test.loginId}`);
      console.log(`   User Type: ${test.userType}`);

      try {
        const response = await axios.post(
          'http://192.168.1.7:5002/api/auth/login',
          {
            loginId: test.loginId,
            password: test.password,
            userType: test.userType
          },
          {
            headers: {
              'Content-Type': 'application/json'
            },
            timeout: 10000
          }
        );

        console.log(`✅ ${test.name} - SUCCESS`);
        console.log(`   Status: ${response.status}`);
        console.log(`   Message: ${response.data.message}`);
        console.log(`   User ID: ${response.data.data.user.id}`);
        console.log(`   User Name: ${response.data.data.user.name}`);
        console.log(`   Token Length: ${response.data.data.token.length}`);

      } catch (error) {
        console.log(`❌ ${test.name} - FAILED`);
        
        if (error.response) {
          console.log(`   Status: ${error.response.status}`);
          console.log(`   Error: ${error.response.data.message}`);
          if (error.response.data.errors) {
            console.log(`   Validation errors:`, error.response.data.errors);
          }
        } else if (error.request) {
          console.log('   No response received - Server might be down');
        } else {
          console.log(`   Error: ${error.message}`);
        }
      }
    }

    // Test with invalid credentials
    console.log('\n🚫 Testing Invalid Credentials...');

    try {
      const response = await axios.post(
        'http://192.168.1.7:5002/api/auth/login',
        {
          loginId: testPatient.phone,
          password: 'wrongpassword',
          userType: 'patient'
        },
        {
          headers: {
            'Content-Type': 'application/json'
          },
          timeout: 10000
        }
      );

      console.log('❌ Invalid credentials test FAILED - Should have been rejected');
    } catch (error) {
      if (error.response && error.response.status === 401) {
        console.log('✅ Invalid credentials correctly rejected');
        console.log(`   Status: ${error.response.status}`);
        console.log(`   Message: ${error.response.data.message}`);
      } else {
        console.log('❌ Unexpected error for invalid credentials');
        console.log(`   Error: ${error.message}`);
      }
    }

  } catch (error) {
    console.error('💥 Test failed:', error.message);
  } finally {
    mongoose.connection.close();
  }
}

// Wait for server to start, then run tests
setTimeout(() => {
  console.log('⏳ Waiting for server to start...\n');
  testPhonePasswordLogin();
}, 3000);
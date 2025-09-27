const axios = require('axios');

// Test profile update to debug the 500 error
async function testProfileUpdate() {
    console.log('🧪 Testing Profile Update to Debug 500 Error');
    console.log('=' .repeat(60));
    
    try {
        // First, login to get a valid token
        console.log('🔐 Step 1: Login to get authentication token');
        const loginData = {
            loginId: '+91-9876543301',
            password: 'patient123',
            userType: 'patient'
        };
        
        const loginResponse = await axios.post('https://telemed18.onrender.com/api/auth/login', loginData);
        
        if (!loginResponse.data.data?.token) {
            console.log('❌ Login failed - no token received');
            console.log('Response:', loginResponse.data);
            return;
        }
        
        const token = loginResponse.data.data.token;
        const userId = loginResponse.data.data.user.id;
        console.log('✅ Login successful');
        console.log(`👤 User ID: ${userId}`);
        console.log(`🎫 Token: ${token.substring(0, 20)}...`);
        
        // Step 2: Test profile update
        console.log('\n📝 Step 2: Test Profile Update');
        
        const profileData = {
            fullName: 'John Updated Doe',
            email: 'john.doe.updated@example.com',
            phoneNumber: '+91-9876543301',
            dateOfBirth: '1990-01-01',
            gender: 'male',
            bloodGroup: 'O+',
            address: 'Updated Test Address',
            emergencyContact: 'Jane Doe',
            emergencyContactPhone: '+91-9876543302'
        };
        
        console.log('📤 Sending profile update request...');
        console.log('Data:', JSON.stringify(profileData, null, 2));
        
        const updateResponse = await axios.put(
            'https://telemed18.onrender.com/api/patients/profile',
            profileData,
            {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            }
        );
        
        console.log('✅ Profile Update: SUCCESS');
        console.log(`📊 Status: ${updateResponse.status}`);
        console.log(`📝 Message: ${updateResponse.data.message}`);
        console.log('Updated Data:', updateResponse.data.data?.name || 'No name field');
        
    } catch (error) {
        console.log('❌ Profile Update: FAILED');
        console.log(`📊 Status: ${error.response?.status}`);
        console.log(`📝 Error Message: ${error.response?.data?.message}`);
        console.log(`🔧 Error Details: ${error.response?.data?.error}`);
        console.log('\n📄 Full Error Response:');
        if (error.response?.data) {
            console.log(JSON.stringify(error.response.data, null, 2));
        }
        console.log('\n🔍 Request Details:');
        console.log(`URL: ${error.config?.url}`);
        console.log(`Method: ${error.config?.method?.toUpperCase()}`);
        console.log('Headers:', error.config?.headers);
    }
}

// Run the test
testProfileUpdate()
    .then(() => {
        console.log('\n✅ Profile update test completed');
    })
    .catch(error => {
        console.log('\n💥 Test execution failed:', error.message);
    });
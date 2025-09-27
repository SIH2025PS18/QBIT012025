const axios = require('axios');

// Test credentials for phone authentication
const TEST_PHONE = '+91-9876543301';
const TEST_PASSWORD = 'patient123';

async function debugPhoneAuthResponse() {
    console.log('🔍 Debugging Phone Authentication Response');
    console.log('=' .repeat(50));
    
    try {
        const loginData = {
            loginId: TEST_PHONE,
            password: TEST_PASSWORD,
            userType: 'patient'
        };
        
        console.log('📤 Request Data:');
        console.log(JSON.stringify(loginData, null, 2));
        
        const response = await axios.post('http://192.168.1.7:5002/api/auth/login', loginData);
        
        console.log('\n📥 Response Details:');
        console.log(`Status: ${response.status}`);
        console.log(`Status Text: ${response.statusText}`);
        
        console.log('\n📄 Full Response Data:');
        console.log(JSON.stringify(response.data, null, 2));
        
        console.log('\n🔍 Response Analysis:');
        console.log(`Has token: ${!!response.data.token}`);
        console.log(`Has user: ${!!response.data.user}`);
        console.log(`Message: ${response.data.message}`);
        
        if (response.data.token) {
            console.log(`Token type: ${typeof response.data.token}`);
            console.log(`Token length: ${response.data.token.length}`);
            console.log(`Token preview: ${response.data.token.substring(0, 20)}...`);
        }
        
        if (response.data.user) {
            console.log(`User ID: ${response.data.user.id}`);
            console.log(`User Type: ${response.data.user.userType}`);
            console.log(`User Email: ${response.data.user.email}`);
            console.log(`User Phone: ${response.data.user.phone}`);
        }
        
    } catch (error) {
        console.log('💥 Error:');
        console.log(`Status: ${error.response?.status}`);
        console.log(`Message: ${error.response?.data?.message || error.message}`);
        console.log('\n📄 Full Error Response:');
        if (error.response?.data) {
            console.log(JSON.stringify(error.response.data, null, 2));
        }
    }
}

debugPhoneAuthResponse()
    .then(() => console.log('\n✅ Debug completed'))
    .catch(error => console.log('\n💥 Debug failed:', error.message));
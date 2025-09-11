const https = require('https');

function makeRequest(url, method, data) {
    return new Promise((resolve, reject) => {
        const postData = JSON.stringify(data);
        const urlObj = new URL(url);
        
        const options = {
            hostname: urlObj.hostname,
            port: urlObj.port || 443,
            path: urlObj.pathname,
            method: method,
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(postData)
            }
        };

        const req = https.request(options, (res) => {
            let responseData = '';
            
            res.on('data', (chunk) => {
                responseData += chunk;
            });
            
            res.on('end', () => {
                resolve({
                    status: res.statusCode,
                    data: responseData
                });
            });
        });

        req.on('error', (error) => {
            reject(error);
        });

        req.write(postData);
        req.end();
    });
}

async function createTestPatient() {
    const patientData = {
        name: "Test Patient",
        phone: "9026508435",
        password: "shaurya",
        age: 25,
        gender: "male"
    };

    try {
        console.log('🔄 Creating test patient...');
        console.log('📦 Patient data:', JSON.stringify(patientData, null, 2));

        const response = await makeRequest('https://telemed18.onrender.com/api/auth/patient/register-mobile', 'POST', patientData);

        console.log('📡 Response status:', response.status);
        console.log('📋 Response:', response.data);

        if (response.status === 200 || response.status === 201) {
            console.log('✅ Test patient created successfully!');
            
            // Now test login
            console.log('\n🔐 Testing login...');
            const loginResponse = await makeRequest('https://telemed18.onrender.com/api/auth/login', 'POST', {
                loginId: "9026508435",
                password: "shaurya",
                userType: "patient"
            });

            console.log('🔐 Login response status:', loginResponse.status);
            console.log('🔐 Login response:', loginResponse.data);

            if (loginResponse.status === 200) {
                console.log('✅ Login test successful!');
            } else {
                console.log('❌ Login test failed!');
            }
        } else {
            console.log('❌ Failed to create test patient');
            console.log('Response details:', response.data);
        }
    } catch (error) {
        console.error('💥 Error:', error.message);
    }
}

createTestPatient();

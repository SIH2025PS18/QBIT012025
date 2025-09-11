const https = require('https');
const http = require('http');

function makeRequest(url, method, data) {
    return new Promise((resolve, reject) => {
        const postData = JSON.stringify(data);
        const urlObj = new URL(url);
        
        const options = {
            hostname: urlObj.hostname,
            port: urlObj.port || (urlObj.protocol === 'https:' ? 443 : 80),
            path: urlObj.pathname,
            method: method,
            headers: {
                'Content-Type': 'application/json',
                'Content-Length': Buffer.byteLength(postData)
            }
        };

        const requestLib = urlObj.protocol === 'https:' ? https : http;

        const req = requestLib.request(options, (res) => {
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

async function testSeededCredentials() {
    const seededCredentials = [
        // From database seed - using phone without +91-
        { loginId: "9876543301", password: "password" },
        { loginId: "9876543302", password: "password" },
        // With +91- prefix
        { loginId: "+91-9876543301", password: "password" },
        { loginId: "+91-9876543302", password: "password" },
        // Using patientId
        { loginId: "p1", password: "password" },
        { loginId: "p2", password: "password" },
        // Using email
        { loginId: "john.doe@example.com", password: "password" },
        { loginId: "priya.sharma@example.com", password: "password" }
    ];

    for (const creds of seededCredentials) {
        try {
            console.log(`🔐 Testing seeded credentials: ${creds.loginId} / ${creds.password}`);
            
            const loginResponse = await makeRequest('http://localhost:5001/api/auth/login', 'POST', {
                loginId: creds.loginId,
                password: creds.password,
                userType: "patient"
            });

            console.log(`📡 Status: ${loginResponse.status}`);
            
            if (loginResponse.status === 200) {
                console.log(`✅ SUCCESS! Working credentials found:`);
                console.log(`   Login ID: ${creds.loginId}`);
                console.log(`   Password: ${creds.password}`);
                console.log(`📋 Response:`, loginResponse.data);
                return;
            } else {
                console.log(`❌ Failed: ${loginResponse.data}`);
            }
        } catch (error) {
            console.log(`💥 Error testing ${creds.loginId}: ${error.message}`);
        }
        console.log('');
    }
    console.log('❌ None of the seeded credentials worked');
}

testSeededCredentials();

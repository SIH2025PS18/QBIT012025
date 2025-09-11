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

async function testExistingCredentials() {
    const testCredentials = [
        { loginId: "9026508435", password: "shaurya" },
        { loginId: "1111111111", password: "dgrthj" },
        { loginId: "9999999999", password: "password" },
        { loginId: "8888888888", password: "test123" },
        { loginId: "7777777777", password: "patient123" },
        { loginId: "patient1", password: "password" },
        { loginId: "testpatient", password: "test123" },
        { loginId: "demo", password: "demo" }
    ];

    for (const creds of testCredentials) {
        try {
            console.log(`🔐 Testing login: ${creds.loginId} / ${creds.password}`);
            
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
                break;
            } else {
                console.log(`❌ Failed: ${loginResponse.data}`);
            }
        } catch (error) {
            console.log(`💥 Error testing ${creds.loginId}: ${error.message}`);
        }
        console.log('');
    }
}

testExistingCredentials();

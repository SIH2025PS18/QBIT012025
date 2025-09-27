// Test doctor creation API endpoint directly
const http = require('http');

const testDoctorData = {
  name: "Dr. Harpeet Singh",
  email: "harpeet@gmail.com",
  phone: "7845120369",
  speciality: "General Practitioner",
  qualification: "MS",
  experience: 6,
  licenseNumber: "MG-851",
  consultationFee: 0,
  isAvailable: true,
  languages: ["en", "hi", "pa"],
  isVerified: true,
  employeeId: "EMP41159",
  department: "General Medicine",
  licenseExpiryDate: "2029-12-05",
  permissions: ["consultation", "profile_update", "patient_management", "reports"],
  address: {
    street: "nabha punjab",
    city: "",
    state: "",
    country: "India"
  }
};

const postData = JSON.stringify(testDoctorData);

const options = {
  hostname: '192.168.1.7',
  port: 5002,
  path: '/api/doctors',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(postData)
  }
};

console.log('🧪 Testing doctor creation with correct permissions...');
console.log('📤 Sending data:', postData);

const req = http.request(options, (res) => {
  console.log(`📥 Status Code: ${res.statusCode}`);
  console.log(`📋 Headers:`, res.headers);

  let data = '';
  res.on('data', (chunk) => {
    data += chunk;
  });

  res.on('end', () => {
    console.log('📄 Response Body:', data);
    
    try {
      const response = JSON.parse(data);
      if (response.success) {
        console.log('✅ Doctor created successfully!');
        console.log('👨‍⚕️ Doctor ID:', response.data?.doctorId);
        console.log('🔑 Default Password:', response.defaultPassword);
        console.log('📧 Login Email:', response.data?.email);
      } else {
        console.log('❌ Doctor creation failed:', response.message);
        if (response.errors) {
          console.log('🚫 Validation errors:', response.errors);
        }
      }
    } catch (e) {
      console.log('❌ Error parsing response:', e.message);
    }
  });
});

req.on('error', (e) => {
  console.error(`❌ Request error: ${e.message}`);
});

req.write(postData);
req.end();
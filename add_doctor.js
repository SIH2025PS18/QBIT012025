const fetch = require('node-fetch');

// Doctor data for Emma Johnson
const doctorData = {
  name: "Emma Johnson",
  email: "emma@example.com", 
  phone: "9876543210",
  speciality: "General Practitioner",
  qualification: "MBBS, MD",
  experience: 8,
  licenseNumber: "LIC123456",
  consultationFee: 500,
  languages: ["English", "Hindi"],
  isVerified: true,
  status: "active",
  password: "emma@123" // Adding password for login
};

// Function to add doctor
async function addDoctor() {
  try {
    console.log('Adding Emma Johnson to backend...');
    
    const response = await fetch('https://telemed18.onrender.com/api/auth/register', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        ...doctorData,
        userType: 'doctor'
      })
    });

    const result = await response.json();
    
    if (response.ok) {
      console.log('✅ Emma Johnson added successfully!');
      console.log('Doctor ID:', result.data?.user?.id);
      console.log('Email:', result.data?.user?.email);
    } else {
      console.log('❌ Error adding doctor:', result.message);
      
      // If doctor already exists, try to get doctor list
      if (result.message && result.message.includes('already exists')) {
        console.log('👤 Doctor already exists, fetching doctor list...');
        await getDoctors();
      }
    }
  } catch (error) {
    console.error('❌ Network error:', error.message);
  }
}

// Function to get all doctors  
async function getDoctors() {
  try {
    const response = await fetch('https://telemed18.onrender.com/api/doctors/public');
    const result = await response.json();
    
    if (response.ok && result.data) {
      console.log('📋 Available doctors:');
      result.data.forEach(doctor => {
        console.log(`- ${doctor.name} (${doctor.email}) - ${doctor.speciality}`);
      });
      
      // Check if Emma Johnson exists
      const emma = result.data.find(d => d.name.includes('Emma Johnson'));
      if (emma) {
        console.log('🎯 Found Emma Johnson:', emma);
      }
    } else {
      console.log('❌ Error fetching doctors:', result.message);
    }
  } catch (error) {
    console.error('❌ Error fetching doctors:', error.message);
  }
}

// Run the script
addDoctor();
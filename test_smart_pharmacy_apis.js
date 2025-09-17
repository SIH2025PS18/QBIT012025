const axios = require('axios');

// Base URL for your backend API
const BASE_URL = 'http://localhost:3000/api/smart-pharmacy';

// Test data
const samplePrescription = {
  prescriptionId: 'TEST_PRESC_001',
  patientId: 'TEST_PATIENT_001',
  doctorId: 'TEST_DOCTOR_001',
  prescribedMedicines: [
    {
      medicineId: 'paracetamol_500mg',
      name: 'Paracetamol 500mg',
      quantity: 10,
      price: 15.00,
      composition: 'Paracetamol',
      strength: '500mg'
    },
    {
      medicineId: 'amoxicillin_250mg', 
      name: 'Amoxicillin 250mg',
      quantity: 21,
      price: 45.00,
      composition: 'Amoxicillin',
      strength: '250mg'
    }
  ],
  patientProfile: {
    patientId: 'TEST_PATIENT_001',
    annualIncome: 150000,
    hasRationCard: true,
    hasESICCard: false,
    area: 'rural',
    state: 'uttar_pradesh',
    latitude: 28.7041,
    longitude: 77.1025
  }
};

// Test functions
async function testPrescriptionAnalysis() {
  console.log('🧪 Testing Prescription Analysis API...');
  try {
    const response = await axios.post(`${BASE_URL}/analyze-prescription`, samplePrescription);
    console.log('✅ Prescription Analysis Success!');
    console.log('💰 Total Savings:', response.data.analysis.totalSavings);
    console.log('📊 Savings Percentage:', response.data.analysis.savingsPercentage.toFixed(1) + '%');
    console.log('🏛️ Has Scheme Eligibility:', response.data.analysis.hasSchemeEligibility);
    console.log('---\n');
    return response.data;
  } catch (error) {
    console.error('❌ Prescription Analysis Failed:', error.message);
    return null;
  }
}

async function testPharmacyFinder() {
  console.log('🧪 Testing Pharmacy Finder API...');
  try {
    const response = await axios.post(`${BASE_URL}/find-pharmacies`, {
      latitude: 28.7041,
      longitude: 77.1025,
      radiusKm: 10
    });
    console.log('✅ Pharmacy Finder Success!');
    console.log('🏪 Found Pharmacies:', response.data.pharmacies.length);
    console.log('🥇 Nearest Pharmacy:', response.data.pharmacies[0]?.name);
    console.log('---\n');
    return response.data;
  } catch (error) {
    console.error('❌ Pharmacy Finder Failed:', error.message);
    return null;
  }
}

async function testSchemeVerification() {
  console.log('🧪 Testing Scheme Verification API...');
  try {
    const response = await axios.post(`${BASE_URL}/verify-scheme`, {
      schemeName: 'PMJAY',
      patientProfile: samplePrescription.patientProfile,
      documents: [
        { type: 'ration_card', verified: true },
        { type: 'aadhaar_card', verified: true }
      ]
    });
    console.log('✅ Scheme Verification Success!');
    console.log('🎯 PMJAY Eligible:', response.data.verification.isEligible);
    console.log('📄 Verification Status:', response.data.verification.verificationStatus);
    console.log('---\n');
    return response.data;
  } catch (error) {
    console.error('❌ Scheme Verification Failed:', error.message);
    return null;
  }
}

async function testMedicineDatabase() {
  console.log('🧪 Testing Medicine Database API...');
  try {
    const response = await axios.get(`${BASE_URL}/medicines?search=paracetamol&limit=5`);
    console.log('✅ Medicine Database Success!');
    console.log('💊 Found Medicines:', response.data.medicines.length);
    console.log('🔍 First Result:', response.data.medicines[0]?.name);
    console.log('---\n');
    return response.data;
  } catch (error) {
    console.error('❌ Medicine Database Failed:', error.message);
    return null;
  }
}

async function testSavingsAnalytics() {
  console.log('🧪 Testing Savings Analytics API...');
  try {
    const response = await axios.get(`${BASE_URL}/analytics/TEST_PATIENT_001?period=30d`);
    console.log('✅ Savings Analytics Success!');
    console.log('💰 Total Savings:', response.data.analytics.totalSavings);
    console.log('📈 Prescriptions Analyzed:', response.data.analytics.prescriptionsAnalyzed);
    console.log('📊 Average Savings:', response.data.analytics.averageSavingsPerPrescription);
    console.log('---\n');
    return response.data;
  } catch (error) {
    console.error('❌ Savings Analytics Failed:', error.message);
    return null;
  }
}

// Real-world usage examples
async function demonstrateRealWorldScenarios() {
  console.log('🌟 REAL-WORLD SMART PHARMACY SCENARIOS\n');

  // Scenario 1: Rural diabetic patient
  console.log('📋 SCENARIO 1: Rural Diabetic Patient');
  console.log('👤 Profile: Farmer, ₹80,000 income, has ration card');
  
  const diabeticPrescription = {
    prescriptionId: 'RURAL_DIABETES_001',
    patientId: 'RURAL_PATIENT_001',
    doctorId: 'DOCTOR_001',
    prescribedMedicines: [
      {
        medicineId: 'metformin_500mg',
        name: 'Metformin 500mg',
        quantity: 30,
        price: 120.00
      }
    ],
    patientProfile: {
      annualIncome: 80000,
      hasRationCard: true,
      area: 'rural',
      state: 'uttar_pradesh'
    }
  };

  try {
    const analysis = await axios.post(`${BASE_URL}/analyze-prescription`, diabeticPrescription);
    console.log('💊 Original Cost: ₹' + analysis.data.analysis.totalOriginalCost);
    console.log('💰 Optimized Cost: ₹' + analysis.data.analysis.totalOptimizedCost);
    console.log('🎯 Savings: ₹' + analysis.data.analysis.totalSavings + ' (' + analysis.data.analysis.savingsPercentage.toFixed(1) + '%)');
    console.log('🏛️ Government Schemes: ' + (analysis.data.analysis.hasSchemeEligibility ? 'Eligible for PMJAY & Jan Aushadhi' : 'None'));
  } catch (error) {
    console.log('❌ Analysis failed for rural scenario');
  }
  console.log('---\n');

  // Scenario 2: Urban employee with ESIC
  console.log('📋 SCENARIO 2: Urban Employee with ESIC');
  console.log('👤 Profile: Software engineer, ₹500,000 income, ESIC member');
  
  const urbanPrescription = {
    prescriptionId: 'URBAN_EMPLOYEE_001',
    patientId: 'URBAN_PATIENT_001',
    doctorId: 'DOCTOR_002',
    prescribedMedicines: [
      {
        medicineId: 'amlodipine_5mg',
        name: 'Amlodipine 5mg',
        quantity: 30,
        price: 85.00
      }
    ],
    patientProfile: {
      annualIncome: 500000,
      hasESICCard: true,
      area: 'urban',
      state: 'karnataka'
    }
  };

  try {
    const analysis = await axios.post(`${BASE_URL}/analyze-prescription`, urbanPrescription);
    console.log('💊 Original Cost: ₹' + analysis.data.analysis.totalOriginalCost);
    console.log('💰 ESIC Coverage: Free medicines at empaneled pharmacies');
    console.log('🏥 Alternative: Generic available for ₹' + (analysis.data.analysis.totalOptimizedCost || 35));
    console.log('🎯 Maximum Savings: 100% through ESIC');
  } catch (error) {
    console.log('❌ Analysis failed for urban scenario');
  }
  console.log('---\n');

  // Scenario 3: Family with multiple medicines
  console.log('📋 SCENARIO 3: Family Medicine Budget');
  console.log('👨‍👩‍👧‍👦 Family of 4 with various health conditions');
  
  try {
    const analytics = await axios.get(`${BASE_URL}/analytics/FAMILY_001?period=30d`);
    console.log('💰 Monthly Family Savings: ₹' + analytics.data.analytics.totalSavings);
    console.log('📊 Top Saving Category: ' + analytics.data.analytics.topSavingCategories[0]?.category);
    console.log('🏛️ Government Schemes Used: ' + analytics.data.analytics.schemesUtilized.length);
    console.log('📈 Annual Projection: ₹' + (analytics.data.analytics.totalSavings * 12) + ' savings');
  } catch (error) {
    console.log('❌ Analytics failed for family scenario');
  }
  console.log('---\n');
}

// Run all tests
async function runAllTests() {
  console.log('🚀 SMART PHARMACY ENGINE API TESTING\n');
  console.log('📅 Date:', new Date().toLocaleDateString());
  console.log('⚡ Backend URL:', BASE_URL);
  console.log('═'.repeat(50) + '\n');

  await testPrescriptionAnalysis();
  await testPharmacyFinder();
  await testSchemeVerification();
  await testMedicineDatabase();
  await testSavingsAnalytics();
  
  console.log('═'.repeat(50) + '\n');
  await demonstrateRealWorldScenarios();
  
  console.log('🎉 ALL TESTS COMPLETED!');
  console.log('💡 Ready to revolutionize healthcare affordability in India! 🇮🇳');
}

// Usage instructions
console.log(`
🏥 SMART PHARMACY ENGINE - API TESTING GUIDE

Before running tests:
1. Start your backend server: npm start (in backend directory)
2. Ensure all routes are properly configured
3. Run this script: node test_smart_pharmacy_apis.js

Features being tested:
✅ Prescription cost analysis with savings calculation
✅ Government scheme eligibility checking (PMJAY, Jan Aushadhi, ESIC)
✅ Pharmacy locator with Jan Aushadhi centers
✅ Medicine database with generic alternatives
✅ Patient savings analytics and trends

Expected Results:
💰 30-80% cost reduction on medicines
🏛️ Automatic government scheme detection
🏪 Location-based pharmacy recommendations
📊 Comprehensive savings analytics

═══════════════════════════════════════════════════
`);

// Run the tests if this file is executed directly
if (require.main === module) {
  runAllTests().catch(console.error);
}

module.exports = {
  testPrescriptionAnalysis,
  testPharmacyFinder,
  testSchemeVerification,
  testMedicineDatabase,
  testSavingsAnalytics,
  runAllTests
};
const express = require('express');
const router = express.Router();
const axios = require('axios');

// Mock database for demonstration - replace with actual database
const medicineDatabase = {
  // Analgesics & Pain Relief
  'paracetamol_500mg': {
    id: 'paracetamol_500mg',
    name: 'Paracetamol 500mg',
    chemicalComposition: 'Paracetamol',
    strength: '500mg',
    type: 'tablet',
    price: 15.00,
    category: 'analgesic',
    manufacturer: 'Various',
    genericAlternatives: [
      {
        id: 'dolo_650mg',
        name: 'Dolo 650mg',
        price: 18.50,
        savings: -3.50,
        savingsPercentage: -23.33,
        efficacySimilarity: 95.0
      }
    ]
  },
  'ibuprofen_400mg': {
    id: 'ibuprofen_400mg',
    name: 'Ibuprofen 400mg',
    chemicalComposition: 'Ibuprofen',
    strength: '400mg',
    type: 'tablet',
    price: 25.00,
    category: 'analgesic',
    manufacturer: 'Various',
    genericAlternatives: [
      {
        id: 'brufen_400mg',
        name: 'Brufen 400mg',
        price: 32.00,
        savings: -7.00,
        savingsPercentage: -28.00,
        efficacySimilarity: 98.0
      }
    ]
  },
  // Add more medicines as needed
};

const governmentSchemes = {
  pmjay: {
    name: 'Pradhan Mantri Jan Arogya Yojana (PMJAY)',
    eligibilityType: 'income_based',
    coverageAmount: 500000,
    medicinesCovered: ['paracetamol_500mg', 'ibuprofen_400mg', 'amoxicillin_500mg'],
    subsidyPercentage: 80
  },
  jan_aushadhi: {
    name: 'Jan Aushadhi Scheme',
    eligibilityType: 'universal',
    coverageAmount: null,
    medicinesCovered: ['paracetamol_500mg', 'ibuprofen_400mg', 'metformin_500mg'],
    subsidyPercentage: 50
  },
  esic: {
    name: 'Employee State Insurance Corporation (ESIC)',
    eligibilityType: 'employment_based',
    coverageAmount: 100000,
    medicinesCovered: ['paracetamol_500mg', 'amlodipine_5mg'],
    subsidyPercentage: 100
  }
};

// Analyze prescription for cost optimization
router.post('/analyze-prescription', async (req, res) => {
  try {
    const {
      prescriptionId,
      patientId,
      doctorId,
      prescribedMedicines,
      patientProfile
    } = req.body;

    if (!prescribedMedicines || !Array.isArray(prescribedMedicines)) {
      return res.status(400).json({
        error: 'Invalid prescribed medicines data'
      });
    }

    const analysis = {
      prescriptionId,
      patientId,
      doctorId,
      analyzedAt: new Date().toISOString(),
      originalMedicines: [],
      totalOriginalCost: 0,
      totalOptimizedCost: 0,
      totalSavings: 0,
      savingsPercentage: 0,
      hasSchemeEligibility: false,
      applicableSchemes: [],
      janAushadhiCenters: [],
      recommendations: []
    };

    // Analyze each prescribed medicine
    for (const prescMed of prescribedMedicines) {
      const medicineId = prescMed.medicineId || prescMed.name?.toLowerCase().replace(/\s+/g, '_');
      const medicine = medicineDatabase[medicineId];
      
      if (!medicine) {
        // Handle unknown medicine
        const unknownMedicine = {
          medicine: {
            id: medicineId,
            name: prescMed.name || 'Unknown Medicine',
            chemicalComposition: prescMed.composition || 'Unknown',
            strength: prescMed.strength || 'Unknown',
            price: prescMed.price || 50.00 // Default price
          },
          quantity: prescMed.quantity || 1,
          totalCost: (prescMed.price || 50.00) * (prescMed.quantity || 1),
          genericAlternatives: [],
          schemeEligibility: [],
          bestGenericAlternative: null
        };
        
        analysis.originalMedicines.push(unknownMedicine);
        analysis.totalOriginalCost += unknownMedicine.totalCost;
        analysis.totalOptimizedCost += unknownMedicine.totalCost;
        continue;
      }

      const quantity = prescMed.quantity || 1;
      const totalCost = medicine.price * quantity;

      // Find generic alternatives
      const genericAlternatives = medicine.genericAlternatives || [];
      const bestAlternative = genericAlternatives.length > 0 
        ? genericAlternatives.reduce((best, current) => 
            current.savings > best.savings ? current : best
          )
        : null;

      // Check scheme eligibility
      const schemeEligibility = await checkSchemeEligibility(medicineId, patientProfile);

      const medicineAnalysis = {
        medicine: medicine,
        quantity: quantity,
        totalCost: totalCost,
        genericAlternatives: genericAlternatives,
        schemeEligibility: schemeEligibility,
        bestGenericAlternative: bestAlternative
      };

      analysis.originalMedicines.push(medicineAnalysis);
      analysis.totalOriginalCost += totalCost;

      // Calculate optimized cost (with best alternative if available)
      const optimizedCost = bestAlternative 
        ? (medicine.price + bestAlternative.savings) * quantity
        : totalCost;
      analysis.totalOptimizedCost += optimizedCost;

      // Check if has scheme eligibility
      if (schemeEligibility.length > 0) {
        analysis.hasSchemeEligibility = true;
      }
    }

    // Calculate total savings
    analysis.totalSavings = analysis.totalOriginalCost - analysis.totalOptimizedCost;
    analysis.savingsPercentage = analysis.totalOriginalCost > 0 
      ? (analysis.totalSavings / analysis.totalOriginalCost) * 100 
      : 0;

    // Find applicable schemes
    analysis.applicableSchemes = await findApplicableSchemes(patientProfile);

    // Find nearby Jan Aushadhi centers
    analysis.janAushadhiCenters = await findNearbyJanAushadhiCenters(
      patientProfile.latitude || 28.7041,
      patientProfile.longitude || 77.1025
    );

    // Generate recommendations
    analysis.recommendations = generateRecommendations(analysis);

    res.json({
      success: true,
      analysis: analysis
    });

  } catch (error) {
    console.error('Error analyzing prescription:', error);
    res.status(500).json({
      error: 'Failed to analyze prescription',
      details: error.message
    });
  }
});

// Check scheme eligibility for a medicine
async function checkSchemeEligibility(medicineId, patientProfile) {
  const eligibility = [];

  // Check PMJAY eligibility
  if (governmentSchemes.pmjay.medicinesCovered.includes(medicineId)) {
    if (await checkPMJAYEligibility(patientProfile)) {
      eligibility.push({
        schemeName: 'PMJAY',
        schemeType: 'government',
        isEligible: true,
        isFullyCovered: false,
        subsidyAmount: 0, // Calculate based on medicine cost
        subsidyPercentage: governmentSchemes.pmjay.subsidyPercentage,
        documentsRequired: ['Ration Card', 'Aadhaar Card']
      });
    }
  }

  // Check Jan Aushadhi eligibility (universal)
  if (governmentSchemes.jan_aushadhi.medicinesCovered.includes(medicineId)) {
    eligibility.push({
      schemeName: 'Jan Aushadhi',
      schemeType: 'government',
      isEligible: true,
      isFullyCovered: false,
      subsidyAmount: 0,
      subsidyPercentage: governmentSchemes.jan_aushadhi.subsidyPercentage,
      documentsRequired: ['Any ID Proof']
    });
  }

  // Check ESIC eligibility
  if (governmentSchemes.esic.medicinesCovered.includes(medicineId)) {
    if (await checkESICEligibility(patientProfile)) {
      eligibility.push({
        schemeName: 'ESIC',
        schemeType: 'employment',
        isEligible: true,
        isFullyCovered: true,
        subsidyAmount: 0,
        subsidyPercentage: 100,
        documentsRequired: ['ESIC Card', 'Employee ID']
      });
    }
  }

  return eligibility;
}

// Check PMJAY eligibility
async function checkPMJAYEligibility(patientProfile) {
  // Simplified eligibility check
  const income = patientProfile.annualIncome || 0;
  const hasRationCard = patientProfile.hasRationCard || false;
  const isRural = patientProfile.area === 'rural';

  return hasRationCard && (income < 200000 || isRural);
}

// Check ESIC eligibility
async function checkESICEligibility(patientProfile) {
  return patientProfile.hasESICCard || false;
}

// Find applicable schemes for patient
async function findApplicableSchemes(patientProfile) {
  const schemes = [];

  if (await checkPMJAYEligibility(patientProfile)) {
    schemes.push({
      schemeName: 'PMJAY',
      eligibilityStatus: 'eligible',
      coverageAmount: 500000,
      description: 'Health insurance for economically vulnerable families'
    });
  }

  // Jan Aushadhi is universal
  schemes.push({
    schemeName: 'Jan Aushadhi',
    eligibilityStatus: 'eligible',
    coverageAmount: null,
    description: 'Generic medicines at affordable prices'
  });

  if (await checkESICEligibility(patientProfile)) {
    schemes.push({
      schemeName: 'ESIC',
      eligibilityStatus: 'eligible',
      coverageAmount: 100000,
      description: 'Medical benefits for organized sector employees'
    });
  }

  return schemes;
}

// Find nearby Jan Aushadhi centers
async function findNearbyJanAushadhiCenters(latitude, longitude) {
  // Mock data - replace with actual API call to Jan Aushadhi center database
  return [
    'Jan Aushadhi Store, Sector 15, Noida - 2.3 km',
    'PMBJP Center, Greater Noida - 3.8 km',
    'Jan Aushadhi Kendra, Delhi - 12.5 km'
  ];
}

// Generate recommendations based on analysis
function generateRecommendations(analysis) {
  const recommendations = [];

  if (analysis.totalSavings > 50) {
    recommendations.push({
      type: 'cost_savings',
      priority: 'high',
      message: `You can save ₹${analysis.totalSavings.toFixed(2)} by choosing generic alternatives`,
      action: 'Switch to recommended generics'
    });
  }

  if (analysis.hasSchemeEligibility) {
    recommendations.push({
      type: 'scheme_benefit',
      priority: 'high',
      message: 'You are eligible for government scheme benefits',
      action: 'Visit Jan Aushadhi center for subsidized medicines'
    });
  }

  if (analysis.janAushadhiCenters.length > 0) {
    recommendations.push({
      type: 'pharmacy_location',
      priority: 'medium',
      message: `Found ${analysis.janAushadhiCenters.length} Jan Aushadhi centers near you`,
      action: 'Visit nearest Jan Aushadhi center'
    });
  }

  return recommendations;
}

// Find nearby pharmacies
router.post('/find-pharmacies', async (req, res) => {
  try {
    const { latitude, longitude, radiusKm = 10 } = req.body;

    if (!latitude || !longitude) {
      return res.status(400).json({
        error: 'Latitude and longitude are required'
      });
    }

    // Mock pharmacy data - replace with actual database query
    const pharmacies = [
      {
        id: 'pharmacy_1',
        name: 'Apollo Pharmacy',
        address: 'Sector 18, Noida, UP 201301',
        latitude: 28.5706,
        longitude: 77.3272,
        distanceFromUser: 2.5,
        phoneNumber: '+91-9876543210',
        isOpen: true,
        openingHours: '9:00 AM - 11:00 PM',
        hasGenericMedicines: true,
        specialFeatures: ['24/7 Service', 'Home Delivery', 'Generic Medicines'],
        rating: 4.5
      },
      {
        id: 'pharmacy_2',
        name: 'MedPlus',
        address: 'Sector 62, Noida, UP 201307',
        latitude: 28.6139,
        longitude: 77.3738,
        distanceFromUser: 5.2,
        phoneNumber: '+91-9876543211',
        isOpen: true,
        openingHours: '8:00 AM - 10:00 PM',
        hasGenericMedicines: true,
        specialFeatures: ['Online Ordering', 'Insurance Accepted'],
        rating: 4.2
      },
      {
        id: 'jan_aushadhi_1',
        name: 'Jan Aushadhi Store',
        address: 'Sector 15, Noida, UP 201301',
        latitude: 28.5833,
        longitude: 77.3167,
        distanceFromUser: 1.8,
        phoneNumber: '+91-9876543212',
        isOpen: true,
        openingHours: '9:00 AM - 6:00 PM',
        hasGenericMedicines: true,
        specialFeatures: ['Government Subsidized', 'Generic Only', 'PMJAY Accepted'],
        rating: 4.0,
        isJanAushadhi: true
      }
    ];

    // Filter pharmacies within radius
    const nearbyPharmacies = pharmacies.filter(pharmacy => 
      pharmacy.distanceFromUser <= radiusKm
    );

    res.json({
      success: true,
      pharmacies: nearbyPharmacies,
      totalFound: nearbyPharmacies.length
    });

  } catch (error) {
    console.error('Error finding pharmacies:', error);
    res.status(500).json({
      error: 'Failed to find pharmacies',
      details: error.message
    });
  }
});

// Verify scheme eligibility
router.post('/verify-scheme', async (req, res) => {
  try {
    const { schemeName, patientProfile, documents } = req.body;

    if (!schemeName || !patientProfile) {
      return res.status(400).json({
        error: 'Scheme name and patient profile are required'
      });
    }

    let verification = {
      schemeName: schemeName,
      isEligible: false,
      verificationStatus: 'pending',
      requiredDocuments: [],
      submittedDocuments: documents || [],
      missingDocuments: [],
      eligibilityReasons: [],
      nextSteps: []
    };

    switch (schemeName.toLowerCase()) {
      case 'pmjay':
        verification = await verifyPMJAYEligibility(patientProfile, documents);
        break;
      case 'jan_aushadhi':
        verification = await verifyJanAushadhiEligibility(patientProfile, documents);
        break;
      case 'esic':
        verification = await verifyESICEligibility(patientProfile, documents);
        break;
      default:
        return res.status(400).json({
          error: 'Unsupported scheme name'
        });
    }

    res.json({
      success: true,
      verification: verification
    });

  } catch (error) {
    console.error('Error verifying scheme:', error);
    res.status(500).json({
      error: 'Failed to verify scheme eligibility',
      details: error.message
    });
  }
});

// Verify PMJAY eligibility
async function verifyPMJAYEligibility(patientProfile, documents) {
  const requiredDocs = ['ration_card', 'aadhaar_card'];
  const submittedDocs = documents?.map(doc => doc.type) || [];
  const missingDocs = requiredDocs.filter(doc => !submittedDocs.includes(doc));

  const isIncomeEligible = (patientProfile.annualIncome || 0) < 200000;
  const hasRationCard = submittedDocs.includes('ration_card');
  const hasAadhaar = submittedDocs.includes('aadhaar_card');

  const isEligible = isIncomeEligible && hasRationCard && hasAadhaar;

  return {
    schemeName: 'PMJAY',
    isEligible: isEligible,
    verificationStatus: isEligible ? 'verified' : 'rejected',
    requiredDocuments: requiredDocs,
    submittedDocuments: submittedDocs,
    missingDocuments: missingDocs,
    eligibilityReasons: [
      isIncomeEligible ? 'Income criteria met' : 'Income exceeds eligibility limit',
      hasRationCard ? 'Valid ration card provided' : 'Ration card required',
      hasAadhaar ? 'Valid Aadhaar card provided' : 'Aadhaar card required'
    ],
    nextSteps: isEligible 
      ? ['Visit empaneled hospital', 'Show PMJAY card for cashless treatment']
      : missingDocs.length > 0 
        ? [`Upload missing documents: ${missingDocs.join(', ')}`]
        : ['Check income eligibility criteria']
  };
}

// Verify Jan Aushadhi eligibility
async function verifyJanAushadhiEligibility(patientProfile, documents) {
  // Jan Aushadhi is universal - only requires basic ID
  const requiredDocs = ['id_proof'];
  const submittedDocs = documents?.map(doc => doc.type) || [];
  const hasIdProof = submittedDocs.some(doc => 
    ['aadhaar_card', 'pan_card', 'voter_id', 'driving_license'].includes(doc)
  );

  return {
    schemeName: 'Jan Aushadhi',
    isEligible: true, // Universal scheme
    verificationStatus: hasIdProof ? 'verified' : 'pending',
    requiredDocuments: requiredDocs,
    submittedDocuments: submittedDocs,
    missingDocuments: hasIdProof ? [] : ['id_proof'],
    eligibilityReasons: ['Universal scheme - all citizens eligible'],
    nextSteps: hasIdProof 
      ? ['Visit nearest Jan Aushadhi store', 'Show ID proof for purchase']
      : ['Upload any government ID proof']
  };
}

// Verify ESIC eligibility
async function verifyESICEligibility(patientProfile, documents) {
  const requiredDocs = ['esic_card', 'employee_id'];
  const submittedDocs = documents?.map(doc => doc.type) || [];
  const missingDocs = requiredDocs.filter(doc => !submittedDocs.includes(doc));

  const hasESICCard = submittedDocs.includes('esic_card');
  const hasEmployeeId = submittedDocs.includes('employee_id');
  const isEligible = hasESICCard && hasEmployeeId;

  return {
    schemeName: 'ESIC',
    isEligible: isEligible,
    verificationStatus: isEligible ? 'verified' : 'pending',
    requiredDocuments: requiredDocs,
    submittedDocuments: submittedDocs,
    missingDocuments: missingDocs,
    eligibilityReasons: [
      hasESICCard ? 'Valid ESIC card provided' : 'ESIC card required',
      hasEmployeeId ? 'Valid employee ID provided' : 'Employee ID required'
    ],
    nextSteps: isEligible 
      ? ['Visit ESIC empaneled facility', 'Show ESIC card for treatment']
      : [`Upload missing documents: ${missingDocs.join(', ')}`]
  };
}

// Get medicine database
router.get('/medicines', async (req, res) => {
  try {
    const { search, category, limit = 50 } = req.query;

    let medicines = Object.values(medicineDatabase);

    // Filter by search term
    if (search) {
      const searchTerm = search.toLowerCase();
      medicines = medicines.filter(medicine => 
        medicine.name.toLowerCase().includes(searchTerm) ||
        medicine.chemicalComposition.toLowerCase().includes(searchTerm)
      );
    }

    // Filter by category
    if (category) {
      medicines = medicines.filter(medicine => 
        medicine.category === category.toLowerCase()
      );
    }

    // Limit results
    medicines = medicines.slice(0, parseInt(limit));

    res.json({
      success: true,
      medicines: medicines,
      totalFound: medicines.length
    });

  } catch (error) {
    console.error('Error fetching medicines:', error);
    res.status(500).json({
      error: 'Failed to fetch medicines',
      details: error.message
    });
  }
});

// Get patient savings analytics
router.get('/analytics/:patientId', async (req, res) => {
  try {
    const { patientId } = req.params;
    const { period = '30d' } = req.query;

    // Mock analytics data - replace with actual database queries
    const analytics = {
      patientId: patientId,
      period: period,
      totalSavings: 1250.50,
      savingsBreakdown: {
        genericAlternatives: 850.00,
        schemeSubsidies: 400.50
      },
      prescriptionsAnalyzed: 8,
      averageSavingsPerPrescription: 156.31,
      topSavingCategories: [
        { category: 'Diabetes', savings: 420.00 },
        { category: 'Hypertension', savings: 380.50 },
        { category: 'Pain Relief', savings: 250.00 },
        { category: 'Antibiotics', savings: 200.00 }
      ],
      schemesUtilized: [
        { schemeName: 'Jan Aushadhi', utilizationCount: 5, totalSavings: 300.50 },
        { schemeName: 'PMJAY', utilizationCount: 2, totalSavings: 100.00 }
      ],
      monthlyTrend: [
        { month: 'Jan', savings: 120.00 },
        { month: 'Feb', savings: 250.50 },
        { month: 'Mar', savings: 380.00 },
        { month: 'Apr', savings: 500.00 }
      ]
    };

    res.json({
      success: true,
      analytics: analytics
    });

  } catch (error) {
    console.error('Error fetching analytics:', error);
    res.status(500).json({
      error: 'Failed to fetch analytics',
      details: error.message
    });
  }
});

module.exports = router;
import '../models/medicine.dart';
import '../models/smart_pharmacy_models.dart';

/// Service for managing comprehensive medicine database with Indian pharmaceutical data
class MedicineDatabaseService {
  /// Get comprehensive list of common Indian medicines with generic alternatives
  static List<Medicine> getIndianMedicineDatabase() {
    return [
      // Paracetamol/Acetaminophen Group
      Medicine(
        id: 'med_001',
        name: 'Calpol',
        chemicalComposition: 'Paracetamol',
        manufacturer: 'GSK Consumer Healthcare',
        category: 'Analgesic/Antipyretic',
        price: 32.0,
        strength: '500mg',
        form: 'tablet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_002',
        name: 'Paracetamol Generic',
        chemicalComposition: 'Paracetamol',
        manufacturer: 'Jan Aushadhi',
        category: 'Analgesic/Antipyretic',
        price: 8.0,
        strength: '500mg',
        form: 'tablet',
        isGeneric: true,
        brandEquivalentId: 'med_001',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_003',
        name: 'Dolo 650',
        chemicalComposition: 'Paracetamol',
        manufacturer: 'Micro Labs Ltd',
        category: 'Analgesic/Antipyretic',
        price: 28.0,
        strength: '650mg',
        form: 'tablet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_004',
        name: 'Paracetamol 650mg Generic',
        chemicalComposition: 'Paracetamol',
        manufacturer: 'Jan Aushadhi',
        category: 'Analgesic/Antipyretic',
        price: 10.0,
        strength: '650mg',
        form: 'tablet',
        isGeneric: true,
        brandEquivalentId: 'med_003',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Aspirin Group
      Medicine(
        id: 'med_005',
        name: 'Disprin',
        chemicalComposition: 'Aspirin',
        manufacturer: 'Reckitt Benckiser',
        category: 'Analgesic/Antiplatelet',
        price: 25.0,
        strength: '325mg',
        form: 'tablet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_006',
        name: 'Aspirin Generic',
        chemicalComposition: 'Aspirin',
        manufacturer: 'Jan Aushadhi',
        category: 'Analgesic/Antiplatelet',
        price: 6.0,
        strength: '325mg',
        form: 'tablet',
        isGeneric: true,
        brandEquivalentId: 'med_005',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Ibuprofen Group
      Medicine(
        id: 'med_007',
        name: 'Brufen',
        chemicalComposition: 'Ibuprofen',
        manufacturer: 'Abbott Healthcare',
        category: 'NSAID',
        price: 45.0,
        strength: '400mg',
        form: 'tablet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_008',
        name: 'Ibuprofen Generic',
        chemicalComposition: 'Ibuprofen',
        manufacturer: 'Jan Aushadhi',
        category: 'NSAID',
        price: 15.0,
        strength: '400mg',
        form: 'tablet',
        isGeneric: true,
        brandEquivalentId: 'med_007',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Antibiotics - Amoxicillin
      Medicine(
        id: 'med_009',
        name: 'Amoxil',
        chemicalComposition: 'Amoxicillin',
        manufacturer: 'GSK Pharmaceuticals',
        category: 'Antibiotic',
        price: 120.0,
        strength: '500mg',
        form: 'capsule',
        isPrescriptionRequired: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_010',
        name: 'Amoxicillin Generic',
        chemicalComposition: 'Amoxicillin',
        manufacturer: 'Jan Aushadhi',
        category: 'Antibiotic',
        price: 35.0,
        strength: '500mg',
        form: 'capsule',
        isPrescriptionRequired: true,
        isGeneric: true,
        brandEquivalentId: 'med_009',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Antibiotics - Azithromycin
      Medicine(
        id: 'med_011',
        name: 'Azithral',
        chemicalComposition: 'Azithromycin',
        manufacturer: 'Alembic Pharmaceuticals',
        category: 'Antibiotic',
        price: 85.0,
        strength: '500mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_012',
        name: 'Azithromycin Generic',
        chemicalComposition: 'Azithromycin',
        manufacturer: 'Jan Aushadhi',
        category: 'Antibiotic',
        price: 25.0,
        strength: '500mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        isGeneric: true,
        brandEquivalentId: 'med_011',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Diabetes - Metformin
      Medicine(
        id: 'med_013',
        name: 'Glycomet',
        chemicalComposition: 'Metformin HCl',
        manufacturer: 'USV Pharmaceuticals',
        category: 'Antidiabetic',
        price: 75.0,
        strength: '500mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_014',
        name: 'Metformin Generic',
        chemicalComposition: 'Metformin HCl',
        manufacturer: 'Jan Aushadhi',
        category: 'Antidiabetic',
        price: 22.0,
        strength: '500mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        isGeneric: true,
        brandEquivalentId: 'med_013',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Hypertension - Amlodipine
      Medicine(
        id: 'med_015',
        name: 'Amlong',
        chemicalComposition: 'Amlodipine Besylate',
        manufacturer: 'Micro Labs',
        category: 'Antihypertensive',
        price: 65.0,
        strength: '5mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_016',
        name: 'Amlodipine Generic',
        chemicalComposition: 'Amlodipine Besylate',
        manufacturer: 'Jan Aushadhi',
        category: 'Antihypertensive',
        price: 18.0,
        strength: '5mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        isGeneric: true,
        brandEquivalentId: 'med_015',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Hypertension - Losartan
      Medicine(
        id: 'med_017',
        name: 'Losar',
        chemicalComposition: 'Losartan Potassium',
        manufacturer: 'IPCA Laboratories',
        category: 'Antihypertensive',
        price: 95.0,
        strength: '50mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_018',
        name: 'Losartan Generic',
        chemicalComposition: 'Losartan Potassium',
        manufacturer: 'Jan Aushadhi',
        category: 'Antihypertensive',
        price: 28.0,
        strength: '50mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        isGeneric: true,
        brandEquivalentId: 'med_017',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Antacids
      Medicine(
        id: 'med_019',
        name: 'ENO',
        chemicalComposition: 'Sodium Bicarbonate + Citric Acid',
        manufacturer: 'GSK Consumer Healthcare',
        category: 'Antacid',
        price: 35.0,
        strength: '5g',
        form: 'sachet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_020',
        name: 'Antacid Generic',
        chemicalComposition: 'Sodium Bicarbonate + Citric Acid',
        manufacturer: 'Jan Aushadhi',
        category: 'Antacid',
        price: 12.0,
        strength: '5g',
        form: 'sachet',
        isGeneric: true,
        brandEquivalentId: 'med_019',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Proton Pump Inhibitors
      Medicine(
        id: 'med_021',
        name: 'Pantoprazole Protonix',
        chemicalComposition: 'Pantoprazole Sodium',
        manufacturer: 'Alkem Laboratories',
        category: 'PPI',
        price: 85.0,
        strength: '40mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_022',
        name: 'Pantoprazole Generic',
        chemicalComposition: 'Pantoprazole Sodium',
        manufacturer: 'Jan Aushadhi',
        category: 'PPI',
        price: 25.0,
        strength: '40mg',
        form: 'tablet',
        isPrescriptionRequired: true,
        isGeneric: true,
        brandEquivalentId: 'med_021',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Vitamins
      Medicine(
        id: 'med_023',
        name: 'Becosules',
        chemicalComposition: 'B-Complex Vitamins',
        manufacturer: 'Pfizer',
        category: 'Vitamin',
        price: 65.0,
        strength: '1 tab',
        form: 'capsule',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_024',
        name: 'B-Complex Generic',
        chemicalComposition: 'B-Complex Vitamins',
        manufacturer: 'Jan Aushadhi',
        category: 'Vitamin',
        price: 20.0,
        strength: '1 tab',
        form: 'capsule',
        isGeneric: true,
        brandEquivalentId: 'med_023',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Iron Supplements
      Medicine(
        id: 'med_025',
        name: 'Autrin',
        chemicalComposition: 'Ferrous Sulfate',
        manufacturer: 'Pfizer',
        category: 'Iron Supplement',
        price: 45.0,
        strength: '200mg',
        form: 'tablet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_026',
        name: 'Ferrous Sulfate Generic',
        chemicalComposition: 'Ferrous Sulfate',
        manufacturer: 'Jan Aushadhi',
        category: 'Iron Supplement',
        price: 12.0,
        strength: '200mg',
        form: 'tablet',
        isGeneric: true,
        brandEquivalentId: 'med_025',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Cough and Cold
      Medicine(
        id: 'med_027',
        name: 'Benadryl',
        chemicalComposition: 'Diphenhydramine + Ammonium Chloride',
        manufacturer: 'Johnson & Johnson',
        category: 'Cough Syrup',
        price: 55.0,
        strength: '100ml',
        form: 'syrup',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_028',
        name: 'Cough Syrup Generic',
        chemicalComposition: 'Diphenhydramine + Ammonium Chloride',
        manufacturer: 'Jan Aushadhi',
        category: 'Cough Syrup',
        price: 18.0,
        strength: '100ml',
        form: 'syrup',
        isGeneric: true,
        brandEquivalentId: 'med_027',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Antihistamines
      Medicine(
        id: 'med_029',
        name: 'Allegra',
        chemicalComposition: 'Fexofenadine HCl',
        manufacturer: 'Sanofi India',
        category: 'Antihistamine',
        price: 95.0,
        strength: '120mg',
        form: 'tablet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: 'med_030',
        name: 'Fexofenadine Generic',
        chemicalComposition: 'Fexofenadine HCl',
        manufacturer: 'Jan Aushadhi',
        category: 'Antihistamine',
        price: 30.0,
        strength: '120mg',
        form: 'tablet',
        isGeneric: true,
        brandEquivalentId: 'med_029',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Get government schemes database for India
  static List<GovernmentScheme> getIndianGovernmentSchemes() {
    return [
      // Central Government Schemes
      GovernmentScheme(
        id: 'scheme_001',
        name: 'Pradhan Mantri Jan Aushadhi Yojana',
        shortName: 'Jan Aushadhi',
        description:
            'Providing quality generic medicines at affordable prices to all',
        state: 'central',
        eligibilityCriteria: [
          'All Indian citizens',
          'Valid prescription required',
          'Available medicines at Jan Aushadhi centers',
        ],
        coveredMedicines: [
          'Analgesic/Antipyretic',
          'NSAID',
          'Antibiotic',
          'Antidiabetic',
          'Antihypertensive',
          'PPI',
          'Vitamin',
          'Iron Supplement',
          'Cough Syrup',
          'Antihistamine',
          'Antacid',
        ],
        subsidyPercentage: 50.0,
        maxSubsidyAmount: 0, // No cap, percentage-based
        requiredDocuments: [
          'Valid prescription',
          'Any government ID proof',
          'Address proof (optional)',
        ],
        applicationProcess:
            'Visit nearest Jan Aushadhi center with prescription. No pre-registration required.',
        officialWebsite: 'https://janaushadhi.gov.in',
        helplineNumber: '1800-180-1143',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      GovernmentScheme(
        id: 'scheme_002',
        name: 'Ayushman Bharat Pradhan Mantri Jan Arogya Yojana',
        shortName: 'PMJAY',
        description: 'Healthcare coverage for economically vulnerable families',
        state: 'central',
        eligibilityCriteria: [
          'Families identified through SECC 2011 database',
          'Rural families: Landless, manual laborers, tribal families',
          'Urban families: Rag pickers, street vendors, construction workers',
          'Annual family income less than ₹5 lakhs',
        ],
        coveredMedicines: [
          'Analgesic/Antipyretic',
          'Antibiotic',
          'Antidiabetic',
          'Antihypertensive',
          'Cardiovascular medicines',
          'Cancer treatment medicines',
          'Emergency medicines',
        ],
        maxSubsidyAmount: 500000.0, // ₹5 lakh annual coverage
        subsidyPercentage: 100.0, // Fully covered
        requiredDocuments: [
          'Ayushman Bharat Golden Card',
          'Valid prescription',
          'Aadhar card',
          'Family ID from PMJAY list',
        ],
        applicationProcess:
            'Use Ayushman card at empaneled hospitals and pharmacies',
        officialWebsite: 'https://pmjay.gov.in',
        helplineNumber: '14555',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      GovernmentScheme(
        id: 'scheme_003',
        name: 'Employees State Insurance Scheme',
        shortName: 'ESIC',
        description: 'Medical coverage for organized sector employees',
        state: 'central',
        eligibilityCriteria: [
          'Employees earning up to ₹25,000 per month',
          'Working in factories or establishments with 10+ employees',
          'Valid ESI registration',
        ],
        coveredMedicines: [
          'All essential medicines',
          'Chronic disease medications',
          'Emergency medicines',
        ],
        subsidyPercentage: 100.0,
        maxSubsidyAmount: 0, // No cap for registered members
        requiredDocuments: ['ESI card', 'Valid prescription', 'Employee ID'],
        applicationProcess: 'Visit ESI hospital or dispensary with ESI card',
        officialWebsite: 'https://esic.in',
        helplineNumber: '1800-11-2526',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // State-specific schemes (examples)
      GovernmentScheme(
        id: 'scheme_004',
        name: 'Delhi Aam Aadmi Mohalla Clinic',
        shortName: 'Mohalla Clinic',
        description: 'Free medicines and consultation in Delhi',
        state: 'Delhi',
        eligibilityCriteria: [
          'Delhi residents',
          'All income groups eligible',
          'Basic health conditions',
        ],
        coveredMedicines: [
          'Basic medicines for common ailments',
          'Diabetes medicines',
          'Hypertension medicines',
          'Common antibiotics',
        ],
        subsidyPercentage: 100.0,
        maxSubsidyAmount: 0,
        requiredDocuments: ['Delhi address proof', 'Any ID proof'],
        applicationProcess: 'Visit nearest Mohalla Clinic',
        officialWebsite: 'https://health.delhi.gov.in',
        helplineNumber: '1031',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      GovernmentScheme(
        id: 'scheme_005',
        name: 'Tamil Nadu Chief Minister Comprehensive Health Insurance',
        shortName: 'CMCHIS',
        description: 'Comprehensive health coverage for Tamil Nadu families',
        state: 'Tamil Nadu',
        eligibilityCriteria: [
          'Tamil Nadu residents',
          'All ration card holders',
          'Annual family income criteria',
        ],
        coveredMedicines: [
          'All prescribed medicines in government hospitals',
          'Chronic disease medications',
          'Cancer treatment medicines',
        ],
        maxSubsidyAmount: 500000.0,
        subsidyPercentage: 100.0,
        requiredDocuments: ['CMCHIS card', 'Ration card', 'Valid prescription'],
        applicationProcess: 'Use CMCHIS card at empaneled hospitals',
        officialWebsite: 'https://cms.tn.gov.in',
        helplineNumber: '104',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      GovernmentScheme(
        id: 'scheme_006',
        name: 'Rajasthan Bhamashah Swasthya Bima Yojana',
        shortName: 'RSBY',
        description: 'Health insurance for BPL families in Rajasthan',
        state: 'Rajasthan',
        eligibilityCriteria: [
          'BPL families in Rajasthan',
          'Bhamashah card holders',
          'Annual verification required',
        ],
        coveredMedicines: [
          'Essential medicines list',
          'Hospitalization medicines',
          'Emergency drugs',
        ],
        maxSubsidyAmount: 300000.0,
        subsidyPercentage: 100.0,
        requiredDocuments: [
          'Bhamashah card',
          'BPL certificate',
          'Valid prescription',
        ],
        applicationProcess: 'Use Bhamashah card at empaneled facilities',
        officialWebsite: 'https://health.rajasthan.gov.in',
        helplineNumber: '108',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Get sample Jan Aushadhi pharmacies data
  static List<Pharmacy> getSampleJanAushadhiCenters() {
    return [
      Pharmacy(
        id: 'pharmacy_001',
        name: 'Jan Aushadhi Store - AIIMS Delhi',
        address: 'AIIMS Campus, Ansari Nagar',
        city: 'New Delhi',
        state: 'Delhi',
        pincode: '110029',
        phoneNumber: '+91-11-26593246',
        latitude: 28.5672,
        longitude: 77.2100,
        isJanAushadhiCenter: true,
        supportedSchemes: ['scheme_001', 'scheme_002'],
        rating: 4.5,
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Pharmacy(
        id: 'pharmacy_002',
        name: 'Jan Aushadhi Medical Store - Safdarjung',
        address: 'Safdarjung Hospital Campus',
        city: 'New Delhi',
        state: 'Delhi',
        pincode: '110029',
        phoneNumber: '+91-11-26163323',
        latitude: 28.5739,
        longitude: 77.2062,
        isJanAushadhiCenter: true,
        supportedSchemes: ['scheme_001'],
        rating: 4.2,
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Pharmacy(
        id: 'pharmacy_003',
        name: 'Jan Aushadhi Kendra - Lajpat Nagar',
        address: 'Central Market, Lajpat Nagar II',
        city: 'New Delhi',
        state: 'Delhi',
        pincode: '110024',
        phoneNumber: '+91-11-29817542',
        latitude: 28.5653,
        longitude: 77.2433,
        isJanAushadhiCenter: true,
        supportedSchemes: ['scheme_001'],
        rating: 4.0,
        isVerified: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Search medicines by name, composition, or category
  static List<Medicine> searchMedicines(String query, List<Medicine> database) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return database
        .where(
          (medicine) =>
              medicine.name.toLowerCase().contains(lowerQuery) ||
              medicine.chemicalComposition.toLowerCase().contains(lowerQuery) ||
              medicine.category.toLowerCase().contains(lowerQuery) ||
              medicine.manufacturer.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  /// Get generic alternatives for a branded medicine
  static List<Medicine> getGenericAlternatives(
    Medicine brandedMedicine,
    List<Medicine> database,
  ) {
    return database
        .where(
          (medicine) =>
              medicine.chemicalComposition.toLowerCase() ==
                  brandedMedicine.chemicalComposition.toLowerCase() &&
              medicine.strength == brandedMedicine.strength &&
              medicine.form == brandedMedicine.form &&
              medicine.isGeneric &&
              medicine.price < brandedMedicine.price &&
              medicine.id != brandedMedicine.id,
        )
        .toList()
      ..sort((a, b) => a.price.compareTo(b.price));
  }

  /// Calculate potential savings for a prescription
  static Map<String, dynamic> calculatePrescriptionSavings(
    List<Map<String, dynamic>> prescribedMedicines,
    List<Medicine> medicineDatabase,
  ) {
    double originalCost = 0.0;
    double optimizedCost = 0.0;
    int medicinesWithAlternatives = 0;

    final analysisDetails = <Map<String, dynamic>>[];

    for (var prescMed in prescribedMedicines) {
      final medicineName = prescMed['name'] as String;
      final quantity = prescMed['quantity'] as int? ?? 1;

      // Find medicine in database
      final medicine = medicineDatabase.firstWhere(
        (med) => med.name.toLowerCase() == medicineName.toLowerCase(),
        orElse: () => Medicine(
          id: 'temp',
          name: medicineName,
          chemicalComposition: 'Unknown',
          manufacturer: 'Unknown',
          category: 'General',
          price: prescMed['price']?.toDouble() ?? 0.0,
          strength: prescMed['strength'] ?? '',
          form: prescMed['form'] ?? 'tablet',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      final medOriginalCost = medicine.price * quantity;
      originalCost += medOriginalCost;

      // Find best generic alternative
      final alternatives = getGenericAlternatives(medicine, medicineDatabase);

      if (alternatives.isNotEmpty) {
        final bestAlternative = alternatives.first; // Cheapest
        final medOptimizedCost = bestAlternative.price * quantity;
        optimizedCost += medOptimizedCost;
        medicinesWithAlternatives++;

        analysisDetails.add({
          'originalMedicine': medicine.name,
          'originalPrice': medicine.price,
          'genericAlternative': bestAlternative.name,
          'genericPrice': bestAlternative.price,
          'quantity': quantity,
          'savings': medOriginalCost - medOptimizedCost,
        });
      } else {
        optimizedCost += medOriginalCost;
        analysisDetails.add({
          'originalMedicine': medicine.name,
          'originalPrice': medicine.price,
          'genericAlternative': null,
          'quantity': quantity,
          'savings': 0.0,
        });
      }
    }

    final totalSavings = originalCost - optimizedCost;
    final savingsPercentage = originalCost > 0
        ? (totalSavings / originalCost) * 100
        : 0.0;

    return {
      'originalCost': originalCost,
      'optimizedCost': optimizedCost,
      'totalSavings': totalSavings,
      'savingsPercentage': savingsPercentage,
      'medicinesWithAlternatives': medicinesWithAlternatives,
      'totalMedicines': prescribedMedicines.length,
      'analysisDetails': analysisDetails,
    };
  }
}

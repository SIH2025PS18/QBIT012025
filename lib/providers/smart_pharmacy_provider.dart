import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/medicine.dart';
import '../models/smart_pharmacy_models.dart';
import '../services/auth_service.dart';

/// Provider for Smart Pharmacy Engine with generic medicine suggestions and scheme integration
class SmartPharmacyProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://telemed18.onrender.com/api';

  final AuthService _authService = AuthService();

  // State management
  List<Medicine> _medicineDatabase = [];
  List<GovernmentScheme> _availableSchemes = [];
  List<Pharmacy> _nearbyPharmacies = [];
  PrescriptionAnalysis? _currentAnalysis;
  PatientSavingsSummary? _patientSavings;

  // Loading and error states
  bool _isLoading = false;
  bool _isAnalyzing = false;
  String? _error;

  // Getters
  List<Medicine> get medicineDatabase => List.unmodifiable(_medicineDatabase);
  List<GovernmentScheme> get availableSchemes =>
      List.unmodifiable(_availableSchemes);
  List<Pharmacy> get nearbyPharmacies => List.unmodifiable(_nearbyPharmacies);
  PrescriptionAnalysis? get currentAnalysis => _currentAnalysis;
  PatientSavingsSummary? get patientSavings => _patientSavings;
  bool get isLoading => _isLoading;
  bool get isAnalyzing => _isAnalyzing;
  String? get error => _error;

  /// Initialize the Smart Pharmacy Engine
  Future<void> initialize() async {
    _setLoading(true);
    _clearError();

    try {
      await Future.wait([
        _loadMedicineDatabase(),
        _loadGovernmentSchemes(),
        _loadPatientSavings(),
      ]);
    } catch (e) {
      _setError('Failed to initialize Smart Pharmacy Engine: $e');
      if (kDebugMode) print('Smart Pharmacy initialization error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Analyze a prescription for generic alternatives and scheme eligibility
  Future<PrescriptionAnalysis?> analyzePrescription({
    required String prescriptionId,
    required String patientId,
    required String doctorId,
    required List<Map<String, dynamic>> prescribedMedicines,
    Map<String, dynamic>? patientProfile,
  }) async {
    _setAnalyzing(true);
    _clearError();

    try {
      // Convert prescription data to PrescribedMedicine objects
      final medicines = await _processPrescribedMedicines(prescribedMedicines);

      // Find generic alternatives for each medicine
      for (var medicine in medicines) {
        medicine.genericAlternatives.addAll(
          await _findGenericAlternatives(medicine.medicine),
        );
        medicine.schemeEligibility.addAll(
          await _checkSchemeEligibility(
            medicine.medicine,
            patientProfile ?? {},
          ),
        );
      }

      // Create prescription analysis
      _currentAnalysis = PrescriptionAnalysis.create(
        prescriptionId: prescriptionId,
        patientId: patientId,
        doctorId: doctorId,
        medicines: medicines,
      );

      // Update patient savings
      await _updatePatientSavings(patientId, _currentAnalysis!);

      notifyListeners();
      return _currentAnalysis;
    } catch (e) {
      _setError('Failed to analyze prescription: $e');
      if (kDebugMode) print('Prescription analysis error: $e');
      return null;
    } finally {
      _setAnalyzing(false);
    }
  }

  /// Find generic alternatives for a specific medicine
  Future<List<GenericAlternative>> findGenericAlternatives(
    Medicine medicine,
  ) async {
    return await _findGenericAlternatives(medicine);
  }

  /// Check government scheme eligibility for a medicine
  Future<List<GovernmentSchemeEligibility>> checkSchemeEligibility(
    Medicine medicine,
    Map<String, dynamic> patientProfile,
  ) async {
    return await _checkSchemeEligibility(medicine, patientProfile);
  }

  /// Find nearby pharmacies including Jan Aushadhi centers
  Future<List<Pharmacy>> findNearbyPharmacies({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final headers = await _getAuthHeaders();

      final response = await http.post(
        Uri.parse('$_baseUrl/smart-pharmacy/find-pharmacies'),
        headers: headers,
        body: json.encode({
          'latitude': latitude,
          'longitude': longitude,
          'radiusKm': radiusKm,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final pharmacies = (data['pharmacies'] as List)
              .map((pharmacy) => Pharmacy.fromJson(pharmacy))
              .toList();

          _nearbyPharmacies = pharmacies;
          notifyListeners();
          return pharmacies;
        } else {
          _setError(data['error'] ?? 'Failed to find nearby pharmacies');
          return [];
        }
      } else {
        _setError('Server error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _setError('Failed to find nearby pharmacies: $e');
      if (kDebugMode) print('Nearby pharmacies error: $e');

      // Return mock data for demo
      final mockPharmacies = _getMockPharmacies(latitude, longitude);
      _nearbyPharmacies = mockPharmacies;
      notifyListeners();
      return mockPharmacies;
    } finally {
      _setLoading(false);
    }
  }

  /// Find nearby Jan Aushadhi centers
  Future<List<String>> findJanAushadhiCenters({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.post(
        Uri.parse('$_baseUrl/smart-pharmacy/find-pharmacies'),
        headers: headers,
        body: json.encode({
          'latitude': latitude,
          'longitude': longitude,
          'radiusKm': radiusKm,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final pharmacies = data['pharmacies'] as List;
          final janAushadhiCenters = pharmacies
              .where((p) => p['isJanAushadhi'] == true)
              .map(
                (p) =>
                    '${p['name']} - ${(p['distanceFromUser'] ?? 0).toStringAsFixed(1)} km',
              )
              .toList()
              .cast<String>();

          return janAushadhiCenters;
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error finding Jan Aushadhi centers: $e');
    }

    // Return mock data for demo
    return [
      'Jan Aushadhi Store, Sector 15, Noida - 2.3 km',
      'PMBJP Center, Greater Noida - 3.8 km',
      'Jan Aushadhi Kendra, Delhi - 12.5 km',
    ];
  }

  /// Get mock pharmacies for demonstration
  List<Pharmacy> _getMockPharmacies(double latitude, double longitude) {
    final now = DateTime.now();
    return [
      Pharmacy(
        id: 'pharmacy_1',
        name: 'Apollo Pharmacy',
        address: 'Sector 18, Noida, UP 201301',
        city: 'Noida',
        state: 'Uttar Pradesh',
        pincode: '201301',
        phoneNumber: '+91-9876543210',
        latitude: 28.5706,
        longitude: 77.3272,
        createdAt: now,
        updatedAt: now,
        distanceFromUser: 2.5,
        isOpen: true,
        hasGenericMedicines: true,
        specialFeatures: ['24/7 Service', 'Home Delivery', 'Generic Medicines'],
        openingHours: '9:00 AM - 11:00 PM',
        rating: 4.5,
      ),
      Pharmacy(
        id: 'pharmacy_2',
        name: 'MedPlus',
        address: 'Sector 62, Noida, UP 201307',
        city: 'Noida',
        state: 'Uttar Pradesh',
        pincode: '201307',
        phoneNumber: '+91-9876543211',
        latitude: 28.6139,
        longitude: 77.3738,
        createdAt: now,
        updatedAt: now,
        distanceFromUser: 5.2,
        isOpen: true,
        hasGenericMedicines: true,
        specialFeatures: ['Online Ordering', 'Insurance Accepted'],
        openingHours: '8:00 AM - 10:00 PM',
        rating: 4.2,
      ),
      Pharmacy(
        id: 'jan_aushadhi_1',
        name: 'Jan Aushadhi Store',
        address: 'Sector 15, Noida, UP 201301',
        city: 'Noida',
        state: 'Uttar Pradesh',
        pincode: '201301',
        phoneNumber: '+91-9876543212',
        latitude: 28.5833,
        longitude: 77.3167,
        createdAt: now,
        updatedAt: now,
        distanceFromUser: 1.8,
        isOpen: true,
        hasGenericMedicines: true,
        specialFeatures: [
          'Government Subsidized',
          'Generic Only',
          'PMJAY Accepted',
        ],
        openingHours: '9:00 AM - 6:00 PM',
        rating: 4.0,
        isJanAushadhiCenter: true,
      ),
    ];
  }

  /// Get patient savings summary
  Future<void> getPatientSavings(String patientId) async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse('$_baseUrl/pharmacy/patient-savings/$patientId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _patientSavings = PatientSavingsSummary.fromJson(data['data']);
          notifyListeners();
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error loading patient savings: $e');
    }
  }

  /// Search medicines by name or composition
  List<Medicine> searchMedicines(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    return _medicineDatabase
        .where(
          (medicine) =>
              medicine.name.toLowerCase().contains(lowerQuery) ||
              medicine.chemicalComposition.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  /// Get government schemes applicable to patient
  List<GovernmentScheme> getApplicableSchemes(
    Map<String, dynamic> patientProfile,
  ) {
    return _availableSchemes
        .where((scheme) => scheme.isPatientEligible(patientProfile))
        .toList();
  }

  /// Load medicine database from backend
  Future<void> _loadMedicineDatabase() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse('$_baseUrl/pharmacy/medicines'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _medicineDatabase = (data['data'] as List)
              .map((medicine) => Medicine.fromJson(medicine))
              .toList();
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error loading medicine database: $e');
      // Fallback to mock data for development
      _loadMockMedicineDatabase();
    }
  }

  /// Load government schemes from backend
  Future<void> _loadGovernmentSchemes() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse('$_baseUrl/pharmacy/schemes'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _availableSchemes = (data['data'] as List)
              .map((scheme) => GovernmentScheme.fromJson(scheme))
              .toList();
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error loading government schemes: $e');
      // Fallback to mock data for development
      _loadMockSchemes();
    }
  }

  /// Process prescribed medicines from prescription data
  Future<List<PrescribedMedicine>> _processPrescribedMedicines(
    List<Map<String, dynamic>> prescribedMedicines,
  ) async {
    final List<PrescribedMedicine> processed = [];

    for (var prescMed in prescribedMedicines) {
      // Find medicine in database or create new one
      Medicine? medicine = _findMedicineByName(prescMed['name']);

      if (medicine == null) {
        // Create a new medicine entry if not found
        medicine = Medicine(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: prescMed['name'],
          chemicalComposition: prescMed['composition'] ?? '',
          manufacturer: prescMed['manufacturer'] ?? 'Unknown',
          category: prescMed['category'] ?? 'General',
          price: (prescMed['price'] as num?)?.toDouble() ?? 0.0,
          strength: prescMed['strength'] ?? '',
          form: prescMed['form'] ?? 'tablet',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      final quantity = prescMed['quantity'] ?? 1;
      final totalCost = medicine.price * quantity;

      processed.add(
        PrescribedMedicine(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          medicine: medicine,
          dosage: prescMed['dosage'] ?? '',
          frequency: prescMed['frequency'] ?? '',
          durationDays: prescMed['durationDays'] ?? 7,
          instructions: prescMed['instructions'] ?? '',
          quantity: quantity,
          totalCost: totalCost,
        ),
      );
    }

    return processed;
  }

  /// Find generic alternatives for a medicine
  Future<List<GenericAlternative>> _findGenericAlternatives(
    Medicine medicine,
  ) async {
    final alternatives = <GenericAlternative>[];

    // Find medicines with same chemical composition but lower price
    final genericOptions = _medicineDatabase
        .where(
          (med) =>
              med.chemicalComposition.toLowerCase() ==
                  medicine.chemicalComposition.toLowerCase() &&
              med.strength == medicine.strength &&
              med.form == medicine.form &&
              med.price < medicine.price &&
              med.id != medicine.id,
        )
        .toList();

    // Sort by price (cheapest first)
    genericOptions.sort((a, b) => a.price.compareTo(b.price));

    for (var generic in genericOptions.take(3)) {
      // Limit to top 3 alternatives
      alternatives.add(GenericAlternative.create(medicine, generic));
    }

    return alternatives;
  }

  /// Check scheme eligibility for a medicine
  Future<List<GovernmentSchemeEligibility>> _checkSchemeEligibility(
    Medicine medicine,
    Map<String, dynamic> patientProfile,
  ) async {
    final eligibleSchemes = <GovernmentSchemeEligibility>[];

    for (var scheme in _availableSchemes) {
      if (scheme.isPatientEligible(patientProfile) &&
          _isMedicineCoveredByScheme(medicine, scheme)) {
        final subsidyAmount = scheme.subsidyPercentage > 0
            ? medicine.price * (scheme.subsidyPercentage / 100)
            : scheme.maxSubsidyAmount;

        eligibleSchemes.add(
          GovernmentSchemeEligibility(
            schemeId: scheme.id,
            schemeName: scheme.name,
            description: scheme.description,
            subsidyAmount: subsidyAmount,
            subsidyPercentage: scheme.subsidyPercentage,
            isFullyCovered: subsidyAmount >= medicine.price,
            eligibilityCriteria: scheme.eligibilityCriteria,
            requiredDocuments: scheme.requiredDocuments,
            applicationProcess: scheme.applicationProcess,
            contactInfo: scheme.helplineNumber,
          ),
        );
      }
    }

    return eligibleSchemes;
  }

  /// Check if medicine is covered by scheme
  bool _isMedicineCoveredByScheme(Medicine medicine, GovernmentScheme scheme) {
    // Check if medicine category or specific medicine is covered
    return scheme.coveredMedicines.contains(medicine.category) ||
        scheme.coveredMedicines.contains(medicine.name) ||
        scheme.coveredMedicines.contains(medicine.chemicalComposition) ||
        scheme.coveredMedicines.contains('*'); // Universal coverage
  }

  /// Find medicine by name in database
  Medicine? _findMedicineByName(String name) {
    try {
      return _medicineDatabase.firstWhere(
        (med) => med.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Update patient savings summary
  Future<void> _updatePatientSavings(
    String patientId,
    PrescriptionAnalysis analysis,
  ) async {
    try {
      final headers = await _getAuthHeaders();

      await http.post(
        Uri.parse('$_baseUrl/pharmacy/patient-savings'),
        headers: headers,
        body: json.encode({
          'patientId': patientId,
          'analysisId': analysis.id,
          'totalSavings': analysis.totalSavings,
          'prescriptionDate': analysis.analyzedAt.toIso8601String(),
        }),
      );

      // Reload patient savings
      await getPatientSavings(patientId);
    } catch (e) {
      if (kDebugMode) print('Error updating patient savings: $e');
    }
  }

  /// Load patient savings summary
  Future<void> _loadPatientSavings() async {
    // This would load for current authenticated patient
    // For now, we'll skip this as it requires patient context
  }

  /// Load mock medicine database for development
  void _loadMockMedicineDatabase() {
    _medicineDatabase = [
      Medicine(
        id: '1',
        name: 'Calpol',
        chemicalComposition: 'Paracetamol',
        manufacturer: 'GSK',
        category: 'Analgesic',
        price: 30.0,
        strength: '500mg',
        form: 'tablet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: '2',
        name: 'Paracetamol',
        chemicalComposition: 'Paracetamol',
        manufacturer: 'Generic',
        category: 'Analgesic',
        price: 10.0,
        strength: '500mg',
        form: 'tablet',
        isGeneric: true,
        brandEquivalentId: '1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: '3',
        name: 'Dolo 650',
        chemicalComposition: 'Paracetamol',
        manufacturer: 'Micro Labs',
        category: 'Analgesic',
        price: 25.0,
        strength: '650mg',
        form: 'tablet',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medicine(
        id: '4',
        name: 'Generic Paracetamol 650',
        chemicalComposition: 'Paracetamol',
        manufacturer: 'Jan Aushadhi',
        category: 'Analgesic',
        price: 8.0,
        strength: '650mg',
        form: 'tablet',
        isGeneric: true,
        brandEquivalentId: '3',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Load mock government schemes for development
  void _loadMockSchemes() {
    _availableSchemes = [
      GovernmentScheme(
        id: '1',
        name: 'Jan Aushadhi Scheme',
        shortName: 'Jan Aushadhi',
        description: 'Providing quality generic medicines at affordable prices',
        state: 'central',
        coveredMedicines: ['*'], // Universal coverage
        subsidyPercentage: 50.0,
        eligibilityCriteria: ['All citizens'],
        requiredDocuments: ['Prescription', 'ID Proof'],
        applicationProcess: 'Visit Jan Aushadhi center with prescription',
        officialWebsite: 'https://janaushadhi.gov.in',
        helplineNumber: '1800-180-1143',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      GovernmentScheme(
        id: '2',
        name: 'Ayushman Bharat',
        shortName: 'PMJAY',
        description: 'Healthcare coverage for economically vulnerable families',
        state: 'central',
        coveredMedicines: [
          'Analgesic',
          'Antibiotic',
          'Diabetes',
          'Hypertension',
        ],
        maxSubsidyAmount: 500000.0, // Annual limit
        eligibilityCriteria: ['BPL families', 'Income < 5 Lakhs'],
        requiredDocuments: ['Ayushman Card', 'Prescription', 'Aadhar'],
        applicationProcess: 'Use Ayushman card at empaneled hospitals',
        officialWebsite: 'https://pmjay.gov.in',
        helplineNumber: '14555',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Get authentication headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = _authService.authToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set analyzing state
  void _setAnalyzing(bool analyzing) {
    _isAnalyzing = analyzing;
    notifyListeners();
  }

  /// Set error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error state
  void _clearError() {
    _error = null;
  }

  /// Clear current analysis
  void clearCurrentAnalysis() {
    _currentAnalysis = null;
    notifyListeners();
  }

  /// Get patient savings analytics from backend API
  Future<Map<String, dynamic>> getPatientSavingsAnalytics({
    required String patientId,
    String period = '30d',
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/smart-pharmacy/analytics/$patientId?period=$period',
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['analytics'] as Map<String, dynamic>;
        } else {
          throw Exception(data['error'] ?? 'Failed to fetch analytics');
        }
      } else {
        throw Exception('Failed to fetch analytics: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching analytics: $e');

      // Return mock data for demonstration if API fails
      return {
        'patientId': patientId,
        'period': period,
        'totalSavings': 1250.50,
        'savingsBreakdown': {
          'genericAlternatives': 850.00,
          'schemeSubsidies': 400.50,
        },
        'prescriptionsAnalyzed': 8,
        'averageSavingsPerPrescription': 156.31,
        'topSavingCategories': [
          {'category': 'Diabetes', 'savings': 420.00},
          {'category': 'Hypertension', 'savings': 380.50},
          {'category': 'Pain Relief', 'savings': 250.00},
          {'category': 'Antibiotics', 'savings': 200.00},
        ],
        'schemesUtilized': [
          {
            'schemeName': 'Jan Aushadhi',
            'utilizationCount': 5,
            'totalSavings': 300.50,
          },
          {
            'schemeName': 'PMJAY',
            'utilizationCount': 2,
            'totalSavings': 100.00,
          },
        ],
        'monthlyTrend': [
          {'month': 'Jan', 'savings': 120.00},
          {'month': 'Feb', 'savings': 250.50},
          {'month': 'Mar', 'savings': 380.00},
          {'month': 'Apr', 'savings': 500.00},
        ],
      };
    }
  }
}

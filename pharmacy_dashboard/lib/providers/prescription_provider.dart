import 'package:flutter/foundation.dart';
import '../models/prescription_request.dart';
import '../services/notification_service.dart';
import '../services/api_service.dart';

class PrescriptionProvider with ChangeNotifier {
  final PharmacyNotificationService _notificationService =
      PharmacyNotificationService();
  final PharmacyApiService _apiService = PharmacyApiService();

  List<PrescriptionRequest> _pendingRequests = [];
  List<PrescriptionRequest> _respondedRequests = [];
  List<PrescriptionRequest> _expiredRequests = [];

  bool _isLoading = false;
  String? _error;

  // Getters
  List<PrescriptionRequest> get pendingRequests => _pendingRequests;
  List<PrescriptionRequest> get respondedRequests => _respondedRequests;
  List<PrescriptionRequest> get expiredRequests => _expiredRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Quick response options
  static const String responseAllAvailable = 'all_available';
  static const String responseSomeAvailable = 'some_available';
  static const String responseUnavailable = 'unavailable';

  PrescriptionProvider() {
    _initializeListeners();
    _loadDemoRequests();
    // Force UI update after initialization
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  void _loadDemoRequests() {
    // Add comprehensive demo prescription requests for testing
    final now = DateTime.now();

    _pendingRequests = [
      // Critical request - expires in 3 minutes
      PrescriptionRequest(
        id: 'req_001',
        patientId: 'patient_001',
        patientName: 'Raj Sharma',
        patientPhone: '+91 9876543210',
        doctorName: 'Dr. Anita Singh',
        medicines: [
          Medicine(
            name: 'Paracetamol',
            dosage: '500mg',
            quantity: 10,
            instructions: 'Take twice daily after meals',
          ),
          Medicine(
            name: 'Amoxicillin',
            dosage: '250mg',
            quantity: 15,
            instructions: 'Take three times daily for 5 days',
          ),
        ],
        requestedAt: now.subtract(const Duration(minutes: 12)),
        responseDeadline: now.add(const Duration(minutes: 3)),
        status: 'pending',
        estimatedCost: 350.0,
        patientLocation: 'Connaught Place, Delhi',
        distanceFromPharmacy: 0.8,
        preferredLanguage: 'hi',
        multiLanguageResponses: {
          'all_available_en':
              'All medicines are available. Ready for pickup in 15 minutes. Total cost: ₹350',
          'all_available_hi':
              'सभी दवाएं उपलब्ध हैं। 15 मिनट में लेने के लिए तैयार। कुल लागत: ₹350',
          'all_available_regional':
              'সব ওষুধ উপলব্ধ। 15 মিনিটে নিতে পারেন। মোট খরচ: ₹350',
          'some_available_en':
              'Paracetamol available, Amoxicillin out of stock. Alternative available.',
          'some_available_hi':
              'पैरासिटामोल उपलब्ध है, एमोक्सिसिलिन स्टॉक में नहीं है। विकल्प उपलब्ध है।',
          'some_available_regional':
              'প্যারাসিটামল আছে, অ্যামোক্সিসিলিন স্টকে নেই। বিকল্প আছে।',
          'unavailable_en':
              'Currently out of stock. Expected restocking by tomorrow.',
          'unavailable_hi':
              'फिलहाल स्टॉक नहीं है। कल तक फिर से स्टॉक होने की उम्मीद है।',
          'unavailable_regional':
              'এখন স্টকে নেই। আগামীকাল পুনরায় স্টক হওয়ার আশা।',
        },
      ),

      // High priority - expires in 8 minutes
      PrescriptionRequest(
        id: 'req_002',
        patientId: 'patient_002',
        patientName: 'Priya Patel',
        patientPhone: '+91 8765432109',
        doctorName: 'Dr. Rajesh Kumar',
        medicines: [
          Medicine(
            name: 'Crocin Advance',
            dosage: '650mg',
            quantity: 20,
            instructions: 'Take when fever, max 4 tablets per day',
          ),
          Medicine(
            name: 'Vitamin D3',
            dosage: '60000 IU',
            quantity: 4,
            instructions: 'Once weekly with milk',
          ),
          Medicine(
            name: 'Calcium Carbonate',
            dosage: '500mg',
            quantity: 30,
            instructions: 'Take with meals, twice daily',
          ),
        ],
        requestedAt: now.subtract(const Duration(minutes: 7)),
        responseDeadline: now.add(const Duration(minutes: 8)),
        status: 'pending',
        estimatedCost: 580.0,
        patientLocation: 'Karol Bagh, Delhi',
        distanceFromPharmacy: 1.5,
        preferredLanguage: 'en',
        multiLanguageResponses: {
          'all_available_en':
              'All supplements available. Ready for pickup in 20 minutes. Total cost: ₹580',
          'all_available_hi':
              'सभी पूरक उपलब्ध हैं। 20 मिनट में लेने के लिए तैयार। कुल लागत: ₹580',
          'all_available_regional':
              'সব পরিপূরক উপলব্ধ। 20 মিনিটে নিতে পারেন। মোট খরচ: ₹580',
          'some_available_en':
              'Crocin and Calcium available, Vitamin D3 different brand available.',
          'some_available_hi':
              'क्रोसिन और कैल्शियम उपलब्ध है, विटामिन डी3 अलग ब्रांड उपलब्ध है।',
          'some_available_regional':
              'ক্রোসিন ও ক্যালসিয়াম আছে, ভিটামিন ডি3 অন্য ব্র্যান্ড আছে।',
          'unavailable_en':
              'Vitamin D3 out of stock. Can arrange from nearby pharmacy.',
          'unavailable_hi':
              'विटामिन डी3 स्टॉक में नहीं है। नजदीकी फार्मेसी से व्यवस्था हो सकती है।',
          'unavailable_regional':
              'ভিটামিন ডি3 স্টকে নেই। কাছের ফার্মেসি থেকে ব্যবস্থা করা যায়।',
        },
      ),

      // Medium priority - expires in 12 minutes
      PrescriptionRequest(
        id: 'req_003',
        patientId: 'patient_003',
        patientName: 'Arjun Gupta',
        patientPhone: '+91 9988776655',
        doctorName: 'Dr. Neha Sharma',
        medicines: [
          Medicine(
            name: 'Azithromycin',
            dosage: '500mg',
            quantity: 6,
            instructions: 'Take once daily for 6 days',
          ),
          Medicine(
            name: 'Montair LC',
            dosage: '10mg',
            quantity: 15,
            instructions: 'Take at bedtime',
          ),
        ],
        requestedAt: now.subtract(const Duration(minutes: 3)),
        responseDeadline: now.add(const Duration(minutes: 12)),
        status: 'pending',
        estimatedCost: 420.0,
        patientLocation: 'Lajpat Nagar, Delhi',
        distanceFromPharmacy: 2.1,
        preferredLanguage: 'regional',
        multiLanguageResponses: {
          'all_available_en':
              'Both antibiotics available. Please pickup within 2 hours. Total cost: ₹420',
          'all_available_hi':
              'दोनों एंटीबायोटिक्स उपलब्ध हैं। कृपया 2 घंटे के भीतर ले लें। कुल लागत: ₹420',
          'all_available_regional':
              'দুটি অ্যান্টিবায়োটিকই আছে। 2 ঘন্টার মধ্যে নিয়ে যান। মোট খরচ: ₹420',
          'some_available_en':
              'Azithromycin available, Montair LC substitute available.',
          'some_available_hi':
              'एज़िथ्रोमाइसिन उपलब্ধ है, मॉन्टायर एलसी का विकল्प उपলब्ध है।',
          'some_available_regional':
              'অ্যাজিথ্রোমাইসিন আছে, মনটেয়ার এলসি এর বিকল্প আছে।',
          'unavailable_en':
              'Both medicines need to be ordered. Available by evening.',
          'unavailable_hi':
              'दोनों दवाएं ऑर्डर करनी होंगी। शाम तक उपलব्ध होंगी।',
          'unavailable_regional':
              'দুটি ওষুধই অর্ডার করতে হবে। সন্ধ্যার মধ্যে পাওয়া যাবে।',
        },
      ),

      // Normal priority - expires in 14 minutes
      PrescriptionRequest(
        id: 'req_004',
        patientId: 'patient_004',
        patientName: 'Sunita Devi',
        patientPhone: '+91 8877665544',
        doctorName: 'Dr. Mohan Singh',
        medicines: [
          Medicine(
            name: 'Metformin',
            dosage: '500mg',
            quantity: 60,
            instructions: 'Take twice daily before meals',
          ),
          Medicine(
            name: 'Glimepiride',
            dosage: '2mg',
            quantity: 30,
            instructions: 'Take once daily before breakfast',
          ),
          Medicine(
            name: 'Atorvastatin',
            dosage: '20mg',
            quantity: 30,
            instructions: 'Take at bedtime',
          ),
        ],
        requestedAt: now.subtract(const Duration(minutes: 1)),
        responseDeadline: now.add(const Duration(minutes: 14)),
        status: 'pending',
        estimatedCost: 720.0,
        patientLocation: 'Rohini, Delhi',
        distanceFromPharmacy: 3.2,
        preferredLanguage: 'hi',
        multiLanguageResponses: {
          'all_available_en':
              'All diabetes medicines available. Monthly supply ready. Total cost: ₹720',
          'all_available_hi':
              'सभी मधुमेह की दवाएं उपलब्ध हैं। मासिक आपूर्ति तैयार। कुल लागत: ₹720',
          'all_available_regional':
              'সব ডায়াবেটিসের ওষুধ আছে। মাসিক সরবরাহ প্রস্তুত। মোট খরচ: ₹720',
          'some_available_en':
              'Metformin and Glimepiride available, Atorvastatin different brand available.',
          'some_available_hi':
              'मेटफॉर्मिन और ग्लिमेपिराइड उपलब्ध, एटोरवास्टेटिन अलग ब्रांड उपलब्ध।',
          'some_available_regional':
              'মেটফরমিন ও গ্লিমেপিরাইড আছে, অ্যাটরভাস্ট্যাটিন অন্য ব্র্যান্ড আছে।',
          'unavailable_en':
              'Some medicines out of stock. Can arrange from distributor by tomorrow.',
          'unavailable_hi':
              'कुछ दवाएं स्टॉक में नहीं हैं। कल तक डिस्ट्रिब्यूटर से व्यवस्था हो सकती है।',
          'unavailable_regional':
              'কিছু ওষুধ স্টকে নেই। আগামীকাল পর্যন্ত ডিস্ট্রিবিউটর থেকে ব্যবস্থা করা যায়।',
        },
      ),
    ];

    _respondedRequests = [
      PrescriptionRequest(
        id: 'req_005',
        patientId: 'patient_005',
        patientName: 'Amit Kumar',
        patientPhone: '+91 7654321098',
        doctorName: 'Dr. Kavya Reddy',
        medicines: [
          Medicine(
            name: 'Cetirizine',
            dosage: '10mg',
            quantity: 10,
            instructions: 'Once daily for allergy',
          ),
          Medicine(
            name: 'Nasal Spray',
            dosage: '50mcg',
            quantity: 1,
            instructions: 'Two sprays in each nostril twice daily',
          ),
        ],
        requestedAt: now.subtract(const Duration(hours: 2)),
        responseDeadline: now.subtract(const Duration(hours: 1, minutes: 45)),
        status: 'all_available',
        pharmacyResponse: 'all_available',
        notes: 'All medicines available. Ready for pickup in 15 minutes.',
        estimatedCost: 180.0,
        patientLocation: 'CP Metro Station, Delhi',
        distanceFromPharmacy: 0.5,
        preferredLanguage: 'en',
        multiLanguageResponses: {
          'response_en':
              'All allergy medicines available. Ready for pickup in 15 minutes. Total cost: ₹180',
          'response_hi':
              'सभी एलर्जी की दवाएं उपलब्ध हैं। 15 मिनट में लेने के लिए तैयार। कुल लागत: ₹180',
          'response_regional':
              'সব অ্যালার্জির ওষুধ আছে। 15 মিনিটে নিতে পারেন। মোট খরচ: ₹180',
        },
      ),

      PrescriptionRequest(
        id: 'req_006',
        patientId: 'patient_006',
        patientName: 'Meera Joshi',
        patientPhone: '+91 9876501234',
        doctorName: 'Dr. Rakesh Agarwal',
        medicines: [
          Medicine(
            name: 'Iron tablets',
            dosage: '100mg',
            quantity: 60,
            instructions: 'Take twice daily with Vitamin C',
          ),
          Medicine(
            name: 'Folic Acid',
            dosage: '5mg',
            quantity: 30,
            instructions: 'Once daily',
          ),
          Medicine(
            name: 'Calcium',
            dosage: '1000mg',
            quantity: 30,
            instructions: 'Take with meals',
          ),
        ],
        requestedAt: now.subtract(const Duration(hours: 4)),
        responseDeadline: now.subtract(const Duration(hours: 3, minutes: 45)),
        status: 'some_available',
        pharmacyResponse: 'some_available',
        notes:
            'Iron tablets and Calcium available. Folic Acid out of stock. Alternative suggested.',
        estimatedCost: 320.0,
        patientLocation: 'Janakpuri, Delhi',
        distanceFromPharmacy: 2.8,
      ),

      PrescriptionRequest(
        id: 'req_007',
        patientId: 'patient_007',
        patientName: 'Vikash Singh',
        patientPhone: '+91 8765098765',
        doctorName: 'Dr. Sushma Verma',
        medicines: [
          Medicine(
            name: 'Insulin Glargine',
            dosage: '100 units/ml',
            quantity: 3,
            instructions: 'As per doctor instructions',
          ),
        ],
        requestedAt: now.subtract(const Duration(hours: 6)),
        responseDeadline: now.subtract(const Duration(hours: 5, minutes: 45)),
        status: 'unavailable',
        pharmacyResponse: 'unavailable',
        notes:
            'Insulin currently out of stock. Recommended nearby specialty pharmacy.',
        estimatedCost: 0.0,
        patientLocation: 'Dwarka, Delhi',
        distanceFromPharmacy: 4.5,
      ),
    ];

    _expiredRequests = [
      PrescriptionRequest(
        id: 'req_008',
        patientId: 'patient_008',
        patientName: 'Rohit Sharma',
        patientPhone: '+91 9012345678',
        doctorName: 'Dr. Priya Mehta',
        medicines: [
          Medicine(
            name: 'Antibiotics',
            dosage: '500mg',
            quantity: 10,
            instructions: 'Complete course as prescribed',
          ),
        ],
        requestedAt: now.subtract(const Duration(hours: 1)),
        responseDeadline: now.subtract(const Duration(minutes: 5)),
        status: 'expired',
        estimatedCost: 250.0,
        patientLocation: 'Gurgaon, Haryana',
        distanceFromPharmacy: 8.2,
      ),
    ];

    // Add more realistic current requests
    _addRecentPrescriptionRequests(now);

    notifyListeners();
  }

  void _addRecentPrescriptionRequests(DateTime now) {
    // Add requests that show realistic pharmacy workflow
    _pendingRequests.addAll([
      // Urgent diabetes prescription - 8 minutes ago
      PrescriptionRequest(
        id: 'req_urgent_001',
        patientId: 'patient_urgent_001',
        patientName: 'Suresh Patel',
        patientPhone: '+91 9988776655',
        doctorName: 'Dr. Ramesh Kumar',
        medicines: [
          Medicine(
            name: 'Metformin',
            dosage: '500mg',
            quantity: 30,
            instructions: 'Take twice daily with meals',
          ),
          Medicine(
            name: 'Glimepiride',
            dosage: '2mg',
            quantity: 30,
            instructions: 'Take once daily before breakfast',
          ),
        ],
        requestedAt: now.subtract(const Duration(minutes: 8)),
        responseDeadline: now.add(const Duration(minutes: 7)),
        status: 'pending',
        patientLocation: 'Sector 15, Chandigarh',
        distanceFromPharmacy: 1.2,
        preferredLanguage: 'hi',
        multiLanguageResponses: {
          'suggestion_hindi':
              'दोनों दवाएं उपलब्ध हैं। कुल लागत: ₹340। 10 मिनट में तैयार।',
          'suggestion_english':
              'Both diabetes medicines available. Total cost: ₹340. Ready in 10 minutes.',
        },
      ),

      // Child fever - just requested
      PrescriptionRequest(
        id: 'req_child_001',
        patientId: 'patient_child_001',
        patientName: 'Baby Arjun (via Mother Priya)',
        patientPhone: '+91 8877665544',
        doctorName: 'Dr. Kavya Pediatrics',
        medicines: [
          Medicine(
            name: 'Paracetamol Syrup',
            dosage: '120mg/5ml',
            quantity: 1,
            instructions: 'Give 2.5ml every 6 hours when fever',
          ),
          Medicine(
            name: 'ORS Solution',
            dosage: 'Electral powder',
            quantity: 10,
            instructions: 'Mix in 200ml water, give frequently',
          ),
        ],
        requestedAt: now.subtract(const Duration(minutes: 2)),
        responseDeadline: now.add(const Duration(minutes: 13)),
        status: 'pending',
        patientLocation: 'Model Town, Ludhiana',
        distanceFromPharmacy: 0.8,
        preferredLanguage: 'en',
        multiLanguageResponses: {
          'suggestion_english':
              'Both medicines available. Child-safe formulation. Total: ₹85. Ready immediately.',
          'suggestion_punjabi':
              'ਦੋਵੇਂ ਦਵਾਈਆਂ ਉਪਲਬਧ ਹਨ। ਬੱਚਿਆਂ ਲਈ ਸੁਰੱਖਿਤ। ਕੁੱਲ: ₹85। ਤੁਰੰਤ ਤਿਆਰ।',
        },
      ),

      // Heart patient - 5 minutes ago
      PrescriptionRequest(
        id: 'req_heart_001',
        patientId: 'patient_heart_001',
        patientName: 'Mr. Joginder Singh',
        patientPhone: '+91 7766554433',
        doctorName: 'Dr. Cardio Specialist',
        medicines: [
          Medicine(
            name: 'Amlodipine',
            dosage: '5mg',
            quantity: 30,
            instructions: 'Take once daily in morning',
          ),
          Medicine(
            name: 'Atorvastatin',
            dosage: '20mg',
            quantity: 30,
            instructions: 'Take at bedtime',
          ),
          Medicine(
            name: 'Aspirin',
            dosage: '75mg',
            quantity: 30,
            instructions: 'Take daily after food',
          ),
        ],
        requestedAt: now.subtract(const Duration(minutes: 5)),
        responseDeadline: now.add(const Duration(minutes: 10)),
        status: 'pending',
        patientLocation: 'Civil Lines, Patiala',
        distanceFromPharmacy: 2.1,
        preferredLanguage: 'en',
        multiLanguageResponses: {
          'suggestion_english':
              'All heart medicines in stock. Total cost: ₹520. Please bring prescription copy.',
          'suggestion_hindi':
              'सभी हृदय की दवाएं उपलब्ध। कुल लागत: ₹520। कृपया प्रिस्क्रिप्शन की कॉपी लाएं।',
        },
      ),
    ]);
  }

  void _initializeListeners() {
    // Listen for new prescription requests
    _notificationService.prescriptionRequests.listen((request) {
      _addNewRequest(request);
    });

    // Listen for status updates
    _notificationService.statusUpdates.listen((update) {
      _handleStatusUpdate(update);
    });
  }

  void _addNewRequest(PrescriptionRequest request) {
    // Check if request already exists (prevent duplicates)
    final existingIndex = _pendingRequests.indexWhere(
      (r) => r.id == request.id,
    );

    if (existingIndex != -1) {
      _pendingRequests[existingIndex] = request;
    } else {
      _pendingRequests.insert(0, request); // Add to beginning for newest first
    }

    notifyListeners();
  }

  void _handleStatusUpdate(Map<String, dynamic> update) {
    final type = update['type'];

    if (type == 'expiry_warning') {
      final requestId = update['data']['requestId'];
      _markRequestAsExpiring(requestId);
    }
  }

  void _markRequestAsExpiring(String requestId) {
    final requestIndex = _pendingRequests.indexWhere((r) => r.id == requestId);
    if (requestIndex != -1) {
      final request = _pendingRequests[requestIndex];
      if (request.isExpired) {
        _pendingRequests.removeAt(requestIndex);
        _expiredRequests.insert(0, request.copyWith(status: 'expired'));
        notifyListeners();
      }
    }
  }

  // Quick response actions
  Future<bool> respondAllAvailable(
    String requestId, {
    String? notes,
    double? estimatedCost,
  }) async {
    return await _respondToRequest(
      requestId,
      responseAllAvailable,
      notes: notes ?? 'All medicines are available. Ready for pickup/delivery.',
      estimatedCost: estimatedCost,
    );
  }

  Future<bool> respondSomeAvailable(
    String requestId, {
    required String notes,
    double? estimatedCost,
    List<Map<String, dynamic>>? medicineAvailability,
  }) async {
    return await _respondToRequest(
      requestId,
      responseSomeAvailable,
      notes: notes,
      estimatedCost: estimatedCost,
      medicineAvailability: medicineAvailability,
    );
  }

  Future<bool> respondUnavailable(String requestId, {String? notes}) async {
    return await _respondToRequest(
      requestId,
      responseUnavailable,
      notes:
          notes ?? 'Sorry, the requested medicines are currently unavailable.',
    );
  }

  Future<bool> _respondToRequest(
    String requestId,
    String response, {
    String? notes,
    double? estimatedCost,
    List<Map<String, dynamic>>? medicineAvailability,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Send response via notification service (real-time)
      await _notificationService.respondToPrescription(
        requestId,
        response,
        notes: notes,
        estimatedCost: estimatedCost,
        medicineAvailability: medicineAvailability,
      );

      // Also save via API service
      final success = await _apiService.respondToPrescription(
        requestId,
        response,
        notes: notes,
        estimatedCost: estimatedCost,
        medicineAvailability: medicineAvailability,
      );

      if (success) {
        _moveRequestToResponded(requestId, response, notes, estimatedCost);
        return true;
      } else {
        _setError('Failed to save response to database');
        return false;
      }
    } catch (e) {
      _setError('Failed to send response: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _moveRequestToResponded(
    String requestId,
    String response,
    String? notes,
    double? estimatedCost,
  ) {
    final requestIndex = _pendingRequests.indexWhere((r) => r.id == requestId);
    if (requestIndex != -1) {
      final request = _pendingRequests.removeAt(requestIndex);
      final updatedRequest = request.copyWith(
        status: response,
        pharmacyResponse: response,
        notes: notes,
        estimatedCost: estimatedCost,
      );
      _respondedRequests.insert(0, updatedRequest);
      notifyListeners();
    }
  }

  // Load historical requests
  Future<void> loadRequests() async {
    _setLoading(true);
    _clearError();

    try {
      final allRequests = await _apiService.getPrescriptionRequests();

      // If API returns data, use it
      if (allRequests.isNotEmpty) {
        _pendingRequests.clear();
        _respondedRequests.clear();
        _expiredRequests.clear();

        for (final request in allRequests) {
          if (request.status == 'pending') {
            if (request.isExpired) {
              _expiredRequests.add(request.copyWith(status: 'expired'));
            } else {
              _pendingRequests.add(request);
            }
          } else {
            _respondedRequests.add(request);
          }
        }
      } else {
        // If API returns empty or fails, keep demo data already loaded
        print('No requests from API, using demo data');
      }

      notifyListeners();
    } catch (e) {
      print('API error: $e, using demo data');
      // Don't set error, just use demo data instead
    } finally {
      _setLoading(false);
    }
  }

  // Remove expired requests from pending
  void cleanupExpiredRequests() {
    final expiredInPending = _pendingRequests
        .where((r) => r.isExpired)
        .toList();

    for (final expired in expiredInPending) {
      _pendingRequests.remove(expired);
      _expiredRequests.insert(0, expired.copyWith(status: 'expired'));
    }

    if (expiredInPending.isNotEmpty) {
      notifyListeners();
    }
  }

  // Get time remaining for a request
  String getTimeRemaining(PrescriptionRequest request) {
    if (request.responseDeadline == null) return 'No deadline';

    final remaining = request.timeRemaining;

    if (remaining == Duration.zero) return 'Expired';

    if (remaining.inMinutes < 60) {
      return '${remaining.inMinutes}m ${remaining.inSeconds % 60}s';
    } else {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m';
    }
  }

  // Get request urgency level
  String getRequestUrgency(PrescriptionRequest request) {
    if (request.responseDeadline == null) return 'normal';

    final remaining = request.timeRemaining;

    if (remaining == Duration.zero) return 'expired';
    if (remaining.inMinutes <= 5) return 'critical';
    if (remaining.inMinutes <= 10) return 'high';
    if (remaining.inMinutes <= 15) return 'medium';

    return 'normal';
  }

  // Statistics
  int get totalPendingRequests => _pendingRequests.length;
  int get totalRespondedRequests => _respondedRequests.length;
  int get totalExpiredRequests => _expiredRequests.length;

  int get criticalRequests =>
      _pendingRequests.where((r) => getRequestUrgency(r) == 'critical').length;

  // Get suggested response in patient's preferred language
  String getSuggestedResponse(
    PrescriptionRequest request,
    String responseType,
  ) {
    if (request.multiLanguageResponses == null) return '';

    final language = request.preferredLanguage ?? 'en';
    final responseKey = '${responseType}_$language';

    return request.multiLanguageResponses![responseKey] ??
        request.multiLanguageResponses!['${responseType}_en'] ??
        '';
  }

  // Get all suggested responses for a request
  Map<String, String> getAllSuggestedResponses(PrescriptionRequest request) {
    if (request.multiLanguageResponses == null) return {};

    final language = request.preferredLanguage ?? 'en';
    final responses = <String, String>{};

    // Get responses for the preferred language
    for (final responseType in [
      'all_available',
      'some_available',
      'unavailable',
    ]) {
      final key = '${responseType}_$language';
      if (request.multiLanguageResponses!.containsKey(key)) {
        responses[responseType] = request.multiLanguageResponses![key]!;
      }
    }

    return responses;
  }

  // Get language display name
  String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी (Hindi)';
      case 'regional':
        return 'বাংলা (Bengali)'; // Can be customized based on region
      default:
        return 'English';
    }
  }

  // Bulk response actions
  Future<void> respondToAllPending(String responseType) async {
    final pendingRequestIds = _pendingRequests.map((r) => r.id).toList();

    for (final requestId in pendingRequestIds) {
      switch (responseType) {
        case 'all_available':
          await respondAllAvailable(requestId);
          break;
        case 'unavailable':
          await respondUnavailable(requestId);
          break;
        case 'some_available':
          await respondSomeAvailable(
            requestId,
            notes: 'Please contact pharmacy for medicine availability details.',
          );
          break;
      }
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

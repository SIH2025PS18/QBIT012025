import 'package:flutter/foundation.dart';
import '../models/pharmacy.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class PharmacyProvider with ChangeNotifier {
  final PharmacyApiService _apiService = PharmacyApiService();
  final PharmacyNotificationService _notificationService =
      PharmacyNotificationService();

  Pharmacy? _pharmacy;
  bool _isOnline = false;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Dashboard analytics
  Map<String, dynamic> _analytics = {};
  List<Map<String, dynamic>> _orderHistory = [];

  // Getters
  Pharmacy? get pharmacy => _pharmacy;
  bool get isOnline => _isOnline;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic> get analytics => _analytics;
  List<Map<String, dynamic>> get orderHistory => _orderHistory;

  PharmacyProvider() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _apiService.initialize();
    _isAuthenticated = _apiService.isAuthenticated;

    if (_isAuthenticated) {
      await loadPharmacyProfile();
    }

    notifyListeners();
  }

  // Authentication
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Handle demo credentials
      if (email == 'pharmacy@demo.com' && password == 'demo123') {
        _pharmacy = _createDemoPharmacy();
        _isAuthenticated = true;

        // Initialize notification service
        await _notificationService.initialize(_pharmacy!.id);

        // Set online status
        await setOnlineStatus(true);

        // Load demo data
        await _loadDemoData();

        return true;
      }

      // For real credentials, try API
      final result = await _apiService.login(email, password);

      if (result['success']) {
        _pharmacy = result['pharmacy'];
        _isAuthenticated = true;

        // Initialize notification service
        await _notificationService.initialize(_pharmacy!.id);

        // Set online status
        await setOnlineStatus(true);

        // Load initial data
        await Future.wait([loadDashboardAnalytics(), loadOrderHistory()]);

        return true;
      } else {
        _setError(result['message']);
        return false;
      }
    } catch (e) {
      // If API fails and using demo credentials, use demo mode
      if (email == 'pharmacy@demo.com' && password == 'demo123') {
        _pharmacy = _createDemoPharmacy();
        _isAuthenticated = true;
        await setOnlineStatus(true);
        await _loadDemoData();
        return true;
      }

      _setError('Login failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Pharmacy _createDemoPharmacy() {
    return Pharmacy(
      id: 'demo_pharmacy_001',
      name: 'HealthCare Pharmacy',
      licenseNumber: 'DL-12345',
      ownerName: 'Dr. Rajesh Kumar',
      email: 'pharmacy@demo.com',
      phone: '+91 9876543210',
      address: PharmacyAddress(
        street: '123 Medical Street',
        area: 'Health District',
        city: 'Delhi',
        state: 'Delhi',
        pincode: '110001',
        latitude: 28.6139,
        longitude: 77.2090,
        landmark: 'Near City Hospital',
      ),
      isActive: true,
      isVerified: true,
      timings: PharmacyTimings(
        openTime: '08:00',
        closeTime: '22:00',
        workingDays: [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        is24Hours: false,
      ),
      services: [
        'Prescription Filling',
        'Medicine Delivery',
        'Health Consultation',
      ],
      rating: 4.5,
      totalOrders: 1250,
      registeredAt: DateTime.now().subtract(const Duration(days: 365)),
    );
  }

  Future<void> _loadDemoData() async {
    // Load comprehensive demo analytics
    _analytics = {
      'averageResponseTime': 8.5,
      'customerSatisfaction': 4.5,
      'totalCustomers': 450,
      'todayOrders': 25,
      'weeklyRevenue': 15000.0,
      'monthlyRevenue': 65000.0,
      'totalPrescriptionsFilled': 1250,
      'averageOrderValue': 320.0,
      'topSellingMedicines': [
        {'name': 'Paracetamol', 'quantity': 450},
        {'name': 'Amoxicillin', 'quantity': 320},
        {'name': 'Cetirizine', 'quantity': 280},
        {'name': 'Metformin', 'quantity': 200},
        {'name': 'Vitamin D3', 'quantity': 180},
      ],
      'monthlyGrowth': 12.5,
      'customerRetention': 78.3,
    };

    // Load comprehensive demo order history with realistic data
    _orderHistory = [
      // Today's orders
      {
        'id': 'ORD001',
        'patientName': 'Raj Sharma',
        'totalAmount': 350.0,
        'status': 'completed',
        'createdAt': DateTime.now()
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
        'medicineCount': 2,
        'medicines': ['Paracetamol 500mg x10', 'Amoxicillin 250mg x15'],
        'paymentMethod': 'UPI',
      },
      {
        'id': 'ORD002',
        'patientName': 'Priya Patel',
        'totalAmount': 580.0,
        'status': 'ready_for_pickup',
        'createdAt': DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
        'medicineCount': 3,
        'medicines': [
          'Crocin Advance 650mg x20',
          'Vitamin D3 60000 IU x4',
          'Calcium Carbonate 500mg x30',
        ],
        'paymentMethod': 'Cash',
      },
      {
        'id': 'ORD003',
        'patientName': 'Amit Kumar',
        'totalAmount': 180.0,
        'status': 'delivered',
        'createdAt': DateTime.now()
            .subtract(const Duration(hours: 4))
            .toIso8601String(),
        'medicineCount': 2,
        'medicines': ['Cetirizine 10mg x10', 'Nasal Spray 50mcg x1'],
        'paymentMethod': 'Card',
      },

      // Yesterday's orders
      {
        'id': 'ORD004',
        'patientName': 'Sunita Devi',
        'totalAmount': 720.0,
        'status': 'delivered',
        'createdAt': DateTime.now()
            .subtract(const Duration(days: 1, hours: 3))
            .toIso8601String(),
        'medicineCount': 3,
        'medicines': [
          'Metformin 500mg x60',
          'Glimepiride 2mg x30',
          'Atorvastatin 20mg x30',
        ],
        'paymentMethod': 'UPI',
      },
      {
        'id': 'ORD005',
        'patientName': 'Meera Joshi',
        'totalAmount': 320.0,
        'status': 'delivered',
        'createdAt': DateTime.now()
            .subtract(const Duration(days: 1, hours: 6))
            .toIso8601String(),
        'medicineCount': 2,
        'medicines': ['Iron tablets 100mg x60', 'Calcium 1000mg x30'],
        'paymentMethod': 'Cash',
      },

      // This week's orders
      {
        'id': 'ORD006',
        'patientName': 'Arjun Gupta',
        'totalAmount': 420.0,
        'status': 'delivered',
        'createdAt': DateTime.now()
            .subtract(const Duration(days: 2))
            .toIso8601String(),
        'medicineCount': 2,
        'medicines': ['Azithromycin 500mg x6', 'Montair LC 10mg x15'],
        'paymentMethod': 'UPI',
      },
      {
        'id': 'ORD007',
        'patientName': 'Kavya Singh',
        'totalAmount': 650.0,
        'status': 'delivered',
        'createdAt': DateTime.now()
            .subtract(const Duration(days: 3))
            .toIso8601String(),
        'medicineCount': 4,
        'medicines': [
          'BP Medicine',
          'Diabetes tablets',
          'Multivitamin',
          'Omega-3',
        ],
        'paymentMethod': 'Card',
      },
      {
        'id': 'ORD008',
        'patientName': 'Rohit Verma',
        'totalAmount': 280.0,
        'status': 'delivered',
        'createdAt': DateTime.now()
            .subtract(const Duration(days: 4))
            .toIso8601String(),
        'medicineCount': 3,
        'medicines': ['Cough Syrup', 'Throat Lozenges', 'Vitamin C'],
        'paymentMethod': 'UPI',
      },

      // Older orders
      ...List.generate(15, (index) {
        final date = DateTime.now().subtract(Duration(days: 5 + index));
        final orderNumber = 1009 + index;
        return {
          'id': 'ORD${orderNumber.toString().padLeft(3, '0')}',
          'patientName': _getRandomPatientName(index),
          'totalAmount': 150.0 + (index * 35.0),
          'status': 'delivered',
          'createdAt': date.toIso8601String(),
          'medicineCount': 2 + (index % 4),
          'medicines': _getRandomMedicines(index),
          'paymentMethod': index % 3 == 0
              ? 'Cash'
              : (index % 3 == 1 ? 'UPI' : 'Card'),
        };
      }),
    ];

    notifyListeners();
  }

  String _getRandomPatientName(int index) {
    final names = [
      'Ankit Sharma',
      'Deepika Agarwal',
      'Manish Kumar',
      'Pooja Singh',
      'Rahul Gupta',
      'Sneha Patel',
      'Vivek Joshi',
      'Ankita Verma',
      'Harsh Malhotra',
      'Nisha Reddy',
      'Saurabh Singh',
      'Priyanka Dubey',
      'Mohit Agarwal',
      'Ritika Sharma',
      'Abhishek Kumar',
    ];
    return names[index % names.length];
  }

  List<String> _getRandomMedicines(int index) {
    final medicineGroups = [
      ['Paracetamol 500mg', 'Cough Syrup'],
      ['Vitamin D3', 'Calcium tablets', 'Multivitamin'],
      ['Antibiotics', 'Probiotics'],
      ['BP Medicine', 'Cholesterol tablets'],
      ['Diabetes medication', 'Insulin'],
      ['Allergy tablets', 'Nasal spray'],
      ['Pain relief gel', 'Anti-inflammatory'],
      ['Iron tablets', 'Folic acid'],
      ['Thyroid medication', 'Vitamin B12'],
      ['Antacid', 'Digestive enzymes'],
    ];
    return medicineGroups[index % medicineGroups.length];
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      // Set offline status
      await setOnlineStatus(false);

      // Clear authentication
      await _apiService.logout();

      // Reset state
      _pharmacy = null;
      _isAuthenticated = false;
      _isOnline = false;
      _analytics.clear();
      _orderHistory.clear();

      // Dispose notification service
      _notificationService.dispose();
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Profile management
  Future<void> loadPharmacyProfile() async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await _apiService.getPharmacyProfile();
      if (profile != null) {
        _pharmacy = profile;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to load profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _apiService.updatePharmacyProfile(updates);

      if (success) {
        await loadPharmacyProfile(); // Reload to get updated data
        return true;
      } else {
        _setError('Failed to update profile');
        return false;
      }
    } catch (e) {
      _setError('Update failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Online status management
  Future<void> setOnlineStatus(bool online) async {
    try {
      // For demo mode, always allow status change
      if (_pharmacy?.id == 'demo_pharmacy_001') {
        _isOnline = online;
        print(
          'Demo mode: Pharmacy status changed to ${online ? 'Online' : 'Offline'}',
        );

        // Simulate notification service update
        try {
          await _notificationService.updateOnlineStatus(online);
        } catch (e) {
          print('Notification service update failed (demo mode): $e');
        }

        notifyListeners();
        return;
      }

      // For real pharmacies, try API first
      final success = await _apiService.updateOnlineStatus(online);

      if (success) {
        _isOnline = online;

        // Update notification service
        await _notificationService.updateOnlineStatus(online);

        notifyListeners();
      } else {
        // Fallback for demo mode if API fails
        _isOnline = online;
        print('API failed, using demo mode status change');
        notifyListeners();
      }
    } catch (e) {
      print('Failed to update online status: $e');
      // Even if there's an error, allow demo mode to work
      if (_pharmacy?.id == 'demo_pharmacy_001') {
        _isOnline = online;
        notifyListeners();
      }
    }
  }

  // Quick toggle method
  Future<void> toggleOnlineStatus() async {
    await setOnlineStatus(!_isOnline);
  }

  // Dashboard analytics
  Future<void> loadDashboardAnalytics({String period = 'week'}) async {
    try {
      _analytics = await _apiService.getDashboardAnalytics(period: period);
      notifyListeners();
    } catch (e) {
      print('Failed to load analytics: $e');
    }
  }

  // Order history
  Future<void> loadOrderHistory({int page = 1, int limit = 20}) async {
    try {
      final orders = await _apiService.getOrderHistory(
        page: page,
        limit: limit,
      );

      if (page == 1) {
        _orderHistory = orders;
      } else {
        _orderHistory.addAll(orders);
      }

      notifyListeners();
    } catch (e) {
      print('Failed to load order history: $e');
    }
  }

  // Business hours
  bool get isOpenNow {
    return _pharmacy?.timings.isOpenNow ?? false;
  }

  String get businessHoursStatus {
    if (_pharmacy?.timings.is24Hours == true) {
      return '24/7 Service';
    }

    if (isOpenNow) {
      return 'Open Now';
    } else {
      return 'Closed';
    }
  }

  // Revenue calculations
  double get todaysRevenue {
    final today = DateTime.now();
    return _orderHistory
        .where((order) {
          final orderDate = DateTime.parse(order['createdAt'] ?? '');
          return orderDate.day == today.day &&
              orderDate.month == today.month &&
              orderDate.year == today.year;
        })
        .fold(
          0.0,
          (sum, order) => sum + (order['totalAmount']?.toDouble() ?? 0.0),
        );
  }

  double get weeklyRevenue {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return _orderHistory
        .where((order) {
          final orderDate = DateTime.parse(order['createdAt'] ?? '');
          return orderDate.isAfter(weekStart);
        })
        .fold(
          0.0,
          (sum, order) => sum + (order['totalAmount']?.toDouble() ?? 0.0),
        );
  }

  // Order statistics
  int get todaysOrders {
    final today = DateTime.now();
    return _orderHistory.where((order) {
      final orderDate = DateTime.parse(order['createdAt'] ?? '');
      return orderDate.day == today.day &&
          orderDate.month == today.month &&
          orderDate.year == today.year;
    }).length;
  }

  int get pendingOrders {
    return _orderHistory
        .where(
          (order) =>
              order['status'] == 'pending' || order['status'] == 'processing',
        )
        .length;
  }

  // Performance metrics
  double get averageResponseTime {
    return _analytics['averageResponseTime']?.toDouble() ?? 0.0;
  }

  double get customerSatisfaction {
    return _analytics['customerSatisfaction']?.toDouble() ?? 0.0;
  }

  int get totalCustomers {
    return _analytics['totalCustomers'] ?? 0;
  }

  // Quick actions
  Future<void> refreshData() async {
    await Future.wait([
      loadPharmacyProfile(),
      loadDashboardAnalytics(),
      loadOrderHistory(),
    ]);
  }

  // Notification settings
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  Future<void> updateNotificationSettings(bool soundEnabled) async {
    try {
      await _notificationService.setSoundEnabled(soundEnabled);
      _notificationsEnabled = soundEnabled;
      notifyListeners();
    } catch (e) {
      print('Failed to update notification settings: $e');
    }
  }

  Future<void> toggleNotifications() async {
    await updateNotificationSettings(!_notificationsEnabled);
  }

  // Test notification
  Future<void> testNotification() async {
    try {
      await _notificationService.testNotification();
    } catch (e) {
      print('Failed to test notification: $e');
    }
  }

  // Business hours getters
  String get weekdayHours {
    if (_pharmacy?.timings.is24Hours == true) return '24 Hours';
    return '${_pharmacy?.timings.openTime ?? '9:00'} - ${_pharmacy?.timings.closeTime ?? '21:00'}';
  }

  String get saturdayHours {
    final workingDays = _pharmacy?.timings.workingDays ?? [];
    if (!workingDays.contains('Saturday')) return 'Closed';
    if (_pharmacy?.timings.is24Hours == true) return '24 Hours';
    return '${_pharmacy?.timings.openTime ?? '9:00'} - ${_pharmacy?.timings.closeTime ?? '21:00'}';
  }

  String get sundayHours {
    final workingDays = _pharmacy?.timings.workingDays ?? [];
    if (!workingDays.contains('Sunday')) return 'Closed';
    if (_pharmacy?.timings.is24Hours == true) return '24 Hours';
    return '${_pharmacy?.timings.openTime ?? '9:00'} - ${_pharmacy?.timings.closeTime ?? '21:00'}';
  }

  // Current pharmacy getter
  Pharmacy? get currentPharmacy => _pharmacy;

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
    _notificationService.dispose();
    super.dispose();
  }
}

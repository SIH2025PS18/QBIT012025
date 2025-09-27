import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prescription_request.dart';
import '../models/pharmacy.dart';

class PharmacyApiService {
  static const String baseUrl =
      'https://telemed18.onrender.com || http://192.168.1.7:5002/api';
  static final PharmacyApiService _instance = PharmacyApiService._internal();
  factory PharmacyApiService() => _instance;
  PharmacyApiService._internal();

  String? _authToken;
  String? _pharmacyId;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('pharmacy_auth_token');
    _pharmacyId = prefs.getString('pharmacy_id');
  }

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pharmacy/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _authToken = data['token'];
        _pharmacyId = data['pharmacy']['id'] ?? data['pharmacy']['_id'];

        // Save to local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pharmacy_auth_token', _authToken!);
        await prefs.setString('pharmacy_id', _pharmacyId!);

        return {
          'success': true,
          'pharmacy': Pharmacy.fromJson(data['pharmacy']),
          'token': _authToken,
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<void> logout() async {
    _authToken = null;
    _pharmacyId = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pharmacy_auth_token');
    await prefs.remove('pharmacy_id');
  }

  // Get pharmacy profile
  Future<Pharmacy?> getPharmacyProfile() async {
    if (_pharmacyId == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pharmacy/profile/$_pharmacyId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Pharmacy.fromJson(data['pharmacy']);
      }
    } catch (e) {
      print('Error fetching pharmacy profile: $e');
    }

    return null;
  }

  // Update pharmacy profile
  Future<bool> updatePharmacyProfile(Map<String, dynamic> updates) async {
    if (_pharmacyId == null) return false;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/pharmacy/profile/$_pharmacyId'),
        headers: _headers,
        body: jsonEncode(updates),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating pharmacy profile: $e');
      return false;
    }
  }

  // Get prescription requests
  Future<List<PrescriptionRequest>> getPrescriptionRequests({
    String status = 'all',
    int page = 1,
    int limit = 20,
  }) async {
    if (_pharmacyId == null) return [];

    try {
      final queryParams = {
        'pharmacyId': _pharmacyId!,
        'status': status,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse(
        '$baseUrl/prescriptions/requests',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final requests = data['requests'] as List;
        return requests.map((r) => PrescriptionRequest.fromJson(r)).toList();
      }
    } catch (e) {
      print('Error fetching prescription requests: $e');
    }

    return [];
  }

  // Respond to prescription request
  Future<bool> respondToPrescription(
    String requestId,
    String response, {
    String? notes,
    double? estimatedCost,
    List<Map<String, dynamic>>? medicineAvailability,
  }) async {
    try {
      final responseData = {
        'pharmacyId': _pharmacyId,
        'response': response,
        'notes': notes,
        'estimatedCost': estimatedCost,
        'medicineAvailability': medicineAvailability,
        'respondedAt': DateTime.now().toIso8601String(),
      };

      final response_http = await http.post(
        Uri.parse('$baseUrl/prescriptions/respond/$requestId'),
        headers: _headers,
        body: jsonEncode(responseData),
      );

      return response_http.statusCode == 200;
    } catch (e) {
      print('Error responding to prescription: $e');
      return false;
    }
  }

  // Get order history
  Future<List<Map<String, dynamic>>> getOrderHistory({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    if (_pharmacyId == null) return [];

    try {
      final queryParams = {
        'pharmacyId': _pharmacyId!,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (status != null) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse(
        '$baseUrl/orders/pharmacy-history',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['orders'] ?? []);
      }
    } catch (e) {
      print('Error fetching order history: $e');
    }

    return [];
  }

  // Get dashboard analytics
  Future<Map<String, dynamic>> getDashboardAnalytics({
    String period = 'week',
  }) async {
    if (_pharmacyId == null) return {};

    try {
      final uri = Uri.parse(
        '$baseUrl/pharmacy/analytics/$_pharmacyId',
      ).replace(queryParameters: {'period': period});

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching analytics: $e');
    }

    return {};
  }

  // Update online status
  Future<bool> updateOnlineStatus(bool isOnline) async {
    if (_pharmacyId == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pharmacy/status/$_pharmacyId'),
        headers: _headers,
        body: jsonEncode({
          'isOnline': isOnline,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating online status: $e');
      return false;
    }
  }

  // Medicine inventory methods
  Future<List<Map<String, dynamic>>> searchMedicines(String query) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/medicines/search',
      ).replace(queryParameters: {'q': query, 'limit': '50'});

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['medicines'] ?? []);
      }
    } catch (e) {
      print('Error searching medicines: $e');
    }

    return [];
  }

  // Get nearby patients (for delivery estimates)
  Future<List<Map<String, dynamic>>> getNearbyPatients() async {
    if (_pharmacyId == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pharmacy/nearby-patients/$_pharmacyId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['patients'] ?? []);
      }
    } catch (e) {
      print('Error fetching nearby patients: $e');
    }

    return [];
  }

  // Upload prescription image
  Future<String?> uploadPrescriptionImage(String filePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/prescription'),
      );

      request.headers.addAll(_headers);
      request.files.add(await http.MultipartFile.fromPath('image', filePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        return data['imageUrl'];
      }
    } catch (e) {
      print('Error uploading prescription image: $e');
    }

    return null;
  }

  String? get pharmacyId => _pharmacyId;
  bool get isAuthenticated => _authToken != null && _pharmacyId != null;
}

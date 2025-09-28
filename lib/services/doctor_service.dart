import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/doctor.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class DoctorService extends ChangeNotifier {
  static final ApiService _apiService = ApiService();
  IO.Socket? _socket;

  // Real-time data
  List<Doctor> _allDoctors = [];
  List<Doctor> _onlineDoctors = [];
  Map<String, List<Map<String, dynamic>>> _doctorQueues =
      {}; // doctorId -> patient queue

  // Getters
  List<Doctor> get allDoctors => _allDoctors;
  List<Doctor> get onlineDoctors => _onlineDoctors;
  Map<String, List<Map<String, dynamic>>> get doctorQueues => _doctorQueues;

  // Singleton instance
  static final DoctorService _instance = DoctorService._internal();
  factory DoctorService() => _instance;
  DoctorService._internal();

  /// Initialize real-time connection
  Future<void> initialize() async {
    await _connectSocket();
    await refreshDoctors();
    _startPeriodicUpdates();
  }

  /// Connect to socket for real-time updates
  Future<void> _connectSocket() async {
    try {
      _socket = IO.io(ApiConfig.socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      _socket!.connect();

      _socket!.on('connect', (_) {
        debugPrint('🔌 Connected to doctor service socket');
      });

      _socket!.on('disconnect', (_) {
        debugPrint('❌ Disconnected from doctor service socket');
      });

      // Listen for doctor status updates
      _socket!.on('doctor_status_update', (data) {
        _handleDoctorStatusUpdate(data);
      });

      // Listen for queue updates
      _socket!.on('queue_update', (data) {
        _handleQueueUpdate(data);
      });

      // Listen for new doctor online
      _socket!.on('doctor_online', (data) {
        _handleDoctorOnline(data);
      });

      // Listen for doctor offline
      _socket!.on('doctor_offline', (data) {
        _handleDoctorOffline(data);
      });

      // Listen for doctor login (real-time from dashboard)
      _socket!.on('doctor_login', (data) {
        _handleDoctorLogin(data);
      });

      // Listen for doctor logout (real-time from dashboard)
      _socket!.on('doctor_logout', (data) {
        _handleDoctorLogout(data);
      });
    } catch (e) {
      debugPrint('❌ Error connecting to socket: $e');
    }
  }

  /// Handle real-time doctor status updates
  void _handleDoctorStatusUpdate(dynamic data) {
    try {
      final doctorId = data['doctorId'];
      final status = data['status'];
      final isAvailable = data['isAvailable'] ?? true;

      // Update doctor in local lists
      _updateDoctorStatus(doctorId, status, isAvailable);
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling doctor status update: $e');
    }
  }

  /// Handle queue updates
  void _handleQueueUpdate(dynamic data) {
    try {
      final doctorId = data['doctorId'];
      final queue = data['queue'] ?? [];

      _doctorQueues[doctorId] = List<Map<String, dynamic>>.from(queue);
      notifyListeners();

      debugPrint(
        '📋 Doctor $doctorId queue updated: ${_doctorQueues[doctorId]?.length ?? 0} patients',
      );
    } catch (e) {
      debugPrint('Error handling queue update: $e');
    }
  }

  /// Handle doctor coming online
  void _handleDoctorOnline(dynamic data) {
    try {
      final doctor = Doctor.fromMap(data['doctor']);
      _addOrUpdateDoctor(doctor);
      _showToast('Dr. ${doctor.name} is now online!', isError: false);
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling doctor online: $e');
    }
  }

  /// Handle doctor going offline
  void _handleDoctorOffline(dynamic data) {
    try {
      final doctorId = data['doctorId'];
      _removeDoctorFromOnline(doctorId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling doctor offline: $e');
    }
  }

  /// Handle doctor login (real-time from dashboard)
  void _handleDoctorLogin(dynamic data) {
    try {
      final doctorId = data['doctorId'];
      final doctorName = data['name'];
      final speciality = data['speciality'];

      debugPrint('🟢 Doctor login detected: $doctorName ($speciality)');

      // Find the doctor in all doctors list and mark as online
      final doctorIndex = _allDoctors.indexWhere(
        (d) => d.id == doctorId || d.doctorId == doctorId,
      );
      if (doctorIndex != -1) {
        final doctor = _allDoctors[doctorIndex];
        final updatedDoctor = doctor.copyWith(
          status: 'online',
          isAvailable: true,
        );
        _allDoctors[doctorIndex] = updatedDoctor;

        // Add to online doctors if not already there
        if (!_onlineDoctors.any(
          (d) => d.id == doctorId || d.doctorId == doctorId,
        )) {
          _onlineDoctors.add(updatedDoctor);
        }
      }

      _showToast('Dr. $doctorName is now online!', isError: false);
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling doctor login: $e');
    }
  }

  /// Handle doctor logout (real-time from dashboard)
  void _handleDoctorLogout(dynamic data) {
    try {
      final doctorId = data['doctorId'];
      final doctorName = data['name'];

      debugPrint('🔴 Doctor logout detected: $doctorName');

      // Update doctor status in all doctors list
      final doctorIndex = _allDoctors.indexWhere(
        (d) => d.id == doctorId || d.doctorId == doctorId,
      );
      if (doctorIndex != -1) {
        _allDoctors[doctorIndex] = _allDoctors[doctorIndex].copyWith(
          status: 'offline',
          isAvailable: false,
        );
      }

      // Remove from online doctors
      _onlineDoctors.removeWhere(
        (d) => d.id == doctorId || d.doctorId == doctorId,
      );

      _showToast('Dr. $doctorName went offline', isError: true);
      notifyListeners();
    } catch (e) {
      debugPrint('Error handling doctor logout: $e');
    }
  }

  /// Update doctor status in local lists
  void _updateDoctorStatus(String doctorId, String status, bool isAvailable) {
    // Update in all doctors list
    final index = _allDoctors.indexWhere(
      (d) => d.id == doctorId || d.doctorId == doctorId,
    );
    if (index != -1) {
      _allDoctors[index] = _allDoctors[index].copyWith(
        status: status,
        isAvailable: isAvailable,
      );
    }

    // Update online doctors list
    if (status == 'online' && isAvailable) {
      if (!_onlineDoctors.any(
        (d) => d.id == doctorId || d.doctorId == doctorId,
      )) {
        final doctor = _allDoctors.firstWhere(
          (d) => d.id == doctorId || d.doctorId == doctorId,
          orElse: () => throw Exception('Doctor not found'),
        );
        _onlineDoctors.add(doctor);
      }
    } else {
      _onlineDoctors.removeWhere(
        (d) => d.id == doctorId || d.doctorId == doctorId,
      );
    }
  }

  /// Add or update doctor in lists
  void _addOrUpdateDoctor(Doctor doctor) {
    // Update or add to all doctors
    final index = _allDoctors.indexWhere((d) => d.id == doctor.id);
    if (index != -1) {
      _allDoctors[index] = doctor;
    } else {
      _allDoctors.add(doctor);
    }

    // Update online doctors if doctor is online
    if (doctor.status == 'online' && doctor.isAvailable) {
      final onlineIndex = _onlineDoctors.indexWhere((d) => d.id == doctor.id);
      if (onlineIndex != -1) {
        _onlineDoctors[onlineIndex] = doctor;
      } else {
        _onlineDoctors.add(doctor);
      }
    }
  }

  /// Remove doctor from online list
  void _removeDoctorFromOnline(String doctorId) {
    _onlineDoctors.removeWhere(
      (d) => d.id == doctorId || d.doctorId == doctorId,
    );
    _doctorQueues.remove(doctorId);
  }

  /// Start periodic updates
  void _startPeriodicUpdates() {
    // Refresh doctors every 30 seconds
    Timer.periodic(const Duration(seconds: 30), (timer) {
      refreshDoctors();
    });
  }

  /// Refresh all doctors from backend
  Future<void> refreshDoctors() async {
    try {
      final response = await _apiService.get(ApiConfig.doctorsBooking);

      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        final List<dynamic> doctorsData = responseData is Map
            ? responseData['data'] ?? []
            : responseData as List<dynamic>;

        _allDoctors = doctorsData.map((data) => Doctor.fromMap(data)).toList();

        // Filter online doctors
        _onlineDoctors = _allDoctors
            .where((doctor) => doctor.status == 'online' && doctor.isAvailable)
            .toList();

        notifyListeners();
        debugPrint(
          '✅ Refreshed ${_allDoctors.length} doctors, ${_onlineDoctors.length} online',
        );
      }
    } catch (e) {
      debugPrint('❌ Error refreshing doctors: $e');
    }
  }

  /// Request video consultation with doctor
  Future<Map<String, dynamic>?> requestVideoConsultation({
    required String doctorId,
    required String patientId,
    required String patientName,
    String? symptoms,
    String priority = 'normal',
  }) async {
    try {
      final requestData = {
        'doctorId': doctorId,
        'patientId': patientId,
        'patientName': patientName,
        'symptoms': symptoms,
        'priority': priority,
        'type': 'video_call',
        'requestedAt': DateTime.now().toIso8601String(),
      };

      // Emit socket event for real-time request
      _socket?.emit('patient_request_consultation', requestData);

      // Also send HTTP request as backup
      final response = await _apiService.post(
        '${ApiConfig.baseUrl}/consultations/request',
        body: requestData,
      );

      if (response.isSuccess) {
        final consultationData = response.data;
        debugPrint(
          '✅ Video consultation requested: ${consultationData?['id']}',
        );

        // Add to doctor's queue
        if (_doctorQueues[doctorId] == null) {
          _doctorQueues[doctorId] = [];
        }
        _doctorQueues[doctorId]!.add({
          'patientId': patientId,
          'patientName': patientName,
          'symptoms': symptoms,
          'priority': priority,
          'requestedAt': DateTime.now().toIso8601String(),
          'consultationId': consultationData?['id'],
        });

        notifyListeners();
        return consultationData;
      } else {
        debugPrint('❌ Failed to request consultation: ${response.error}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Error requesting video consultation: $e');
      return null;
    }
  }

  /// Get patient queue for a specific doctor
  List<Map<String, dynamic>> getDoctorQueue(String doctorId) {
    return _doctorQueues[doctorId] ?? [];
  }

  /// Accept consultation request (for doctor dashboard)
  Future<bool> acceptConsultation(
    String consultationId,
    String doctorId,
  ) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.baseUrl}/consultations/$consultationId/accept',
        body: {'doctorId': doctorId},
      );

      if (response.isSuccess) {
        // Emit socket event
        _socket?.emit('doctor_accept_consultation', {
          'consultationId': consultationId,
          'doctorId': doctorId,
        });

        debugPrint('✅ Consultation accepted: $consultationId');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error accepting consultation: $e');
      return false;
    }
  }

  /// Generate Agora token for video call
  Future<Map<String, dynamic>?> generateAgoraToken({
    required String channelName,
    required String userId,
    int expireTime = 3600, // 1 hour
  }) async {
    try {
      final response = await _apiService.post(
        '${ApiConfig.baseUrl}/agora/token',
        body: {
          'channelName': channelName,
          'userId': userId,
          'expireTime': expireTime,
        },
      );

      if (response.isSuccess) {
        final tokenData = response.data;
        debugPrint('✅ Agora token generated for channel: $channelName');
        return {
          'token': tokenData?['token'],
          'channelName': channelName,
          'appId': '98d3fa37dec44dc1950b071e3482cfae', // Your Agora App ID
          'userId': userId,
        };
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error generating Agora token: $e');
      return null;
    }
  }

  /// Get all available doctors from unified backend (for live queue - only online)
  static Future<List<Doctor>> getAllDoctors() async {
    try {
      final response = await _apiService.get(ApiConfig.doctorsAvailable);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> doctorsData = response.data as List<dynamic>;
        return doctorsData.map((data) => Doctor.fromMap(data)).toList();
      } else {
        _showToast('Error loading doctors: ${response.error}', isError: true);
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching doctors: $e');
      _showToast('Error loading doctors', isError: true);
      return [];
    }
  }

  /// Get available doctors (alias for getAllDoctors) - for live queue only
  static Future<List<Doctor>> getAvailableDoctors() async {
    return getAllDoctors();
  }

  /// Get all doctors for appointment booking (includes offline doctors)
  static Future<List<Doctor>> getBookingDoctors() async {
    try {
      // Try the booking endpoint first
      final response = await _apiService.get(ApiConfig.doctorsBooking);

      if (response.isSuccess && response.data != null) {
        final responseData = response.data;
        final List<dynamic> doctorsData = responseData is Map
            ? responseData['data'] ?? []
            : responseData as List<dynamic>;
        final doctors = doctorsData.map((data) => Doctor.fromMap(data)).toList();
        
        if (doctors.isNotEmpty) {
          debugPrint('✅ Booking endpoint returned ${doctors.length} doctors');
          return doctors;
        }
      }
      
      // Fallback: Use createSampleDoctors or hardcoded list for booking
      debugPrint('⚠️ Booking endpoint failed, using fallback doctors');
      return _getFallbackDoctors();
      
    } catch (e) {
      debugPrint('❌ Error fetching booking doctors: $e');
      debugPrint('⚠️ Using fallback doctors for appointment booking');
      return _getFallbackDoctors();
    }
  }

  /// Fallback doctors for appointment booking when API fails
  static List<Doctor> _getFallbackDoctors() {
    return [
      Doctor(
        id: '67758a6b0b4bfcd839113b70',
        doctorId: 'DOC001',
        name: 'Dr. Rahul Sharma',
        speciality: 'Cardiologist',
        qualification: 'MBBS, MD (Cardiology)',
        experience: 15,
        consultationFee: 800.0,
        rating: 4.8,
        totalConsultations: 500,
        languages: ['English', 'Hindi'],
        status: 'offline',
        isAvailable: true,
        email: 'rahul.sharma@example.com',
        phone: '+919876543210',
      ),
      Doctor(
        id: '67758a6b0b4bfcd839113b71',
        doctorId: 'DOC002',
        name: 'Dr. Preet Kaur',
        speciality: 'Pediatrician',
        qualification: 'MBBS, MD (Pediatrics)',
        experience: 12,
        consultationFee: 700.0,
        rating: 4.9,
        totalConsultations: 450,
        languages: ['English', 'Hindi', 'Punjabi'],
        status: 'offline',
        isAvailable: true,
        email: 'preet.kaur@example.com',
        phone: '+919876543211',
      ),
      Doctor(
        id: '67758a6b0b4bfcd839113b72',
        doctorId: 'DOC003',
        name: 'Dr. Amit Patel',
        speciality: 'Orthopedic',
        qualification: 'MBBS, MS (Orthopedics)',
        experience: 18,
        consultationFee: 900.0,
        rating: 4.7,
        totalConsultations: 600,
        languages: ['English', 'Hindi', 'Gujarati'],
        status: 'offline',
        isAvailable: true,
        email: 'amit.patel@example.com',
        phone: '+919876543212',
      ),
      Doctor(
        id: '67758a6b0b4bfcd839113b73',
        doctorId: 'DOC004',
        name: 'Dr. Harjeet Singh',
        speciality: 'General Practitioner',
        qualification: 'MBBS',
        experience: 10,
        consultationFee: 500.0,
        rating: 4.5,
        totalConsultations: 300,
        languages: ['English', 'Hindi', 'Punjabi'],
        status: 'offline',
        isAvailable: true,
        email: 'harjeet.singh@example.com',
        phone: '+919876543213',
      ),
      Doctor(
        id: '67758a6b0b4bfcd839113b74',
        doctorId: 'DOC005',
        name: 'Dr. Sunita Gupta',
        speciality: 'Gynecologist',
        qualification: 'MBBS, MD (Gynecology)',
        experience: 14,
        consultationFee: 750.0,
        rating: 4.6,
        totalConsultations: 400,
        languages: ['English', 'Hindi'],
        status: 'offline',
        isAvailable: true,
        email: 'sunita.gupta@example.com',
        phone: '+919876543214',
      ),
      Doctor(
        id: '67758a6b0b4bfcd839113b75',
        doctorId: 'DOC006',
        name: 'Dr. Ravi Dhaliwal',
        speciality: 'Dermatologist',
        qualification: 'MBBS, MD (Dermatology)',
        experience: 11,
        consultationFee: 650.0,
        rating: 4.4,
        totalConsultations: 350,
        languages: ['English', 'Hindi', 'Punjabi'],
        status: 'offline',
        isAvailable: true,
        email: 'ravi.dhaliwal@example.com',
        phone: '+919876543215',
      ),
    ];
  }

  /// Search doctors by speciality using unified backend
  static Future<List<Doctor>> searchDoctorsBySpeciality(
    String speciality,
  ) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.doctorsList}?speciality=$speciality&available=true',
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> doctorsData = response.data as List<dynamic>;
        return doctorsData.map((data) => Doctor.fromMap(data)).toList();
      } else {
        _showToast('Error searching doctors: ${response.error}', isError: true);
        return [];
      }
    } catch (e) {
      debugPrint('Error searching doctors: $e');
      _showToast('Error searching doctors', isError: true);
      return [];
    }
  }

  /// Search doctors by name using unified backend
  static Future<List<Doctor>> searchDoctorsByName(String name) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.doctorsList}?name=$name&available=true',
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> doctorsData = response.data as List<dynamic>;
        return doctorsData.map((data) => Doctor.fromMap(data)).toList();
      } else {
        _showToast('Error searching doctors: ${response.error}', isError: true);
        return [];
      }
    } catch (e) {
      debugPrint('Error searching doctors by name: $e');
      _showToast('Error searching doctors', isError: true);
      return [];
    }
  }

  /// Get doctors by availability (online status) from unified backend
  static Future<List<Doctor>> getOnlineDoctors() async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.doctorsList}?status=online&available=true',
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> doctorsData = response.data as List<dynamic>;
        return doctorsData.map((data) => Doctor.fromMap(data)).toList();
      } else {
        _showToast(
          'Error loading online doctors: ${response.error}',
          isError: true,
        );
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching online doctors: $e');
      _showToast('Error loading online doctors', isError: true);
      return [];
    }
  }

  /// Get doctor by ID from unified backend
  static Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      final response = await _apiService.get(ApiConfig.doctorById(doctorId));

      if (response.isSuccess && response.data != null) {
        return Doctor.fromMap(response.data);
      } else {
        _showToast(
          'Error loading doctor details: ${response.error}',
          isError: true,
        );
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching doctor: $e');
      _showToast('Error loading doctor details', isError: true);
      return null;
    }
  }

  /// Get unique specializations from unified backend
  static Future<List<String>> getSpecializations() async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.doctorsList}/specialties',
      );

      if (response.isSuccess && response.data != null) {
        final List<dynamic> specialties = response.data as List<dynamic>;
        return specialties.map((specialty) => specialty.toString()).toList();
      } else {
        // Fallback to common specialties if API doesn't have this endpoint
        return [
          'Cardiology',
          'Dermatology',
          'General Medicine',
          'Pediatrics',
          'Orthopedics',
          'Neurology',
          'Gynecology',
          'Psychiatry',
          'Oncology',
          'Endocrinology',
        ];
      }
    } catch (e) {
      debugPrint('Error fetching specializations: $e');
      // Return default specializations
      return [
        'Cardiology',
        'Dermatology',
        'General Medicine',
        'Pediatrics',
        'Orthopedics',
        'Neurology',
        'Gynecology',
        'Psychiatry',
        'Oncology',
        'Endocrinology',
      ];
    }
  }

  /// Filter doctors by multiple criteria
  static Future<List<Doctor>> filterDoctors({
    String? speciality,
    String? searchQuery,
    bool? isOnline,
    double? minRating,
    double? maxConsultationFee,
    List<String>? languages,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {'available': 'true'};

      if (speciality != null && speciality.isNotEmpty) {
        queryParams['speciality'] = speciality;
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['name'] = searchQuery;
      }

      if (isOnline == true) {
        queryParams['status'] = 'online';
      }

      if (minRating != null) {
        queryParams['minRating'] = minRating.toString();
      }

      if (maxConsultationFee != null) {
        queryParams['maxFee'] = maxConsultationFee.toString();
      }

      // Build URL with query parameters
      String url = ApiConfig.doctorsList;
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
            .join('&');
        url += '?$queryString';
      }

      final response = await _apiService.get(url);

      if (response.isSuccess && response.data != null) {
        List<Doctor> doctors = (response.data as List<dynamic>)
            .map((data) => Doctor.fromMap(data))
            .toList();

        // Filter by languages if specified (client-side filtering)
        if (languages != null && languages.isNotEmpty) {
          doctors = doctors.where((doctor) {
            return doctor.languages.any(
              (doctorLang) => languages.any(
                (filterLang) =>
                    doctorLang.toLowerCase().contains(filterLang.toLowerCase()),
              ),
            );
          }).toList();
        }

        // Sort by rating
        doctors.sort((a, b) => b.rating.compareTo(a.rating));

        return doctors;
      } else {
        _showToast('Error filtering doctors: ${response.error}', isError: true);
        return [];
      }
    } catch (e) {
      debugPrint('Error filtering doctors: $e');
      _showToast('Error filtering doctors', isError: true);
      return [];
    }
  }

  /// Get top rated doctors
  static Future<List<Doctor>> getTopRatedDoctors({int limit = 10}) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.doctorsList}?available=true&minRating=4.0&limit=$limit&sortBy=rating',
      );

      if (response.isSuccess && response.data != null) {
        List<Doctor> doctors = (response.data as List<dynamic>)
            .map((data) => Doctor.fromMap(data))
            .toList();

        // Sort by rating and total consultations (client-side if backend doesn't support complex sorting)
        doctors.sort((a, b) {
          int ratingComparison = b.rating.compareTo(a.rating);
          if (ratingComparison != 0) return ratingComparison;
          return b.totalConsultations.compareTo(a.totalConsultations);
        });

        // Apply limit if backend doesn't support it
        return doctors.take(limit).toList();
      } else {
        _showToast(
          'Error loading top doctors: ${response.error}',
          isError: true,
        );
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching top rated doctors: $e');
      _showToast('Error loading top doctors', isError: true);
      return [];
    }
  }

  /// Create sample doctors for testing (for development only)
  static Future<void> createSampleDoctors() async {
    try {
      final sampleDoctors = [
        {
          'doctorId': 'dr_rajesh_kumar',
          'name': 'Dr. Rajesh Kumar',
          'email': 'rajesh.kumar@example.com',
          'password': 'password123', // This would be hashed by backend
          'phone': '+91-9876543210',
          'speciality': 'General Practitioner',
          'qualification': 'MBBS, MD',
          'experience': 8,
          'licenseNumber': 'DL-GP-12345',
          'consultationFee': 500.00,
          'languages': ['hi', 'en'],
          'rating': 4.5,
          'totalConsultations': 250,
          'isAvailable': true,
          'status': 'online',
        },
        {
          'doctorId': 'dr_priya_sharma',
          'name': 'Dr. Priya Sharma',
          'email': 'priya.sharma@example.com',
          'password': 'password123',
          'phone': '+91-9876543211',
          'speciality': 'Pediatrician',
          'qualification': 'MBBS, MD (Pediatrics)',
          'experience': 6,
          'licenseNumber': 'DL-PED-67890',
          'consultationFee': 600.00,
          'languages': ['hi', 'en', 'pa'],
          'rating': 4.7,
          'totalConsultations': 180,
          'isAvailable': true,
          'status': 'offline',
        },
        {
          'doctorId': 'dr_amit_singh',
          'name': 'Dr. Amit Singh',
          'email': 'amit.singh@example.com',
          'password': 'password123',
          'phone': '+91-9876543212',
          'speciality': 'Cardiologist',
          'qualification': 'MBBS, MD, DM (Cardiology)',
          'experience': 12,
          'licenseNumber': 'DL-CARD-54321',
          'consultationFee': 1000.00,
          'languages': ['hi', 'en'],
          'rating': 4.8,
          'totalConsultations': 320,
          'isAvailable': true,
          'status': 'online',
        },
        {
          'doctorId': 'dr_sneha_patel',
          'name': 'Dr. Sneha Patel',
          'email': 'sneha.patel@example.com',
          'password': 'password123',
          'phone': '+91-9876543213',
          'speciality': 'Dermatologist',
          'qualification': 'MBBS, MD (Dermatology)',
          'experience': 5,
          'licenseNumber': 'DL-DERM-98765',
          'consultationFee': 700.00,
          'languages': ['hi', 'en'],
          'rating': 4.4,
          'totalConsultations': 150,
          'isAvailable': true,
          'status': 'offline',
        },
        {
          'doctorId': 'dr_vikram_reddy',
          'name': 'Dr. Vikram Reddy',
          'email': 'vikram.reddy@example.com',
          'password': 'password123',
          'phone': '+91-9876543214',
          'speciality': 'Orthopedic',
          'qualification': 'MBBS, MS (Orthopedics)',
          'experience': 10,
          'licenseNumber': 'DL-ORTH-13579',
          'consultationFee': 800.00,
          'languages': ['hi', 'en'],
          'rating': 4.6,
          'totalConsultations': 200,
          'isAvailable': true,
          'status': 'online',
        },
      ];

      for (final doctorData in sampleDoctors) {
        final response = await _apiService.post(
          '${ApiConfig.baseUrl}/doctors/seed',
          body: doctorData,
        );

        if (!response.isSuccess) {
          debugPrint(
            'Failed to create doctor: ${doctorData['name']}, Error: ${response.error}',
          );
        }
      }

      debugPrint('✅ Sample doctors created successfully');
      _showToast('Sample doctors added successfully!', isError: false);
    } catch (e) {
      debugPrint('❌ Error creating sample doctors: $e');
      _showToast('Error creating sample doctors', isError: true);
    }
  }

  /// Show toast message
  static void _showToast(String message, {required bool isError}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError
          ? const Color(0xFFE53E3E)
          : const Color(0xFF38A169),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 16.0,
    );
  }
}

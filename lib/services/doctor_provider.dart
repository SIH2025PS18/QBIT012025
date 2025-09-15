import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/doctor.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

/// Provider class for managing doctors and queue functionality
class DoctorService extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  late IO.Socket _socket;

  List<Doctor> _allDoctors = [];
  List<Doctor> _onlineDoctors = [];
  Map<String, List<String>> _doctorQueues =
      {}; // doctorId -> list of patientIds

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Doctor> get allDoctors => _allDoctors;
  List<Doctor> get onlineDoctors => _onlineDoctors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize the service with real-time socket connection
  void initialize() {
    _initializeSocket();
    refreshDoctors();
  }

  /// Initialize socket connection for real-time updates
  void _initializeSocket() {
    try {
      _socket = IO.io(ApiConfig.baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      _socket.connect();

      _socket.on('connect', (_) {
        print('✅ Socket connected for doctor updates');
      });

      _socket.on('doctor_status_update', (data) {
        _handleDoctorStatusUpdate(data);
      });

      _socket.on('queue_update', (data) {
        _handleQueueUpdate(data);
      });

      _socket.on('disconnect', (_) {
        print('❌ Socket disconnected');
      });
    } catch (e) {
      print('Socket initialization error: $e');
    }
  }

  /// Handle doctor status updates from socket
  void _handleDoctorStatusUpdate(dynamic data) {
    try {
      final doctorId = data['doctorId'];
      final status = data['status'];

      // Update doctor status in our lists
      for (int i = 0; i < _allDoctors.length; i++) {
        if (_allDoctors[i].id == doctorId) {
          _allDoctors[i] = _allDoctors[i].copyWith(status: status);
          break;
        }
      }

      // Refresh online doctors list
      _onlineDoctors = _allDoctors
          .where((doctor) => doctor.status == 'online')
          .toList();

      notifyListeners();
      print('✅ Doctor $doctorId status updated to $status');
    } catch (e) {
      print('Error handling doctor status update: $e');
    }
  }

  /// Handle queue updates from socket
  void _handleQueueUpdate(dynamic data) {
    try {
      final doctorId = data['doctorId'];
      final queue = List<String>.from(data['queue'] ?? []);

      _doctorQueues[doctorId] = queue;
      notifyListeners();
      print('✅ Queue updated for doctor $doctorId: ${queue.length} patients');
    } catch (e) {
      print('Error handling queue update: $e');
    }
  }

  /// Refresh doctors list from API
  Future<void> refreshDoctors() async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _apiService.get(ApiConfig.doctorsAvailable);

      if (response.isSuccess && response.data != null) {
        final List<dynamic> doctorsData = response.data as List<dynamic>;
        _allDoctors = doctorsData.map((data) => Doctor.fromMap(data)).toList();
        _onlineDoctors = _allDoctors
            .where((doctor) => doctor.status == 'online')
            .toList();

        print(
          '✅ Refreshed ${_allDoctors.length} doctors, ${_onlineDoctors.length} online',
        );
      } else {
        _error = 'Failed to load doctors: ${response.error}';
        print('❌ Error loading doctors: ${response.error}');
      }
    } catch (e) {
      _error = 'Error loading doctors: $e';
      print('❌ Exception loading doctors: $e');
    }

    _setLoading(false);
  }

  /// Search doctors by speciality
  Future<List<Doctor>> searchDoctorsBySpeciality(String speciality) async {
    try {
      if (speciality.isEmpty || speciality == 'All') {
        return _onlineDoctors;
      }

      return _onlineDoctors
          .where(
            (doctor) => doctor.speciality.toLowerCase().contains(
              speciality.toLowerCase(),
            ),
          )
          .toList();
    } catch (e) {
      print('Error searching doctors by speciality: $e');
      return [];
    }
  }

  /// Get online doctors
  List<Doctor> getOnlineDoctors() {
    return _onlineDoctors;
  }

  /// Get queue for a specific doctor
  List<String> getDoctorQueue(String doctorId) {
    return _doctorQueues[doctorId] ?? [];
  }

  /// Join doctor queue
  Future<Map<String, dynamic>> joinDoctorQueue(
    String doctorId,
    String patientId, {
    String? symptoms,
  }) async {
    try {
      final authService = AuthService();
      if (!authService.isAuthenticated) {
        return {'success': false, 'error': 'Not authenticated'};
      }

      // For demo purposes, simulate queue joining
      // In a real app, this would call the backend API
      final currentQueue = getDoctorQueue(doctorId);
      final newQueue = [...currentQueue, patientId];
      _doctorQueues[doctorId] = newQueue;

      final position = newQueue.indexOf(patientId) + 1;

      // Simulate socket update - send more patient data
      _socket.emit('join_queue', {
        'doctorId': doctorId,
        'patientId': patientId,
        'patientName': authService.currentUser?.name ?? 'Unknown Patient',
        'symptoms': symptoms ?? 'No symptoms provided',
        'timestamp': DateTime.now().toIso8601String(),
      });

      notifyListeners();

      print(
        '✅ Patient $patientId joined queue for doctor $doctorId at position $position',
      );

      return {
        'success': true,
        'position': position,
        'queueLength': newQueue.length,
        'estimatedWaitTime': position * 10, // 10 minutes per position
      };
    } catch (e) {
      print('Error joining queue: $e');
      return {'success': false, 'error': 'Failed to join queue'};
    }
  }

  /// Leave doctor queue
  Future<bool> leaveDoctorQueue(String doctorId, String patientId) async {
    try {
      final currentQueue = getDoctorQueue(doctorId);
      currentQueue.remove(patientId);
      _doctorQueues[doctorId] = currentQueue;

      _socket.emit('leave_queue', {
        'doctorId': doctorId,
        'patientId': patientId,
      });

      notifyListeners();
      return true;
    } catch (e) {
      print('Error leaving queue: $e');
      return false;
    }
  }

  /// Check if patient is in queue
  bool isPatientInQueue(String doctorId, String patientId) {
    final queue = getDoctorQueue(doctorId);
    return queue.contains(patientId);
  }

  /// Get patient position in queue
  int getPatientPosition(String doctorId, String patientId) {
    final queue = getDoctorQueue(doctorId);
    final index = queue.indexOf(patientId);
    return index == -1 ? -1 : index + 1;
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/models.dart';

class DoctorProvider with ChangeNotifier {
  Doctor? _currentDoctor;
  List<Patient> _patientQueue = [];
  bool _isLoading = false;
  int _todaysCallsCount = 0;
  String? _authToken;

  // Backend API URL
  static const String _baseUrl = 'https://telemed18.onrender.com/api';

  Doctor? get currentDoctor => _currentDoctor;
  List<Patient> get patientQueue => _patientQueue;
  bool get isLoading => _isLoading;
  int get todaysCallsCount => _todaysCallsCount;
  int get waitingPatientsCount => _patientQueue.length;
  String? get authToken => _authToken;

  // Real login with backend
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'userType': 'doctor',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _authToken = data['token'];
          _currentDoctor = Doctor.fromJson(data['doctor']);

          // Load doctor's queue and today's calls
          await _loadDoctorData();

          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Load doctor's queue and statistics
  Future<void> _loadDoctorData() async {
    if (_currentDoctor == null || _authToken == null) return;

    try {
      // Get doctor's queue
      final queueResponse = await http.get(
        Uri.parse('$_baseUrl/doctors/${_currentDoctor!.id}/queue'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (queueResponse.statusCode == 200) {
        final queueData = json.decode(queueResponse.body);
        if (queueData['success']) {
          _patientQueue = (queueData['queue'] as List)
              .map((patient) => Patient.fromJson(patient))
              .toList();
        }
      }

      // Get today's consultation count
      final statsResponse = await http.get(
        Uri.parse('$_baseUrl/doctors/${_currentDoctor!.id}/stats/today'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (statsResponse.statusCode == 200) {
        final statsData = json.decode(statsResponse.body);
        if (statsData['success']) {
          _todaysCallsCount = statsData['todayConsultations'] ?? 0;
        }
      }

      notifyListeners();
    } catch (e) {
      print('Error loading doctor data: $e');
    }
  }

  // Refresh queue from backend
  Future<void> refreshQueue() async {
    await _loadDoctorData();
  }

  // Update doctor availability status
  Future<void> updateAvailability(bool isAvailable) async {
    if (_currentDoctor == null || _authToken == null) return;

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/doctors/${_currentDoctor!.id}/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode({
          'isAvailable': isAvailable,
          'status': isAvailable ? 'online' : 'offline',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _currentDoctor = Doctor.fromJson(data['doctor']);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error updating availability: $e');
    }
  }

  void setCurrentDoctor(Doctor doctor) {
    _currentDoctor = doctor;
    notifyListeners();
  }

  void setPatientQueue(List<Patient> patients) {
    _patientQueue = patients;
    notifyListeners();
  }

  void addPatientToQueue(Patient patient) {
    _patientQueue.add(patient);
    notifyListeners();
  }

  void removePatientFromQueue(String patientId) {
    _patientQueue.removeWhere((patient) => patient.id == patientId);
    notifyListeners();

    // Also update backend
    _removePatientFromBackend(patientId);
  }

  void updatePatientStatus(String patientId, String status) {
    final index = _patientQueue.indexWhere(
      (patient) => patient.id == patientId,
    );
    if (index != -1) {
      // Create new patient with updated status
      final patient = _patientQueue[index];
      _patientQueue[index] = Patient(
        id: patient.id,
        name: patient.name,
        profileImage: patient.profileImage,
        age: patient.age,
        gender: patient.gender,
        phone: patient.phone,
        email: patient.email,
        symptoms: patient.symptoms,
        appointmentTime: patient.appointmentTime,
        status: status,
      );
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void logout() {
    _currentDoctor = null;
    _patientQueue.clear();
    _todaysCallsCount = 0;
    _authToken = null;
    notifyListeners();
  }

  void incrementTodaysCallsCount() {
    _todaysCallsCount++;
    notifyListeners();
  }

  Future<void> _removePatientFromBackend(String patientId) async {
    if (_authToken == null) return;

    try {
      await http.delete(
        Uri.parse('$_baseUrl/queue/$patientId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );
    } catch (e) {
      print('Error removing patient from queue: $e');
    }
  }

  // Remove mock data - we now use real data from backend
}

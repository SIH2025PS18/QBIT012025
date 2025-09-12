import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor.dart';
import '../models/patient.dart';
import '../models/dashboard_stats.dart';
import 'websocket_service.dart';
import 'auth_service.dart';

class AdminService {
  static const String baseUrl = 'https://telemed18.onrender.com/api';
  final WebSocketService _webSocketService = WebSocketService();
  final AuthService _authService = AuthService();

  // Singleton pattern
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  Map<String, String> get _headers => _authService.authHeaders;

  // Helper method to create doctor authentication credentials
  Future<bool> _createDoctorAuth(String email, String password) async {
    try {
      // Try different endpoints for creating doctor authentication
      final endpoints = [
        '$baseUrl/auth/doctor/register',
        '$baseUrl/auth/register',
        '$baseUrl/users',
      ];

      for (String endpoint in endpoints) {
        try {
          final response = await http.post(
            Uri.parse(endpoint),
            headers: _headers,
            body: json.encode({
              'email': email,
              'loginId': email,
              'password': password,
              'userType': 'doctor',
            }),
          );

          print('Auth creation attempt at $endpoint: ${response.statusCode}');
          if (response.statusCode == 200 || response.statusCode == 201) {
            print('✅ Auth created successfully at $endpoint');
            return true;
          }
        } catch (e) {
          print('❌ Auth creation failed at $endpoint: $e');
          continue;
        }
      }
      return false;
    } catch (e) {
      print('Error creating doctor auth: $e');
      return false;
    }
  }

  // Dashboard Statistics
  Future<DashboardStats> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/dashboard/stats'),
        headers: _headers,
      );

      print('Dashboard Stats Response: ${response.statusCode}');
      print('Dashboard Stats Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return DashboardStats.fromJson(data['data']);
        }
      }

      // If API fails, return error instead of mock data
      throw Exception('Failed to load dashboard stats');
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      rethrow;
    }
  }

  // Doctor Management
  Future<List<Doctor>> getAllDoctors() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doctors'),
        headers: _headers,
      );

      print('Get Doctors Response: ${response.statusCode}');
      print('Get Doctors Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((doctor) => Doctor.fromJson(doctor))
              .toList();
        }
      }

      // If API fails, return error instead of mock data
      throw Exception('Failed to load doctors');
    } catch (e) {
      print('Error fetching doctors: $e');
      rethrow;
    }
  }

  Future<Doctor?> getDoctorById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doctors/$id'),
        headers: _headers,
      );

      print('Get Doctor Response: ${response.statusCode}');
      print('Get Doctor Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Doctor.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching doctor: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createDoctorWithCredentials(
      Doctor doctor, String password) async {
    try {
      // Create clean doctor data for creation - only send necessary fields
      final doctorData = <String, dynamic>{
        'name': doctor.name,
        'email': doctor.email,
        'phone': doctor.phone,
        'speciality': doctor.speciality,
        'qualification': doctor.qualification,
        'experience': doctor.experience,
        'licenseNumber': doctor.licenseNumber,
        'consultationFee': doctor.consultationFee,
        'isAvailable': doctor.isAvailable,
        'languages': doctor.languages,
        'isVerified': doctor.isVerified,
      };

      // Only add optional fields if they have values
      if (doctor.address != null) doctorData['address'] = doctor.address!;
      if (doctor.workingHours != null)
        doctorData['workingHours'] = doctor.workingHours!;

      final response = await http.post(
        Uri.parse('$baseUrl/doctors'),
        headers: _headers,
        body: json.encode(doctorData),
      );

      print('Create Doctor Response: ${response.statusCode}');
      print('Create Doctor Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final newDoctor =
              data['data'] != null ? Doctor.fromJson(data['data']) : doctor;

          // Try to create authentication credentials separately
          bool authCreated = await _createDoctorAuth(newDoctor.email, password);

          // Notify WebSocket about new doctor
          _webSocketService.notifyDoctorAdded(newDoctor);

          // Return the doctor data with credentials
          return {
            'doctor': newDoctor,
            'email': newDoctor.email,
            'password': password, // Use the password we sent
            'doctorId': newDoctor.doctorId,
            'authCreated': authCreated,
            'loginInstructions': authCreated
                ? 'Use email and password to login to the doctor dashboard'
                : 'Doctor created successfully. Authentication setup may require backend configuration.',
          };
        }
      }
      return null;
    } catch (e) {
      print('Error creating doctor: $e');
      return null;
    }
  }

  Future<bool> createDoctor(Doctor doctor) async {
    try {
      final doctorData = doctor.toJson();
      doctorData.remove('id'); // Remove ID for creation

      final response = await http.post(
        Uri.parse('$baseUrl/doctors'),
        headers: _headers,
        body: json.encode(doctorData),
      );

      print('Create Doctor Response: ${response.statusCode}');
      print('Create Doctor Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Notify WebSocket about new doctor
          final newDoctor =
              data['data'] != null ? Doctor.fromJson(data['data']) : doctor;
          _webSocketService.notifyDoctorAdded(newDoctor);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error creating doctor: $e');
      return false;
    }
  }

  Future<bool> updateDoctor(String id, Doctor doctor) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/doctors/$id'),
        headers: _headers,
        body: json.encode(doctor.toJson()),
      );

      print('Update Doctor Response: ${response.statusCode}');
      print('Update Doctor Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Notify WebSocket about updated doctor
          _webSocketService.notifyDoctorUpdated(doctor);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error updating doctor: $e');
      return false;
    }
  }

  Future<bool> deleteDoctor(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/doctors/$id'),
        headers: _headers,
      );

      print('Delete Doctor Response: ${response.statusCode}');
      print('Delete Doctor Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Notify WebSocket about deleted doctor
          _webSocketService.notifyDoctorDeleted(id);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting doctor: $e');
      return false;
    }
  }

  Future<bool> updateDoctorAvailability(String id, bool isAvailable) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/doctors/$id/availability'),
        headers: _headers,
        body: json.encode({'is_available': isAvailable}),
      );

      print('Update Availability Response: ${response.statusCode}');
      print('Update Availability Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Notify WebSocket about availability change
          _webSocketService.notifyDoctorAvailabilityChanged(id, isAvailable);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error updating doctor availability: $e');
      return false;
    }
  }

  // Search and Filter
  Future<List<Doctor>> searchDoctors(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doctors/search?q=$query'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((doctor) => Doctor.fromJson(doctor))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching doctors: $e');
      return [];
    }
  }

  // Get doctors by speciality (replaces department functionality)
  Future<List<Doctor>> getDoctorsBySpeciality(String speciality) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doctors?speciality=$speciality'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((doctor) => Doctor.fromJson(doctor))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching doctors by speciality: $e');
      return [];
    }
  }

  // Patient Management
  Future<List<Patient>> getAllPatients() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients'),
        headers: _headers,
      );

      print('Get Patients Response: ${response.statusCode}');
      print('Get Patients Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((patient) => Patient.fromJson(patient))
              .toList();
        }
      }

      // If API fails, return error instead of mock data
      throw Exception('Failed to load patients');
    } catch (e) {
      print('Error fetching patients: $e');
      rethrow;
    }
  }

  Future<Patient?> getPatientById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$id'),
        headers: _headers,
      );

      print('Get Patient Response: ${response.statusCode}');
      print('Get Patient Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Patient.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching patient: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createPatientWithCredentials(
      Patient patient, String password) async {
    try {
      final patientData = patient.toJson();
      patientData.remove('id'); // Remove ID for creation
      patientData['password'] = password; // Add password for login
      patientData['userType'] = 'patient'; // Specify user type

      final response = await http.post(
        Uri.parse('$baseUrl/auth/patient/register-mobile'),
        headers: _headers,
        body: json.encode(patientData),
      );

      print('Create Patient Response: ${response.statusCode}');
      print('Create Patient Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final newPatient = data['patient'] != null
              ? Patient.fromJson(data['patient'])
              : patient;

          // Return the patient data with credentials
          return {
            'patient': newPatient,
            'phone': patient.phone,
            'password': password,
            'patientId': data['patientId'] ?? newPatient.id,
          };
        }
      }
      return null;
    } catch (e) {
      print('Error creating patient: $e');
      return null;
    }
  }

  Future<bool> updatePatient(String id, Patient patient) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/patients/$id'),
        headers: _headers,
        body: json.encode(patient.toJson()),
      );

      print('Update Patient Response: ${response.statusCode}');
      print('Update Patient Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error updating patient: $e');
      return false;
    }
  }

  Future<bool> deletePatient(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/patients/$id'),
        headers: _headers,
      );

      print('Delete Patient Response: ${response.statusCode}');
      print('Delete Patient Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting patient: $e');
      return false;
    }
  }

  Future<List<Patient>> searchPatients(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients?search=$query'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((patient) => Patient.fromJson(patient))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching patients: $e');
      return [];
    }
  }
}

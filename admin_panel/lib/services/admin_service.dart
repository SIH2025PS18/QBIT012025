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
        return DashboardStats.fromJson(data);
      } else {
        // Return mock data for now
        return _getMockDashboardStats();
      }
    } catch (e) {
      print('Error fetching dashboard stats: $e');
      return _getMockDashboardStats();
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

      // Return mock data if API fails
      return _getMockDoctors();
    } catch (e) {
      print('Error fetching doctors: $e');
      return _getMockDoctors();
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
      final doctorData = doctor.toJson();
      doctorData.remove('id'); // Remove ID for creation
      // Note: We don't add password here since the /api/doctors endpoint
      // will generate a default password

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

          // Return the doctor data with credentials
          return {
            'doctor': newDoctor,
            'email': doctor.email,
            'password': data['defaultPassword'] ??
                'doctor123', // Use backend-provided password
            'doctorId': newDoctor.doctorId,
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

      // Return mock data if API fails
      return _getMockPatients();
    } catch (e) {
      print('Error fetching patients: $e');
      return _getMockPatients();
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

  // Mock Data Methods
  DashboardStats _getMockDashboardStats() {
    return DashboardStats(
      totalDoctors: 45,
      totalPatients: 1250,
      totalAppointments: 890,
      activeAppointments: 28,
      totalDepartments: 8,
      appointmentsByMonth: [
        ChartData(label: 'Jan', value: 650),
        ChartData(label: 'Feb', value: 720),
        ChartData(label: 'Mar', value: 780),
        ChartData(label: 'Apr', value: 820),
        ChartData(label: 'May', value: 890),
      ],
      doctorsBySpecialty: [
        ChartData(label: 'Cardiology', value: 12),
        ChartData(label: 'Neurology', value: 8),
        ChartData(label: 'Pediatrics', value: 10),
        ChartData(label: 'Dermatology', value: 6),
        ChartData(label: 'Orthopedics', value: 9),
      ],
      // Additional fields for backward compatibility
      todayAppointments: 28,
      pendingAppointments: 15,
      completedAppointments: 775,
      cancelledAppointments: 100,
      revenue: 125000.0,
      monthlyGrowth: 12.5,
      appointmentChart: [
        ChartData(label: 'Mon', value: 25),
        ChartData(label: 'Tue', value: 30),
        ChartData(label: 'Wed', value: 28),
        ChartData(label: 'Thu', value: 35),
        ChartData(label: 'Fri', value: 32),
        ChartData(label: 'Sat', value: 20),
        ChartData(label: 'Sun', value: 15),
      ],
      revenueChart: [
        ChartData(label: 'Jan', value: 85000),
        ChartData(label: 'Feb', value: 92000),
        ChartData(label: 'Mar', value: 105000),
        ChartData(label: 'Apr', value: 118000),
        ChartData(label: 'May', value: 125000),
      ],
    );
  }

  List<Doctor> _getMockDoctors() {
    return [
      Doctor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        email: 'sarah.johnson@hospital.com',
        phone: '+1234567890',
        speciality: 'Cardiologist',
        qualification: 'MD, FACC',
        experience: 8,
        licenseNumber: 'LIC001',
        consultationFee: 800.0,
        rating: 4.8,
        totalConsultations: 150,
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      Doctor(
        id: '2',
        name: 'Dr. Michael Chen',
        email: 'michael.chen@hospital.com',
        phone: '+1234567891',
        speciality: 'Neurologist',
        qualification: 'MD, PhD',
        experience: 12,
        licenseNumber: 'LIC002',
        consultationFee: 900.0,
        rating: 4.9,
        totalConsultations: 200,
        isAvailable: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1825)),
      ),
      Doctor(
        id: '3',
        name: 'Dr. Emily Rodriguez',
        email: 'emily.rodriguez@hospital.com',
        phone: '+1234567892',
        speciality: 'Pediatrician',
        qualification: 'MD, FAAP',
        experience: 6,
        licenseNumber: 'LIC003',
        consultationFee: 600.0,
        rating: 4.7,
        totalConsultations: 120,
        isAvailable: false,
        createdAt: DateTime.now().subtract(const Duration(days: 730)),
      ),
    ];
  }

  List<Patient> _getMockPatients() {
    return [
      Patient(
        id: '1',
        name: 'John Smith',
        email: 'john.smith@email.com',
        phone: '+1234567890',
        age: 35,
        gender: 'male',
        patientId: 'PAT001',
        address: '123 Main Street, City',
        emergencyContact: '+1234567891',
        medicalHistory: 'Hypertension, Diabetes',
        allergies: ['Penicillin', 'Nuts'],
        bloodGroup: 'O+',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastVisit: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
        medications: ['Metformin', 'Lisinopril'],
        medicalRecords: ['Blood Test - Normal', 'X-Ray - Clear'],
      ),
      Patient(
        id: '2',
        name: 'Sarah Johnson',
        email: 'sarah.johnson@email.com',
        phone: '+1234567892',
        age: 28,
        gender: 'female',
        patientId: 'PAT002',
        address: '456 Oak Avenue, Town',
        emergencyContact: '+1234567893',
        medicalHistory: 'Asthma',
        allergies: ['Dust'],
        bloodGroup: 'A+',
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        lastVisit: DateTime.now().subtract(const Duration(days: 15)),
        isActive: true,
        medications: ['Inhaler'],
        medicalRecords: ['Lung Function Test - Normal'],
      ),
      Patient(
        id: '3',
        name: 'Michael Brown',
        email: 'michael.brown@email.com',
        phone: '+1234567894',
        age: 42,
        gender: 'male',
        patientId: 'PAT003',
        address: '789 Pine Street, Village',
        emergencyContact: '+1234567895',
        medicalHistory: 'Heart Disease',
        allergies: ['Latex'],
        bloodGroup: 'B-',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        lastVisit: DateTime.now().subtract(const Duration(days: 7)),
        isActive: true,
        medications: ['Aspirin', 'Statin'],
        medicalRecords: ['ECG - Abnormal', 'Echo - Mild LVH'],
      ),
    ];
  }
}

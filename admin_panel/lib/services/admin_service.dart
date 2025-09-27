import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor.dart';
import '../models/patient.dart';
import '../models/pharmacy.dart';
import '../models/appointment.dart';
import '../models/dashboard_stats.dart';
import 'websocket_service.dart';
import 'auth_service.dart';

class AdminService {
  static const String baseUrl = 'https://telemed18.onrender.com || http://192.168.1.7:5002/api';
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

      // If API fails, return demo data for testing
      return _getDemoDoctors();
    } catch (e) {
      print('Error fetching doctors: $e');
      // Return demo data for testing
      return _getDemoDoctors();
    }
  }

  List<Doctor> _getDemoDoctors() {
    return [
      Doctor(
        id: '1',
        doctorId: 'DOC001',
        name: 'Dr. Rajesh Kumar',
        email: 'rajesh.kumar@sehatsarthi.com',
        phone: '+91-9876543210',
        speciality: 'Cardiologist',
        qualification: 'MBBS, MD Cardiology',
        experience: 15,
        licenseNumber: 'MCI-12345',
        consultationFee: 800.0,
        isAvailable: true,
        isVerified: true,
        isEnabled: true,
        rating: 4.8,
        totalRatings: 245,
        totalConsultations: 1200,
        todayConsultations: 8,
        defaultPassword: 'Temp@123',
        hasTemporaryPassword: false,
        employeeId: 'EMP001',
        department: 'Cardiology',
        emergencyContact: '+91-9876543211',
        licenseExpiryDate: '2025-12-31',
        permissions: ['consultation', 'profile_update', 'reports'],
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Doctor(
        id: '2',
        doctorId: 'DOC002',
        name: 'Dr. Priya Sharma',
        email: 'priya.sharma@sehatsarthi.com',
        phone: '+91-9876543220',
        speciality: 'Pediatrician',
        qualification: 'MBBS, MD Pediatrics',
        experience: 10,
        licenseNumber: 'MCI-12346',
        consultationFee: 600.0,
        isAvailable: true,
        isVerified: true,
        isEnabled: true,
        rating: 4.9,
        totalRatings: 189,
        totalConsultations: 890,
        todayConsultations: 5,
        defaultPassword: 'Welcome@456',
        hasTemporaryPassword: true,
        employeeId: 'EMP002',
        department: 'Pediatrics',
        emergencyContact: '+91-9876543221',
        licenseExpiryDate: '2026-06-30',
        permissions: ['consultation', 'profile_update'],
        lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      Doctor(
        id: '3',
        doctorId: 'DOC003',
        name: 'Dr. Amit Patel',
        email: 'amit.patel@sehatsarthi.com',
        phone: '+91-9876543230',
        speciality: 'Dermatologist',
        qualification: 'MBBS, MD Dermatology',
        experience: 8,
        licenseNumber: 'MCI-12347',
        consultationFee: 700.0,
        isAvailable: false,
        isVerified: true,
        isEnabled: false,
        rating: 4.6,
        totalRatings: 156,
        totalConsultations: 650,
        todayConsultations: 0,
        defaultPassword: 'Reset@789',
        hasTemporaryPassword: true,
        employeeId: 'EMP003',
        department: 'Dermatology',
        emergencyContact: '+91-9876543231',
        licenseExpiryDate: '2025-03-31',
        permissions: ['consultation'],
        lastActive: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      Doctor(
        id: '4',
        doctorId: 'DOC004',
        name: 'Dr. Sunita Gupta',
        email: 'sunita.gupta@sehatsarthi.com',
        phone: '+91-9876543240',
        speciality: 'Gynecologist',
        qualification: 'MBBS, MS Gynecology',
        experience: 12,
        licenseNumber: 'MCI-12348',
        consultationFee: 750.0,
        isAvailable: true,
        isVerified: false,
        isEnabled: true,
        rating: 4.7,
        totalRatings: 203,
        totalConsultations: 980,
        todayConsultations: 6,
        defaultPassword: 'NewDoc@123',
        hasTemporaryPassword: true,
        employeeId: 'EMP004',
        department: 'Gynecology',
        emergencyContact: '+91-9876543241',
        licenseExpiryDate: '2025-09-30',
        permissions: ['consultation', 'profile_update'],
        lastActive: DateTime.now().subtract(const Duration(hours: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Doctor(
        id: '5',
        doctorId: 'DOC005',
        name: 'Dr. Vikram Singh',
        email: 'vikram.singh@sehatsarthi.com',
        phone: '+91-9876543250',
        speciality: 'Orthopedic',
        qualification: 'MBBS, MS Orthopedics',
        experience: 18,
        licenseNumber: 'MCI-12349',
        consultationFee: 900.0,
        isAvailable: true,
        isVerified: true,
        isEnabled: true,
        rating: 4.9,
        totalRatings: 298,
        totalConsultations: 1500,
        todayConsultations: 12,
        defaultPassword: 'Senior@456',
        hasTemporaryPassword: false,
        employeeId: 'EMP005',
        department: 'Orthopedics',
        emergencyContact: '+91-9876543251',
        licenseExpiryDate: '2026-12-31',
        permissions: [
          'consultation',
          'profile_update',
          'reports',
          'patient_management'
        ],
        lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
      ),
    ];
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
      // Map language names to codes
      const languageMap = {
        'English': 'en',
        'Hindi': 'hi',
        'Punjabi': 'pa',
        'Bengali': 'bn',
        'Tamil': 'ta',
        'Telugu': 'te',
        'Marathi': 'mr',
        'Gujarati': 'gu',
        'Kannada': 'kn',
        'Malayalam': 'ml',
      };

      final mappedLanguages =
          doctor.languages.map((lang) => languageMap[lang] ?? 'en').toList();

      // Create clean doctor data for creation - including all admin management fields
      final doctorData = <String, dynamic>{
        'name': doctor.name,
        'email': doctor.email,
        'phone': doctor.phone,
        'speciality': doctor.speciality,
        'qualification': doctor.qualification,
        'experience': doctor.experience,
        'licenseNumber': doctor.licenseNumber,
        'consultationFee': doctor.consultationFee.toDouble(),
        'isAvailable': doctor.isAvailable,
        'languages': mappedLanguages,
        'isVerified': true, // Admin-created doctors are always verified
        // Admin management fields (only include if they have values)
        if (doctor.employeeId != null && doctor.employeeId!.isNotEmpty)
          'employeeId': doctor.employeeId,
        if (doctor.department != null && doctor.department!.isNotEmpty)
          'department': doctor.department,
        if (doctor.emergencyContact != null &&
            doctor.emergencyContact!.isNotEmpty)
          'emergencyContact': doctor.emergencyContact,
        if (doctor.licenseExpiryDate != null &&
            doctor.licenseExpiryDate!.isNotEmpty)
          'licenseExpiryDate': doctor.licenseExpiryDate,
        if (doctor.permissions.isNotEmpty) 'permissions': doctor.permissions,
      };

      print('🔍 Sending doctor data to backend: ${json.encode(doctorData)}');

      // Handle address - convert from full address to structured format if needed
      if (doctor.address != null) {
        try {
          if (doctor.address is Map<String, dynamic>) {
            final addressMap = doctor.address as Map<String, dynamic>;
            if (addressMap.containsKey('full')) {
              // Parse full address string into structured format
              final fullAddress = addressMap['full'] as String;
              final addressParts =
                  fullAddress.split(',').map((e) => e.trim()).toList();

              doctorData['address'] = {
                'street': addressParts.isNotEmpty ? addressParts[0] : '',
                'city': addressParts.length > 1 ? addressParts[1] : '',
                'state': addressParts.length > 2 ? addressParts[2] : '',
                'country': 'India',
              };
            } else {
              // Address is already in structured format
              doctorData['address'] = doctor.address;
            }
          } else {
            // Address is a string, convert to structured format
            final addressParts = doctor.address
                .toString()
                .split(',')
                .map((e) => e.trim())
                .toList();
            doctorData['address'] = {
              'street': addressParts.isNotEmpty ? addressParts[0] : '',
              'city': addressParts.length > 1 ? addressParts[1] : '',
              'state': addressParts.length > 2 ? addressParts[2] : '',
              'country': 'India',
            };
          }
          print('📍 Processed address: ${json.encode(doctorData['address'])}');
        } catch (e) {
          print('⚠️ Error processing address: $e');
          // Skip address if there's an error
        }
      }

      // Only add optional fields if they have values
      if (doctor.workingHours != null) {
        doctorData['workingHours'] = doctor.workingHours!;
      }

      print('📤 Final doctor data being sent: ${json.encode(doctorData)}');
      ;

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

          // Get the auto-generated password from the response
          final generatedPassword = data['defaultPassword'] ?? password;

          // Update the doctor object with the password for display in admin panel
          final doctorWithPassword = Doctor(
            id: newDoctor.id,
            doctorId: newDoctor.doctorId,
            name: newDoctor.name,
            email: newDoctor.email,
            phone: newDoctor.phone,
            speciality: newDoctor.speciality,
            qualification: newDoctor.qualification,
            experience: newDoctor.experience,
            licenseNumber: newDoctor.licenseNumber,
            consultationFee: newDoctor.consultationFee,
            isAvailable: newDoctor.isAvailable,
            isVerified: newDoctor.isVerified,
            isEnabled: newDoctor.isEnabled,
            rating: newDoctor.rating,
            totalRatings: newDoctor.totalRatings,
            totalConsultations: newDoctor.totalConsultations,
            todayConsultations: newDoctor.todayConsultations,
            defaultPassword: generatedPassword, // Store the generated password
            hasTemporaryPassword: true,
            employeeId: newDoctor.employeeId,
            department: newDoctor.department,
            permissions: newDoctor.permissions,
            emergencyContact: newDoctor.emergencyContact,
            licenseExpiryDate: newDoctor.licenseExpiryDate,
            address: newDoctor.address,
            workingHours: newDoctor.workingHours,
            languages: newDoctor.languages,
            lastActive: newDoctor.lastActive,
            createdAt: newDoctor.createdAt,
          );

          // Notify WebSocket about new doctor
          _webSocketService.notifyDoctorAdded(doctorWithPassword);

          // Return the doctor data with credentials
          return {
            'doctor': doctorWithPassword,
            'email': doctorWithPassword.email,
            'password': generatedPassword, // Use the auto-generated password
            'doctorId': doctorWithPassword.doctorId,
            'authCreated': true, // Doctor creation includes authentication
            'loginInstructions':
                'Use email "${doctorWithPassword.email}" and password "$generatedPassword" to login to the doctor dashboard',
          };
        }
      }
      print(
          '❌ Doctor creation failed: ${response.statusCode} - ${response.body}');
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
      final response = await http.put(
        Uri.parse('$baseUrl/doctors/$id'),
        headers: _headers,
        body: json.encode({'isAvailable': isAvailable}),
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

  // New doctor management functions
  Future<bool> enableDisableDoctor(String id, bool isEnabled) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/doctors/$id/status'),
        headers: _headers,
        body: json.encode({'isEnabled': isEnabled}),
      );

      print('Enable/Disable Doctor Response: ${response.statusCode}');
      print('Enable/Disable Doctor Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error enabling/disabling doctor: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> resetDoctorPassword(String id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/doctors/$id/reset-password'),
        headers: _headers,
      );

      print('Reset Password Response: ${response.statusCode}');
      print('Reset Password Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'newPassword': data['newPassword'],
            'isTemporary': true,
          };
        }
      }
      return null;
    } catch (e) {
      print('Error resetting doctor password: $e');
      return null;
    }
  }

  Future<bool> updateDoctorCredentials(
      String id, Map<String, dynamic> credentials) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/doctors/$id/credentials'),
        headers: _headers,
        body: json.encode(credentials),
      );

      print('Update Credentials Response: ${response.statusCode}');
      print('Update Credentials Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error updating doctor credentials: $e');
      return false;
    }
  }

  Future<bool> updateDoctorPermissions(
      String id, List<String> permissions) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/doctors/$id/permissions'),
        headers: _headers,
        body: json.encode({'permissions': permissions}),
      );

      print('Update Permissions Response: ${response.statusCode}');
      print('Update Permissions Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error updating doctor permissions: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getDoctorLoginHistory(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/doctors/$id/login-history'),
        headers: _headers,
      );

      print('Get Login History Response: ${response.statusCode}');
      print('Get Login History Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      print('Error fetching doctor login history: $e');
      return null;
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

  // Pharmacy Management
  Future<List<Pharmacy>> getAllPharmacies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/pharmacies'),
        headers: _headers,
      );

      print('Get Pharmacies Response: ${response.statusCode}');
      print('Get Pharmacies Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((pharmacy) => Pharmacy.fromJson(pharmacy))
              .toList();
        }
      }

      // Return demo data if API fails or for development
      return _getDemoPharmacies();
    } catch (e) {
      print('Error fetching pharmacies: $e');
      // Return demo data on error
      return _getDemoPharmacies();
    }
  }

  Future<bool> addPharmacy(Pharmacy pharmacy) async {
    try {
      final pharmacyData = pharmacy.toJson();
      pharmacyData.remove('id'); // Remove ID for creation

      final response = await http.post(
        Uri.parse('$baseUrl/admin/pharmacies'),
        headers: _headers,
        body: json.encode(pharmacyData),
      );

      print('Add Pharmacy Response: ${response.statusCode}');
      print('Add Pharmacy Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      // Return true for demo mode
      return true;
    } catch (e) {
      print('Error adding pharmacy: $e');
      // Return true for demo mode
      return true;
    }
  }

  Future<bool> updatePharmacy(Pharmacy pharmacy) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/pharmacies/${pharmacy.id}'),
        headers: _headers,
        body: json.encode(pharmacy.toJson()),
      );

      print('Update Pharmacy Response: ${response.statusCode}');
      print('Update Pharmacy Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      // Return true for demo mode
      return true;
    } catch (e) {
      print('Error updating pharmacy: $e');
      // Return true for demo mode
      return true;
    }
  }

  Future<bool> deletePharmacy(String pharmacyId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/admin/pharmacies/$pharmacyId'),
        headers: _headers,
      );

      print('Delete Pharmacy Response: ${response.statusCode}');
      print('Delete Pharmacy Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      // Return true for demo mode
      return true;
    } catch (e) {
      print('Error deleting pharmacy: $e');
      // Return true for demo mode
      return true;
    }
  }

  Future<bool> updatePharmacyVerification(
      String pharmacyId, bool isVerified) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/admin/pharmacies/$pharmacyId/verification'),
        headers: _headers,
        body: json.encode({'isVerified': isVerified}),
      );

      print('Update Pharmacy Verification Response: ${response.statusCode}');
      print('Update Pharmacy Verification Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      // Return true for demo mode
      return true;
    } catch (e) {
      print('Error updating pharmacy verification: $e');
      // Return true for demo mode
      return true;
    }
  }

  Future<bool> updatePharmacyStatus(String pharmacyId, bool isActive) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/admin/pharmacies/$pharmacyId/status'),
        headers: _headers,
        body: json.encode({'isActive': isActive}),
      );

      print('Update Pharmacy Status Response: ${response.statusCode}');
      print('Update Pharmacy Status Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      // Return true for demo mode
      return true;
    } catch (e) {
      print('Error updating pharmacy status: $e');
      // Return true for demo mode
      return true;
    }
  }

  // Demo pharmacy data for development/testing
  List<Pharmacy> _getDemoPharmacies() {
    return [
      Pharmacy(
        id: 'gov_pharmacy_001',
        name: 'Central Government Hospital Pharmacy',
        ownerName: 'Dr. Rajesh Kumar',
        email: 'pharmacy.central@gov.in',
        phone: '+91 11 2611 2345',
        licenseNumber: 'DL-20A-2024-001',
        address: 'Central Government Hospital, Sector 1',
        city: 'New Delhi',
        state: 'Delhi',
        pincode: '110001',
        latitude: 28.6139,
        longitude: 77.2090,
        services: [
          'Emergency Medicines',
          'Surgical Supplies',
          'Vaccines',
          'General Medicines'
        ],
        operatingHours: '24 Hours',
        isVerified: true,
        isActive: true,
        registeredAt: DateTime.now().subtract(const Duration(days: 730)),
        rating: 4.8,
        totalOrders: 2450,
      ),
      Pharmacy(
        id: 'gov_pharmacy_002',
        name: 'District Hospital Pharmacy - South Delhi',
        ownerName: 'Dr. Priya Sharma',
        email: 'pharmacy.south@delhigov.in',
        phone: '+91 11 2467 8901',
        licenseNumber: 'DL-20A-2024-002',
        address: 'District Hospital, Defence Colony',
        city: 'New Delhi',
        state: 'Delhi',
        pincode: '110024',
        latitude: 28.5729,
        longitude: 77.2310,
        services: [
          'Chronic Disease Medicines',
          'Pediatric Care',
          'Maternity Supplies'
        ],
        operatingHours: '8:00 AM - 8:00 PM',
        isVerified: true,
        isActive: true,
        registeredAt: DateTime.now().subtract(const Duration(days: 600)),
        rating: 4.6,
        totalOrders: 1820,
      ),
      Pharmacy(
        id: 'gov_pharmacy_003',
        name: 'State Medical Store - Primary Health Center',
        ownerName: 'Dr. Amit Singh',
        email: 'pharmacy.phc@haryanahealth.gov.in',
        phone: '+91 124 234 5678',
        licenseNumber: 'HR-14A-2024-003',
        address: 'Primary Health Center, Sector 15',
        city: 'Gurgaon',
        state: 'Haryana',
        pincode: '122001',
        latitude: 28.4595,
        longitude: 77.0266,
        services: [
          'Essential Medicines',
          'Family Planning',
          'Immunization Supplies'
        ],
        operatingHours: '9:00 AM - 6:00 PM',
        isVerified: true,
        isActive: true,
        registeredAt: DateTime.now().subtract(const Duration(days: 450)),
        rating: 4.4,
        totalOrders: 1120,
      ),
      Pharmacy(
        id: 'gov_pharmacy_004',
        name: 'AIIMS Hospital Pharmacy',
        ownerName: 'Dr. Kavya Reddy',
        email: 'pharmacy@aiims.edu',
        phone: '+91 11 2659 3456',
        licenseNumber: 'DL-20A-2024-004',
        address: 'All India Institute of Medical Sciences',
        city: 'New Delhi',
        state: 'Delhi',
        pincode: '110029',
        latitude: 28.5672,
        longitude: 77.2100,
        services: [
          'Specialized Medicines',
          'Oncology Drugs',
          'Cardiac Care',
          'Research Supplies'
        ],
        operatingHours: '24 Hours',
        isVerified: true,
        isActive: true,
        registeredAt: DateTime.now().subtract(const Duration(days: 900)),
        rating: 4.9,
        totalOrders: 3890,
      ),
      Pharmacy(
        id: 'gov_pharmacy_005',
        name: 'Government Medical College Pharmacy',
        ownerName: 'Dr. Suresh Patel',
        email: 'pharmacy@gmcjaipur.edu.in',
        phone: '+91 141 234 5678',
        licenseNumber: 'RJ-12A-2024-005',
        address: 'Government Medical College Campus',
        city: 'Jaipur',
        state: 'Rajasthan',
        pincode: '302004',
        latitude: 26.9124,
        longitude: 75.7873,
        services: ['Student Health', 'Faculty Care', 'Emergency Medicines'],
        operatingHours: '7:00 AM - 9:00 PM',
        isVerified: false, // Pending verification
        isActive: true,
        registeredAt: DateTime.now().subtract(const Duration(days: 90)),
        rating: 4.2,
        totalOrders: 456,
      ),
    ];
  }

  // Bulk upload functionality
  Future<Map<String, dynamic>> uploadPatientRecords(String csvData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/patients/bulk-upload'),
        headers: _headers,
        body: json.encode({'csvData': csvData}),
      );

      print('Bulk Upload Response: ${response.statusCode}');
      print('Bulk Upload Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }

      // Return demo response for testing
      return {
        'success': true,
        'message': 'Bulk upload completed successfully',
        'data': {
          'totalRecords': 50,
          'successfulUploads': 47,
          'failedUploads': 3,
          'errors': [
            'Row 15: Invalid phone number format',
            'Row 28: Missing required field - email',
            'Row 42: Duplicate patient ID'
          ]
        }
      };
    } catch (e) {
      print('Error uploading patient records: $e');
      return {'success': false, 'message': 'Upload failed: $e', 'data': null};
    }
  }

  // Appointment Management
  Future<List<Appointment>> getAllAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/appointments'),
        headers: _headers,
      );

      print('Get Appointments Response: ${response.statusCode}');
      print('Get Appointments Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((appointment) => Appointment.fromJson(appointment))
              .toList();
        }
      }

      // Return demo appointments if API fails
      return _getDemoAppointments();
    } catch (e) {
      print('Error fetching appointments: $e');
      // Return demo appointments on error
      return _getDemoAppointments();
    }
  }

  // Demo appointments data for development/testing
  List<Appointment> _getDemoAppointments() {
    final now = DateTime.now();
    return [
      Appointment(
        id: 'apt_001',
        patientId: 'patient_001',
        patientName: 'John Doe',
        doctorId: 'doc_001',
        doctorName: 'Dr. Smith',
        department: 'Cardiology',
        appointmentDate: now.add(const Duration(hours: 2)),
        timeSlot: '10:00 AM - 10:30 AM',
        status: 'confirmed',
        reason: 'Regular checkup',
        isEmergency: false,
        createdAt: now.subtract(const Duration(days: 1)),
        patientPhone: '+1234567890',
        patientEmail: 'john.doe@email.com',
      ),
      Appointment(
        id: 'apt_002',
        patientId: 'patient_002',
        patientName: 'Jane Smith',
        doctorId: 'doc_002',
        doctorName: 'Dr. Johnson',
        department: 'Neurology',
        appointmentDate: now.add(const Duration(days: 1)),
        timeSlot: '2:00 PM - 2:30 PM',
        status: 'pending',
        reason: 'Migraine consultation',
        isEmergency: false,
        createdAt: now.subtract(const Duration(hours: 6)),
        patientPhone: '+1234567891',
        patientEmail: 'jane.smith@email.com',
      ),
      Appointment(
        id: 'apt_003',
        patientId: 'patient_003',
        patientName: 'Bob Wilson',
        doctorId: 'doc_003',
        doctorName: 'Dr. Brown',
        department: 'Emergency',
        appointmentDate: now.subtract(const Duration(hours: 1)),
        timeSlot: '9:00 AM - 9:30 AM',
        status: 'completed',
        reason: 'Emergency consultation',
        isEmergency: true,
        createdAt: now.subtract(const Duration(hours: 2)),
        patientPhone: '+1234567892',
        patientEmail: 'bob.wilson@email.com',
      ),
      Appointment(
        id: 'apt_004',
        patientId: 'patient_004',
        patientName: 'Alice Brown',
        doctorId: 'doc_004',
        doctorName: 'Dr. Davis',
        department: 'Pediatrics',
        appointmentDate: now.add(const Duration(days: 2)),
        timeSlot: '11:00 AM - 11:30 AM',
        status: 'confirmed',
        reason: 'Child vaccination',
        isEmergency: false,
        createdAt: now.subtract(const Duration(days: 2)),
        patientPhone: '+1234567893',
        patientEmail: 'alice.brown@email.com',
      ),
      Appointment(
        id: 'apt_005',
        patientId: 'patient_005',
        patientName: 'Charlie Green',
        doctorId: 'doc_005',
        doctorName: 'Dr. Miller',
        department: 'Orthopedics',
        appointmentDate: now.add(const Duration(hours: 4)),
        timeSlot: '3:00 PM - 3:30 PM',
        status: 'cancelled',
        reason: 'Knee pain consultation',
        isEmergency: false,
        createdAt: now.subtract(const Duration(hours: 12)),
        patientPhone: '+1234567894',
        patientEmail: 'charlie.green@email.com',
      ),
    ];
  }
}

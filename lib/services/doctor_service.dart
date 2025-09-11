import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/doctor.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class DoctorService {
  static final ApiService _apiService = ApiService();

  /// Get all available doctors from unified backend
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

  /// Search doctors by specialization using unified backend
  static Future<List<Doctor>> searchDoctorsBySpecialization(
    String specialization,
  ) async {
    try {
      final response = await _apiService.get(
        '${ApiConfig.doctorsList}?speciality=$specialization&available=true',
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
    String? specialization,
    String? searchQuery,
    bool? isOnline,
    double? minRating,
    double? maxConsultationFee,
    List<String>? languages,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {'available': 'true'};

      if (specialization != null && specialization.isNotEmpty) {
        queryParams['speciality'] = specialization;
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

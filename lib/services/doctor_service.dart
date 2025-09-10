import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/doctor.dart';

class DoctorService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'doctors';

  /// Get all available doctors
  static Future<List<Doctor>> getAllDoctors() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('is_available', true)
          .order('rating', ascending: false);

      return response.map<Doctor>((data) => Doctor.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error fetching doctors: $e');
      _showToast('Error loading doctors', isError: true);
      return [];
    }
  }

  /// Search doctors by specialization
  static Future<List<Doctor>> searchDoctorsBySpecialization(
    String specialization,
  ) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('is_available', true)
          .ilike('specialization', '%$specialization%')
          .order('rating', ascending: false);

      return response.map<Doctor>((data) => Doctor.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error searching doctors: $e');
      _showToast('Error searching doctors', isError: true);
      return [];
    }
  }

  /// Search doctors by name
  static Future<List<Doctor>> searchDoctorsByName(String name) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('is_available', true)
          .ilike('full_name', '%$name%')
          .order('rating', ascending: false);

      return response.map<Doctor>((data) => Doctor.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error searching doctors by name: $e');
      _showToast('Error searching doctors', isError: true);
      return [];
    }
  }

  /// Get doctors by availability (online status)
  static Future<List<Doctor>> getOnlineDoctors() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('is_available', true)
          .eq('is_online', true)
          .order('rating', ascending: false);

      return response.map<Doctor>((data) => Doctor.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error fetching online doctors: $e');
      _showToast('Error loading online doctors', isError: true);
      return [];
    }
  }

  /// Get doctor by ID
  static Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', doctorId)
          .single();

      return Doctor.fromMap(response);
    } catch (e) {
      debugPrint('Error fetching doctor: $e');
      _showToast('Error loading doctor details', isError: true);
      return null;
    }
  }

  /// Get unique specializations
  static Future<List<String>> getSpecializations() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('specialization')
          .eq('is_available', true);

      final Set<String> specializations = {};
      for (final data in response) {
        final specialization = data['specialization'] as String?;
        if (specialization != null && specialization.isNotEmpty) {
          specializations.add(specialization);
        }
      }

      final sortedList = specializations.toList()..sort();
      return sortedList;
    } catch (e) {
      debugPrint('Error fetching specializations: $e');
      return [];
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
      var query = _supabase.from(_tableName).select().eq('is_available', true);

      // Apply filters
      if (specialization != null && specialization.isNotEmpty) {
        query = query.eq('specialization', specialization);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike('full_name', '%$searchQuery%');
      }

      if (isOnline == true) {
        query = query.eq('is_online', true);
      }

      if (minRating != null) {
        query = query.gte('rating', minRating);
      }

      if (maxConsultationFee != null) {
        query = query.lte('consultation_fee', maxConsultationFee);
      }

      final response = await query.order('rating', ascending: false);

      List<Doctor> doctors = response
          .map<Doctor>((data) => Doctor.fromMap(data))
          .toList();

      // Filter by languages if specified
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

      return doctors;
    } catch (e) {
      debugPrint('Error filtering doctors: $e');
      _showToast('Error filtering doctors', isError: true);
      return [];
    }
  }

  /// Get top rated doctors
  static Future<List<Doctor>> getTopRatedDoctors({int limit = 10}) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('is_available', true)
          .gte('rating', 4.0)
          .order('rating', ascending: false)
          .order('total_consultations', ascending: false)
          .limit(limit);

      return response.map<Doctor>((data) => Doctor.fromMap(data)).toList();
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
          'full_name': 'Dr. Rajesh Kumar',
          'email': 'rajesh.kumar@example.com',
          'phone_number': '+91-9876543210',
          'specialization': 'General Medicine',
          'qualification': 'MBBS, MD',
          'experience_years': 8,
          'consultation_fee': 500.00,
          'languages': ['Hindi', 'English'],
          'rating': 4.5,
          'total_consultations': 250,
          'is_available': true,
          'is_online': true,
        },
        {
          'full_name': 'Dr. Priya Sharma',
          'email': 'priya.sharma@example.com',
          'phone_number': '+91-9876543211',
          'specialization': 'Pediatrics',
          'qualification': 'MBBS, MD (Pediatrics)',
          'experience_years': 6,
          'consultation_fee': 600.00,
          'languages': ['Hindi', 'English', 'Punjabi'],
          'rating': 4.7,
          'total_consultations': 180,
          'is_available': true,
          'is_online': false,
        },
        {
          'full_name': 'Dr. Amit Singh',
          'email': 'amit.singh@example.com',
          'phone_number': '+91-9876543212',
          'specialization': 'Cardiology',
          'qualification': 'MBBS, MD, DM (Cardiology)',
          'experience_years': 12,
          'consultation_fee': 1000.00,
          'languages': ['Hindi', 'English'],
          'rating': 4.8,
          'total_consultations': 320,
          'is_available': true,
          'is_online': true,
        },
        {
          'full_name': 'Dr. Sneha Patel',
          'email': 'sneha.patel@example.com',
          'phone_number': '+91-9876543213',
          'specialization': 'Dermatology',
          'qualification': 'MBBS, MD (Dermatology)',
          'experience_years': 5,
          'consultation_fee': 700.00,
          'languages': ['Hindi', 'English', 'Gujarati'],
          'rating': 4.4,
          'total_consultations': 150,
          'is_available': true,
          'is_online': false,
        },
        {
          'full_name': 'Dr. Vikram Reddy',
          'email': 'vikram.reddy@example.com',
          'phone_number': '+91-9876543214',
          'specialization': 'Orthopedics',
          'qualification': 'MBBS, MS (Orthopedics)',
          'experience_years': 10,
          'consultation_fee': 800.00,
          'languages': ['Hindi', 'English', 'Telugu'],
          'rating': 4.6,
          'total_consultations': 200,
          'is_available': true,
          'is_online': true,
        },
      ];

      for (final doctorData in sampleDoctors) {
        await _supabase.from(_tableName).insert(doctorData);
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

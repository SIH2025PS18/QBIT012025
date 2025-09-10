import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/patient_profile.dart';
import 'supabase_auth_service.dart';
import 'image_upload_service.dart';

class PatientProfileService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'patient_profiles';

  // Create or update patient profile
  static Future<bool> savePatientProfile(PatientProfile profile) async {
    try {
      final data = profile.toMap();

      // Check if profile already exists
      final existing = await _supabase
          .from(_tableName)
          .select('id')
          .eq('id', profile.id)
          .maybeSingle();

      if (existing != null) {
        // Update existing profile
        await _supabase.from(_tableName).update(data).eq('id', profile.id);
      } else {
        // Insert new profile
        await _supabase.from(_tableName).insert(data);
      }

      _showToast('Profile saved successfully! ✓', isError: false);
      return true;
    } catch (e) {
      print('Supabase Error: ${e.toString()}');
      _showToast('Error saving profile: ${e.toString()}', isError: true);
      return false;
    }
  }

  // Get current user's patient profile
  static Future<PatientProfile?> getCurrentPatientProfile() async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) return null;

      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', currentUser.id)
          .maybeSingle();

      if (response != null) {
        return PatientProfile.fromMap(response);
      }
      return null;
    } catch (e) {
      print('Supabase Error: ${e.toString()}');
      _showToast('Error fetching profile: ${e.toString()}', isError: true);
      return null;
    }
  }

  // Get patient profile by ID
  static Future<PatientProfile?> getPatientProfile(String patientId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', patientId)
          .maybeSingle();

      if (response != null) {
        return PatientProfile.fromMap(response);
      }
      return null;
    } catch (e) {
      _showToast(
        'Error fetching patient profile: ${e.toString()}',
        isError: true,
      );
      return null;
    }
  }

  // Update specific fields of patient profile
  static Future<bool> updatePatientProfile(
    String patientId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabase.from(_tableName).update(updates).eq('id', patientId);

      _showToast('Profile updated successfully!', isError: false);
      return true;
    } catch (e) {
      _showToast('Error updating profile: ${e.toString()}', isError: true);
      return false;
    }
  }

  // Add medical history entry
  static Future<bool> addMedicalHistoryEntry(
    String patientId,
    String condition,
    String description,
  ) async {
    try {
      final profile = await getPatientProfile(patientId);
      if (profile == null) return false;

      final medicalHistory = Map<String, dynamic>.from(profile.medicalHistory);
      medicalHistory[DateTime.now().toIso8601String()] = {
        'condition': condition,
        'description': description,
        'date': DateTime.now().toIso8601String(),
      };

      return await updatePatientProfile(patientId, {
        'medical_history': medicalHistory,
      });
    } catch (e) {
      _showToast(
        'Error adding medical history: ${e.toString()}',
        isError: true,
      );
      return false;
    }
  }

  // Add medication
  static Future<bool> addMedication(String patientId, String medication) async {
    try {
      final profile = await getPatientProfile(patientId);
      if (profile == null) return false;

      final medications = List<String>.from(profile.medications);
      if (!medications.contains(medication)) {
        medications.add(medication);
        return await updatePatientProfile(patientId, {
          'medications': medications,
        });
      }
      return true;
    } catch (e) {
      _showToast('Error adding medication: ${e.toString()}', isError: true);
      return false;
    }
  }

  // Add allergy
  static Future<bool> addAllergy(String patientId, String allergy) async {
    try {
      final profile = await getPatientProfile(patientId);
      if (profile == null) return false;

      final allergies = List<String>.from(profile.allergies);
      if (!allergies.contains(allergy)) {
        allergies.add(allergy);
        return await updatePatientProfile(patientId, {'allergies': allergies});
      }
      return true;
    } catch (e) {
      _showToast('Error adding allergy: ${e.toString()}', isError: true);
      return false;
    }
  }

  // Update last visit
  static Future<bool> updateLastVisit(String patientId) async {
    return await updatePatientProfile(patientId, {
      'last_visit': DateTime.now().toIso8601String(),
    });
  }

  // Check if patient profile exists
  static Future<bool> profileExists(String patientId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select('id')
          .eq('id', patientId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Create initial profile after registration
  static Future<PatientProfile?> createInitialProfile({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    try {
      final profile = PatientProfile(
        id: userId,
        fullName: fullName,
        email: email,
        dateOfBirth: DateTime.now().subtract(
          const Duration(days: 365 * 25),
        ), // Default 25 years old
        gender: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await savePatientProfile(profile);
      return success ? profile : null;
    } catch (e) {
      _showToast('Error creating profile: ${e.toString()}', isError: true);
      return null;
    }
  }

  // Upload and update profile photo
  static Future<String?> uploadProfilePhoto({
    required String userId,
    required XFile imageFile,
  }) async {
    try {
      // Validate image first
      final isValid = await ImageUploadService.validateImage(imageFile);
      if (!isValid) {
        _showToast(
          'Invalid image. Please select a valid image under 5MB.',
          isError: true,
        );
        return null;
      }

      // Upload to storage
      final imageUrl = await ImageUploadService.uploadProfilePhoto(
        userId: userId,
        imageFile: imageFile,
      );

      if (imageUrl != null) {
        // Update profile with new photo URL
        final currentProfile = await getCurrentPatientProfile();
        if (currentProfile != null) {
          final updatedProfile = currentProfile.copyWith(
            profilePhotoUrl: imageUrl,
          );

          final success = await savePatientProfile(updatedProfile);
          if (success) {
            _showToast(
              'Profile photo updated successfully! 📷',
              isError: false,
            );
            return imageUrl;
          }
        }
      }

      _showToast('Failed to upload profile photo', isError: true);
      return null;
    } catch (e) {
      _showToast('Error uploading photo: ${e.toString()}', isError: true);
      return null;
    }
  }

  // Remove profile photo
  static Future<bool> removeProfilePhoto() async {
    try {
      final currentProfile = await getCurrentPatientProfile();
      if (currentProfile == null || currentProfile.profilePhotoUrl.isEmpty) {
        return true; // Nothing to remove
      }

      // Delete from storage
      final deleted = await ImageUploadService.deleteProfilePhoto(
        currentProfile.profilePhotoUrl,
      );

      if (deleted) {
        // Update profile to remove photo URL
        final updatedProfile = currentProfile.copyWith(profilePhotoUrl: '');

        final success = await savePatientProfile(updatedProfile);
        if (success) {
          _showToast('Profile photo removed successfully', isError: false);
          return true;
        }
      }

      _showToast('Failed to remove profile photo', isError: true);
      return false;
    } catch (e) {
      _showToast('Error removing photo: ${e.toString()}', isError: true);
      return false;
    }
  }

  // Show toast message
  static void _showToast(String message, {required bool isError}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError
          ? const Color(0xFFE53E3E)
          : const Color(0xFF38A169),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 16.0,
    );
  }
}

/// Service class that implements the interface expected by SupabasePatientProfileRepository
class SupabasePatientProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'patient_profiles';

  /// Get current user's profile
  Future<PatientProfile?> getCurrentProfile() async {
    return await PatientProfileService.getCurrentPatientProfile();
  }

  /// Create a new patient profile
  Future<PatientProfile> createProfile(PatientProfile profile) async {
    final success = await PatientProfileService.savePatientProfile(profile);
    if (success) {
      return profile;
    }
    throw Exception('Failed to create profile');
  }

  /// Update an existing patient profile
  Future<PatientProfile> updateProfile(PatientProfile profile) async {
    final success = await PatientProfileService.savePatientProfile(profile);
    if (success) {
      return profile;
    }
    throw Exception('Failed to update profile');
  }

  /// Delete the current user's profile
  Future<void> deleteProfile() async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }

    await _supabase.from(_tableName).delete().eq('id', currentUser.id);
  }

  /// Upload profile photo
  Future<String> uploadProfilePhoto(String filePath) async {
    final currentUser = AuthService.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user');
    }

    // Create XFile from file path
    final imageFile = XFile(filePath);

    final imageUrl = await PatientProfileService.uploadProfilePhoto(
      userId: currentUser.id,
      imageFile: imageFile,
    );

    if (imageUrl != null) {
      return imageUrl;
    }
    throw Exception('Failed to upload profile photo');
  }

  /// Delete profile photo
  Future<void> deleteProfilePhoto(String photoUrl) async {
    final success = await PatientProfileService.removeProfilePhoto();
    if (!success) {
      throw Exception('Failed to delete profile photo');
    }
  }

  /// Get profile by user ID
  Future<PatientProfile?> getProfileById(String userId) async {
    return await PatientProfileService.getPatientProfile(userId);
  }

  /// Search profiles by criteria
  Future<List<PatientProfile>> searchProfiles({
    String? name,
    String? email,
    String? phone,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      var query = _supabase.from(_tableName).select();

      // Apply filters
      if (name != null && name.isNotEmpty) {
        query = query.ilike('full_name', '%$name%');
      }
      if (email != null && email.isNotEmpty) {
        query = query.ilike('email', '%$email%');
      }
      if (phone != null && phone.isNotEmpty) {
        query = query.ilike('phone_number', '%$phone%');
      }

      // Apply pagination and execute query
      final response = await query.range(offset, offset + limit - 1);

      return response
          .map<PatientProfile>((data) => PatientProfile.fromMap(data))
          .toList();
    } catch (e) {
      throw Exception('Failed to search profiles: $e');
    }
  }
}

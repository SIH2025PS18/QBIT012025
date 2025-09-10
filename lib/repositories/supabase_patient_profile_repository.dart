import '../models/patient_profile.dart';
import '../services/supabase_patient_profile_service.dart';
import 'patient_profile_repository.dart';

/// Supabase implementation of PatientProfileRepository
class SupabasePatientProfileRepository implements PatientProfileRepository {
  final SupabasePatientProfileService _service = SupabasePatientProfileService();

  @override
  Future<PatientProfile?> getCurrentProfile() async {
    try {
      return await _service.getCurrentProfile();
    } catch (e) {
      throw Exception('Failed to get current profile: $e');
    }
  }

  @override
  Future<PatientProfile> createProfile(PatientProfile profile) async {
    try {
      return await _service.createProfile(profile);
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  @override
  Future<PatientProfile> updateProfile(PatientProfile profile) async {
    try {
      return await _service.updateProfile(profile);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> deleteProfile() async {
    try {
      await _service.deleteProfile();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  @override
  Future<String> uploadProfilePhoto(String filePath) async {
    try {
      return await _service.uploadProfilePhoto(filePath);
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  @override
  Future<void> deleteProfilePhoto(String photoUrl) async {
    try {
      await _service.deleteProfilePhoto(photoUrl);
    } catch (e) {
      throw Exception('Failed to delete profile photo: $e');
    }
  }

  @override
  Future<bool> profileExists() async {
    try {
      final profile = await getCurrentProfile();
      return profile != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<PatientProfile?> getProfileById(String userId) async {
    try {
      return await _service.getProfileById(userId);
    } catch (e) {
      throw Exception('Failed to get profile by ID: $e');
    }
  }

  @override
  Future<List<PatientProfile>> searchProfiles({
    String? name,
    String? email,
    String? phone,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      return await _service.searchProfiles(
        name: name,
        email: email,
        phone: phone,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      throw Exception('Failed to search profiles: $e');
    }
  }
}
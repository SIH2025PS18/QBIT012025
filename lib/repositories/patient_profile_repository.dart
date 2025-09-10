import '../models/patient_profile.dart';

/// Abstract repository interface for patient profile operations
/// This allows for easy swapping between different data sources (Supabase, Firebase, etc.)
abstract class PatientProfileRepository {
  /// Get the current user's profile
  Future<PatientProfile?> getCurrentProfile();

  /// Create a new patient profile
  Future<PatientProfile> createProfile(PatientProfile profile);

  /// Update an existing patient profile
  Future<PatientProfile> updateProfile(PatientProfile profile);

  /// Delete the current user's profile
  Future<void> deleteProfile();

  /// Upload profile photo
  Future<String> uploadProfilePhoto(String filePath);

  /// Delete profile photo
  Future<void> deleteProfilePhoto(String photoUrl);

  /// Check if profile exists for current user
  Future<bool> profileExists();

  /// Get profile by user ID (admin function)
  Future<PatientProfile?> getProfileById(String userId);

  /// Search profiles by criteria (admin function)
  Future<List<PatientProfile>> searchProfiles({
    String? name,
    String? email,
    String? phone,
    int limit = 20,
    int offset = 0,
  });
}

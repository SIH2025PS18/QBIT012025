import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/patient_profile.dart';
import '../repositories/patient_profile_repository.dart';
import '../repositories/supabase_patient_profile_repository.dart';

/// Provider class for managing patient profile state
class PatientProfileProvider extends ChangeNotifier {
  final PatientProfileRepository _repository =
      SupabasePatientProfileRepository();

  PatientProfile? _profile;
  bool _isLoading = false;
  String? _error;

  // Getters
  PatientProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasProfile => _profile != null;

  /// Load the current user's profile
  Future<void> loadProfile() async {
    _setLoading(true);
    _clearError();

    try {
      _profile = await _repository.getCurrentProfile();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new profile
  Future<void> createProfile(PatientProfile profile) async {
    _setLoading(true);
    _clearError();

    try {
      _profile = await _repository.createProfile(profile);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create profile: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Update the current profile
  Future<void> updateProfile(PatientProfile profile) async {
    _setLoading(true);
    _clearError();

    try {
      _profile = await _repository.updateProfile(profile);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update profile: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Upload profile photo
  Future<void> uploadProfilePhoto(String filePath) async {
    _setLoading(true);
    _clearError();

    try {
      final photoUrl = await _repository.uploadProfilePhoto(filePath);
      if (_profile != null) {
        final updatedProfile = _profile!.copyWith(profilePhotoUrl: photoUrl);
        await updateProfile(updatedProfile);
      }
    } catch (e) {
      _setError('Failed to upload profile photo: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete profile photo
  Future<void> deleteProfilePhoto() async {
    if (_profile?.profilePhotoUrl == null || _profile!.profilePhotoUrl.isEmpty)
      return;

    _setLoading(true);
    _clearError();

    try {
      await _repository.deleteProfilePhoto(_profile!.profilePhotoUrl);
      final updatedProfile = _profile!.copyWith(profilePhotoUrl: '');
      await updateProfile(updatedProfile);
    } catch (e) {
      _setError('Failed to delete profile photo: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Check if profile exists
  Future<bool> checkProfileExists() async {
    try {
      return await _repository.profileExists();
    } catch (e) {
      _setError('Failed to check profile existence: $e');
      return false;
    }
  }

  /// Clear the current profile (on logout)
  void clearProfile() {
    _profile = null;
    _clearError();
    notifyListeners();
  }

  /// Refresh the profile data
  Future<void> refreshProfile() async {
    await loadProfile();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}

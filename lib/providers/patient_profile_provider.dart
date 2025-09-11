import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient_profile.dart';
import '../services/auth_service.dart';

/// Provider class for managing patient profile state
class PatientProfileProvider extends ChangeNotifier {
  static const String _baseUrl = 'http://localhost:5001/api';
  final AuthService _authService = AuthService();

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
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/patients/${currentUser.id}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _profile = PatientProfile.fromJson(data);
      } else {
        throw Exception('Failed to load profile: ${response.body}');
      }
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
      final response = await http.post(
        Uri.parse('$_baseUrl/patients'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _profile = PatientProfile.fromJson(data);
      } else {
        throw Exception('Failed to create profile: ${response.body}');
      }
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
      final response = await http.put(
        Uri.parse('$_baseUrl/patients/${profile.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _profile = PatientProfile.fromJson(data);
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
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
      // For now, just store the local file path
      // In a real implementation, you'd upload to the backend
      if (_profile != null) {
        final updatedProfile = _profile!.copyWith(profilePhotoUrl: filePath);
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
      // Remove photo URL from profile
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
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return false;

      final response = await http.get(
        Uri.parse('$_baseUrl/patients/${currentUser.id}'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
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

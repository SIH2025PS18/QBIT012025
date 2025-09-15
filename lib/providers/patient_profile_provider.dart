import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient_profile.dart';
import '../services/auth_service.dart';

/// Provider class for managing patient profile state
class PatientProfileProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://telemed18.onrender.com/api';
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

      final token = _authService.authToken;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Try to fetch patient data from backend
      final response = await http.get(
        Uri.parse('$_baseUrl/patients/${currentUser.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Load Profile Response: ${response.statusCode}');
      print('Load Profile Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final patientData = data['data'];
          _profile = PatientProfile(
            id: patientData['_id'] ?? currentUser.id,
            fullName: patientData['name'] ?? currentUser.name,
            email: patientData['email'] ?? currentUser.email,
            phoneNumber: patientData['phone'] ?? '',
            dateOfBirth: patientData['dateOfBirth'] != null
                ? DateTime.parse(patientData['dateOfBirth'])
                : DateTime.now().subtract(const Duration(days: 365 * 25)),
            gender: patientData['gender'] ?? 'Not specified',
            bloodGroup: patientData['bloodGroup'] ?? '',
            address: patientData['address'] ?? '',
            emergencyContact: patientData['emergencyContact'] ?? '',
            emergencyContactPhone: patientData['emergencyContactPhone'] ?? '',
            profilePhotoUrl: patientData['profilePhotoUrl'] ?? '',
            allergies: patientData['allergies'] != null
                ? List<String>.from(patientData['allergies'])
                : [],
            medications: patientData['medications'] != null
                ? List<String>.from(patientData['medications'])
                : [],
            medicalHistory: patientData['medicalHistory'] ?? {},
            lastVisit: patientData['lastVisit'] != null
                ? DateTime.parse(patientData['lastVisit'])
                : null,
            createdAt: patientData['createdAt'] != null
                ? DateTime.parse(patientData['createdAt'])
                : DateTime.now(),
            updatedAt: patientData['updatedAt'] != null
                ? DateTime.parse(patientData['updatedAt'])
                : DateTime.now(),
          );
        } else {
          // Create default profile if data is missing
          _profile = _createDefaultProfile(currentUser);
        }
      } else {
        // Create default profile if backend request fails
        _profile = _createDefaultProfile(currentUser);
      }

      notifyListeners();
    } catch (e) {
      print('Error loading profile: $e');
      // Create default profile on error
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        _profile = _createDefaultProfile(currentUser);
        notifyListeners();
      }
      _setError('Failed to load profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a default profile for new users
  PatientProfile _createDefaultProfile(dynamic currentUser) {
    return PatientProfile(
      id: currentUser.id,
      fullName: currentUser.name ?? 'User',
      email: currentUser.email ?? '',
      phoneNumber: '',
      dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 25)),
      gender: 'Not specified',
      bloodGroup: '',
      address: '',
      emergencyContact: '',
      emergencyContactPhone: '',
      profilePhotoUrl: '',
      allergies: [],
      medications: [],
      medicalHistory: {},
      lastVisit: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
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
      // Get authentication token
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final token = _authService.authToken;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Prepare the update data
      final updateData = {
        'name': profile.fullName,
        'phone': profile.phoneNumber,
        'email': profile.email,
        'dateOfBirth': profile.dateOfBirth.toIso8601String(),
        'gender': profile.gender.toLowerCase(),
        'bloodGroup': profile.bloodGroup,
        'address': profile.address,
        'emergencyContact': profile.emergencyContact,
        'emergencyContactPhone': profile.emergencyContactPhone,
        'allergies': profile.allergies,
        'medications': profile.medications,
        'medicalHistory': profile.medicalHistory,
      };

      final response = await http.put(
        Uri.parse('$_baseUrl/patients/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      print('Update Profile Response: ${response.statusCode}');
      print('Update Profile Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          // Map the backend patient data to our profile model
          final patientData = data['data'];
          _profile = PatientProfile(
            id: patientData['_id'] ?? profile.id,
            fullName: patientData['name'] ?? profile.fullName,
            email: patientData['email'] ?? profile.email,
            phoneNumber: patientData['phone'] ?? profile.phoneNumber,
            dateOfBirth: patientData['dateOfBirth'] != null
                ? DateTime.parse(patientData['dateOfBirth'])
                : profile.dateOfBirth,
            gender: patientData['gender'] ?? profile.gender,
            bloodGroup: patientData['bloodGroup'] ?? profile.bloodGroup,
            address: patientData['address'] ?? profile.address,
            emergencyContact:
                patientData['emergencyContact'] ?? profile.emergencyContact,
            emergencyContactPhone:
                patientData['emergencyContactPhone'] ??
                profile.emergencyContactPhone,
            profilePhotoUrl:
                patientData['profilePhotoUrl'] ?? profile.profilePhotoUrl,
            allergies: patientData['allergies'] != null
                ? List<String>.from(patientData['allergies'])
                : profile.allergies,
            medications: patientData['medications'] != null
                ? List<String>.from(patientData['medications'])
                : profile.medications,
            medicalHistory:
                patientData['medicalHistory'] ?? profile.medicalHistory,
            lastVisit: patientData['lastVisit'] != null
                ? DateTime.parse(patientData['lastVisit'])
                : profile.lastVisit,
            createdAt: patientData['createdAt'] != null
                ? DateTime.parse(patientData['createdAt'])
                : profile.createdAt,
            updatedAt: DateTime.now(),
          );
        } else {
          _profile = profile;
        }
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
      notifyListeners();
    } catch (e) {
      print('Error updating profile: $e');
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

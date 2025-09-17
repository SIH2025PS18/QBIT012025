import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/dependent_profile.dart';
import '../services/auth_service.dart';

/// Provider for managing family profiles, caregiver mode, and family health overview
class FamilyProfileProvider extends ChangeNotifier {
  static const String _baseUrl = 'http://localhost:3000/api';

  final AuthService _authService = AuthService();

  // Family profile state
  FamilyHealthOverview? _familyOverview;
  List<DependentProfile> _dependents = [];
  CaregiverMode _caregiverMode = const CaregiverMode();
  String? _currentActiveProfileId;

  // Loading and error states
  bool _isLoading = false;
  String? _error;

  // Getters
  FamilyHealthOverview? get familyOverview => _familyOverview;
  List<DependentProfile> get dependents => List.unmodifiable(_dependents);
  CaregiverMode get caregiverMode => _caregiverMode;
  String? get currentActiveProfileId => _currentActiveProfileId;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCaregiverModeActive => _caregiverMode.isActive;

  /// Get the currently active profile (dependent or primary user)
  DependentProfile? get activeProfile {
    if (_caregiverMode.isActive &&
        _caregiverMode.activeDependentId.isNotEmpty) {
      return _dependents.firstWhere(
        (d) => d.id == _caregiverMode.activeDependentId,
        orElse: () => _dependents.first,
      );
    }
    return null;
  }

  /// Initialize family profiles for the current user
  Future<void> initializeFamilyProfiles() async {
    _setLoading(true);
    _clearError();

    try {
      // Get dependents list
      await _loadDependents();

      // Load family overview
      await _loadFamilyOverview();
    } catch (e) {
      _setError('Failed to initialize family profiles: $e');
      if (kDebugMode) print('Error initializing family profiles: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load dependents from backend
  Future<void> _loadDependents() async {
    final headers = await _getAuthHeaders();

    final response = await http.get(
      Uri.parse('$_baseUrl/family/dependents'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        final List<dynamic> dependentsData = data['data'];
        _dependents = dependentsData
            .map((json) => DependentProfile.fromMap(json))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to load dependents');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  /// Load family overview from backend
  Future<void> _loadFamilyOverview() async {
    try {
      final headers = await _getAuthHeaders();

      final response = await http.get(
        Uri.parse('$_baseUrl/family/overview'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _familyOverview = FamilyHealthOverview.fromMap(data['data']);
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error loading family overview: $e');
      // Non-critical error, continue without overview
    }
  }

  /// Add a new dependent to the family
  Future<bool> addDependent(DependentProfile dependent) async {
    _setLoading(true);
    _clearError();

    try {
      final headers = await _getAuthHeaders();

      final response = await http.post(
        Uri.parse('$_baseUrl/family/dependents'),
        headers: headers,
        body: json.encode(dependent.toMap()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success']) {
          final newDependent = DependentProfile.fromMap(data['data']);
          _dependents.add(newDependent);

          // Refresh overview
          await _loadFamilyOverview();

          notifyListeners();
          return true;
        } else {
          _setError(data['message'] ?? 'Failed to add dependent');
        }
      } else {
        _setError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Failed to add dependent: $e');
      if (kDebugMode) print('Error adding dependent: $e');
    } finally {
      _setLoading(false);
    }

    return false;
  }

  /// Update an existing dependent
  Future<bool> updateDependent(DependentProfile dependent) async {
    _setLoading(true);
    _clearError();

    try {
      final headers = await _getAuthHeaders();

      final response = await http.put(
        Uri.parse('$_baseUrl/family/dependents/${dependent.id}'),
        headers: headers,
        body: json.encode(dependent.toMap()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final updatedDependent = DependentProfile.fromMap(data['data']);
          final index = _dependents.indexWhere((d) => d.id == dependent.id);
          if (index != -1) {
            _dependents[index] = updatedDependent;

            // Update active profile if it's the same
            if (_caregiverMode.activeDependentId == dependent.id) {
              _caregiverMode = _caregiverMode.copyWith(
                activeDependentId: dependent.id,
              );
            }

            await _loadFamilyOverview();
            notifyListeners();
            return true;
          }
        } else {
          _setError(data['message'] ?? 'Failed to update dependent');
        }
      } else {
        _setError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Failed to update dependent: $e');
      if (kDebugMode) print('Error updating dependent: $e');
    } finally {
      _setLoading(false);
    }

    return false;
  }

  /// Remove a dependent from the family
  Future<bool> removeDependent(String dependentId) async {
    _setLoading(true);
    _clearError();

    try {
      final headers = await _getAuthHeaders();

      final response = await http.delete(
        Uri.parse('$_baseUrl/family/dependents/$dependentId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          _dependents.removeWhere((d) => d.id == dependentId);

          // Exit caregiver mode if removing active dependent
          if (_caregiverMode.activeDependentId == dependentId) {
            exitCaregiverMode();
          }

          await _loadFamilyOverview();
          notifyListeners();
          return true;
        } else {
          _setError(data['message'] ?? 'Failed to remove dependent');
        }
      } else {
        _setError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Failed to remove dependent: $e');
      if (kDebugMode) print('Error removing dependent: $e');
    } finally {
      _setLoading(false);
    }

    return false;
  }

  /// Enter caregiver mode for a specific dependent
  Future<void> enterCaregiverMode(String dependentId) async {
    try {
      final dependent = _dependents.firstWhere((d) => d.id == dependentId);

      _caregiverMode = CaregiverMode(
        isActive: true,
        activeDependentId: dependentId,
        activeDependentName: dependent.name,
        activeDependentRelation: dependent.relation,
        activatedAt: DateTime.now(),
        enabledFeatures: _getCaregiverPermissions(dependent),
      );

      _currentActiveProfileId = dependentId;

      // Update caregiver activity on backend
      try {
        final headers = await _getAuthHeaders();
        await http.put(
          Uri.parse(
            '$_baseUrl/family/dependents/$dependentId/caregiver-activity',
          ),
          headers: headers,
        );
      } catch (e) {
        if (kDebugMode) print('Error updating caregiver activity: $e');
      }

      notifyListeners();

      if (kDebugMode) print('Entered caregiver mode for: ${dependent.name}');
    } catch (e) {
      _setError('Failed to enter caregiver mode: $e');
      if (kDebugMode) print('Error entering caregiver mode: $e');
    }
  }

  /// Exit caregiver mode
  void exitCaregiverMode() {
    _caregiverMode = const CaregiverMode();
    _currentActiveProfileId = null;
    notifyListeners();

    if (kDebugMode) print('Exited caregiver mode');
  }

  /// Switch to a different dependent profile
  void switchToProfile(String dependentId) {
    if (_dependents.any((d) => d.id == dependentId)) {
      _currentActiveProfileId = dependentId;

      if (_caregiverMode.isActive) {
        _caregiverMode = _caregiverMode.copyWith(
          activeDependentId: dependentId,
        );
      }

      notifyListeners();
    }
  }

  /// Refresh all family data
  Future<void> refresh() async {
    await initializeFamilyProfiles();
  }

  /// Get authentication headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = _authService.authToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Get caregiver permissions for a dependent
  List<String> _getCaregiverPermissions(DependentProfile dependent) {
    final List<String> permissions = [
      'view_medical_history',
      'book_appointments',
      'receive_notifications',
    ];

    // Age-based permissions
    if (dependent.age < 18) {
      permissions.addAll([
        'full_access',
        'emergency_access',
        'manage_medications',
      ]);
    } else if (dependent.age > 65) {
      permissions.addAll([
        'manage_medications',
        'emergency_access',
        'update_profile',
      ]);
    }

    // Condition-based permissions
    if (dependent.medicalConditions.isNotEmpty) {
      permissions.add('manage_medications');
    }

    return permissions.toSet().toList(); // Remove duplicates
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error state
  void _clearError() {
    _error = null;
  }
}

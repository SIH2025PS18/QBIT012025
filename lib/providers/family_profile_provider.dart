import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/dependent_profile.dart';
import '../services/auth_service.dart';

/// Provider for managing family profiles, caregiver mode, and family health overview
class FamilyProfileProvider extends ChangeNotifier {
  static const String _baseUrl = 'https://telemed18.onrender.com/api';

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
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final token = _authService.authToken;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      await Future.wait([_loadFamilyOverview(), _loadDependentProfiles()]);

      print('✅ Family profiles initialized successfully');
    } catch (e) {
      _setError('Failed to initialize family profiles: $e');
      print('❌ Error initializing family profiles: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load family health overview
  Future<void> _loadFamilyOverview() async {
    try {
      final token = _authService.authToken;
      final response = await http.get(
        Uri.parse('$_baseUrl/family/overview'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Family Overview Response: ${response.statusCode}');
      print('Family Overview Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          _familyOverview = FamilyHealthOverview.fromMap(data['data']);
        }
      } else if (response.statusCode == 404) {
        // No family overview exists yet, create an empty one
        await _createEmptyFamilyOverview();
      }
    } catch (e) {
      print('Error loading family overview: $e');
      // Don't throw here, as this might be the first time
    }
  }

  /// Load dependent profiles
  Future<void> _loadDependentProfiles() async {
    try {
      final token = _authService.authToken;
      final response = await http.get(
        Uri.parse('$_baseUrl/family/dependents'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Dependents Response: ${response.statusCode}');
      print('Dependents Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          _dependents = (data['data'] as List)
              .map((d) => DependentProfile.fromMap(d))
              .toList();
        }
      }
    } catch (e) {
      print('Error loading dependents: $e');
      // Initialize empty list if error
      _dependents = [];
    }
  }

  /// Create empty family overview for first-time users
  Future<void> _createEmptyFamilyOverview() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      _familyOverview = FamilyHealthOverview(
        primaryUserId: currentUser.id,
        primaryUserName: currentUser.name,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('Error creating empty family overview: $e');
    }
  }

  /// Add a new dependent profile
  Future<void> addDependentProfile(DependentProfile dependent) async {
    _setLoading(true);
    _clearError();

    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final token = _authService.authToken;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final dependentData = dependent.copyWith(
        primaryUserId: currentUser.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/family/dependents'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dependentData.toMap()),
      );

      print('Add Dependent Response: ${response.statusCode}');
      print('Add Dependent Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final newDependent = DependentProfile.fromMap(data['data']);
          _dependents.add(newDependent);
          await _refreshFamilyOverview();
          notifyListeners();
        }
      } else {
        throw Exception('Failed to add dependent: ${response.body}');
      }
    } catch (e) {
      _setError('Failed to add family member: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing dependent profile
  Future<void> updateDependentProfile(DependentProfile dependent) async {
    _setLoading(true);
    _clearError();

    try {
      final token = _authService.authToken;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final updatedDependent = dependent.copyWith(updatedAt: DateTime.now());

      final response = await http.put(
        Uri.parse('$_baseUrl/family/dependents/${dependent.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updatedDependent.toMap()),
      );

      print('Update Dependent Response: ${response.statusCode}');
      print('Update Dependent Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final updatedDep = DependentProfile.fromMap(data['data']);
          final index = _dependents.indexWhere((d) => d.id == dependent.id);
          if (index != -1) {
            _dependents[index] = updatedDep;
            await _refreshFamilyOverview();
            notifyListeners();
          }
        }
      } else {
        throw Exception('Failed to update dependent: ${response.body}');
      }
    } catch (e) {
      _setError('Failed to update family member: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove a dependent profile
  Future<void> removeDependentProfile(String dependentId) async {
    _setLoading(true);
    _clearError();

    try {
      final token = _authService.authToken;
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.delete(
        Uri.parse('$_baseUrl/family/dependents/$dependentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Remove Dependent Response: ${response.statusCode}');
      print('Remove Dependent Body: ${response.body}');

      if (response.statusCode == 200) {
        _dependents.removeWhere((d) => d.id == dependentId);

        // If we're in caregiver mode for this dependent, exit caregiver mode
        if (_caregiverMode.isActive &&
            _caregiverMode.activeDependentId == dependentId) {
          await exitCaregiverMode();
        }

        await _refreshFamilyOverview();
        notifyListeners();
      } else {
        throw Exception('Failed to remove dependent: ${response.body}');
      }
    } catch (e) {
      _setError('Failed to remove family member: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Enter caregiver mode for a specific dependent
  Future<void> enterCaregiverMode(DependentProfile dependent) async {
    try {
      _caregiverMode = CaregiverMode(
        isActive: true,
        activeDependentId: dependent.id,
        activeDependentName: dependent.name,
        activeDependentRelation: dependent.relation,
        activatedAt: DateTime.now(),
        enabledFeatures: CaregiverPermissions.defaultPermissions,
      );

      _currentActiveProfileId = dependent.id;

      print(
        '🔄 Entered caregiver mode for ${dependent.name} (${dependent.relation})',
      );
      notifyListeners();
    } catch (e) {
      _setError('Failed to enter caregiver mode: $e');
      print('❌ Error entering caregiver mode: $e');
    }
  }

  /// Exit caregiver mode and return to primary user profile
  Future<void> exitCaregiverMode() async {
    try {
      _caregiverMode = const CaregiverMode();
      _currentActiveProfileId = null;

      print('🔄 Exited caregiver mode');
      notifyListeners();
    } catch (e) {
      _setError('Failed to exit caregiver mode: $e');
      print('❌ Error exiting caregiver mode: $e');
    }
  }

  /// Switch between family member profiles
  Future<void> switchToProfile(String profileId) async {
    try {
      final dependent = _dependents.firstWhere(
        (d) => d.id == profileId,
        orElse: () => throw Exception('Dependent not found'),
      );

      await enterCaregiverMode(dependent);
    } catch (e) {
      _setError('Failed to switch profile: $e');
      print('❌ Error switching profile: $e');
    }
  }

  /// Refresh family overview with latest data
  Future<void> _refreshFamilyOverview() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      // Calculate updated metrics
      final totalMembers = _dependents.length + 1; // +1 for primary user
      final upcomingAppointments = await _getUpcomingAppointmentsCount();
      final pendingMedications = await _getPendingMedicationsCount();
      final criticalAlerts = await _getCriticalAlertsCount();

      _familyOverview = FamilyHealthOverview(
        primaryUserId: currentUser.id,
        primaryUserName: currentUser.name,
        dependents: _dependents,
        totalMembers: totalMembers,
        upcomingAppointments: upcomingAppointments,
        pendingMedications: pendingMedications,
        criticalAlerts: criticalAlerts,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('Error refreshing family overview: $e');
    }
  }

  /// Get count of upcoming appointments for all family members
  Future<int> _getUpcomingAppointmentsCount() async {
    try {
      // TODO: Implement actual appointment counting logic
      return 0;
    } catch (e) {
      print('Error getting appointments count: $e');
      return 0;
    }
  }

  /// Get count of pending medications for all family members
  Future<int> _getPendingMedicationsCount() async {
    try {
      // TODO: Implement actual medication counting logic
      return 0;
    } catch (e) {
      print('Error getting medications count: $e');
      return 0;
    }
  }

  /// Get count of critical health alerts for all family members
  Future<int> _getCriticalAlertsCount() async {
    try {
      // TODO: Implement actual alerts counting logic
      return 0;
    } catch (e) {
      print('Error getting alerts count: $e');
      return 0;
    }
  }

  /// Refresh all family data
  Future<void> refreshFamilyData() async {
    await initializeFamilyProfiles();
  }

  /// Helper methods for state management
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
    notifyListeners();
  }

  /// Clear all data (for logout)
  void clearData() {
    _familyOverview = null;
    _dependents.clear();
    _caregiverMode = const CaregiverMode();
    _currentActiveProfileId = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}

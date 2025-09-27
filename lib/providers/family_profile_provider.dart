import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/dependent_profile.dart';
import '../services/auth_service.dart';
import '../database/offline_database.dart';
import '../core/service_locator.dart';
import '../services/connectivity_service.dart';

/// Provider for managing family profiles, caregiver mode, and family health overview
class FamilyProfileProvider extends ChangeNotifier {
  // Dummy family members for demo (Hindi/Punjabi names)
  static final List<DependentProfile> demoDependents = [
    DependentProfile(
      id: 'mother',
      name: 'Sunita Devi',
      relation: 'Mother',
      dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 52)),
      gender: 'Female',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      primaryUserId: 'demo_user',
      medicalConditions: ['Diabetes'],
    ),
    DependentProfile(
      id: 'father',
      name: 'Rajesh Singh',
      relation: 'Father',
      dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 55)),
      gender: 'Male',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      primaryUserId: 'demo_user',
      medicalConditions: ['Hypertension'],
    ),
    DependentProfile(
      id: 'wife',
      name: 'Priya Kaur',
      relation: 'Wife',
      dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 26)),
      gender: 'Female',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      primaryUserId: 'demo_user',
      medicalConditions: ['Prenatal'],
    ),
    DependentProfile(
      id: 'son',
      name: 'Arjun Singh',
      relation: 'Son',
      dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 5)),
      gender: 'Male',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      primaryUserId: 'demo_user',
      medicalConditions: ['Vaccination'],
    ),
    DependentProfile(
      id: 'daughter',
      name: 'Simran Kaur',
      relation: 'Daughter',
      dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 3)),
      gender: 'Female',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      primaryUserId: 'demo_user',
      medicalConditions: ['Fever'],
    ),
  ];
  static const String _baseUrl = 'http://192.168.1.7:5002/api';

  final AuthService _authService = AuthService();
  late final OfflineDatabase _database;
  late final ConnectivityService _connectivityService;

  // Family profile state
  FamilyHealthOverview? _familyOverview;
  List<DependentProfile> _dependents = [];
  CaregiverMode _caregiverMode = const CaregiverMode();
  String? _currentActiveProfileId;

  // Loading and error states
  bool _isLoading = false;
  String? _error;

  // Initialization flag
  bool _isInitialized = false;

  // Getters
  FamilyHealthOverview? get familyOverview => _familyOverview;
  List<DependentProfile> get dependents => List.unmodifiable(_dependents);
  CaregiverMode get caregiverMode => _caregiverMode;
  String? get currentActiveProfileId => _currentActiveProfileId;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCaregiverModeActive => _caregiverMode.isActive;
  bool get isInitialized => _isInitialized;

  /// Initialize the provider with required services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _database = serviceLocator<OfflineDatabase>();
      _connectivityService = serviceLocator<ConnectivityService>();
      _isInitialized = true;
      print('✅ FamilyProfileProvider initialized with services');
    } catch (e) {
      print('❌ Error initializing FamilyProfileProvider: $e');
      rethrow;
    }
  }

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
    if (!_isInitialized) {
      await initialize();
    }

    _setLoading(true);
    _clearError();

    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Load data offline-first approach
      await _loadFamilyDataOfflineFirst(currentUser.id);

      // Try to sync with backend if connected
      if (await _connectivityService.isConnected) {
        try {
          await _syncWithBackend();
        } catch (e) {
          print('⚠️ Backend sync failed, using local data: $e');
        }
      }

      print('✅ Family profiles initialized successfully');
    } catch (e) {
      _setError('Failed to initialize family profiles: $e');
      print('❌ Error initializing family profiles: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Load family data using offline-first approach
  Future<void> _loadFamilyDataOfflineFirst(String userId) async {
    try {
      // For demo: always show dummy dependents
      _dependents = List<DependentProfile>.from(demoDependents);
      await _createEmptyFamilyOverview();
      notifyListeners();
    } catch (e) {
      print('Error loading family data locally: $e');
      // Initialize empty state
      _dependents = [];
      await _createEmptyFamilyOverview();
    }
  }

  /// Sync local data with backend
  Future<void> _syncWithBackend() async {
    try {
      final token = _authService.authToken;
      if (token == null) return;

      // Load backend data
      await Future.wait([_loadFamilyOverview(), _loadDependentProfiles()]);

      // TODO: Implement proper sync logic that merges local and remote changes
    } catch (e) {
      print('Error syncing with backend: $e');
      // Continue with local data
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

  /// Convert FamilyMember from database to DependentProfile
  DependentProfile _convertFamilyMemberToDependent(FamilyMember member) {
    return DependentProfile(
      id: member.id,
      primaryUserId: member.primaryUserId,
      name: member.name,
      relation: member.relationship,
      dateOfBirth: member.dateOfBirth,
      gender: member.gender,
      bloodGroup: member.bloodGroup ?? '',
      phoneNumber: member.phoneNumber ?? '',
      email: member.email ?? '',
      allergies:
          member.allergies?.split(',').map((a) => a.trim()).toList() ?? [],
      medications: [],
      medicalHistory: {},
      isPrimaryContact: false,
      hasOwnAccount: member.hasOwnAccount,
      linkedAccountId: member.linkedAccountId,
      allowIndependentAccess: member.allowIndependentAccess,
      caregiverPermissions: [],
      caregiverSettings: {},
      medicalConditions: [],
      emergencyInfo: {},
      createdAt: member.createdAt,
      updatedAt: member.lastModified,
    );
  }

  /// Create family overview from local data
  Future<void> _createFamilyOverviewFromLocal(
    String userId,
    FamilyGroup familyGroup,
    List<FamilyMember> familyMembers,
  ) async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      final totalMembers = familyMembers.length;
      final upcomingAppointments = await _getUpcomingAppointmentsCount();
      final pendingMedications = await _getPendingMedicationsCount();
      final criticalAlerts = await _getCriticalAlertsCount();

      _familyOverview = FamilyHealthOverview(
        primaryUserId: userId,
        primaryUserName: currentUser.name,
        dependents: _dependents,
        totalMembers: totalMembers,
        upcomingAppointments: upcomingAppointments,
        pendingMedications: pendingMedications,
        criticalAlerts: criticalAlerts,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      print('Error creating family overview from local data: $e');
    }
  }

  /// Create default family group for new users
  Future<void> _createDefaultFamilyGroup(String userId) async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      // Create family group
      final familyGroupId = await _database.createFamilyGroup(
        primaryMemberId: userId,
        familyName: '${currentUser.name}\'s Family',
        address: '',
        village: '',
        pincode: '',
        emergencyContact: '',
        emergencyPhone: '',
        healthInsurance: null,
      );

      // Create primary user as family member
      await _database.createFamilyMember(
        familyGroupId: familyGroupId,
        primaryUserId: userId,
        name: currentUser.name,
        relationship: 'Primary',
        dateOfBirth: DateTime.now().subtract(
          const Duration(days: 365 * 25),
        ), // Default age
        gender: 'Other',
        bloodGroup: '',
        phoneNumber: '',
        email: currentUser.email,
        allergies: '',
        medicalConditions: null,
        medications: null,
        emergencyContact: '',
        hasOwnAccount: true,
        linkedAccountId: userId,
        allowIndependentAccess: true,
        caregiverPermissions: null,
        profileImageUrl: '',
      );

      // Initialize empty overview
      await _createEmptyFamilyOverview();

      print('✅ Default family group created for user: $userId');
    } catch (e) {
      print('Error creating default family group: $e');
    }
  }

  /// Enhanced add dependent method with local database integration
  Future<void> addDependentProfileWithLocalSync(
    DependentProfile dependent,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Get or create family group
      final familyGroups = await _database.getFamilyGroups(currentUser.id);
      String familyGroupId;

      if (familyGroups.isNotEmpty) {
        familyGroupId = familyGroups.first.id;
      } else {
        // Create default family group
        await _createDefaultFamilyGroup(currentUser.id);
        final newFamilyGroups = await _database.getFamilyGroups(currentUser.id);
        familyGroupId = newFamilyGroups.first.id;
      }

      // Add to local database first
      final localMemberId = await _database.createFamilyMember(
        familyGroupId: familyGroupId,
        primaryUserId: currentUser.id,
        name: dependent.name,
        relationship: dependent.relation,
        dateOfBirth: dependent.dateOfBirth,
        gender: dependent.gender,
        bloodGroup: dependent.bloodGroup,
        phoneNumber: dependent.phoneNumber,
        email: dependent.email,
        allergies: dependent.allergies.join(', '),
        medicalConditions: null,
        medications: null,
        emergencyContact: '',
        hasOwnAccount: dependent.hasOwnAccount,
        linkedAccountId: dependent.linkedAccountId,
        allowIndependentAccess: dependent.allowIndependentAccess,
        caregiverPermissions: dependent.caregiverPermissions,
        profileImageUrl: '',
      );

      // Update local dependent with generated ID
      final updatedDependent = dependent.copyWith(id: localMemberId);
      _dependents.add(updatedDependent);

      // Try to sync with backend if connected
      if (await _connectivityService.isConnected) {
        try {
          await addDependentProfile(updatedDependent);
        } catch (e) {
          print('⚠️ Backend sync failed for new dependent, saved locally: $e');
        }
      }

      await _refreshFamilyOverview();
      notifyListeners();
    } catch (e) {
      _setError('Failed to add family member: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
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

  /// Enhanced sync functionality for family data
  Future<void> syncFamilyData() async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      _setLoading(true);
      _clearError();

      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      if (await _connectivityService.isConnected) {
        await _performFullSync(currentUser.id);
      } else {
        print('⚠️ No internet connection, using local data only');
        await _loadFamilyDataOfflineFirst(currentUser.id);
      }
    } catch (e) {
      _setError('Sync failed: $e');
      print('❌ Sync error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Perform full bidirectional sync between local and backend
  Future<void> _performFullSync(String userId) async {
    try {
      print('🔄 Starting full family data sync...');

      // 1. Load local data first for comparison
      final localFamilyGroups = await _database.getFamilyGroups(userId);
      List<FamilyMember> localMembers = [];

      if (localFamilyGroups.isNotEmpty) {
        localMembers = await _database.getFamilyMembers(
          localFamilyGroups.first.id,
        );
      }

      // 2. Load backend data
      await Future.wait([_loadFamilyOverview(), _loadDependentProfiles()]);

      // 3. Compare and sync differences
      await _syncLocalWithBackend(userId, localMembers);

      // 4. Update local data with backend changes
      await _updateLocalFromBackend(userId);

      print('✅ Full family data sync completed');
    } catch (e) {
      print('❌ Full sync failed: $e');
      throw e;
    }
  }

  /// Sync local changes to backend
  Future<void> _syncLocalWithBackend(
    String userId,
    List<FamilyMember> localMembers,
  ) async {
    try {
      // Find local members that don't exist in backend dependents
      final backendIds = _dependents.map((d) => d.id).toSet();
      final localOnlyMembers = localMembers
          .where((m) => m.primaryUserId != userId && !backendIds.contains(m.id))
          .toList();

      // Upload local-only members to backend
      for (final localMember in localOnlyMembers) {
        try {
          final dependent = _convertFamilyMemberToDependent(localMember);
          await addDependentProfile(dependent);
          print('📤 Uploaded local member to backend: ${localMember.name}');
        } catch (e) {
          print('⚠️ Failed to upload ${localMember.name}: $e');
        }
      }
    } catch (e) {
      print('❌ Error syncing local to backend: $e');
    }
  }

  /// Update local database with backend changes
  Future<void> _updateLocalFromBackend(String userId) async {
    try {
      // Get or create family group
      final familyGroups = await _database.getFamilyGroups(userId);
      String familyGroupId;

      if (familyGroups.isNotEmpty) {
        familyGroupId = familyGroups.first.id;
      } else {
        await _createDefaultFamilyGroup(userId);
        final newFamilyGroups = await _database.getFamilyGroups(userId);
        familyGroupId = newFamilyGroups.first.id;
      }

      final currentLocalMembers = await _database.getFamilyMembers(
        familyGroupId,
      );
      final localMemberIds = currentLocalMembers
          .where((m) => m.primaryUserId != userId)
          .map((m) => m.id)
          .toSet();

      // Add/update backend dependents in local database
      for (final dependent in _dependents) {
        if (!localMemberIds.contains(dependent.id)) {
          // New member from backend - add to local
          try {
            await _database.createFamilyMember(
              familyGroupId: familyGroupId,
              primaryUserId: userId,
              name: dependent.name,
              relationship: dependent.relation,
              dateOfBirth: dependent.dateOfBirth,
              gender: dependent.gender,
              bloodGroup: dependent.bloodGroup,
              phoneNumber: dependent.phoneNumber,
              email: dependent.email,
              allergies: dependent.allergies.join(', '),
              medicalConditions: null,
              medications: null,
              emergencyContact: '',
              hasOwnAccount: dependent.hasOwnAccount,
              linkedAccountId: dependent.linkedAccountId,
              allowIndependentAccess: dependent.allowIndependentAccess,
              caregiverPermissions: dependent.caregiverPermissions,
              profileImageUrl: '',
            );
            print('📥 Downloaded backend member to local: ${dependent.name}');
          } catch (e) {
            print('⚠️ Failed to download ${dependent.name}: $e');
          }
        }
      }

      // TODO: Handle member updates and deletions
      // For now, we're doing add-only sync to avoid conflicts
    } catch (e) {
      print('❌ Error updating local from backend: $e');
    }
  }

  /// Queue operation for later sync when offline
  Future<void> _queueSyncOperation(
    String operation,
    Map<String, dynamic> data,
  ) async {
    try {
      // Generate a simple unique ID for sync operations
      final id = data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();

      // For now, just log the operation. In a full implementation,
      // you would store this in a sync queue table
      print('📋 Queued operation for sync: $operation (ID: $id)');

      // Store operation details for future sync
      // This could be expanded to use a proper sync queue table
      final operationData = {
        'id': id,
        'operation': operation,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Log for debugging - in production, store in database
      debugPrint('Sync operation queued: ${jsonEncode(operationData)}');
    } catch (e) {
      print('❌ Failed to queue sync operation: $e');
    }
  }

  /// Enhanced add dependent with better sync support
  Future<void> addDependentWithSync(DependentProfile dependent) async {
    _setLoading(true);
    _clearError();

    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Always save locally first
      final localMemberId = await _addDependentLocally(
        currentUser.id,
        dependent,
      );
      final updatedDependent = dependent.copyWith(id: localMemberId);

      // Update local state immediately
      _dependents.add(updatedDependent);
      await _refreshFamilyOverview();
      notifyListeners();

      // Try to sync with backend
      if (await _connectivityService.isConnected) {
        try {
          await addDependentProfile(updatedDependent);
          print('✅ Dependent synced with backend: ${updatedDependent.name}');
        } catch (e) {
          print('⚠️ Backend sync failed, queuing for later: $e');
          await _queueSyncOperation(
            'CREATE_DEPENDENT',
            updatedDependent.toMap(),
          );
        }
      } else {
        // Queue for sync when online
        await _queueSyncOperation('CREATE_DEPENDENT', updatedDependent.toMap());
      }
    } catch (e) {
      _setError('Failed to add family member: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Add dependent to local database only
  Future<String> _addDependentLocally(
    String userId,
    DependentProfile dependent,
  ) async {
    // Get or create family group
    final familyGroups = await _database.getFamilyGroups(userId);
    String familyGroupId;

    if (familyGroups.isNotEmpty) {
      familyGroupId = familyGroups.first.id;
    } else {
      await _createDefaultFamilyGroup(userId);
      final newFamilyGroups = await _database.getFamilyGroups(userId);
      familyGroupId = newFamilyGroups.first.id;
    }

    // Add to local database
    return await _database.createFamilyMember(
      familyGroupId: familyGroupId,
      primaryUserId: userId,
      name: dependent.name,
      relationship: dependent.relation,
      dateOfBirth: dependent.dateOfBirth,
      gender: dependent.gender,
      bloodGroup: dependent.bloodGroup,
      phoneNumber: dependent.phoneNumber,
      email: dependent.email,
      allergies: dependent.allergies.join(', '),
      medicalConditions: null,
      medications: null,
      emergencyContact: '',
      hasOwnAccount: dependent.hasOwnAccount,
      linkedAccountId: dependent.linkedAccountId,
      allowIndependentAccess: dependent.allowIndependentAccess,
      caregiverPermissions: dependent.caregiverPermissions,
      profileImageUrl: '',
    );
  }

  /// Get sync status information
  Map<String, dynamic> getSyncStatus() {
    return {
      'isInitialized': _isInitialized,
      'isLoading': _isLoading,
      'hasError': _error != null,
      'error': _error,
      'dependentsCount': _dependents.length,
      'isCaregiverModeActive': _caregiverMode.isActive,
      'lastUpdated': _familyOverview?.lastUpdated,
    };
  }

  /// Force refresh with sync
  Future<void> forceRefreshWithSync() async {
    await syncFamilyData();
  }
}

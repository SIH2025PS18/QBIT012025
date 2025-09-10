import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/local_database.dart';
import '../models/patient_profile.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import '../services/supabase_auth_service.dart';
import 'patient_profile_repository.dart';

/// Offline-first repository for patient profiles
class OfflinePatientProfileRepository implements PatientProfileRepository {
  final LocalDatabase _localDb = LocalDatabase();
  final ConnectivityService _connectivity = ConnectivityService();
  final SyncService _sync = SyncService();
  final Uuid _uuid = const Uuid();

  @override
  Future<PatientProfile?> getCurrentProfile() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return null;

      // Try to get from local database first
      final localProfile = await _localDb.getPatientProfile(user.id);

      if (localProfile != null) {
        return _mapLocalToModelPatientProfile(localProfile);
      }

      // If not found locally and connected, trigger sync
      if (_connectivity.isConnected) {
        await _sync.syncNow();

        // Try again after sync
        final syncedProfile = await _localDb.getPatientProfile(user.id);
        if (syncedProfile != null) {
          return _mapLocalToModelPatientProfile(syncedProfile);
        }
      }

      return null;
    } catch (e) {
      // Even in case of error, try to return any cached profile data
      try {
        final user = AuthService.currentUser;
        if (user == null) return null;
        final localProfile = await _localDb.getPatientProfile(user.id);
        if (localProfile != null) {
          return _mapLocalToModelPatientProfile(localProfile);
        }
      } catch (cacheError) {
        // If even cache fails, return null
        return null;
      }
      return null;
    }
  }

  @override
  Future<PatientProfile> createProfile(PatientProfile profile) async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final localProfile = _mapModelToLocalPatientProfile(profile, user.id);

      // Save to local database
      await _localDb.upsertPatientProfile(localProfile);

      // Add sync operation
      final syncOperation = SyncOperation(
        id: 0, // Will be auto-generated
        tableNameColumn: 'patient_profiles',
        recordId: user.id,
        operation: 'create',
        data: jsonEncode(_mapLocalToSupabaseData(localProfile)),
        isCompleted: false,
        retryCount: 0,
        createdAt: DateTime.now(),
        lastRetryAt: null,
        errorMessage: null,
      );
      await _localDb.addSyncOperation(syncOperation);

      // Trigger sync if connected
      if (_connectivity.isConnected) {
        _sync.syncNow();
      }

      return profile;
    } catch (e) {
      // Even if online sync fails, profile is still available offline
      return profile;
    }
  }

  @override
  Future<PatientProfile> updateProfile(PatientProfile profile) async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final localProfile = _mapModelToLocalPatientProfile(profile, user.id);

      // Save to local database
      await _localDb.upsertPatientProfile(localProfile);

      // Add sync operation
      final syncOperation = SyncOperation(
        id: 0, // Will be auto-generated
        tableNameColumn: 'patient_profiles',
        recordId: user.id,
        operation: 'update',
        data: jsonEncode(_mapLocalToSupabaseData(localProfile)),
        isCompleted: false,
        retryCount: 0,
        createdAt: DateTime.now(),
        lastRetryAt: null,
        errorMessage: null,
      );
      await _localDb.addSyncOperation(syncOperation);

      // Trigger sync if connected
      if (_connectivity.isConnected) {
        _sync.syncNow();
      }

      return profile;
    } catch (e) {
      // Even if online sync fails, updated profile is still available offline
      return profile;
    }
  }

  @override
  Future<void> deleteProfile() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Mark for deletion in local database
      await _localDb.markPatientProfileForDeletion(user.id);

      // Add sync operation
      final syncOperation = SyncOperation(
        id: 0, // Will be auto-generated
        tableNameColumn: 'patient_profiles',
        recordId: user.id,
        operation: 'delete',
        data: null,
        isCompleted: false,
        retryCount: 0,
        createdAt: DateTime.now(),
        lastRetryAt: null,
        errorMessage: null,
      );
      await _localDb.addSyncOperation(syncOperation);

      // Trigger sync if connected
      if (_connectivity.isConnected) {
        _sync.syncNow();
      }
    } catch (e) {
      // Profile marked for deletion locally, will sync when connection is restored
    }
  }

  @override
  Future<bool> profileExists() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return false;

      final profile = await _localDb.getPatientProfile(user.id);
      return profile != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> uploadProfilePhoto(String filePath) async {
    // For now, return the file path as URL
    // In a real implementation, you would upload to Supabase storage
    // and handle offline scenarios by storing the file locally
    return filePath;
  }

  @override
  Future<void> deleteProfilePhoto(String photoUrl) async {
    // Handle profile photo deletion
    // In offline mode, mark for deletion and sync later
  }

  @override
  Future<PatientProfile?> getProfileById(String userId) async {
    try {
      final localProfile = await _localDb.getPatientProfile(userId);

      if (localProfile != null) {
        return _mapLocalToModelPatientProfile(localProfile);
      }

      return null;
    } catch (e) {
      // Return cached data even if there's an error
      try {
        final localProfile = await _localDb.getPatientProfile(userId);
        if (localProfile != null) {
          return _mapLocalToModelPatientProfile(localProfile);
        }
      } catch (cacheError) {
        return null;
      }
      return null;
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
      // For now, just return empty list as this is typically admin functionality
      // In a real implementation, you would search local database
      return [];
    } catch (e) {
      throw Exception('Failed to search profiles: $e');
    }
  }

  /// Map local database model to app model
  PatientProfile _mapLocalToModelPatientProfile(LocalPatientProfile local) {
    return PatientProfile(
      id: local.id,
      fullName: local.fullName,
      email: local.email,
      phoneNumber: local.phoneNumber ?? '',
      dateOfBirth: local.dateOfBirth ?? DateTime.now(),
      gender: local.gender ?? '',
      bloodGroup: local.bloodGroup ?? '',
      address: local.address ?? '',
      emergencyContact: local.emergencyContact ?? '',
      emergencyContactPhone: local.emergencyContactPhone ?? '',
      profilePhotoUrl: local.profilePhotoUrl ?? '',
      allergies: List<String>.from(jsonDecode(local.allergies)),
      medications: List<String>.from(jsonDecode(local.medications)),
      medicalHistory: Map<String, dynamic>.from(
        jsonDecode(local.medicalHistory),
      ),
      lastVisit: local.lastVisit,
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
    );
  }

  /// Map app model to local database model
  LocalPatientProfile _mapModelToLocalPatientProfile(
    PatientProfile profile,
    String userId,
  ) {
    final now = DateTime.now();

    return LocalPatientProfile(
      id: userId,
      fullName: profile.fullName,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      bloodGroup: profile.bloodGroup,
      address: profile.address,
      emergencyContact: profile.emergencyContact,
      emergencyContactPhone: profile.emergencyContactPhone,
      profilePhotoUrl: profile.profilePhotoUrl,
      allergies: jsonEncode(profile.allergies),
      medications: jsonEncode(profile.medications),
      medicalHistory: jsonEncode(profile.medicalHistory),
      lastVisit: profile.lastVisit,
      createdAt: profile.createdAt,
      updatedAt: now,
      isSynced: false,
      lastSyncAt: null,
      pendingDelete: false,
      syncVersion: '1',
    );
  }

  /// Map local profile to Supabase data format
  Map<String, dynamic> _mapLocalToSupabaseData(LocalPatientProfile local) {
    return {
      'id': local.id,
      'full_name': local.fullName,
      'email': local.email,
      'phone_number': local.phoneNumber,
      'date_of_birth': local.dateOfBirth?.toIso8601String(),
      'gender': local.gender,
      'blood_group': local.bloodGroup,
      'address': local.address,
      'emergency_contact': local.emergencyContact,
      'emergency_contact_phone': local.emergencyContactPhone,
      'profile_photo_url': local.profilePhotoUrl,
      'allergies': jsonDecode(local.allergies),
      'medications': jsonDecode(local.medications),
      'medical_history': jsonDecode(local.medicalHistory),
      'last_visit': local.lastVisit?.toIso8601String(),
      'created_at': local.createdAt.toIso8601String(),
      'updated_at': local.updatedAt.toIso8601String(),
    };
  }

  /// Get sync status for profile
  Future<bool> isProfileSynced() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return true;

      final localProfile = await _localDb.getPatientProfile(user.id);
      return localProfile?.isSynced ?? true;
    } catch (e) {
      return false;
    }
  }

  /// Force sync profile
  Future<void> forceSyncProfile() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    await _sync.forceSyncRecord('patient_profiles', user.id);
  }

  /// Ensure profile data is cached for offline access
  Future<void> ensureProfileCached(String userId) async {
    try {
      // Try to get profile from local database
      final localProfile = await _localDb.getPatientProfile(userId);

      // If not found and connected, sync from server
      if (localProfile == null && _connectivity.isConnected) {
        await _sync.syncNow();
      }
    } catch (e) {
      // Silently fail, we don't want to interrupt the user experience
    }
  }
}

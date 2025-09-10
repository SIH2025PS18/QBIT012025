import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';

import '../database/local_database.dart';
import '../services/connectivity_service.dart';
import '../services/supabase_auth_service.dart';

/// Enum for sync status
enum SyncStatus { synced, syncing, pendingSync, offline, error }

/// Extension for sync status display
extension SyncStatusExtension on SyncStatus {
  String get displayName {
    switch (this) {
      case SyncStatus.synced:
        return 'Synced';
      case SyncStatus.syncing:
        return 'Syncing...';
      case SyncStatus.pendingSync:
        return 'Pending Sync';
      case SyncStatus.offline:
        return 'Offline';
      case SyncStatus.error:
        return 'Sync Error';
    }
  }
}

/// Service for synchronizing local data with Supabase
class SyncService extends ChangeNotifier {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final LocalDatabase _localDb = LocalDatabase();
  final ConnectivityService _connectivity = ConnectivityService();
  Timer? _periodicSyncTimer;

  SyncStatus _syncStatus = SyncStatus.offline;
  bool _isSyncing = false;
  int _pendingSyncCount = 0;
  DateTime? _lastSyncTime;
  String? _lastSyncError;

  /// Current sync status
  SyncStatus get syncStatus => _syncStatus;

  /// Whether sync is currently in progress
  bool get isSyncing => _isSyncing;

  /// Number of pending sync operations
  int get pendingSyncCount => _pendingSyncCount;

  /// Last successful sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Last sync error message
  String? get lastSyncError => _lastSyncError;

  /// Initialize sync service
  Future<void> initialize() async {
    try {
      // Update sync status based on connectivity
      _updateSyncStatus();

      // Listen to connectivity changes
      _connectivity.addListener(_onConnectivityChanged);

      // Start periodic sync when connected
      if (_connectivity.isConnected) {
        _startPeriodicSync();
      }

      // Update pending sync count
      await _updatePendingSyncCount();

      debugPrint('SyncService initialized');
    } catch (e) {
      debugPrint('Failed to initialize SyncService: $e');
    }
  }

  /// Handle connectivity changes
  void _onConnectivityChanged() {
    _updateSyncStatus();

    if (_connectivity.isConnected) {
      _startPeriodicSync();
      // Trigger immediate sync when connection is restored
      syncNow();
    } else {
      _stopPeriodicSync();
    }
  }

  /// Update sync status based on current state
  void _updateSyncStatus() {
    if (!_connectivity.isConnected) {
      _syncStatus = SyncStatus.offline;
    } else if (_isSyncing) {
      _syncStatus = SyncStatus.syncing;
    } else if (_pendingSyncCount > 0) {
      _syncStatus = SyncStatus.pendingSync;
    } else if (_lastSyncError != null) {
      _syncStatus = SyncStatus.error;
    } else {
      _syncStatus = SyncStatus.synced;
    }

    notifyListeners();
  }

  /// Start periodic sync
  void _startPeriodicSync() {
    _stopPeriodicSync();

    // Sync every 5 minutes when connected
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => syncNow(),
    );
  }

  /// Stop periodic sync
  void _stopPeriodicSync() {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;
  }

  /// Update pending sync count
  Future<void> _updatePendingSyncCount() async {
    try {
      final operations = await _localDb.getPendingSyncOperations();
      _pendingSyncCount = operations.length;
      _updateSyncStatus();
    } catch (e) {
      debugPrint('Error updating pending sync count: $e');
    }
  }

  /// Sync now
  Future<void> syncNow() async {
    if (_isSyncing || !_connectivity.isConnected) {
      return;
    }

    _isSyncing = true;
    _lastSyncError = null;
    _updateSyncStatus();

    try {
      // Sync priority data first
      await _syncPriorityData();

      // Then sync regular data
      await _syncPatientProfiles();
      await _syncAppointments();
      await _syncHealthRecords();
      await _syncDoctors();

      // Process sync operations
      await _processPendingSyncOperations();

      _lastSyncTime = DateTime.now();
      await _updatePendingSyncCount();

      debugPrint('Sync completed successfully');
    } on AuthRetryableFetchException catch (e) {
      _lastSyncError = 'Network authentication error: ${e.message}';
      debugPrint('Sync failed due to auth network error: $e');
    } on SocketException catch (e) {
      _lastSyncError = 'Network connection error: ${e.message}';
      debugPrint('Sync failed due to network error: $e');
    } catch (e) {
      _lastSyncError = e.toString();
      debugPrint('Sync failed: $e');
    } finally {
      _isSyncing = false;
      _updateSyncStatus();
    }
  }

  /// Sync priority data (critical health information)
  Future<void> _syncPriorityData() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return;

      // Get all pending sync operations
      final operations = await _localDb.getPendingSyncOperations();

      // Filter for critical health data (health records with high severity)
      final criticalOperations = operations.where((op) {
        // Health records are considered critical
        if (op.tableNameColumn == 'health_records') {
          return true;
        }

        // Emergency appointments are critical
        if (op.tableNameColumn == 'appointments' && op.data != null) {
          try {
            final data = jsonDecode(op.data!);
            final status = data['status'] as String?;
            return status == 'emergency' || status == 'urgent';
          } catch (e) {
            return false;
          }
        }

        return false;
      }).toList();

      // Process critical operations first
      for (final operation in criticalOperations) {
        try {
          await _processSyncOperation(operation);
          await _localDb.markSyncOperationAsCompleted(operation.id);
        } catch (e) {
          await _localDb.updateSyncOperationRetry(operation.id, e.toString());
          debugPrint(
            'Error processing critical sync operation ${operation.id}: $e',
          );
        }
      }
    } catch (e) {
      debugPrint('Error syncing priority data: $e');
    }
  }

  /// Sync patient profiles
  Future<void> _syncPatientProfiles() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return;

      // Download from Supabase
      final response = await Supabase.instance.client
          .from('patient_profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        final localProfile = await _localDb.getPatientProfile(user.id);

        // Conflict resolution: Check if local version is newer
        if (localProfile != null &&
            localProfile.updatedAt.isAfter(
              DateTime.parse(response['updated_at']),
            )) {
          // Local version is newer, upload it
          await _uploadLocalPatientProfile(localProfile);
        } else {
          // Server version is newer or equal, download it
          final serverProfile = _mapSupabaseToLocalPatientProfile(response);
          await _localDb.upsertPatientProfile(serverProfile);
        }
      }
    } on AuthRetryableFetchException catch (e) {
      // Handle authentication network errors gracefully
      debugPrint(
        'Authentication network error during patient profile sync: $e',
      );
      // Don't rethrow - let sync continue with other data
    } on SocketException catch (e) {
      // Handle network errors gracefully
      debugPrint('Network error during patient profile sync: $e');
      // Don't rethrow - let sync continue with other data
    } catch (e) {
      debugPrint('Error syncing patient profiles: $e');
      // Only rethrow for critical errors, not network issues
      if (!_isNetworkError(e)) {
        rethrow;
      }
    }
  }

  /// Sync appointments
  Future<void> _syncAppointments() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return;

      // Download from Supabase
      final response = await Supabase.instance.client
          .from('appointments')
          .select()
          .eq('patient_id', user.id)
          .order('appointment_date', ascending: false);

      for (final appointmentData in response) {
        final localAppointment = await _localDb.getAppointment(
          appointmentData['id'],
        );

        // Conflict resolution: Check if local version is newer
        if (localAppointment != null &&
            localAppointment.updatedAt.isAfter(
              DateTime.parse(appointmentData['updated_at']),
            )) {
          // Local version is newer, upload it
          await _uploadLocalAppointment(localAppointment);
        } else {
          // Server version is newer or equal, download it
          final serverAppointment = _mapSupabaseToLocalAppointment(
            appointmentData,
          );
          await _localDb.upsertAppointment(serverAppointment);
        }
      }
    } on AuthRetryableFetchException catch (e) {
      // Handle authentication network errors gracefully
      debugPrint('Authentication network error during appointments sync: $e');
      // Don't rethrow - let sync continue
    } on SocketException catch (e) {
      // Handle network errors gracefully
      debugPrint('Network error during appointments sync: $e');
      // Don't rethrow - let sync continue
    } catch (e) {
      debugPrint('Error syncing appointments: $e');
      // Only rethrow for critical errors, not network issues
      if (!_isNetworkError(e)) {
        rethrow;
      }
    }
  }

  /// Sync health records
  Future<void> _syncHealthRecords() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return;

      // Download from Supabase
      final response = await Supabase.instance.client
          .from('health_records')
          .select()
          .eq('patient_id', user.id)
          .order('record_date', ascending: false);

      for (final recordData in response) {
        final localRecord = await _localDb.getHealthRecord(recordData['id']);

        // Conflict resolution: Check if local version is newer
        if (localRecord != null &&
            localRecord.updatedAt.isAfter(
              DateTime.parse(recordData['updated_at']),
            )) {
          // Local version is newer, upload it
          await _uploadLocalHealthRecord(localRecord);
        } else {
          // Server version is newer or equal, download it
          final serverRecord = _mapSupabaseToLocalHealthRecord(recordData);
          await _localDb.upsertHealthRecord(serverRecord);
        }
      }
    } on AuthRetryableFetchException catch (e) {
      // Handle authentication network errors gracefully
      debugPrint('Authentication network error during health records sync: $e');
      // Don't rethrow - let sync continue
    } on SocketException catch (e) {
      // Handle network errors gracefully
      debugPrint('Network error during health records sync: $e');
      // Don't rethrow - let sync continue
    } catch (e) {
      debugPrint('Error syncing health records: $e');
      // Only rethrow for critical errors, not network issues
      if (!_isNetworkError(e)) {
        rethrow;
      }
    }
  }

  /// Sync doctors
  Future<void> _syncDoctors() async {
    try {
      // Download from Supabase
      final response = await Supabase.instance.client
          .from('doctors')
          .select()
          .eq('is_available', true)
          .order('rating', ascending: false);

      for (final doctorData in response) {
        final localDoctor = await _localDb.getDoctor(doctorData['id']);

        // Conflict resolution: Check if local version is newer
        if (localDoctor != null &&
            localDoctor.updatedAt.isAfter(
              DateTime.parse(doctorData['updated_at']),
            )) {
          // Local version is newer, upload it
          await _uploadLocalDoctor(localDoctor);
        } else {
          // Server version is newer or equal, download it
          final serverDoctor = _mapSupabaseToLocalDoctor(doctorData);
          await _localDb.upsertDoctor(serverDoctor);
        }
      }
    } on AuthRetryableFetchException catch (e) {
      // Handle authentication network errors gracefully
      debugPrint('Authentication network error during doctors sync: $e');
      // Don't rethrow - let sync continue
    } on SocketException catch (e) {
      // Handle network errors gracefully
      debugPrint('Network error during doctors sync: $e');
      // Don't rethrow - let sync continue
    } catch (e) {
      debugPrint('Error syncing doctors: $e');
      // Only rethrow for critical errors, not network issues
      if (!_isNetworkError(e)) {
        rethrow;
      }
    }
  }

  /// Process pending sync operations
  Future<void> _processPendingSyncOperations() async {
    try {
      final operations = await _localDb.getPendingSyncOperations();

      for (final operation in operations) {
        try {
          await _processSyncOperation(operation);
          await _localDb.markSyncOperationAsCompleted(operation.id);
        } on AuthRetryableFetchException catch (e) {
          // Handle authentication network errors gracefully
          await _localDb.updateSyncOperationRetry(operation.id, e.toString());
          debugPrint(
            'Auth network error processing sync operation ${operation.id}: $e',
          );
        } on SocketException catch (e) {
          // Handle network errors gracefully
          await _localDb.updateSyncOperationRetry(operation.id, e.toString());
          debugPrint(
            'Network error processing sync operation ${operation.id}: $e',
          );
        } catch (e) {
          await _localDb.updateSyncOperationRetry(operation.id, e.toString());
          debugPrint('Error processing sync operation ${operation.id}: $e');
        }
      }
    } catch (e) {
      debugPrint('Error processing pending sync operations: $e');
      // Only rethrow for critical errors, not network issues
      if (!_isNetworkError(e)) {
        rethrow;
      }
    }
  }

  /// Process individual sync operation
  Future<void> _processSyncOperation(SyncOperation operation) async {
    switch (operation.tableNameColumn) {
      case 'patient_profiles':
        await _processSyncOperationForTable(
          operation,
          'patient_profiles',
          operation.data != null ? jsonDecode(operation.data!) : null,
        );
        break;
      case 'appointments':
        await _processSyncOperationForTable(
          operation,
          'appointments',
          operation.data != null ? jsonDecode(operation.data!) : null,
        );
        break;
      case 'health_records':
        await _processSyncOperationForTable(
          operation,
          'health_records',
          operation.data != null ? jsonDecode(operation.data!) : null,
        );
        break;
      default:
        throw Exception('Unknown table: ${operation.tableNameColumn}');
    }
  }

  /// Process sync operation for specific table
  Future<void> _processSyncOperationForTable(
    SyncOperation operation,
    String tableName,
    Map<String, dynamic>? data,
  ) async {
    final supabase = Supabase.instance.client;

    switch (operation.operation) {
      case 'create':
      case 'update':
        if (data != null) {
          await supabase.from(tableName).upsert(data);
        }
        break;
      case 'delete':
        await supabase.from(tableName).delete().eq('id', operation.recordId);
        break;
      default:
        throw Exception('Unknown operation: ${operation.operation}');
    }
  }

  /// Force sync specific record
  Future<void> forceSyncRecord(String tableName, String recordId) async {
    if (!_connectivity.isConnected) {
      throw Exception('No internet connection');
    }

    try {
      final operations = await _localDb.getPendingSyncOperations();
      final recordOperations = operations
          .where(
            (op) => op.tableNameColumn == tableName && op.recordId == recordId,
          )
          .toList();

      for (final operation in recordOperations) {
        await _processSyncOperation(operation);
        await _localDb.markSyncOperationAsCompleted(operation.id);
      }

      await _updatePendingSyncCount();
    } catch (e) {
      debugPrint('Error force syncing record: $e');
      rethrow;
    }
  }

  /// Force sync critical data immediately
  Future<void> forceSyncCriticalData() async {
    if (!_connectivity.isConnected) {
      throw Exception('No internet connection');
    }

    try {
      await _syncPriorityData();
      await _updatePendingSyncCount();
    } catch (e) {
      debugPrint('Error force syncing critical data: $e');
      rethrow;
    }
  }

  /// Upload local patient profile
  Future<void> _uploadLocalPatientProfile(
    LocalPatientProfile localProfile,
  ) async {
    try {
      final supabase = Supabase.instance.client;
      final data = _mapLocalToSupabasePatientProfileData(localProfile);
      await supabase.from('patient_profiles').upsert(data);

      // Mark as synced locally
      final syncedProfile = localProfile.copyWith(
        isSynced: true,
        lastSyncAt: Value(DateTime.now()),
      );
      await _localDb.upsertPatientProfile(syncedProfile);
    } catch (e) {
      debugPrint('Error uploading local patient profile: $e');
      rethrow;
    }
  }

  /// Upload local appointment
  Future<void> _uploadLocalAppointment(
    LocalAppointment localAppointment,
  ) async {
    try {
      final supabase = Supabase.instance.client;
      final data = _mapLocalToSupabaseAppointmentData(localAppointment);
      await supabase.from('appointments').upsert(data);

      // Mark as synced locally
      final syncedAppointment = localAppointment.copyWith(
        isSynced: true,
        lastSyncAt: Value(DateTime.now()),
      );
      await _localDb.upsertAppointment(syncedAppointment);
    } catch (e) {
      debugPrint('Error uploading local appointment: $e');
      rethrow;
    }
  }

  /// Upload local health record
  Future<void> _uploadLocalHealthRecord(LocalHealthRecord localRecord) async {
    try {
      final supabase = Supabase.instance.client;
      final data = _mapLocalToSupabaseHealthRecordData(localRecord);
      await supabase.from('health_records').upsert(data);

      // Mark as synced locally
      final syncedRecord = localRecord.copyWith(
        isSynced: true,
        lastSyncAt: Value(DateTime.now()),
      );
      await _localDb.upsertHealthRecord(syncedRecord);
    } catch (e) {
      debugPrint('Error uploading local health record: $e');
      rethrow;
    }
  }

  /// Upload local doctor
  Future<void> _uploadLocalDoctor(LocalDoctor localDoctor) async {
    try {
      final supabase = Supabase.instance.client;
      final data = _mapLocalToSupabaseDoctorData(localDoctor);
      await supabase.from('doctors').upsert(data);

      // Mark as synced locally
      final syncedDoctor = localDoctor.copyWith(
        isSynced: true,
        lastSyncAt: Value(DateTime.now()),
      );
      await _localDb.upsertDoctor(syncedDoctor);
    } catch (e) {
      debugPrint('Error uploading local doctor: $e');
      rethrow;
    }
  }

  /// Map Supabase data to local patient profile
  LocalPatientProfile _mapSupabaseToLocalPatientProfile(
    Map<String, dynamic> data,
  ) {
    return LocalPatientProfile(
      id: data['id'],
      fullName: data['full_name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phone_number'],
      dateOfBirth: data['date_of_birth'] != null
          ? DateTime.parse(data['date_of_birth'])
          : null,
      gender: data['gender'],
      bloodGroup: data['blood_group'],
      address: data['address'],
      emergencyContact: data['emergency_contact'],
      emergencyContactPhone: data['emergency_contact_phone'],
      profilePhotoUrl: data['profile_photo_url'],
      allergies: jsonEncode(data['allergies'] ?? []),
      medications: jsonEncode(data['medications'] ?? []),
      medicalHistory: jsonEncode(data['medical_history'] ?? {}),
      lastVisit: data['last_visit'] != null
          ? DateTime.parse(data['last_visit'])
          : null,
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
      isSynced: true,
      lastSyncAt: DateTime.now(),
      pendingDelete: false,
      syncVersion: '1',
    );
  }

  /// Map Supabase data to local appointment
  LocalAppointment _mapSupabaseToLocalAppointment(Map<String, dynamic> data) {
    return LocalAppointment(
      id: data['id'],
      patientId: data['patient_id'],
      doctorId: data['doctor_id'],
      doctorName: data['doctor_name'],
      doctorSpecialization: data['doctor_specialization'],
      appointmentDate: DateTime.parse(data['appointment_date']),
      appointmentTime: DateTime.parse(data['appointment_time']),
      status: data['status'] ?? 'scheduled',
      notes: data['notes'],
      patientSymptoms: data['patient_symptoms'],
      consultationFee: (data['consultation_fee'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
      isSynced: true,
      lastSyncAt: DateTime.now(),
      pendingDelete: false,
      syncVersion: '1',
    );
  }

  /// Map Supabase data to local health record
  LocalHealthRecord _mapSupabaseToLocalHealthRecord(Map<String, dynamic> data) {
    return LocalHealthRecord(
      id: data['id'],
      patientId: data['patient_id'],
      doctorId: data['doctor_id'],
      appointmentId: data['appointment_id'],
      recordType: data['record_type'] ?? 'general',
      title: data['title'] ?? '',
      description: data['description'],
      attachmentUrl: data['attachment_url'],
      metadata: jsonEncode(data['metadata'] ?? {}),
      recordDate: DateTime.parse(data['record_date']),
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
      isSynced: true,
      lastSyncAt: DateTime.now(),
      pendingDelete: false,
      syncVersion: '1',
    );
  }

  /// Map Supabase data to local doctor
  LocalDoctor _mapSupabaseToLocalDoctor(Map<String, dynamic> data) {
    return LocalDoctor(
      id: data['id'],
      fullName: data['full_name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phone_number'],
      specialization: data['specialization'] ?? '',
      qualification: data['qualification'],
      experience: data['experience'],
      profilePhotoUrl: data['profile_photo_url'],
      about: data['about'],
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['total_reviews'] ?? 0,
      consultationFee: (data['consultation_fee'] ?? 0.0).toDouble(),
      isAvailable: data['is_available'] ?? true,
      isOnline: data['is_online'] ?? false,
      availableSlots: jsonEncode(data['available_slots'] ?? []),
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
      isSynced: true,
      lastSyncAt: DateTime.now(),
      pendingDelete: false,
      syncVersion: '1',
    );
  }

  /// Map local patient profile to Supabase data format
  Map<String, dynamic> _mapLocalToSupabasePatientProfileData(
    LocalPatientProfile local,
  ) {
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

  /// Map local appointment to Supabase data format
  Map<String, dynamic> _mapLocalToSupabaseAppointmentData(
    LocalAppointment local,
  ) {
    return {
      'id': local.id,
      'patient_id': local.patientId,
      'doctor_id': local.doctorId,
      'doctor_name': local.doctorName,
      'doctor_specialization': local.doctorSpecialization,
      'appointment_date': local.appointmentDate.toIso8601String(),
      'appointment_time': local.appointmentTime.toIso8601String(),
      'status': local.status,
      'notes': local.notes,
      'patient_symptoms': local.patientSymptoms,
      'consultation_fee': local.consultationFee,
      'created_at': local.createdAt.toIso8601String(),
      'updated_at': local.updatedAt.toIso8601String(),
    };
  }

  /// Map local health record to Supabase data format
  Map<String, dynamic> _mapLocalToSupabaseHealthRecordData(
    LocalHealthRecord local,
  ) {
    return {
      'id': local.id,
      'patient_id': local.patientId,
      'doctor_id': local.doctorId,
      'appointment_id': local.appointmentId,
      'record_type': local.recordType,
      'title': local.title,
      'description': local.description,
      'attachment_url': local.attachmentUrl,
      'metadata': jsonDecode(local.metadata ?? '{}'),
      'record_date': local.recordDate.toIso8601String(),
      'created_at': local.createdAt.toIso8601String(),
      'updated_at': local.updatedAt.toIso8601String(),
    };
  }

  /// Map local doctor to Supabase data format
  Map<String, dynamic> _mapLocalToSupabaseDoctorData(LocalDoctor local) {
    return {
      'id': local.id,
      'full_name': local.fullName,
      'email': local.email,
      'phone_number': local.phoneNumber,
      'specialization': local.specialization,
      'qualification': local.qualification,
      'experience': local.experience,
      'profile_photo_url': local.profilePhotoUrl,
      'about': local.about,
      'rating': local.rating,
      'total_reviews': local.totalReviews,
      'consultation_fee': local.consultationFee,
      'is_available': local.isAvailable,
      'is_online': local.isOnline,
      'available_slots': jsonDecode(local.availableSlots),
      'created_at': local.createdAt.toIso8601String(),
      'updated_at': local.updatedAt.toIso8601String(),
    };
  }

  /// Check if an error is a network-related error
  bool _isNetworkError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('socketexception') ||
        errorString.contains('failed host lookup') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout');
  }

  /// Dispose of resources
  @override
  void dispose() {
    _stopPeriodicSync();
    _connectivity.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}

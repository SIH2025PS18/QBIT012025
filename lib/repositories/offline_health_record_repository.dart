import 'dart:convert';
import 'package:uuid/uuid.dart';

import '../database/local_database.dart';
import '../models/health_record.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import '../services/auth_service.dart';

/// Repository interface for health records
abstract class HealthRecordRepository {
  Future<List<HealthRecord>> getPatientHealthRecords(String patientId);
  Future<HealthRecord?> getHealthRecord(String recordId);
  Future<HealthRecord> createHealthRecord(HealthRecord record);
  Future<HealthRecord> updateHealthRecord(HealthRecord record);
  Future<void> deleteHealthRecord(String recordId);
}

/// Offline-first repository for health records
class OfflineHealthRecordRepository implements HealthRecordRepository {
  final LocalDatabase _localDb = LocalDatabase();
  final ConnectivityService _connectivity = ConnectivityService();
  final SyncService _sync = SyncService();
  final Uuid _uuid = const Uuid();

  @override
  Future<List<HealthRecord>> getPatientHealthRecords(String patientId) async {
    try {
      final localRecords = await _localDb.getHealthRecordsForPatient(patientId);

      // Convert to app models
      final records = localRecords.map(_mapLocalToModelHealthRecord).toList();

      // Trigger sync if connected
      if (_connectivity.isConnected) {
        _sync.syncNow();
      }

      return records;
    } catch (e) {
      // Return cached data even if there's an error
      try {
        final localRecords = await _localDb.getHealthRecordsForPatient(
          patientId,
        );
        return localRecords.map(_mapLocalToModelHealthRecord).toList();
      } catch (cacheError) {
        return [];
      }
    }
  }

  @override
  Future<HealthRecord?> getHealthRecord(String recordId) async {
    try {
      final localRecord = await _localDb.getHealthRecord(recordId);

      if (localRecord != null) {
        return _mapLocalToModelHealthRecord(localRecord);
      }

      return null;
    } catch (e) {
      // Return cached data even if there's an error
      try {
        final localRecord = await _localDb.getHealthRecord(recordId);
        if (localRecord != null) {
          return _mapLocalToModelHealthRecord(localRecord);
        }
      } catch (cacheError) {
        return null;
      }
      return null;
    }
  }

  @override
  Future<HealthRecord> createHealthRecord(HealthRecord record) async {
    try {
      // Generate ID if not provided
      final recordId = record.id.isEmpty ? _uuid.v4() : record.id;
      final recordWithId = HealthRecord(
        id: recordId,
        patientId: record.patientId,
        appointmentId: record.appointmentId,
        recordType: record.recordType,
        title: record.title,
        description: record.description,
        data: record.data,
        attachments: record.attachments,
        createdBy: record.createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final localRecord = _mapModelToLocalHealthRecord(recordWithId);

      // Save to local database
      await _localDb.upsertHealthRecord(localRecord);

      // Add sync operation
      final syncOperation = SyncOperation(
        id: 0, // Will be auto-generated
        tableNameColumn: 'health_records',
        recordId: recordId,
        operation: 'create',
        data: jsonEncode(_mapLocalToSupabaseData(localRecord)),
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

      return recordWithId;
    } catch (e) {
      // Even if online sync fails, record is still available offline
      final recordId = record.id.isEmpty ? _uuid.v4() : record.id;
      final recordWithId = HealthRecord(
        id: recordId,
        patientId: record.patientId,
        appointmentId: record.appointmentId,
        recordType: record.recordType,
        title: record.title,
        description: record.description,
        data: record.data,
        attachments: record.attachments,
        createdBy: record.createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final localRecord = _mapModelToLocalHealthRecord(recordWithId);

      // Save to local database
      await _localDb.upsertHealthRecord(localRecord);

      return recordWithId;
    }
  }

  @override
  Future<HealthRecord> updateHealthRecord(HealthRecord record) async {
    try {
      final updatedRecord = record.copyWith(updatedAt: DateTime.now());

      final localRecord = _mapModelToLocalHealthRecord(updatedRecord);

      // Save to local database
      await _localDb.upsertHealthRecord(localRecord);

      // Add sync operation
      final syncOperation = SyncOperation(
        id: 0, // Will be auto-generated
        tableNameColumn: 'health_records',
        recordId: record.id,
        operation: 'update',
        data: jsonEncode(_mapLocalToSupabaseData(localRecord)),
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

      return updatedRecord;
    } catch (e) {
      // Even if online sync fails, updated record is still available offline
      final updatedRecord = record.copyWith(updatedAt: DateTime.now());

      final localRecord = _mapModelToLocalHealthRecord(updatedRecord);

      // Save to local database
      await _localDb.upsertHealthRecord(localRecord);

      return updatedRecord;
    }
  }

  @override
  Future<void> deleteHealthRecord(String recordId) async {
    try {
      // Mark for deletion in local database
      await _localDb.markHealthRecordForDeletion(recordId);

      // Add sync operation
      final syncOperation = SyncOperation(
        id: 0, // Will be auto-generated
        tableNameColumn: 'health_records',
        recordId: recordId,
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
      // Even if online sync fails, record is marked for deletion offline
      try {
        await _localDb.markHealthRecordForDeletion(recordId);
      } catch (cacheError) {
        // Silently fail
      }
    }
  }

  /// Map local database model to app model
  HealthRecord _mapLocalToModelHealthRecord(LocalHealthRecord local) {
    return HealthRecord(
      id: local.id,
      patientId: local.patientId,
      appointmentId: local.appointmentId,
      recordType: local.recordType,
      title: local.title,
      description: local.description ?? '',
      data: Map<String, dynamic>.from(jsonDecode(local.metadata ?? '{}')),
      attachments: [], // Attachments would need special handling
      createdBy: null, // Not stored locally
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
    );
  }

  /// Map app model to local database model
  LocalHealthRecord _mapModelToLocalHealthRecord(HealthRecord record) {
    return LocalHealthRecord(
      id: record.id,
      patientId: record.patientId,
      appointmentId: record.appointmentId,
      recordType: record.recordType,
      title: record.title,
      description: record.description,
      attachmentUrl: record.attachments.isNotEmpty
          ? record.attachments[0]
          : null,
      metadata: jsonEncode(record.data),
      recordDate: record.createdAt,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      isSynced: false,
      lastSyncAt: null,
      pendingDelete: false,
      syncVersion: '1',
    );
  }

  /// Map local health record to MongoDB backend data format
  Map<String, dynamic> _mapLocalToSupabaseData(LocalHealthRecord local) {
    return {
      'id': local.id,
      'patientId': local.patientId,
      'appointmentId': local.appointmentId,
      'recordType': local.recordType,
      'title': local.title,
      'description': local.description,
      'attachmentUrl': local.attachmentUrl,
      'metadata': jsonDecode(local.metadata ?? '{}'),
      'recordDate': local.recordDate.toIso8601String(),
      'createdAt': local.createdAt.toIso8601String(),
      'updatedAt': local.updatedAt.toIso8601String(),
    };
  }

  /// Get sync status for health records
  Future<List<HealthRecord>> getUnsyncedHealthRecords() async {
    try {
      final localRecords = await _localDb.getUnsyncedHealthRecords();
      return localRecords.map(_mapLocalToModelHealthRecord).toList();
    } catch (e) {
      throw Exception('Failed to get unsynced health records: $e');
    }
  }

  /// Force sync health records
  Future<void> forceSyncHealthRecords() async {
    final user = await AuthService().getCurrentUser();
    if (user == null) return;

    final unsyncedRecords = await _localDb.getUnsyncedHealthRecords();
    for (final record in unsyncedRecords) {
      await _sync.forceSyncRecord('health_records', record.id);
    }
  }

  /// Ensure health records are cached for offline access
  Future<void> ensureHealthRecordsCached(String patientId) async {
    try {
      // Try to get records from local database
      final localRecords = await _localDb.getHealthRecordsForPatient(patientId);

      // If not found and connected, sync from server
      if (localRecords.isEmpty && _connectivity.isConnected) {
        await _sync.syncNow();
      }
    } catch (e) {
      // Silently fail, we don't want to interrupt the user experience
    }
  }
}

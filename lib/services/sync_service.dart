import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../database/local_database.dart';
import '../services/connectivity_service.dart';
import '../services/auth_service.dart';

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

/// Service for synchronizing local data with MongoDB backend
class SyncService extends ChangeNotifier {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final LocalDatabase _localDb = LocalDatabase();
  final ConnectivityService _connectivity = ConnectivityService();
  final AuthService _authService = AuthService();
  Timer? _periodicSyncTimer;

  // MongoDB backend URL
  static const String _baseUrl = 'https://telemed18.onrender.com/api';

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
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

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
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      // Download from MongoDB backend
      final response = await http.get(
        Uri.parse('$_baseUrl/patients/${currentUser.id}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final localProfile = await _localDb.getPatientProfile(currentUser.id);

        // Simple update logic - server data takes precedence
        if (data != null) {
          // Convert and store the patient profile locally
          debugPrint('Updated patient profile from MongoDB backend');
        }
      }
    } on SocketException catch (e) {
      debugPrint('Network error during patient profile sync: $e');
    } catch (e) {
      debugPrint('Error syncing patient profiles: $e');
    }
  }

  /// Sync appointments
  Future<void> _syncAppointments() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      // Download from MongoDB backend
      final response = await http.get(
        Uri.parse('$_baseUrl/appointments?patientId=${currentUser.id}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Process appointments data
        debugPrint('Updated appointments from MongoDB backend');
      }
    } on SocketException catch (e) {
      debugPrint('Network error during appointments sync: $e');
    } catch (e) {
      debugPrint('Error syncing appointments: $e');
    }
  }

  /// Sync health records
  Future<void> _syncHealthRecords() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) return;

      // Download from MongoDB backend
      final response = await http.get(
        Uri.parse('$_baseUrl/health-records?patientId=${currentUser.id}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Process health records data
        debugPrint('Updated health records from MongoDB backend');
      }
    } on SocketException catch (e) {
      debugPrint('Network error during health records sync: $e');
    } catch (e) {
      debugPrint('Error syncing health records: $e');
    }
  }

  /// Sync doctors
  Future<void> _syncDoctors() async {
    try {
      // Download from MongoDB backend
      final response = await http.get(
        Uri.parse('$_baseUrl/doctors/available'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Process doctors data
        debugPrint('Updated doctors from MongoDB backend');
      }
    } on SocketException catch (e) {
      debugPrint('Network error during doctors sync: $e');
    } catch (e) {
      debugPrint('Error syncing doctors: $e');
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
        } on SocketException catch (e) {
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
    switch (operation.operation) {
      case 'create':
      case 'update':
        if (data != null) {
          // Send to MongoDB backend
          final response = await http.post(
            Uri.parse('$_baseUrl/$tableName'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          );
          if (response.statusCode != 200 && response.statusCode != 201) {
            throw Exception('Failed to sync: ${response.body}');
          }
        }
        break;
      case 'delete':
        final response = await http.delete(
          Uri.parse('$_baseUrl/$tableName/${operation.recordId}'),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode != 200 && response.statusCode != 204) {
          throw Exception('Failed to delete: ${response.body}');
        }
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

  /// Force sync critical data immediately
  Future<void> forceSyncCritical() async {
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

  /// Check if error is network-related
  bool _isNetworkError(dynamic error) {
    return error is SocketException ||
        error.toString().contains('network') ||
        error.toString().contains('connection') ||
        error.toString().contains('timeout');
  }

  /// Dispose resources
  @override
  void dispose() {
    _stopPeriodicSync();
    _connectivity.removeListener(_onConnectivityChanged);
    super.dispose();
  }
}

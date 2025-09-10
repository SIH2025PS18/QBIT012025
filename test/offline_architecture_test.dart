import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:telemed/database/local_database.dart';
import 'package:telemed/services/connectivity_service.dart';
import 'package:telemed/services/sync_service.dart';
import 'package:telemed/models/patient_profile.dart';
import 'package:matcher/matcher.dart' as matcher;

/// Test database class that uses in-memory SQLite
class TestLocalDatabase extends LocalDatabase {
  TestLocalDatabase() : super.test();
}

void main() {
  group('Offline-First Architecture Tests', () {
    late TestLocalDatabase database;
    late ConnectivityService connectivity;
    late SyncService syncService;

    setUpAll(() async {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();

      // Initialize services with proper test setup
      database = TestLocalDatabase();
      connectivity = ConnectivityService();
      syncService = SyncService();

      // Initialize connectivity service
      await connectivity.initialize();
    });

    tearDownAll(() async {
      // Clean up
      await database.close();
    });

    test('should initialize local database successfully', () async {
      // Test database initialization
      expect(database, matcher.isNotNull);

      // Test basic database connectivity
      expect(database.executor, matcher.isNotNull);
    });

    test('should detect connectivity status', () async {
      // Test connectivity detection
      expect(connectivity, matcher.isNotNull);
      expect(connectivity.connectionStatus, matcher.isNotNull);

      // Check connection properties
      final isConnected = connectivity.isConnected;
      expect(isConnected, isA<bool>());
    });

    test('should handle basic database operations', () async {
      // Test database initialization
      expect(database, matcher.isNotNull);

      // Test adding sync operations
      await database.addSyncOperation(
        tableName: 'test_table',
        recordId: 'test-record-1',
        operation: 'create',
        data: '{"test": "data"}',
      );

      // Verify sync operation was stored
      final operations = await database.getPendingSyncOperations();
      expect(operations, isNotEmpty);

      final operation = operations.first;
      expect(operation.tableNameColumn, equals('test_table'));
      expect(operation.recordId, equals('test-record-1'));
      expect(operation.operation, equals('create'));
    });

    test('should handle sync status correctly', () async {
      // Test sync service initialization
      expect(syncService, matcher.isNotNull);
      expect(syncService.syncStatus, isA<SyncStatus>());

      // Test sync status properties
      expect(syncService.isSyncing, isA<bool>());
      expect(syncService.pendingSyncCount, isA<int>());
    });

    test('should store sync operations for offline actions', () async {
      // Add a sync operation
      await database.addSyncOperation(
        tableName: 'patient_profiles',
        recordId: 'test-sync-123',
        operation: 'create',
        data: '{"test": "data"}',
      );

      // Verify sync operation was stored
      final operations = await database.getPendingSyncOperations();
      expect(operations, isNotEmpty);

      final operation = operations.first;
      expect(operation.tableNameColumn, equals('patient_profiles'));
      expect(operation.recordId, equals('test-sync-123'));
      expect(operation.operation, equals('create'));
    });

    test('should handle database indexes and performance', () async {
      // Test database performance with indexes
      final stopwatch = Stopwatch()..start();

      // Insert multiple test records
      for (int i = 0; i < 100; i++) {
        await database.addSyncOperation(
          tableName: 'test_table',
          recordId: 'record-$i',
          operation: 'create',
          data: '{"index": $i}',
        );
      }

      stopwatch.stop();

      // Should complete quickly with proper indexes
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));

      // Verify all records were inserted
      final operations = await database.getPendingSyncOperations();
      expect(operations.length, greaterThanOrEqualTo(100));
    });
  });
}

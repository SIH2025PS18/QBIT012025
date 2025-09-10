import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables.dart';

part 'local_database.g.dart';

/// Create the database connection for the local database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'telemed_local.db'));
    return NativeDatabase(file);
  });
}

/// Local SQLite database for offline-first architecture
@DriftDatabase(
  tables: [
    LocalPatientProfiles,
    LocalDoctors,
    LocalAppointments,
    LocalHealthRecords,
    SyncOperations,
    LocalAppSettings,
    LocalTodos, // Add this line
  ],
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // Test constructor for in-memory database
  LocalDatabase.test() : super(NativeDatabase.memory(logStatements: true));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // Enable foreign keys
      await customStatement('PRAGMA foreign_keys = ON');

      // Create indexes for better performance
      await _createIndexes();
    },
    onCreate: (Migrator m) async {
      await m.createAll();
      await _createIndexes();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle database migrations here
      // Since we're currently at version 1, no upgrade needed yet
      // But we'll add a proper migration path for future versions
      if (from < to) {
        for (int i = from + 1; i <= to; i++) {
          switch (i) {
            case 1:
              await m.createAll();
              await _createIndexes();
              break;
            // Add cases for future versions here
            // case 2: await _migrateToV2(m); break;
          }
        }
      }
    },
  );

  /// Create database indexes for performance optimization
  Future<void> _createIndexes() async {
    // Patient profiles indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_patient_profiles_email ON local_patient_profiles(email)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_patient_profiles_sync ON local_patient_profiles(is_synced, last_sync_at)',
    );

    // Doctors indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_doctors_specialization ON local_doctors(specialization)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_doctors_availability ON local_doctors(is_available, is_online)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_doctors_sync ON local_doctors(is_synced, last_sync_at)',
    );

    // Appointments indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_appointments_patient ON local_appointments(patient_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_appointments_doctor ON local_appointments(doctor_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_appointments_date ON local_appointments(appointment_date)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_appointments_status ON local_appointments(status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_appointments_sync ON local_appointments(is_synced, last_sync_at)',
    );

    // Health records indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_health_records_patient ON local_health_records(patient_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_health_records_type ON local_health_records(record_type)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_health_records_date ON local_health_records(record_date DESC)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_health_records_sync ON local_health_records(is_synced, last_sync_at)',
    );

    // Sync operations indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_sync_operations_table ON sync_operations(table_name)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_sync_operations_completed ON sync_operations(is_completed)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_sync_operations_retry ON sync_operations(retry_count, last_retry_at)',
    );

    // Todos indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_todos_completed ON local_todos(is_completed)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_todos_priority ON local_todos(priority)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_todos_due_date ON local_todos(due_date)',
    );
  }

  // ==========================================
  // PATIENT PROFILES QUERIES
  // ==========================================

  /// Get patient profile by ID
  Future<LocalPatientProfile?> getPatientProfile(String id) {
    return (select(localPatientProfiles)
          ..where((p) => p.id.equals(id) & p.pendingDelete.equals(false)))
        .getSingleOrNull();
  }

  /// Get all patient profiles
  Future<List<LocalPatientProfile>> getAllPatientProfiles() {
    return (select(localPatientProfiles)
          ..where((p) => p.pendingDelete.equals(false))
          ..orderBy([(p) => OrderingTerm.desc(p.updatedAt)]))
        .get();
  }

  /// Insert or update patient profile
  Future<void> upsertPatientProfile(LocalPatientProfile profile) {
    return into(localPatientProfiles).insertOnConflictUpdate(profile);
  }

  /// Mark patient profile for deletion
  Future<void> markPatientProfileForDeletion(String id) {
    return (update(localPatientProfiles)..where((p) => p.id.equals(id))).write(
      LocalPatientProfilesCompanion(
        pendingDelete: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  /// Get unsynced patient profiles
  Future<List<LocalPatientProfile>> getUnsyncedPatientProfiles() {
    return (select(
      localPatientProfiles,
    )..where((p) => p.isSynced.equals(false))).get();
  }

  // ==========================================
  // DOCTORS QUERIES
  // ==========================================

  /// Get doctor by ID
  Future<LocalDoctor?> getDoctor(String id) {
    return (select(localDoctors)
          ..where((d) => d.id.equals(id) & d.pendingDelete.equals(false)))
        .getSingleOrNull();
  }

  /// Get all doctors
  Future<List<LocalDoctor>> getAllDoctors() {
    return (select(localDoctors)
          ..where((d) => d.pendingDelete.equals(false))
          ..orderBy([(d) => OrderingTerm.desc(d.rating)]))
        .get();
  }

  /// Get doctors by specialization
  Future<List<LocalDoctor>> getDoctorsBySpecialization(String specialization) {
    return (select(localDoctors)
          ..where(
            (d) =>
                d.specialization.like('%$specialization%') &
                d.pendingDelete.equals(false),
          )
          ..orderBy([(d) => OrderingTerm.desc(d.rating)]))
        .get();
  }

  /// Get available doctors
  Future<List<LocalDoctor>> getAvailableDoctors() {
    return (select(localDoctors)
          ..where(
            (d) => d.isAvailable.equals(true) & d.pendingDelete.equals(false),
          )
          ..orderBy([(d) => OrderingTerm.desc(d.rating)]))
        .get();
  }

  /// Insert or update doctor
  Future<void> upsertDoctor(LocalDoctor doctor) {
    return into(localDoctors).insertOnConflictUpdate(doctor);
  }

  // ==========================================
  // APPOINTMENTS QUERIES
  // ==========================================

  /// Get appointment by ID
  Future<LocalAppointment?> getAppointment(String id) {
    return (select(localAppointments)
          ..where((a) => a.id.equals(id) & a.pendingDelete.equals(false)))
        .getSingleOrNull();
  }

  /// Get all appointments for a patient
  Future<List<LocalAppointment>> getAppointmentsForPatient(String patientId) {
    return (select(localAppointments)
          ..where(
            (a) =>
                a.patientId.equals(patientId) & a.pendingDelete.equals(false),
          )
          ..orderBy([(a) => OrderingTerm.desc(a.appointmentDate)]))
        .get();
  }

  /// Insert or update appointment
  Future<void> upsertAppointment(LocalAppointment appointment) {
    return into(localAppointments).insertOnConflictUpdate(appointment);
  }

  /// Mark appointment for deletion
  Future<void> markAppointmentForDeletion(String id) {
    return (update(localAppointments)..where((a) => a.id.equals(id))).write(
      LocalAppointmentsCompanion(
        pendingDelete: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  /// Get unsynced appointments
  Future<List<LocalAppointment>> getUnsyncedAppointments() {
    return (select(
      localAppointments,
    )..where((a) => a.isSynced.equals(false))).get();
  }

  // ==========================================
  // HEALTH RECORDS QUERIES
  // ==========================================

  /// Get health record by ID
  Future<LocalHealthRecord?> getHealthRecord(String id) {
    return (select(localHealthRecords)
          ..where((h) => h.id.equals(id) & h.pendingDelete.equals(false)))
        .getSingleOrNull();
  }

  /// Get all health records for a patient
  Future<List<LocalHealthRecord>> getHealthRecordsForPatient(String patientId) {
    return (select(localHealthRecords)
          ..where(
            (h) =>
                h.patientId.equals(patientId) & h.pendingDelete.equals(false),
          )
          ..orderBy([(h) => OrderingTerm.desc(h.recordDate)]))
        .get();
  }

  /// Insert or update health record
  Future<void> upsertHealthRecord(LocalHealthRecord record) {
    return into(localHealthRecords).insertOnConflictUpdate(record);
  }

  /// Mark health record for deletion
  Future<void> markHealthRecordForDeletion(String id) {
    return (update(localHealthRecords)..where((h) => h.id.equals(id))).write(
      LocalHealthRecordsCompanion(
        pendingDelete: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  /// Get unsynced health records
  Future<List<LocalHealthRecord>> getUnsyncedHealthRecords() {
    return (select(
      localHealthRecords,
    )..where((h) => h.isSynced.equals(false))).get();
  }

  // ==========================================
  // SYNC OPERATIONS QUERIES
  // ==========================================

  /// Add sync operation
  Future<int> addSyncOperation(SyncOperation operation) {
    return into(syncOperations).insert(operation);
  }

  /// Get pending sync operations
  Future<List<SyncOperation>> getPendingSyncOperations() {
    return (select(
      syncOperations,
    )..where((s) => s.isCompleted.equals(false))).get();
  }

  /// Mark sync operation as completed
  Future<void> markSyncOperationAsCompleted(int id) {
    return (update(syncOperations)..where((s) => s.id.equals(id))).write(
      SyncOperationsCompanion(
        isCompleted: const Value(true),
        lastRetryAt: Value(DateTime.now()),
      ),
    );
  }

  /// Increment retry count for sync operation
  Future<void> incrementSyncOperationRetryCount(int id) {
    return customStatement(
      'UPDATE sync_operations SET retry_count = retry_count + 1, last_retry_at = ? WHERE id = ?',
      [DateTime.now(), id],
    );
  }

  /// Update sync operation retry count and error message
  Future<void> updateSyncOperationRetry(int id, String errorMessage) {
    return customStatement(
      'UPDATE sync_operations SET retry_count = retry_count + 1, last_retry_at = ?, error_message = ? WHERE id = ?',
      [DateTime.now(), errorMessage, id],
    );
  }

  // ==========================================
  // APP SETTINGS QUERIES
  // ==========================================

  /// Get app setting by key
  Future<LocalAppSetting?> getAppSetting(String key) {
    return (select(
      localAppSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
  }

  /// Set app setting
  Future<void> setAppSetting(String key, String value) {
    return into(localAppSettings).insertOnConflictUpdate(
      LocalAppSettingsCompanion(
        key: Value(key),
        value: Value(value),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  // ==========================================
  // TODOS QUERIES
  // ==========================================

  /// Get todo by ID
  Future<LocalTodo?> getTodo(String id) {
    return (select(localTodos)
          ..where((t) => t.id.equals(id) & t.pendingDelete.equals(false)))
        .getSingleOrNull();
  }

  /// Get all todos
  Future<List<LocalTodo>> getAllTodos() {
    return (select(localTodos)
          ..where((t) => t.pendingDelete.equals(false))
          ..orderBy([
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.dueDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
  }

  /// Get completed todos
  Future<List<LocalTodo>> getCompletedTodos() {
    return (select(localTodos)
          ..where(
            (t) => t.isCompleted.equals(true) & t.pendingDelete.equals(false),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  /// Get pending todos
  Future<List<LocalTodo>> getPendingTodos() {
    return (select(localTodos)
          ..where(
            (t) => t.isCompleted.equals(false) & t.pendingDelete.equals(false),
          )
          ..orderBy([
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.dueDate),
          ]))
        .get();
  }

  /// Insert or update todo
  Future<void> upsertTodo(LocalTodo todo) {
    return into(localTodos).insertOnConflictUpdate(todo);
  }

  /// Mark todo as completed
  Future<void> markTodoAsCompleted(String id) {
    return (update(localTodos)..where((t) => t.id.equals(id))).write(
      LocalTodosCompanion(
        isCompleted: const Value(true),
        completedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  /// Mark todo as pending
  Future<void> markTodoAsPending(String id) {
    return (update(localTodos)..where((t) => t.id.equals(id))).write(
      LocalTodosCompanion(
        isCompleted: const Value(false),
        completedAt: const Value(null),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  /// Mark todo for deletion
  Future<void> markTodoForDeletion(String id) {
    return (update(localTodos)..where((t) => t.id.equals(id))).write(
      LocalTodosCompanion(
        pendingDelete: const Value(true),
        updatedAt: Value(DateTime.now()),
        isSynced: const Value(false),
      ),
    );
  }

  /// Get unsynced todos
  Future<List<LocalTodo>> getUnsyncedTodos() {
    return (select(localTodos)..where((t) => t.isSynced.equals(false))).get();
  }
}

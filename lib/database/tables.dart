import 'package:drift/drift.dart';

/// Local Patient Profiles table
class LocalPatientProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text().named('full_name')();
  TextColumn get email => text()();
  TextColumn get phoneNumber => text().named('phone_number').nullable()();
  DateTimeColumn get dateOfBirth =>
      dateTime().named('date_of_birth').nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get bloodGroup => text().named('blood_group').nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get emergencyContact =>
      text().named('emergency_contact').nullable()();
  TextColumn get emergencyContactPhone =>
      text().named('emergency_contact_phone').nullable()();
  TextColumn get profilePhotoUrl =>
      text().named('profile_photo_url').nullable()();
  TextColumn get allergies => text().withDefault(const Constant('[]'))();
  TextColumn get medications => text().withDefault(const Constant('[]'))();
  TextColumn get medicalHistory =>
      text().named('medical_history').withDefault(const Constant('{}'))();
  DateTimeColumn get lastVisit => dateTime().named('last_visit').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // Sync metadata
  BoolColumn get isSynced =>
      boolean().named('is_synced').withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt =>
      dateTime().named('last_sync_at').nullable()();
  BoolColumn get pendingDelete =>
      boolean().named('pending_delete').withDefault(const Constant(false))();
  TextColumn get syncVersion =>
      text().named('sync_version').withDefault(const Constant('1'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local Doctors table
class LocalDoctors extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text().named('full_name')();
  TextColumn get email => text()();
  TextColumn get phoneNumber => text().named('phone_number').nullable()();
  TextColumn get specialization => text()();
  TextColumn get qualification => text().nullable()();
  TextColumn get experience => text().nullable()();
  TextColumn get profilePhotoUrl =>
      text().named('profile_photo_url').nullable()();
  TextColumn get about => text().nullable()();
  RealColumn get rating => real().withDefault(const Constant(0.0))();
  IntColumn get totalReviews =>
      integer().named('total_reviews').withDefault(const Constant(0))();
  RealColumn get consultationFee => real().named('consultation_fee')();
  BoolColumn get isAvailable =>
      boolean().named('is_available').withDefault(const Constant(true))();
  BoolColumn get isOnline =>
      boolean().named('is_online').withDefault(const Constant(false))();
  TextColumn get availableSlots =>
      text().named('available_slots').withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // Sync metadata
  BoolColumn get isSynced =>
      boolean().named('is_synced').withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt =>
      dateTime().named('last_sync_at').nullable()();
  BoolColumn get pendingDelete =>
      boolean().named('pending_delete').withDefault(const Constant(false))();
  TextColumn get syncVersion =>
      text().named('sync_version').withDefault(const Constant('1'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local Appointments table
class LocalAppointments extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().named('patient_id')();
  TextColumn get doctorId => text().named('doctor_id')();
  TextColumn get doctorName => text().named('doctor_name').nullable()();
  TextColumn get doctorSpecialization =>
      text().named('doctor_specialization').nullable()();
  DateTimeColumn get appointmentDate => dateTime().named('appointment_date')();
  DateTimeColumn get appointmentTime => dateTime().named('appointment_time')();
  TextColumn get status => text().withDefault(const Constant('scheduled'))();
  TextColumn get notes => text().nullable()();
  TextColumn get patientSymptoms =>
      text().named('patient_symptoms').nullable()();
  RealColumn get consultationFee => real().named('consultation_fee')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // Sync metadata
  BoolColumn get isSynced =>
      boolean().named('is_synced').withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt =>
      dateTime().named('last_sync_at').nullable()();
  BoolColumn get pendingDelete =>
      boolean().named('pending_delete').withDefault(const Constant(false))();
  TextColumn get syncVersion =>
      text().named('sync_version').withDefault(const Constant('1'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Local Health Records table
class LocalHealthRecords extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text().named('patient_id')();
  TextColumn get doctorId => text().named('doctor_id').nullable()();
  TextColumn get appointmentId => text().named('appointment_id').nullable()();
  TextColumn get recordType => text().named(
    'record_type',
  )(); // prescription, lab_result, diagnosis, etc.
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get attachmentUrl => text().named('attachment_url').nullable()();
  TextColumn get metadata =>
      text().withDefault(const Constant('{}'))(); // JSON for additional data
  DateTimeColumn get recordDate => dateTime().named('record_date')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // Sync metadata
  BoolColumn get isSynced =>
      boolean().named('is_synced').withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt =>
      dateTime().named('last_sync_at').nullable()();
  BoolColumn get pendingDelete =>
      boolean().named('pending_delete').withDefault(const Constant(false))();
  TextColumn get syncVersion =>
      text().named('sync_version').withDefault(const Constant('1'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sync Operations queue table
class SyncOperations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableNameColumn => text().named('table_name')();
  TextColumn get recordId => text().named('record_id')();
  TextColumn get operation => text()(); // create, update, delete
  TextColumn get data => text().nullable()(); // JSON data for the operation
  BoolColumn get isCompleted =>
      boolean().named('is_completed').withDefault(const Constant(false))();
  IntColumn get retryCount =>
      integer().named('retry_count').withDefault(const Constant(0))();
  DateTimeColumn get lastRetryAt =>
      dateTime().named('last_retry_at').nullable()();
  TextColumn get errorMessage => text().named('error_message').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
}

/// Local App Settings table
class LocalAppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // Sync metadata
  BoolColumn get isSynced =>
      boolean().named('is_synced').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {key};
}

/// Local Todos table for offline symptom tracking
class LocalTodos extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted =>
      boolean().named('is_completed').withDefault(const Constant(false))();
  IntColumn get priority =>
      integer().withDefault(const Constant(1))(); // 1=low, 2=medium, 3=high
  DateTimeColumn get dueDate => dateTime().named('due_date').nullable()();
  DateTimeColumn get completedAt =>
      dateTime().named('completed_at').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // Sync metadata
  BoolColumn get isSynced =>
      boolean().named('is_synced').withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt =>
      dateTime().named('last_sync_at').nullable()();
  BoolColumn get pendingDelete =>
      boolean().named('pending_delete').withDefault(const Constant(false))();
  TextColumn get syncVersion =>
      text().named('sync_version').withDefault(const Constant('1'))();

  @override
  Set<Column> get primaryKey => {id};
}

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:uuid/uuid.dart';

part 'offline_database.g.dart';

// Define the tables for offline storage
@DataClassName('PatientProfile')
class PatientProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get age => text()();
  TextColumn get gender => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get medicalHistory => text().nullable()();
  TextColumn get profileImage => text().nullable()();
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSynced => dateTime().nullable()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OfflineAppointment')
class OfflineAppointments extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  TextColumn get patientName => text()();
  TextColumn get patientAge => text()();
  TextColumn get patientGender => text()();
  TextColumn get symptoms => text()();
  TextColumn get medicalHistory => text().nullable()();
  TextColumn get preferredTime => text()();
  TextColumn get priority => text().withDefault(const Constant('normal'))();
  TextColumn get status => text().withDefault(const Constant('waiting'))();
  TextColumn get doctorId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CachedPrescription')
class CachedPrescriptions extends Table {
  TextColumn get id => text()();
  TextColumn get appointmentId => text()();
  TextColumn get patientId => text()();
  TextColumn get doctorId => text()();
  TextColumn get doctorName => text()();
  TextColumn get medications => text()(); // JSON string
  TextColumn get dosage => text()();
  TextColumn get instructions => text()();
  TextColumn get duration => text()();
  DateTimeColumn get prescribedAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime()();
  BoolColumn get isOfflineAccessed =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OfflineSymptomCheck')
class OfflineSymptomChecks extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  TextColumn get symptoms => text()(); // JSON string
  TextColumn get severity => text()();
  TextColumn get recommendations => text()(); // JSON string
  TextColumn get language => text().withDefault(const Constant('en'))();
  DateTimeColumn get checkedAt => dateTime()();
  BoolColumn get requiresUrgentCare =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SyncQueue')
class SyncQueues extends Table {
  TextColumn get id => text()();
  TextColumn get targetTable => text()();
  TextColumn get recordId => text()();
  TextColumn get operation => text()(); // INSERT, UPDATE, DELETE
  TextColumn get data => text()(); // JSON string
  IntColumn get priority =>
      integer().withDefault(const Constant(1))(); // 1=high, 2=medium, 3=low
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAttempt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MedicalReport')
class MedicalReports extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  TextColumn get reportType => text()();
  TextColumn get title => text()();
  TextColumn get hospitalName => text()();
  TextColumn get doctorName => text()();
  TextColumn get doctorSpecialization => text()();
  DateTimeColumn get reportDate => dateTime()();
  DateTimeColumn get issuedDate => dateTime()();
  TextColumn get summary => text()();
  TextColumn get findings => text()(); // JSON string
  TextColumn get recommendations => text()(); // JSON string
  TextColumn get testResults => text()(); // JSON string
  TextColumn get prescriptions => text()(); // JSON string
  TextColumn get severity => text().withDefault(const Constant('Normal'))();
  BoolColumn get isEmergency => boolean().withDefault(const Constant(false))();
  TextColumn get reportUrl => text().withDefault(const Constant(''))();
  TextColumn get attachments => text()(); // JSON string
  TextColumn get vitalSigns => text()(); // JSON string
  TextColumn get status => text().withDefault(const Constant('Final'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('VitalSign')
class VitalSigns extends Table {
  TextColumn get id => text()();
  TextColumn get patientId => text()();
  DateTimeColumn get recordedDate => dateTime()();
  RealColumn get bloodPressureSystolic => real().nullable()();
  RealColumn get bloodPressureDiastolic => real().nullable()();
  RealColumn get heartRate => real().nullable()();
  RealColumn get temperature => real().nullable()();
  RealColumn get respiratoryRate => real().nullable()();
  RealColumn get oxygenSaturation => real().nullable()();
  RealColumn get bloodSugar => real().nullable()();
  RealColumn get weight => real().nullable()();
  RealColumn get height => real().nullable()();
  RealColumn get bmi => real().nullable()();
  TextColumn get recordedBy => text().withDefault(const Constant(''))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserProfile')
class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get passwordHash => text()();
  TextColumn get fullName => text()();
  TextColumn get email => text().nullable()();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FamilyMember')
class FamilyMembers extends Table {
  TextColumn get id => text()();
  TextColumn get familyGroupId => text()();
  TextColumn get primaryUserId => text()();
  TextColumn get name => text()();
  TextColumn get relationship => text()();
  DateTimeColumn get dateOfBirth => dateTime()();
  TextColumn get gender => text()();
  TextColumn get bloodGroup => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get allergies => text().nullable()();
  TextColumn get medicalConditions => text().nullable()(); // JSON string
  TextColumn get medications => text().nullable()(); // JSON string
  TextColumn get emergencyContact => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get hasOwnAccount =>
      boolean().withDefault(const Constant(false))();
  TextColumn get linkedAccountId => text().nullable()();
  BoolColumn get allowIndependentAccess =>
      boolean().withDefault(const Constant(false))();
  TextColumn get caregiverPermissions => text().nullable()(); // JSON string
  TextColumn get profileImageUrl => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FamilyGroup')
class FamilyGroups extends Table {
  TextColumn get id => text()();
  TextColumn get primaryMemberId => text()();
  TextColumn get familyName => text()();
  TextColumn get address => text().nullable()();
  TextColumn get village => text().nullable()();
  TextColumn get pincode => text().nullable()();
  TextColumn get emergencyContact => text().nullable()();
  TextColumn get emergencyPhone => text().nullable()();
  TextColumn get healthInsurance => text().nullable()(); // JSON string
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FamilyHealthRecord')
class FamilyHealthRecords extends Table {
  TextColumn get id => text()();
  TextColumn get familyMemberId => text()();
  TextColumn get familyGroupId => text()();
  TextColumn get recordType =>
      text()(); // vaccination, checkup, illness, emergency
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get condition => text().nullable()();
  TextColumn get symptoms => text().nullable()(); // JSON string
  TextColumn get severity => text().withDefault(const Constant('normal'))();
  TextColumn get treatment => text().nullable()();
  TextColumn get medications => text().nullable()(); // JSON string
  TextColumn get doctorName => text().nullable()();
  TextColumn get hospitalName => text().nullable()();
  TextColumn get reportUrl => text().nullable()();
  TextColumn get attachments => text().nullable()(); // JSON string
  DateTimeColumn get recordDate => dateTime()();
  DateTimeColumn get followUpDate => dateTime().nullable()();
  BoolColumn get isEmergency => boolean().withDefault(const Constant(false))();
  BoolColumn get isResolved => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CaregiverSession')
class CaregiverSessions extends Table {
  TextColumn get id => text()();
  TextColumn get caregiverId => text()();
  TextColumn get dependentId => text()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get activatedFeatures => text().nullable()(); // JSON string
  TextColumn get actionsPerformed => text().nullable()(); // JSON string
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Database class
@DriftDatabase(
  tables: [
    PatientProfiles,
    UserProfiles,
    OfflineAppointments,
    CachedPrescriptions,
    OfflineSymptomChecks,
    SyncQueues,
    MedicalReports,
    VitalSigns,
    FamilyMembers,
    FamilyGroups,
    FamilyHealthRecords,
    CaregiverSessions,
  ],
)
class OfflineDatabase extends _$OfflineDatabase {
  OfflineDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      // No special setup needed before opening
    },
    onCreate: (Migrator m) async {
      // Create all tables when database is first created
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle database migrations here
      if (from < to) {
        for (int i = from + 1; i <= to; i++) {
          switch (i) {
            case 1:
              await m.createAll();
              break;
            case 2:
              // If we need to add new tables or modify existing ones for v2
              // Add migration logic here
              // For now, we'll just ensure all tables exist
              await m.createAll();
              break;
            // Add more cases for future versions
          }
        }
      }
    },
  );

  // Patient Profile Operations
  Future<void> insertOrUpdatePatientProfile(PatientProfile profile) async {
    await into(patientProfiles).insertOnConflictUpdate(
      PatientProfilesCompanion(
        id: Value(profile.id),
        name: Value(profile.name),
        age: Value(profile.age),
        gender: Value(profile.gender),
        phone: Value(profile.phone),
        email: Value(profile.email),
        medicalHistory: Value(profile.medicalHistory),
        profileImage: Value(profile.profileImage),
        isOnline: Value(profile.isOnline),
        lastSynced: Value(profile.lastSynced),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<PatientProfile?> getPatientProfile(String id) async {
    return await (select(
      patientProfiles,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  // User Profile Operations
  Future<void> insertOrUpdateUser(Map<String, dynamic> userData) async {
    await into(userProfiles).insertOnConflictUpdate(
      UserProfilesCompanion(
        id: Value(userData['id'] as String),
        phoneNumber: Value(userData['phone_number'] as String),
        passwordHash: Value(userData['password_hash'] as String),
        fullName: Value(userData['full_name'] as String),
        email: Value(userData['email'] as String?),
        isVerified: Value(userData['is_verified'] as bool? ?? false),
        isActive: Value(userData['is_active'] as bool? ?? true),
        isSynced: const Value(true), // Since it's coming from
        createdAt: Value(
          userData['created_at'] != null
              ? DateTime.parse(userData['created_at'] as String)
              : DateTime.now(),
        ),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  Future<UserProfile?> getUserByPhone(String phoneNumber) async {
    return await (select(
      userProfiles,
    )..where((u) => u.phoneNumber.equals(phoneNumber))).getSingleOrNull();
  }

  Future<UserProfile?> getUserById(String id) async {
    return await (select(
      userProfiles,
    )..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  Future<void> clearUserData() async {
    await delete(userProfiles).go();
  }

  // Appointment Operations
  Future<String> createOfflineAppointment({
    required String patientId,
    required String patientName,
    required String patientAge,
    required String patientGender,
    required String symptoms,
    String? medicalHistory,
    required String preferredTime,
    String priority = 'normal',
  }) async {
    final id = const Uuid().v4();
    final appointment = OfflineAppointmentsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      patientName: Value(patientName),
      patientAge: Value(patientAge),
      patientGender: Value(patientGender),
      symptoms: Value(symptoms),
      medicalHistory: Value(medicalHistory),
      preferredTime: Value(preferredTime),
      priority: Value(priority),
      status: const Value('waiting'),
      createdAt: Value(DateTime.now()),
      lastModified: Value(DateTime.now()),
      isSynced: const Value(false),
    );

    await into(offlineAppointments).insert(appointment);

    // Add to sync queue
    await _addToSyncQueue('appointments', id, 'INSERT', {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'symptoms': symptoms,
      'medicalHistory': medicalHistory,
      'preferredTime': preferredTime,
      'priority': priority,
      'status': 'waiting',
      'createdAt': DateTime.now().toIso8601String(),
    });

    return id;
  }

  Future<List<OfflineAppointment>> getPatientAppointments(
    String patientId,
  ) async {
    return await (select(offlineAppointments)
          ..where(
            (a) => a.patientId.equals(patientId) & a.isDeleted.equals(false),
          )
          ..orderBy([
            (a) =>
                OrderingTerm(expression: a.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<OfflineAppointment>> getPendingSyncAppointments() async {
    return await (select(offlineAppointments)
          ..where((a) => a.isSynced.equals(false) & a.isDeleted.equals(false)))
        .get();
  }

  Future<void> markAppointmentAsSynced(String id) async {
    await (update(offlineAppointments)..where((a) => a.id.equals(id))).write(
      const OfflineAppointmentsCompanion(isSynced: Value(true)),
    );
  }

  // Prescription Operations
  Future<void> cachePrescription(CachedPrescription prescription) async {
    await into(cachedPrescriptions).insertOnConflictUpdate(
      CachedPrescriptionsCompanion(
        id: Value(prescription.id),
        appointmentId: Value(prescription.appointmentId),
        patientId: Value(prescription.patientId),
        doctorId: Value(prescription.doctorId),
        doctorName: Value(prescription.doctorName),
        medications: Value(prescription.medications),
        dosage: Value(prescription.dosage),
        instructions: Value(prescription.instructions),
        duration: Value(prescription.duration),
        prescribedAt: Value(prescription.prescribedAt),
        cachedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<CachedPrescription>> getPatientPrescriptions(
    String patientId,
  ) async {
    return await (select(cachedPrescriptions)
          ..where((p) => p.patientId.equals(patientId))
          ..orderBy([
            (p) => OrderingTerm(
              expression: p.prescribedAt,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  // Symptom Check Operations
  Future<String> saveOfflineSymptomCheck({
    required String patientId,
    required String symptoms,
    required String severity,
    required String recommendations,
    String language = 'en',
    bool requiresUrgentCare = false,
  }) async {
    final id = const Uuid().v4();
    final symptomCheck = OfflineSymptomChecksCompanion(
      id: Value(id),
      patientId: Value(patientId),
      symptoms: Value(symptoms),
      severity: Value(severity),
      recommendations: Value(recommendations),
      language: Value(language),
      checkedAt: Value(DateTime.now()),
      requiresUrgentCare: Value(requiresUrgentCare),
    );

    await into(offlineSymptomChecks).insert(symptomCheck);
    return id;
  }

  Future<List<OfflineSymptomCheck>> getPatientSymptomHistory(
    String patientId,
  ) async {
    return await (select(offlineSymptomChecks)
          ..where((s) => s.patientId.equals(patientId))
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.checkedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  // Medical Records Operations
  Future<void> insertMedicalReport(Map<String, dynamic> reportData) async {
    final data = MedicalReportsCompanion(
      id: Value(reportData['id']),
      patientId: Value(reportData['patientId']),
      reportType: Value(reportData['reportType']),
      title: Value(reportData['title']),
      hospitalName: Value(reportData['hospitalName']),
      doctorName: Value(reportData['doctorName']),
      doctorSpecialization: Value(reportData['doctorSpecialization']),
      reportDate: Value(reportData['reportDate']),
      issuedDate: Value(reportData['issuedDate']),
      summary: Value(reportData['summary']),
      findings: Value(reportData['findings']),
      recommendations: Value(reportData['recommendations']),
      testResults: Value(reportData['testResults']),
      prescriptions: Value(reportData['prescriptions']),
      severity: Value(reportData['severity']),
      isEmergency: Value(reportData['isEmergency']),
      reportUrl: Value(reportData['reportUrl']),
      attachments: Value(reportData['attachments']),
      vitalSigns: Value(reportData['vitalSigns']),
      status: Value(reportData['status']),
      createdAt: Value(DateTime.now()),
    );

    await into(medicalReports).insertOnConflictUpdate(data);
  }

  Future<List<Map<String, dynamic>>> getPatientMedicalReports(
    String patientId,
  ) async {
    final reports =
        await (select(medicalReports)
              ..where((r) => r.patientId.equals(patientId))
              ..orderBy([
                (r) => OrderingTerm(
                  expression: r.reportDate,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    return reports
        .map(
          (r) => {
            'id': r.id,
            'patientId': r.patientId,
            'reportType': r.reportType,
            'title': r.title,
            'hospitalName': r.hospitalName,
            'doctorName': r.doctorName,
            'doctorSpecialization': r.doctorSpecialization,
            'reportDate': r.reportDate,
            'issuedDate': r.issuedDate,
            'summary': r.summary,
            'findings': r.findings
                .split('|')
                .where((f) => f.isNotEmpty)
                .toList(),
            'recommendations': r.recommendations
                .split('|')
                .where((f) => f.isNotEmpty)
                .toList(),
            'testResults': r.testResults,
            'prescriptions': r.prescriptions
                .split('|')
                .where((f) => f.isNotEmpty)
                .toList(),
            'severity': r.severity,
            'isEmergency': r.isEmergency,
            'reportUrl': r.reportUrl,
            'attachments': r.attachments
                .split('|')
                .where((f) => f.isNotEmpty)
                .toList(),
            'vitalSigns': r.vitalSigns,
            'status': r.status,
          },
        )
        .toList();
  }

  Future<void> insertVitalSigns(Map<String, dynamic> vitalData) async {
    final data = VitalSignsCompanion(
      id: Value(vitalData['id']),
      patientId: Value(vitalData['patientId']),
      recordedDate: Value(vitalData['recordedDate']),
      bloodPressureSystolic: Value(vitalData['bloodPressureSystolic']),
      bloodPressureDiastolic: Value(vitalData['bloodPressureDiastolic']),
      heartRate: Value(vitalData['heartRate']),
      temperature: Value(vitalData['temperature']),
      respiratoryRate: Value(vitalData['respiratoryRate']),
      oxygenSaturation: Value(vitalData['oxygenSaturation']),
      bloodSugar: Value(vitalData['bloodSugar']),
      weight: Value(vitalData['weight']),
      height: Value(vitalData['height']),
      bmi: Value(vitalData['bmi']),
      recordedBy: Value(vitalData['recordedBy']),
      notes: Value(vitalData['notes']),
      createdAt: Value(DateTime.now()),
    );

    await into(vitalSigns).insertOnConflictUpdate(data);
  }

  Future<List<Map<String, dynamic>>> getPatientVitalSigns(
    String patientId,
  ) async {
    final vitals =
        await (select(vitalSigns)
              ..where((v) => v.patientId.equals(patientId))
              ..orderBy([
                (v) => OrderingTerm(
                  expression: v.recordedDate,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    return vitals
        .map(
          (v) => {
            'id': v.id,
            'patientId': v.patientId,
            'recordedDate': v.recordedDate,
            'bloodPressureSystolic': v.bloodPressureSystolic,
            'bloodPressureDiastolic': v.bloodPressureDiastolic,
            'heartRate': v.heartRate,
            'temperature': v.temperature,
            'respiratoryRate': v.respiratoryRate,
            'oxygenSaturation': v.oxygenSaturation,
            'bloodSugar': v.bloodSugar,
            'weight': v.weight,
            'height': v.height,
            'bmi': v.bmi,
            'recordedBy': v.recordedBy,
            'notes': v.notes,
          },
        )
        .toList();
  }

  // Store user profile for offline access
  Future<void> storeUserProfile(Map<String, dynamic> userData) async {
    final patientId = userData['id'] ?? const Uuid().v4();

    await into(patientProfiles).insertOnConflictUpdate(
      PatientProfilesCompanion.insert(
        id: patientId,
        name: userData['full_name'] ?? userData['name'] ?? 'Unknown User',
        age: _calculateAge(userData['date_of_birth']) ?? 'N/A',
        gender: userData['gender'] ?? 'Not specified',
        phone: userData['phone'] ?? userData['phone_number'] ?? 'Not provided',
        email: userData['email'] ?? 'Not provided',
        medicalHistory: Value(
          userData['medical_history'] ?? 'No medical history recorded',
        ),
        profileImage: Value(
          userData['profile_image'] ?? userData['avatar_url'],
        ),
        isOnline: const Value(false),
        lastModified: DateTime.now(),
      ),
    );

    // Auto-populate dummy medical data for demo
    await _populateDummyMedicalData(patientId);
  }

  String? _calculateAge(dynamic dateOfBirth) {
    if (dateOfBirth == null) return null;

    DateTime? birthDate;
    if (dateOfBirth is String) {
      try {
        birthDate = DateTime.parse(dateOfBirth);
      } catch (e) {
        return null;
      }
    } else if (dateOfBirth is DateTime) {
      birthDate = dateOfBirth;
    }

    if (birthDate == null) return null;

    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  // Populate dummy medical data for demonstration
  Future<void> _populateDummyMedicalData(String patientId) async {
    try {
      // Check if data already exists
      final existingReports = await getPatientMedicalReports(patientId);
      if (existingReports.isNotEmpty) return; // Don't duplicate data

      final uuid = const Uuid();
      final now = DateTime.now();

      // Add dummy medical reports
      final dummyReports = [
        {
          'reportType': 'Blood Test',
          'title': 'Complete Blood Count (CBC)',
          'hospitalName': 'City General Hospital',
          'doctorName': 'Dr. Sarah Johnson',
          'doctorSpecialization': 'Pathologist',
          'reportDate': now.subtract(const Duration(days: 7)),
          'issuedDate': now.subtract(const Duration(days: 7)),
          'summary':
              'Routine blood work showing normal values across all parameters.',
          'findings':
              '{"hemoglobin": "14.2 g/dL", "wbc": "7,200/μL", "platelets": "285,000/μL", "glucose": "95 mg/dL"}',
          'recommendations':
              '["Maintain current diet", "Regular exercise", "Follow-up in 6 months"]',
          'testResults': '{"status": "Normal", "critical_values": "None"}',
          'prescriptions': '[]',
          'attachments': '[]',
          'vitalSigns': '{"bp": "120/80", "pulse": "72", "temp": "98.6°F"}',
          'createdAt': now.subtract(const Duration(days: 7)),
        },
        {
          'reportType': 'X-Ray',
          'title': 'Chest X-Ray',
          'hospitalName': 'Metro Medical Center',
          'doctorName': 'Dr. Michael Chen',
          'doctorSpecialization': 'Radiologist',
          'reportDate': now.subtract(const Duration(days: 15)),
          'issuedDate': now.subtract(const Duration(days: 15)),
          'summary':
              'Chest X-ray shows clear lungs with no abnormalities detected.',
          'findings':
              '{"lungs": "Clear", "heart": "Normal size", "bones": "No fractures"}',
          'recommendations':
              '["No immediate action required", "Regular health checkups"]',
          'testResults': '{"interpretation": "Normal chest X-ray"}',
          'prescriptions': '[]',
          'attachments': '[]',
          'vitalSigns': '{"bp": "118/76", "pulse": "68", "temp": "98.4°F"}',
          'createdAt': now.subtract(const Duration(days: 15)),
        },
        {
          'reportType': 'Consultation',
          'title': 'General Health Checkup',
          'hospitalName': 'Family Health Clinic',
          'doctorName': 'Dr. Emily Rodriguez',
          'doctorSpecialization': 'Family Medicine',
          'reportDate': now.subtract(const Duration(days: 30)),
          'issuedDate': now.subtract(const Duration(days: 30)),
          'summary':
              'Annual health checkup showing overall good health status.',
          'findings':
              '{"general": "Good health", "weight": "Normal BMI", "vitals": "Stable"}',
          'recommendations':
              '["Continue current lifestyle", "Annual checkups", "Maintain healthy diet"]',
          'testResults':
              '{"blood_pressure": "Normal", "cholesterol": "Within range"}',
          'prescriptions': '["Multivitamin daily", "Omega-3 supplement"]',
          'attachments': '[]',
          'vitalSigns':
              '{"bp": "115/75", "pulse": "70", "temp": "98.6°F", "weight": "165 lbs"}',
          'createdAt': now.subtract(const Duration(days: 30)),
        },
      ];

      // Insert dummy reports
      for (final report in dummyReports) {
        await into(medicalReports).insert(
          MedicalReportsCompanion.insert(
            id: uuid.v4(),
            patientId: patientId,
            reportType: report['reportType'] as String,
            title: report['title'] as String,
            hospitalName: report['hospitalName'] as String,
            doctorName: report['doctorName'] as String,
            doctorSpecialization: report['doctorSpecialization'] as String,
            reportDate: report['reportDate'] as DateTime,
            issuedDate: report['issuedDate'] as DateTime,
            summary: report['summary'] as String,
            findings: report['findings'] as String,
            recommendations: report['recommendations'] as String,
            testResults: report['testResults'] as String,
            prescriptions: report['prescriptions'] as String,
            severity: Value(report['severity'] as String? ?? 'Normal'),
            isEmergency: const Value(false),
            reportUrl: const Value(''),
            attachments: report['attachments'] as String,
            vitalSigns: report['vitalSigns'] as String,
            status: const Value('Final'),
            isSynced: const Value(false),
            createdAt: report['createdAt'] as DateTime,
          ),
        );
      }

      // Add dummy vital signs
      final dummyVitals = [
        {
          'date': now.subtract(const Duration(days: 1)),
          'systolic': 120.0,
          'diastolic': 80.0,
          'heartRate': 72.0,
          'temperature': 98.6,
          'weight': 165.0,
          'height': 170.0,
        },
        {
          'date': now.subtract(const Duration(days: 7)),
          'systolic': 118.0,
          'diastolic': 76.0,
          'heartRate': 68.0,
          'temperature': 98.4,
          'weight': 164.5,
          'height': 170.0,
        },
        {
          'date': now.subtract(const Duration(days: 14)),
          'systolic': 115.0,
          'diastolic': 75.0,
          'heartRate': 70.0,
          'temperature': 98.6,
          'weight': 165.2,
          'height': 170.0,
        },
      ];

      for (final vital in dummyVitals) {
        await into(vitalSigns).insert(
          VitalSignsCompanion.insert(
            id: uuid.v4(),
            patientId: patientId,
            recordedDate: vital['date'] as DateTime,
            bloodPressureSystolic: Value(vital['systolic'] as double),
            bloodPressureDiastolic: Value(vital['diastolic'] as double),
            heartRate: Value(vital['heartRate'] as double),
            temperature: Value(vital['temperature'] as double),
            weight: Value(vital['weight'] as double),
            height: Value(vital['height'] as double),
            bmi: Value(
              (vital['weight'] as double) /
                  (((vital['height'] as double) / 100) *
                      ((vital['height'] as double) / 100)),
            ),
            recordedBy: const Value('Self-recorded'),
            notes: const Value('Routine measurement'),
            isSynced: const Value(false),
            createdAt: vital['date'] as DateTime,
          ),
        );
      }
    } catch (e) {
      print('Error populating dummy medical data: $e');
    }
  }

  // Family Group Operations
  Future<String> createFamilyGroup({
    required String primaryMemberId,
    required String familyName,
    String? address,
    String? village,
    String? pincode,
    String? emergencyContact,
    String? emergencyPhone,
    Map<String, dynamic>? healthInsurance,
  }) async {
    final id = const Uuid().v4();
    final familyGroup = FamilyGroupsCompanion(
      id: Value(id),
      primaryMemberId: Value(primaryMemberId),
      familyName: Value(familyName),
      address: Value(address),
      village: Value(village),
      pincode: Value(pincode),
      emergencyContact: Value(emergencyContact),
      emergencyPhone: Value(emergencyPhone),
      healthInsurance: Value(healthInsurance?.toString()),
      isActive: const Value(true),
      isSynced: const Value(false),
      createdAt: Value(DateTime.now()),
      lastModified: Value(DateTime.now()),
    );

    await into(familyGroups).insert(familyGroup);
    await _addToSyncQueue('family_groups', id, 'INSERT', {
      'id': id,
      'primaryMemberId': primaryMemberId,
      'familyName': familyName,
      'address': address,
      'village': village,
      'pincode': pincode,
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
      'healthInsurance': healthInsurance,
      'createdAt': DateTime.now().toIso8601String(),
    });

    return id;
  }

  Future<List<FamilyGroup>> getFamilyGroups(String primaryMemberId) async {
    return await (select(familyGroups)
          ..where(
            (fg) =>
                fg.primaryMemberId.equals(primaryMemberId) &
                fg.isActive.equals(true),
          )
          ..orderBy([
            (fg) =>
                OrderingTerm(expression: fg.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<FamilyGroup?> getFamilyGroupById(String id) async {
    return await (select(
      familyGroups,
    )..where((fg) => fg.id.equals(id))).getSingleOrNull();
  }

  // Family Member Operations
  Future<String> createFamilyMember({
    required String familyGroupId,
    required String primaryUserId,
    required String name,
    required String relationship,
    required DateTime dateOfBirth,
    required String gender,
    String? bloodGroup,
    String? phoneNumber,
    String? email,
    String? allergies,
    List<String>? medicalConditions,
    List<String>? medications,
    String? emergencyContact,
    bool hasOwnAccount = false,
    String? linkedAccountId,
    bool allowIndependentAccess = false,
    List<String>? caregiverPermissions,
    String? profileImageUrl,
  }) async {
    final id = const Uuid().v4();
    final familyMember = FamilyMembersCompanion(
      id: Value(id),
      familyGroupId: Value(familyGroupId),
      primaryUserId: Value(primaryUserId),
      name: Value(name),
      relationship: Value(relationship),
      dateOfBirth: Value(dateOfBirth),
      gender: Value(gender),
      bloodGroup: Value(bloodGroup),
      phoneNumber: Value(phoneNumber),
      email: Value(email),
      allergies: Value(allergies),
      medicalConditions: Value(medicalConditions?.toString()),
      medications: Value(medications?.toString()),
      emergencyContact: Value(emergencyContact),
      isActive: const Value(true),
      hasOwnAccount: Value(hasOwnAccount),
      linkedAccountId: Value(linkedAccountId),
      allowIndependentAccess: Value(allowIndependentAccess),
      caregiverPermissions: Value(caregiverPermissions?.toString()),
      profileImageUrl: Value(profileImageUrl),
      isSynced: const Value(false),
      createdAt: Value(DateTime.now()),
      lastModified: Value(DateTime.now()),
    );

    await into(familyMembers).insert(familyMember);
    await _addToSyncQueue('family_members', id, 'INSERT', {
      'id': id,
      'familyGroupId': familyGroupId,
      'primaryUserId': primaryUserId,
      'name': name,
      'relationship': relationship,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'bloodGroup': bloodGroup,
      'phoneNumber': phoneNumber,
      'email': email,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'medications': medications,
      'emergencyContact': emergencyContact,
      'hasOwnAccount': hasOwnAccount,
      'linkedAccountId': linkedAccountId,
      'allowIndependentAccess': allowIndependentAccess,
      'caregiverPermissions': caregiverPermissions,
      'profileImageUrl': profileImageUrl,
      'createdAt': DateTime.now().toIso8601String(),
    });

    return id;
  }

  Future<List<FamilyMember>> getFamilyMembers(String familyGroupId) async {
    return await (select(familyMembers)
          ..where(
            (fm) =>
                fm.familyGroupId.equals(familyGroupId) &
                fm.isActive.equals(true),
          )
          ..orderBy([
            (fm) =>
                OrderingTerm(expression: fm.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<List<FamilyMember>> getUserFamilyMembers(String primaryUserId) async {
    return await (select(familyMembers)
          ..where(
            (fm) =>
                fm.primaryUserId.equals(primaryUserId) &
                fm.isActive.equals(true),
          )
          ..orderBy([
            (fm) =>
                OrderingTerm(expression: fm.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<FamilyMember?> getFamilyMemberById(String id) async {
    return await (select(
      familyMembers,
    )..where((fm) => fm.id.equals(id))).getSingleOrNull();
  }

  Future<void> updateFamilyMember(
    String id,
    Map<String, dynamic> updates,
  ) async {
    final companion = FamilyMembersCompanion(
      name: updates['name'] != null
          ? Value(updates['name'])
          : const Value.absent(),
      relationship: updates['relationship'] != null
          ? Value(updates['relationship'])
          : const Value.absent(),
      bloodGroup: updates['bloodGroup'] != null
          ? Value(updates['bloodGroup'])
          : const Value.absent(),
      phoneNumber: updates['phoneNumber'] != null
          ? Value(updates['phoneNumber'])
          : const Value.absent(),
      email: updates['email'] != null
          ? Value(updates['email'])
          : const Value.absent(),
      allergies: updates['allergies'] != null
          ? Value(updates['allergies'])
          : const Value.absent(),
      medicalConditions: updates['medicalConditions'] != null
          ? Value(updates['medicalConditions'].toString())
          : const Value.absent(),
      medications: updates['medications'] != null
          ? Value(updates['medications'].toString())
          : const Value.absent(),
      emergencyContact: updates['emergencyContact'] != null
          ? Value(updates['emergencyContact'])
          : const Value.absent(),
      lastModified: Value(DateTime.now()),
      isSynced: const Value(false),
    );

    await (update(
      familyMembers,
    )..where((fm) => fm.id.equals(id))).write(companion);
    await _addToSyncQueue('family_members', id, 'UPDATE', updates);
  }

  // Family Health Record Operations
  Future<String> createFamilyHealthRecord({
    required String familyMemberId,
    required String familyGroupId,
    required String recordType,
    required String title,
    String? description,
    String? condition,
    List<String>? symptoms,
    String severity = 'normal',
    String? treatment,
    List<String>? medications,
    String? doctorName,
    String? hospitalName,
    String? reportUrl,
    List<String>? attachments,
    required DateTime recordDate,
    DateTime? followUpDate,
    bool isEmergency = false,
    bool isResolved = false,
    String? notes,
  }) async {
    final id = const Uuid().v4();
    final healthRecord = FamilyHealthRecordsCompanion(
      id: Value(id),
      familyMemberId: Value(familyMemberId),
      familyGroupId: Value(familyGroupId),
      recordType: Value(recordType),
      title: Value(title),
      description: Value(description),
      condition: Value(condition),
      symptoms: Value(symptoms?.toString()),
      severity: Value(severity),
      treatment: Value(treatment),
      medications: Value(medications?.toString()),
      doctorName: Value(doctorName),
      hospitalName: Value(hospitalName),
      reportUrl: Value(reportUrl),
      attachments: Value(attachments?.toString()),
      recordDate: Value(recordDate),
      followUpDate: Value(followUpDate),
      isEmergency: Value(isEmergency),
      isResolved: Value(isResolved),
      notes: Value(notes),
      isSynced: const Value(false),
      createdAt: Value(DateTime.now()),
      lastModified: Value(DateTime.now()),
    );

    await into(familyHealthRecords).insert(healthRecord);
    await _addToSyncQueue('family_health_records', id, 'INSERT', {
      'id': id,
      'familyMemberId': familyMemberId,
      'familyGroupId': familyGroupId,
      'recordType': recordType,
      'title': title,
      'description': description,
      'condition': condition,
      'symptoms': symptoms,
      'severity': severity,
      'treatment': treatment,
      'medications': medications,
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'reportUrl': reportUrl,
      'attachments': attachments,
      'recordDate': recordDate.toIso8601String(),
      'followUpDate': followUpDate?.toIso8601String(),
      'isEmergency': isEmergency,
      'isResolved': isResolved,
      'notes': notes,
      'createdAt': DateTime.now().toIso8601String(),
    });

    return id;
  }

  Future<List<FamilyHealthRecord>> getFamilyHealthRecords(
    String familyMemberId,
  ) async {
    return await (select(familyHealthRecords)
          ..where((fhr) => fhr.familyMemberId.equals(familyMemberId))
          ..orderBy([
            (fhr) => OrderingTerm(
              expression: fhr.recordDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  Future<List<FamilyHealthRecord>> getFamilyGroupHealthRecords(
    String familyGroupId,
  ) async {
    return await (select(familyHealthRecords)
          ..where((fhr) => fhr.familyGroupId.equals(familyGroupId))
          ..orderBy([
            (fhr) => OrderingTerm(
              expression: fhr.recordDate,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  // Caregiver Session Operations
  Future<String> startCaregiverSession(
    String caregiverId,
    String dependentId,
    List<String> features,
  ) async {
    final id = const Uuid().v4();
    final session = CaregiverSessionsCompanion(
      id: Value(id),
      caregiverId: Value(caregiverId),
      dependentId: Value(dependentId),
      startTime: Value(DateTime.now()),
      activatedFeatures: Value(features.toString()),
      actionsPerformed: const Value('[]'),
      isActive: const Value(true),
      createdAt: Value(DateTime.now()),
    );

    await into(caregiverSessions).insert(session);
    return id;
  }

  Future<void> endCaregiverSession(String sessionId) async {
    await (update(
      caregiverSessions,
    )..where((cs) => cs.id.equals(sessionId))).write(
      CaregiverSessionsCompanion(
        endTime: Value(DateTime.now()),
        isActive: const Value(false),
      ),
    );
  }

  Future<CaregiverSession?> getActiveCaregiverSession(
    String caregiverId,
  ) async {
    return await (select(caregiverSessions)..where(
          (cs) => cs.caregiverId.equals(caregiverId) & cs.isActive.equals(true),
        ))
        .getSingleOrNull();
  }

  Future<List<CaregiverSession>> getCaregiverSessions(
    String caregiverId,
  ) async {
    return await (select(caregiverSessions)
          ..where((cs) => cs.caregiverId.equals(caregiverId))
          ..orderBy([
            (cs) =>
                OrderingTerm(expression: cs.startTime, mode: OrderingMode.desc),
          ]))
        .get();
  }

  // Sync Queue Operations
  Future<void> _addToSyncQueue(
    String tableName,
    String recordId,
    String operation,
    Map<String, dynamic> data, {
    int priority = 2,
  }) async {
    final id = const Uuid().v4();
    final syncItem = SyncQueuesCompanion(
      id: Value(id),
      targetTable: Value(tableName),
      recordId: Value(recordId),
      operation: Value(operation),
      data: Value(data.toString()),
      priority: Value(priority),
      createdAt: Value(DateTime.now()),
    );

    await into(syncQueues).insert(syncItem);
  }

  Future<List<SyncQueue>> getPendingSyncItems() async {
    return await (select(syncQueues)..orderBy([
          (s) => OrderingTerm(expression: s.priority),
          (s) => OrderingTerm(expression: s.createdAt),
        ]))
        .get();
  }

  Future<void> removeSyncItem(String id) async {
    await (delete(syncQueues)..where((s) => s.id.equals(id))).go();
  }

  Future<void> incrementSyncRetry(String id) async {
    final item = await (select(
      syncQueues,
    )..where((s) => s.id.equals(id))).getSingleOrNull();
    if (item != null) {
      await (update(syncQueues)..where((s) => s.id.equals(id))).write(
        SyncQueuesCompanion(
          retryCount: Value(item.retryCount + 1),
          lastAttempt: Value(DateTime.now()),
        ),
      );
    }
  }

  // Database maintenance
  Future<void> clearOldData() async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    // Clean old symptom checks
    await (delete(
      offlineSymptomChecks,
    )..where((s) => s.checkedAt.isSmallerThanValue(thirtyDaysAgo))).go();

    // Clean failed sync items (retry count > 5)
    await (delete(
      syncQueues,
    )..where((s) => s.retryCount.isBiggerThanValue(5))).go();
  }

  Future<Map<String, int>> getDatabaseStats() async {
    final stats = <String, int>{};

    stats['profiles'] = await (select(
      patientProfiles,
    )).get().then((rows) => rows.length);
    stats['appointments'] = await (select(
      offlineAppointments,
    )).get().then((rows) => rows.length);
    stats['prescriptions'] = await (select(
      cachedPrescriptions,
    )).get().then((rows) => rows.length);
    stats['symptom_checks'] = await (select(
      offlineSymptomChecks,
    )).get().then((rows) => rows.length);
    stats['pending_sync'] = await (select(
      syncQueues,
    )).get().then((rows) => rows.length);

    return stats;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'telemed_offline.db'));
    return NativeDatabase(file);
  });
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/emergency_medical_data.dart';

class EmergencyDataService {
  static final EmergencyDataService _instance =
      EmergencyDataService._internal();
  factory EmergencyDataService() => _instance;
  EmergencyDataService._internal();

  Database? _database;

  // Initialize database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'emergency_data.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Emergency data table
    await db.execute('''
      CREATE TABLE emergency_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id TEXT UNIQUE,
        blood_type TEXT,
        allergies TEXT,
        chronic_conditions TEXT,
        emergency_contact TEXT,
        critical_medications TEXT,
        medical_alerts TEXT,
        last_updated TEXT
      )
    ''');

    // General data table
    await db.execute('''
      CREATE TABLE general_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id TEXT UNIQUE,
        past_prescriptions TEXT,
        recent_lab_reports TEXT,
        medical_history TEXT,
        vaccinations TEXT,
        surgical_history TEXT,
        last_updated TEXT
      )
    ''');

    // Sensitive data table
    await db.execute('''
      CREATE TABLE sensitive_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id TEXT UNIQUE,
        mental_health_history TEXT,
        genetic_information TEXT,
        reproductive_health TEXT,
        substance_use_history TEXT,
        family_medical_history TEXT,
        sensitive_documents TEXT,
        last_updated TEXT
      )
    ''');

    // Access logs table
    await db.execute('''
      CREATE TABLE access_logs (
        id TEXT PRIMARY KEY,
        patient_id TEXT,
        token_id TEXT,
        doctor_id TEXT,
        doctor_name TEXT,
        hospital_name TEXT,
        access_time TEXT,
        location TEXT,
        reason TEXT
      )
    ''');

    // QR tokens table
    await db.execute('''
      CREATE TABLE qr_tokens (
        token_id TEXT PRIMARY KEY,
        patient_id TEXT,
        generated_at TEXT,
        expires_at TEXT,
        is_active INTEGER,
        last_accessed_by TEXT,
        last_accessed_at TEXT
      )
    ''');
  }

  // Emergency Data (Level 1) operations
  Future<EmergencyMedicalData?> getEmergencyData(String patientId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'emergency_data',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return EmergencyMedicalData(
        patientId: map['patient_id'],
        bloodType: map['blood_type'] ?? '',
        allergies: List<String>.from(jsonDecode(map['allergies'] ?? '[]')),
        chronicConditions: List<String>.from(
          jsonDecode(map['chronic_conditions'] ?? '[]'),
        ),
        emergencyContact: EmergencyContact.fromJson(
          jsonDecode(map['emergency_contact'] ?? '{}'),
        ),
        criticalMedications: List<String>.from(
          jsonDecode(map['critical_medications'] ?? '[]'),
        ),
        medicalAlerts: map['medical_alerts'],
        lastUpdated: DateTime.parse(map['last_updated']),
      );
    }
    return null;
  }

  Future<void> saveEmergencyData(EmergencyMedicalData data) async {
    final db = await database;
    await db.insert('emergency_data', {
      'patient_id': data.patientId,
      'blood_type': data.bloodType,
      'allergies': jsonEncode(data.allergies),
      'chronic_conditions': jsonEncode(data.chronicConditions),
      'emergency_contact': jsonEncode(data.emergencyContact.toJson()),
      'critical_medications': jsonEncode(data.criticalMedications),
      'medical_alerts': data.medicalAlerts,
      'last_updated': data.lastUpdated.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // General Data (Level 2) operations
  Future<GeneralMedicalData?> getGeneralData(String patientId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'general_data',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return GeneralMedicalData(
        patientId: map['patient_id'],
        pastPrescriptions:
            (jsonDecode(map['past_prescriptions'] ?? '[]') as List)
                .map((p) => Prescription.fromJson(p))
                .toList(),
        recentLabReports:
            (jsonDecode(map['recent_lab_reports'] ?? '[]') as List)
                .map((r) => LabReport.fromJson(r))
                .toList(),
        medicalHistory: List<String>.from(
          jsonDecode(map['medical_history'] ?? '[]'),
        ),
        vaccinations: (jsonDecode(map['vaccinations'] ?? '[]') as List)
            .map((v) => Vaccination.fromJson(v))
            .toList(),
        surgicalHistory: List<String>.from(
          jsonDecode(map['surgical_history'] ?? '[]'),
        ),
        lastUpdated: DateTime.parse(map['last_updated']),
      );
    }
    return null;
  }

  Future<void> saveGeneralData(GeneralMedicalData data) async {
    final db = await database;
    await db.insert('general_data', {
      'patient_id': data.patientId,
      'past_prescriptions': jsonEncode(
        data.pastPrescriptions.map((p) => p.toJson()).toList(),
      ),
      'recent_lab_reports': jsonEncode(
        data.recentLabReports.map((r) => r.toJson()).toList(),
      ),
      'medical_history': jsonEncode(data.medicalHistory),
      'vaccinations': jsonEncode(
        data.vaccinations.map((v) => v.toJson()).toList(),
      ),
      'surgical_history': jsonEncode(data.surgicalHistory),
      'last_updated': data.lastUpdated.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Sensitive Data (Level 3) operations
  Future<SensitiveMedicalData?> getSensitiveData(String patientId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sensitive_data',
      where: 'patient_id = ?',
      whereArgs: [patientId],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return SensitiveMedicalData(
        patientId: map['patient_id'],
        mentalHealthHistory: List<String>.from(
          jsonDecode(map['mental_health_history'] ?? '[]'),
        ),
        geneticInformation: List<String>.from(
          jsonDecode(map['genetic_information'] ?? '[]'),
        ),
        reproductiveHealth: List<String>.from(
          jsonDecode(map['reproductive_health'] ?? '[]'),
        ),
        substanceUseHistory: List<String>.from(
          jsonDecode(map['substance_use_history'] ?? '[]'),
        ),
        familyMedicalHistory: List<String>.from(
          jsonDecode(map['family_medical_history'] ?? '[]'),
        ),
        sensitiveDocuments:
            (jsonDecode(map['sensitive_documents'] ?? '[]') as List)
                .map((d) => Document.fromJson(d))
                .toList(),
        lastUpdated: DateTime.parse(map['last_updated']),
      );
    }
    return null;
  }

  Future<void> saveSensitiveData(SensitiveMedicalData data) async {
    final db = await database;
    await db.insert('sensitive_data', {
      'patient_id': data.patientId,
      'mental_health_history': jsonEncode(data.mentalHealthHistory),
      'genetic_information': jsonEncode(data.geneticInformation),
      'reproductive_health': jsonEncode(data.reproductiveHealth),
      'substance_use_history': jsonEncode(data.substanceUseHistory),
      'family_medical_history': jsonEncode(data.familyMedicalHistory),
      'sensitive_documents': jsonEncode(
        data.sensitiveDocuments.map((d) => d.toJson()).toList(),
      ),
      'last_updated': data.lastUpdated.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Access logs operations
  Future<List<EmergencyAccessLog>> getAccessLogs(String patientId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'access_logs',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'access_time DESC',
    );

    return maps
        .map(
          (map) => EmergencyAccessLog(
            id: map['id'],
            patientId: map['patient_id'],
            tokenId: map['token_id'],
            doctorId: map['doctor_id'],
            doctorName: map['doctor_name'],
            hospitalName: map['hospital_name'],
            accessTime: DateTime.parse(map['access_time']),
            location: map['location'],
            reason: map['reason'],
          ),
        )
        .toList();
  }

  Future<void> saveAccessLog(EmergencyAccessLog log) async {
    final db = await database;
    await db.insert('access_logs', {
      'id': log.id,
      'patient_id': log.patientId,
      'token_id': log.tokenId,
      'doctor_id': log.doctorId,
      'doctor_name': log.doctorName,
      'hospital_name': log.hospitalName,
      'access_time': log.accessTime.toIso8601String(),
      'location': log.location,
      'reason': log.reason,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // QR Token operations
  Future<void> saveQRToken(EmergencyQRToken token) async {
    final db = await database;
    await db.insert('qr_tokens', {
      'token_id': token.tokenId,
      'patient_id': token.patientId,
      'generated_at': token.generatedAt.toIso8601String(),
      'expires_at': token.expiresAt.toIso8601String(),
      'is_active': token.isActive ? 1 : 0,
      'last_accessed_by': token.lastAccessedBy,
      'last_accessed_at': token.lastAccessedAt?.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<EmergencyQRToken>> getActiveQRTokens(String patientId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'qr_tokens',
      where: 'patient_id = ? AND is_active = 1',
      whereArgs: [patientId],
      orderBy: 'generated_at DESC',
    );

    return maps
        .map(
          (map) => EmergencyQRToken(
            tokenId: map['token_id'],
            patientId: map['patient_id'],
            generatedAt: DateTime.parse(map['generated_at']),
            expiresAt: DateTime.parse(map['expires_at']),
            isActive: map['is_active'] == 1,
            lastAccessedBy: map['last_accessed_by'],
            lastAccessedAt: map['last_accessed_at'] != null
                ? DateTime.parse(map['last_accessed_at'])
                : null,
          ),
        )
        .toList();
  }

  Future<void> revokeQRToken(String tokenId) async {
    final db = await database;
    await db.update(
      'qr_tokens',
      {'is_active': 0},
      where: 'token_id = ?',
      whereArgs: [tokenId],
    );
  }

  // Sample data initialization for testing
  Future<void> initializeSampleData(String patientId) async {
    // Check if data already exists
    final existingData = await getEmergencyData(patientId);
    if (existingData != null) return;

    // Initialize with sample emergency data
    final sampleEmergencyData = EmergencyMedicalData(
      patientId: patientId,
      bloodType: 'O+',
      allergies: ['Penicillin', 'Shellfish'],
      chronicConditions: ['Type 2 Diabetes', 'Hypertension'],
      emergencyContact: EmergencyContact(
        name: 'John Doe',
        relationship: 'Spouse',
        phoneNumber: '+91 98765 43210',
        alternatePhone: '+91 98765 43211',
        email: 'john.doe@email.com',
      ),
      criticalMedications: ['Metformin 500mg', 'Amlodipine 5mg'],
      medicalAlerts: 'Patient has severe allergic reaction to Penicillin',
      lastUpdated: DateTime.now(),
    );

    await saveEmergencyData(sampleEmergencyData);

    // Initialize sample access logs
    final sampleLogs = [
      EmergencyAccessLog(
        id: '1',
        patientId: patientId,
        tokenId: 'sample_token_1',
        doctorId: 'doc_123',
        doctorName: 'Dr. Emergency Physician',
        hospitalName: 'City General Hospital',
        accessTime: DateTime.now().subtract(const Duration(days: 5)),
        location: 'Emergency Room',
        reason: 'Car accident - critical condition',
      ),
      EmergencyAccessLog(
        id: '2',
        patientId: patientId,
        tokenId: 'sample_token_2',
        doctorId: 'doc_456',
        doctorName: 'Dr. First Responder',
        hospitalName: 'Metro Emergency Services',
        accessTime: DateTime.now().subtract(const Duration(days: 15)),
        location: 'Ambulance',
        reason: 'Cardiac event - patient unconscious',
      ),
    ];

    for (final log in sampleLogs) {
      await saveAccessLog(log);
    }
  }

  // Clean up expired tokens
  Future<void> cleanupExpiredTokens() async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    await db.update(
      'qr_tokens',
      {'is_active': 0},
      where: 'expires_at < ?',
      whereArgs: [now],
    );
  }
}

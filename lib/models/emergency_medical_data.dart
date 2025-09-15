// Emergency Medical Data Classification
enum DataAccessLevel {
  emergency, // Level 1: Critical emergency information
  general, // Level 2: General consultation data
  sensitive, // Level 3: Highly sensitive/personal data
}

// Level 1 - Emergency Data (Critical for first responders)
class EmergencyMedicalData {
  final String patientId;
  final String bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;
  final EmergencyContact emergencyContact;
  final List<String> criticalMedications;
  final String? medicalAlerts;
  final DateTime lastUpdated;

  EmergencyMedicalData({
    required this.patientId,
    required this.bloodType,
    required this.allergies,
    required this.chronicConditions,
    required this.emergencyContact,
    required this.criticalMedications,
    this.medicalAlerts,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'bloodType': bloodType,
      'allergies': allergies,
      'chronicConditions': chronicConditions,
      'emergencyContact': emergencyContact.toJson(),
      'criticalMedications': criticalMedications,
      'medicalAlerts': medicalAlerts,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory EmergencyMedicalData.fromJson(Map<String, dynamic> json) {
    return EmergencyMedicalData(
      patientId: json['patientId'],
      bloodType: json['bloodType'],
      allergies: List<String>.from(json['allergies']),
      chronicConditions: List<String>.from(json['chronicConditions']),
      emergencyContact: EmergencyContact.fromJson(json['emergencyContact']),
      criticalMedications: List<String>.from(json['criticalMedications']),
      medicalAlerts: json['medicalAlerts'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

// Emergency Contact Information
class EmergencyContact {
  final String name;
  final String relationship;
  final String phoneNumber;
  final String? alternatePhone;
  final String? email;

  EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    this.alternatePhone,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relationship': relationship,
      'phoneNumber': phoneNumber,
      'alternatePhone': alternatePhone,
      'email': email,
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      relationship: json['relationship'],
      phoneNumber: json['phoneNumber'],
      alternatePhone: json['alternatePhone'],
      email: json['email'],
    );
  }
}

// Level 2 - General Consultation Data
class GeneralMedicalData {
  final String patientId;
  final List<Prescription> pastPrescriptions;
  final List<LabReport> recentLabReports;
  final List<String> medicalHistory;
  final List<Vaccination> vaccinations;
  final List<String> surgicalHistory;
  final DateTime lastUpdated;

  GeneralMedicalData({
    required this.patientId,
    required this.pastPrescriptions,
    required this.recentLabReports,
    required this.medicalHistory,
    required this.vaccinations,
    required this.surgicalHistory,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'pastPrescriptions': pastPrescriptions.map((p) => p.toJson()).toList(),
      'recentLabReports': recentLabReports.map((r) => r.toJson()).toList(),
      'medicalHistory': medicalHistory,
      'vaccinations': vaccinations.map((v) => v.toJson()).toList(),
      'surgicalHistory': surgicalHistory,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory GeneralMedicalData.fromJson(Map<String, dynamic> json) {
    return GeneralMedicalData(
      patientId: json['patientId'],
      pastPrescriptions: (json['pastPrescriptions'] as List)
          .map((p) => Prescription.fromJson(p))
          .toList(),
      recentLabReports: (json['recentLabReports'] as List)
          .map((r) => LabReport.fromJson(r))
          .toList(),
      medicalHistory: List<String>.from(json['medicalHistory']),
      vaccinations: (json['vaccinations'] as List)
          .map((v) => Vaccination.fromJson(v))
          .toList(),
      surgicalHistory: List<String>.from(json['surgicalHistory']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

// Level 3 - Sensitive Data
class SensitiveMedicalData {
  final String patientId;
  final List<String> mentalHealthHistory;
  final List<String> geneticInformation;
  final List<String> reproductiveHealth;
  final List<String> substanceUseHistory;
  final List<String> familyMedicalHistory;
  final List<Document> sensitiveDocuments;
  final DateTime lastUpdated;

  SensitiveMedicalData({
    required this.patientId,
    required this.mentalHealthHistory,
    required this.geneticInformation,
    required this.reproductiveHealth,
    required this.substanceUseHistory,
    required this.familyMedicalHistory,
    required this.sensitiveDocuments,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'mentalHealthHistory': mentalHealthHistory,
      'geneticInformation': geneticInformation,
      'reproductiveHealth': reproductiveHealth,
      'substanceUseHistory': substanceUseHistory,
      'familyMedicalHistory': familyMedicalHistory,
      'sensitiveDocuments': sensitiveDocuments.map((d) => d.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory SensitiveMedicalData.fromJson(Map<String, dynamic> json) {
    return SensitiveMedicalData(
      patientId: json['patientId'],
      mentalHealthHistory: List<String>.from(json['mentalHealthHistory']),
      geneticInformation: List<String>.from(json['geneticInformation']),
      reproductiveHealth: List<String>.from(json['reproductiveHealth']),
      substanceUseHistory: List<String>.from(json['substanceUseHistory']),
      familyMedicalHistory: List<String>.from(json['familyMedicalHistory']),
      sensitiveDocuments: (json['sensitiveDocuments'] as List)
          .map((d) => Document.fromJson(d))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

// Supporting data models
class Prescription {
  final String id;
  final String doctorName;
  final String hospitalName;
  final List<String> medications;
  final DateTime prescribedDate;
  final String? notes;

  Prescription({
    required this.id,
    required this.doctorName,
    required this.hospitalName,
    required this.medications,
    required this.prescribedDate,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'medications': medications,
      'prescribedDate': prescribedDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      doctorName: json['doctorName'],
      hospitalName: json['hospitalName'],
      medications: List<String>.from(json['medications']),
      prescribedDate: DateTime.parse(json['prescribedDate']),
      notes: json['notes'],
    );
  }
}

class LabReport {
  final String id;
  final String testName;
  final String result;
  final String normalRange;
  final DateTime testDate;
  final String labName;

  LabReport({
    required this.id,
    required this.testName,
    required this.result,
    required this.normalRange,
    required this.testDate,
    required this.labName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testName': testName,
      'result': result,
      'normalRange': normalRange,
      'testDate': testDate.toIso8601String(),
      'labName': labName,
    };
  }

  factory LabReport.fromJson(Map<String, dynamic> json) {
    return LabReport(
      id: json['id'],
      testName: json['testName'],
      result: json['result'],
      normalRange: json['normalRange'],
      testDate: DateTime.parse(json['testDate']),
      labName: json['labName'],
    );
  }
}

class Vaccination {
  final String name;
  final DateTime dateAdministered;
  final String? batchNumber;
  final String? administeredBy;

  Vaccination({
    required this.name,
    required this.dateAdministered,
    this.batchNumber,
    this.administeredBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateAdministered': dateAdministered.toIso8601String(),
      'batchNumber': batchNumber,
      'administeredBy': administeredBy,
    };
  }

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      name: json['name'],
      dateAdministered: DateTime.parse(json['dateAdministered']),
      batchNumber: json['batchNumber'],
      administeredBy: json['administeredBy'],
    );
  }
}

class Document {
  final String id;
  final String name;
  final String type;
  final String filePath;
  final DateTime uploadDate;
  final DataAccessLevel accessLevel;

  Document({
    required this.id,
    required this.name,
    required this.type,
    required this.filePath,
    required this.uploadDate,
    required this.accessLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'filePath': filePath,
      'uploadDate': uploadDate.toIso8601String(),
      'accessLevel': accessLevel.toString(),
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      filePath: json['filePath'],
      uploadDate: DateTime.parse(json['uploadDate']),
      accessLevel: DataAccessLevel.values.firstWhere(
        (level) => level.toString() == json['accessLevel'],
      ),
    );
  }
}

// QR Code Token for Emergency Access
class EmergencyQRToken {
  final String tokenId;
  final String patientId;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final bool isActive;
  final String? lastAccessedBy;
  final DateTime? lastAccessedAt;

  EmergencyQRToken({
    required this.tokenId,
    required this.patientId,
    required this.generatedAt,
    required this.expiresAt,
    required this.isActive,
    this.lastAccessedBy,
    this.lastAccessedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'tokenId': tokenId,
      'patientId': patientId,
      'generatedAt': generatedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isActive': isActive,
      'lastAccessedBy': lastAccessedBy,
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
    };
  }

  factory EmergencyQRToken.fromJson(Map<String, dynamic> json) {
    return EmergencyQRToken(
      tokenId: json['tokenId'],
      patientId: json['patientId'],
      generatedAt: DateTime.parse(json['generatedAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      isActive: json['isActive'],
      lastAccessedBy: json['lastAccessedBy'],
      lastAccessedAt: json['lastAccessedAt'] != null
          ? DateTime.parse(json['lastAccessedAt'])
          : null,
    );
  }
}

// Emergency Access Log
class EmergencyAccessLog {
  final String id;
  final String patientId;
  final String tokenId;
  final String doctorId;
  final String doctorName;
  final String hospitalName;
  final DateTime accessTime;
  final String location;
  final String reason;

  EmergencyAccessLog({
    required this.id,
    required this.patientId,
    required this.tokenId,
    required this.doctorId,
    required this.doctorName,
    required this.hospitalName,
    required this.accessTime,
    required this.location,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'tokenId': tokenId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'accessTime': accessTime.toIso8601String(),
      'location': location,
      'reason': reason,
    };
  }

  factory EmergencyAccessLog.fromJson(Map<String, dynamic> json) {
    return EmergencyAccessLog(
      id: json['id'],
      patientId: json['patientId'],
      tokenId: json['tokenId'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      hospitalName: json['hospitalName'],
      accessTime: DateTime.parse(json['accessTime']),
      location: json['location'],
      reason: json['reason'],
    );
  }
}

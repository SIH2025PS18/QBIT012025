import 'package:json_annotation/json_annotation.dart';

part 'medical_record.g.dart';

// Medical Record Models for Offline Storage
class MedicalReport {
  final String id;
  final String patientId;
  final String reportType;
  final String title;
  final String hospitalName;
  final String doctorName;
  final String doctorSpecialization;
  final DateTime reportDate;
  final DateTime issuedDate;
  final String summary;
  final List<String> findings;
  final List<String> recommendations;
  final Map<String, dynamic> testResults;
  final List<String> prescriptions;
  final String severity;
  final bool isEmergency;
  final String reportUrl;
  final List<String> attachments;
  final Map<String, dynamic> vitalSigns;
  final String status;

  MedicalReport({
    required this.id,
    required this.patientId,
    required this.reportType,
    required this.title,
    required this.hospitalName,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.reportDate,
    required this.issuedDate,
    required this.summary,
    this.findings = const [],
    this.recommendations = const [],
    this.testResults = const {},
    this.prescriptions = const [],
    this.severity = 'Normal',
    this.isEmergency = false,
    this.reportUrl = '',
    this.attachments = const [],
    this.vitalSigns = const {},
    this.status = 'Final',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'report_type': reportType,
      'title': title,
      'hospital_name': hospitalName,
      'doctor_name': doctorName,
      'doctor_specialization': doctorSpecialization,
      'report_date': reportDate.toIso8601String(),
      'issued_date': issuedDate.toIso8601String(),
      'summary': summary,
      'findings': findings,
      'recommendations': recommendations,
      'test_results': testResults,
      'prescriptions': prescriptions,
      'severity': severity,
      'is_emergency': isEmergency,
      'report_url': reportUrl,
      'attachments': attachments,
      'vital_signs': vitalSigns,
      'status': status,
    };
  }

  factory MedicalReport.fromMap(Map<String, dynamic> map) {
    return MedicalReport(
      id: map['id'] ?? '',
      patientId: map['patient_id'] ?? '',
      reportType: map['report_type'] ?? '',
      title: map['title'] ?? '',
      hospitalName: map['hospital_name'] ?? '',
      doctorName: map['doctor_name'] ?? '',
      doctorSpecialization: map['doctor_specialization'] ?? '',
      reportDate: DateTime.parse(map['report_date']),
      issuedDate: DateTime.parse(map['issued_date']),
      summary: map['summary'] ?? '',
      findings: List<String>.from(map['findings'] ?? []),
      recommendations: List<String>.from(map['recommendations'] ?? []),
      testResults: Map<String, dynamic>.from(map['test_results'] ?? {}),
      prescriptions: List<String>.from(map['prescriptions'] ?? []),
      severity: map['severity'] ?? 'Normal',
      isEmergency: map['is_emergency'] ?? false,
      reportUrl: map['report_url'] ?? '',
      attachments: List<String>.from(map['attachments'] ?? []),
      vitalSigns: Map<String, dynamic>.from(map['vital_signs'] ?? {}),
      status: map['status'] ?? 'Final',
    );
  }
}

class VitalSigns {
  final String id;
  final String patientId;
  final DateTime recordedDate;
  final double? bloodPressureSystolic;
  final double? bloodPressureDiastolic;
  final double? heartRate;
  final double? temperature;
  final double? respiratoryRate;
  final double? oxygenSaturation;
  final double? bloodSugar;
  final double? weight;
  final double? height;
  final double? bmi;
  final String recordedBy;
  final String notes;

  VitalSigns({
    required this.id,
    required this.patientId,
    required this.recordedDate,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    this.heartRate,
    this.temperature,
    this.respiratoryRate,
    this.oxygenSaturation,
    this.bloodSugar,
    this.weight,
    this.height,
    this.bmi,
    this.recordedBy = '',
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'recorded_date': recordedDate.toIso8601String(),
      'blood_pressure_systolic': bloodPressureSystolic,
      'blood_pressure_diastolic': bloodPressureDiastolic,
      'heart_rate': heartRate,
      'temperature': temperature,
      'respiratory_rate': respiratoryRate,
      'oxygen_saturation': oxygenSaturation,
      'blood_sugar': bloodSugar,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'recorded_by': recordedBy,
      'notes': notes,
    };
  }
}

// Dummy Data Generator for Offline Testing
class DummyMedicalDataGenerator {
  static List<MedicalReport> generateDummyReports(String patientId) {
    final now = DateTime.now();

    return [
      // Blood Test Report
      MedicalReport(
        id: 'report_001',
        patientId: patientId,
        reportType: 'Blood Test',
        title: 'Complete Blood Count (CBC)',
        hospitalName: 'AIIMS New Delhi',
        doctorName: 'Dr. Priya Sharma',
        doctorSpecialization: 'Pathology',
        reportDate: now.subtract(const Duration(days: 7)),
        issuedDate: now.subtract(const Duration(days: 6)),
        summary:
            'Complete blood count analysis showing normal parameters with slight vitamin D deficiency.',
        findings: [
          'Hemoglobin: 13.2 g/dL (Normal)',
          'WBC Count: 7,200/μL (Normal)',
          'Platelet Count: 250,000/μL (Normal)',
          'Vitamin D: 18 ng/mL (Low)',
          'Blood Sugar (Fasting): 95 mg/dL (Normal)',
        ],
        recommendations: [
          'Increase Vitamin D intake through supplements',
          'Maintain regular diet and exercise',
          'Follow up after 3 months',
          'Include more sunlight exposure',
        ],
        testResults: {
          'hemoglobin': 13.2,
          'wbc': 7200,
          'platelets': 250000,
          'vitaminD': 18,
          'bloodSugar': 95,
        },
        prescriptions: [
          'Vitamin D3 60,000 IU once weekly',
          'Calcium + Magnesium supplement daily',
        ],
        severity: 'Low',
        vitalSigns: {'bp_systolic': 120, 'bp_diastolic': 80, 'pulse': 72},
        status: 'Final',
      ),

      // X-Ray Report
      MedicalReport(
        id: 'report_002',
        patientId: patientId,
        reportType: 'X-Ray',
        title: 'Chest X-Ray',
        hospitalName: 'Apollo Hospital Mumbai',
        doctorName: 'Dr. Rajesh Kumar',
        doctorSpecialization: 'Radiology',
        reportDate: now.subtract(const Duration(days: 15)),
        issuedDate: now.subtract(const Duration(days: 14)),
        summary:
            'Chest X-ray PA view showing clear lung fields with no acute pathology.',
        findings: [
          'Clear lung fields bilaterally',
          'Normal cardiac silhouette',
          'No pleural effusion',
          'Bony structures appear normal',
          'No signs of tuberculosis or pneumonia',
        ],
        recommendations: [
          'No immediate treatment required',
          'Maintain good respiratory hygiene',
          'Annual health check-up recommended',
        ],
        testResults: {
          'lungFields': 'Clear',
          'heartSize': 'Normal',
          'boneDensity': 'Normal',
        },
        severity: 'Normal',
        status: 'Final',
      ),

      // ECG Report
      MedicalReport(
        id: 'report_003',
        patientId: patientId,
        reportType: 'ECG',
        title: 'Electrocardiogram (12-Lead ECG)',
        hospitalName: 'Fortis Hospital Bangalore',
        doctorName: 'Dr. Anil Mehta',
        doctorSpecialization: 'Cardiology',
        reportDate: now.subtract(const Duration(days: 30)),
        issuedDate: now.subtract(const Duration(days: 30)),
        summary:
            'Normal sinus rhythm with no significant abnormalities detected.',
        findings: [
          'Normal sinus rhythm (75 bpm)',
          'Normal PR interval (0.16 sec)',
          'Normal QRS duration (0.08 sec)',
          'No ST-T wave abnormalities',
          'No signs of ischemia or arrhythmia',
        ],
        recommendations: [
          'Continue regular exercise',
          'Maintain heart-healthy diet',
          'Monitor blood pressure regularly',
          'Annual cardiac check-up',
        ],
        testResults: {
          'heartRate': 75,
          'rhythm': 'Normal Sinus',
          'prInterval': 0.16,
          'qrsDuration': 0.08,
        },
        vitalSigns: {'bp_systolic': 118, 'bp_diastolic': 78, 'heart_rate': 75},
        severity: 'Normal',
        status: 'Final',
      ),

      // Ultrasound Report
      MedicalReport(
        id: 'report_004',
        patientId: patientId,
        reportType: 'Ultrasound',
        title: 'Abdominal Ultrasound',
        hospitalName: 'Max Hospital Delhi',
        doctorName: 'Dr. Sita Patel',
        doctorSpecialization: 'Radiology',
        reportDate: now.subtract(const Duration(days: 45)),
        issuedDate: now.subtract(const Duration(days: 44)),
        summary:
            'Abdominal ultrasound showing normal organ structures with mild fatty liver.',
        findings: [
          'Liver: Mild fatty infiltration, normal size',
          'Gallbladder: Normal, no stones',
          'Kidneys: Normal size and echogenicity',
          'Pancreas: Normal appearance',
          'Spleen: Normal size and texture',
        ],
        recommendations: [
          'Reduce fatty food intake',
          'Regular exercise for weight management',
          'Limit alcohol consumption',
          'Follow-up ultrasound in 6 months',
        ],
        testResults: {
          'liverCondition': 'Mild Fatty Liver',
          'gallbladder': 'Normal',
          'kidneys': 'Normal',
          'pancreas': 'Normal',
        },
        severity: 'Mild',
        status: 'Final',
      ),

      // Vaccination Record
      MedicalReport(
        id: 'report_005',
        patientId: patientId,
        reportType: 'Vaccination',
        title: 'COVID-19 Vaccination Certificate',
        hospitalName: 'Primary Health Center',
        doctorName: 'Dr. Kavita Singh',
        doctorSpecialization: 'Public Health',
        reportDate: now.subtract(const Duration(days: 90)),
        issuedDate: now.subtract(const Duration(days: 90)),
        summary:
            'COVID-19 vaccination completed with both doses of Covishield vaccine.',
        findings: [
          'First Dose: Covishield (AstraZeneca)',
          'Second Dose: Covishield (AstraZeneca)',
          'No adverse reactions reported',
          'Immunity development confirmed',
        ],
        recommendations: [
          'Continue following COVID protocols',
          'Booster dose as per government guidelines',
          'Regular health monitoring',
        ],
        testResults: {
          'vaccineName': 'Covishield',
          'doses': 2,
          'immunity': 'Developed',
        },
        severity: 'Preventive',
        status: 'Final',
      ),

      // Consultation Report
      MedicalReport(
        id: 'report_006',
        patientId: patientId,
        reportType: 'Consultation',
        title: 'General Health Check-up',
        hospitalName: 'City Hospital Pune',
        doctorName: 'Dr. Ravi Gupta',
        doctorSpecialization: 'General Medicine',
        reportDate: now.subtract(const Duration(days: 60)),
        issuedDate: now.subtract(const Duration(days: 60)),
        summary:
            'Routine health check-up showing overall good health with minor recommendations.',
        findings: [
          'General physical examination: Normal',
          'BMI: 24.5 (Normal weight)',
          'Blood pressure: 122/82 mmHg',
          'No significant health concerns',
          'Good mental health status',
        ],
        recommendations: [
          'Continue current lifestyle',
          'Regular exercise 30 minutes daily',
          'Balanced diet with more vegetables',
          'Annual health screening',
        ],
        testResults: {
          'bmi': 24.5,
          'bloodPressure': '122/82',
          'overallHealth': 'Good',
        },
        vitalSigns: {
          'bp_systolic': 122,
          'bp_diastolic': 82,
          'weight': 70,
          'height': 170,
          'bmi': 24.5,
        },
        severity: 'Normal',
        status: 'Final',
      ),
    ];
  }

  static List<VitalSigns> generateDummyVitalSigns(String patientId) {
    final now = DateTime.now();

    return [
      VitalSigns(
        id: 'vital_001',
        patientId: patientId,
        recordedDate: now.subtract(const Duration(days: 1)),
        bloodPressureSystolic: 120,
        bloodPressureDiastolic: 80,
        heartRate: 72,
        temperature: 98.6,
        respiratoryRate: 16,
        oxygenSaturation: 98,
        bloodSugar: 95,
        weight: 70,
        height: 170,
        bmi: 24.2,
        recordedBy: 'Dr. Sharma',
        notes: 'Normal vital signs',
      ),
      VitalSigns(
        id: 'vital_002',
        patientId: patientId,
        recordedDate: now.subtract(const Duration(days: 7)),
        bloodPressureSystolic: 118,
        bloodPressureDiastolic: 78,
        heartRate: 75,
        temperature: 98.4,
        respiratoryRate: 18,
        oxygenSaturation: 99,
        bloodSugar: 92,
        weight: 69.5,
        height: 170,
        bmi: 24.0,
        recordedBy: 'Nurse Priya',
        notes: 'Excellent vital signs',
      ),
    ];
  }
}

@JsonSerializable()
class MedicalCondition {
  final String name;
  final double confidence;
  final String description;
  final String severity;

  MedicalCondition({
    required this.name,
    required this.confidence,
    required this.description,
    required this.severity,
  });

  factory MedicalCondition.fromJson(Map<String, dynamic> json) =>
      _$MedicalConditionFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalConditionToJson(this);
}

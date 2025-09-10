class HealthRecord {
  final String id;
  final String patientId;
  final String? appointmentId;
  final String
  recordType; // 'diagnosis', 'prescription', 'lab_result', 'symptom_report', 'general'
  final String title;
  final String description;
  final Map<String, dynamic> data;
  final List<String> attachments;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  HealthRecord({
    required this.id,
    required this.patientId,
    this.appointmentId,
    required this.recordType,
    required this.title,
    required this.description,
    this.data = const {},
    this.attachments = const [],
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'appointment_id': appointmentId,
      'record_type': recordType,
      'title': title,
      'description': description,
      'data': data,
      'attachments': attachments,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'] ?? '',
      patientId: map['patient_id'] ?? '',
      appointmentId: map['appointment_id'],
      recordType: map['record_type'] ?? 'general',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      attachments: List<String>.from(map['attachments'] ?? []),
      createdBy: map['created_by'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  HealthRecord copyWith({
    String? title,
    String? description,
    String? recordType,
    Map<String, dynamic>? data,
    List<String>? attachments,
    DateTime? updatedAt,
  }) {
    return HealthRecord(
      id: id,
      patientId: patientId,
      appointmentId: appointmentId,
      recordType: recordType ?? this.recordType,
      title: title ?? this.title,
      description: description ?? this.description,
      data: data ?? this.data,
      attachments: attachments ?? this.attachments,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

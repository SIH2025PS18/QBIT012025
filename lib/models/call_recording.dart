/// Recording status enum
enum RecordingStatus { recording, completed, failed, cancelled, deleted }

/// Model for call recording
class CallRecording {
  final String id;
  final String consultationId;
  final String doctorId;
  final String patientId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final RecordingStatus status;
  final bool requiresConsent;
  final bool? patientConsent;
  final String? filePath;
  final int? fileSizeBytes;
  final int? durationSeconds;
  final DateTime createdAt;
  final DateTime? deletedAt;

  const CallRecording({
    required this.id,
    required this.consultationId,
    required this.doctorId,
    required this.patientId,
    required this.startedAt,
    this.endedAt,
    required this.status,
    this.requiresConsent = true,
    this.patientConsent,
    this.filePath,
    this.fileSizeBytes,
    this.durationSeconds,
    required this.createdAt,
    this.deletedAt,
  });

  /// Get formatted duration
  String get formattedDuration {
    if (durationSeconds == null) return '--:--';

    final duration = Duration(seconds: durationSeconds!);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  /// Get formatted file size
  String get formattedFileSize {
    if (fileSizeBytes == null) return '--';

    final sizeInMB = fileSizeBytes! / (1024 * 1024);
    if (sizeInMB < 1) {
      final sizeInKB = fileSizeBytes! / 1024;
      return '${sizeInKB.toStringAsFixed(1)} KB';
    }

    return '${sizeInMB.toStringAsFixed(1)} MB';
  }

  /// Check if recording is active
  bool get isActive => status == RecordingStatus.recording;

  /// Check if recording is completed
  bool get isCompleted => status == RecordingStatus.completed;

  /// Check if consent is required and not given
  bool get needsConsent => requiresConsent && (patientConsent != true);

  CallRecording copyWith({
    String? id,
    String? consultationId,
    String? doctorId,
    String? patientId,
    DateTime? startedAt,
    DateTime? endedAt,
    RecordingStatus? status,
    bool? requiresConsent,
    bool? patientConsent,
    String? filePath,
    int? fileSizeBytes,
    int? durationSeconds,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return CallRecording(
      id: id ?? this.id,
      consultationId: consultationId ?? this.consultationId,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      requiresConsent: requiresConsent ?? this.requiresConsent,
      patientConsent: patientConsent ?? this.patientConsent,
      filePath: filePath ?? this.filePath,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultation_id': consultationId,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'status': status.name,
      'requires_consent': requiresConsent,
      'patient_consent': patientConsent,
      'file_path': filePath,
      'file_size': fileSizeBytes,
      'duration_seconds': durationSeconds,
      'created_at': createdAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory CallRecording.fromJson(Map<String, dynamic> json) {
    return CallRecording(
      id: json['id'],
      consultationId: json['consultation_id'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      startedAt: DateTime.parse(json['started_at']),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'])
          : null,
      status: RecordingStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => RecordingStatus.recording,
      ),
      requiresConsent: json['requires_consent'] ?? true,
      patientConsent: json['patient_consent'],
      filePath: json['file_path'],
      fileSizeBytes: json['file_size'],
      durationSeconds: json['duration_seconds'],
      createdAt: DateTime.parse(json['created_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }
}

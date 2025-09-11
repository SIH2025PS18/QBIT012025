class VideoCallSession {
  final String sessionId;
  final String channelName;
  final String token;
  final String doctorId;
  final String patientId;
  final String appointmentId;
  final DateTime startTime;
  final VideoCallStatus status;
  final int duration; // in seconds
  final DateTime? endTime;

  VideoCallSession({
    required this.sessionId,
    required this.channelName,
    required this.token,
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
    required this.startTime,
    this.status = VideoCallStatus.waiting,
    this.duration = 0,
    this.endTime,
  });

  factory VideoCallSession.fromJson(Map<String, dynamic> json) {
    return VideoCallSession(
      sessionId: json['session_id'] ?? '',
      channelName: json['channel_name'] ?? '',
      token: json['token'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      patientId: json['patient_id'] ?? '',
      appointmentId: json['appointment_id'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      status: VideoCallStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => VideoCallStatus.waiting,
      ),
      duration: json['duration'] ?? 0,
      endTime:
          json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'channel_name': channelName,
      'token': token,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'appointment_id': appointmentId,
      'start_time': startTime.toIso8601String(),
      'status': status.name,
      'duration': duration,
      'end_time': endTime?.toIso8601String(),
    };
  }

  VideoCallSession copyWith({
    String? sessionId,
    String? channelName,
    String? token,
    String? doctorId,
    String? patientId,
    String? appointmentId,
    DateTime? startTime,
    VideoCallStatus? status,
    int? duration,
    DateTime? endTime,
  }) {
    return VideoCallSession(
      sessionId: sessionId ?? this.sessionId,
      channelName: channelName ?? this.channelName,
      token: token ?? this.token,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      appointmentId: appointmentId ?? this.appointmentId,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      endTime: endTime ?? this.endTime,
    );
  }
}

enum VideoCallStatus {
  waiting,
  connecting,
  connected,
  ended,
  failed,
  cancelled
}

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String patientName;
  final String doctorName;
  final DateTime scheduledTime;
  final AppointmentStatus status;
  final String? reason;
  final String? symptoms;
  final List<String> attachments;
  final VideoCallSession? videoSession;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.doctorName,
    required this.scheduledTime,
    this.status = AppointmentStatus.pending,
    this.reason,
    this.symptoms,
    this.attachments = const [],
    this.videoSession,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString() ?? '',
      patientId: json['patient_id']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString() ?? '',
      patientName: json['patient_name'] ?? '',
      doctorName: json['doctor_name'] ?? '',
      scheduledTime: DateTime.parse(json['scheduled_time']),
      status: AppointmentStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      reason: json['reason'],
      symptoms: json['symptoms'],
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : [],
      videoSession: json['video_session'] != null
          ? VideoCallSession.fromJson(json['video_session'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'patient_name': patientName,
      'doctor_name': doctorName,
      'scheduled_time': scheduledTime.toIso8601String(),
      'status': status.name,
      'reason': reason,
      'symptoms': symptoms,
      'attachments': attachments,
      'video_session': videoSession?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Appointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? patientName,
    String? doctorName,
    DateTime? scheduledTime,
    AppointmentStatus? status,
    String? reason,
    String? symptoms,
    List<String>? attachments,
    VideoCallSession? videoSession,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      symptoms: symptoms ?? this.symptoms,
      attachments: attachments ?? this.attachments,
      videoSession: videoSession ?? this.videoSession,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum AppointmentStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow
}

class PatientRecord {
  final String id;
  final String patientId;
  final String patientName;
  final int age;
  final String gender;
  final String phone;
  final String email;
  final String? profileImage;
  final List<String> allergies;
  final List<String> medications;
  final List<String> medicalHistory;
  final List<Consultation> consultations;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientRecord({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.phone,
    required this.email,
    this.profileImage,
    this.allergies = const [],
    this.medications = const [],
    this.medicalHistory = const [],
    this.consultations = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientRecord.fromJson(Map<String, dynamic> json) {
    return PatientRecord(
      id: json['id']?.toString() ?? '',
      patientId: json['patient_id']?.toString() ?? '',
      patientName: json['patient_name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profile_image'],
      allergies:
          json['allergies'] != null ? List<String>.from(json['allergies']) : [],
      medications: json['medications'] != null
          ? List<String>.from(json['medications'])
          : [],
      medicalHistory: json['medical_history'] != null
          ? List<String>.from(json['medical_history'])
          : [],
      consultations: json['consultations'] != null
          ? (json['consultations'] as List)
              .map((c) => Consultation.fromJson(c))
              .toList()
          : [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'patient_name': patientName,
      'age': age,
      'gender': gender,
      'phone': phone,
      'email': email,
      'profile_image': profileImage,
      'allergies': allergies,
      'medications': medications,
      'medical_history': medicalHistory,
      'consultations': consultations.map((c) => c.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Consultation {
  final String id;
  final String doctorId;
  final String doctorName;
  final DateTime date;
  final String diagnosis;
  final String prescription;
  final String notes;
  final List<String> attachments;

  Consultation({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.diagnosis,
    required this.prescription,
    required this.notes,
    this.attachments = const [],
  });

  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString() ?? '',
      doctorName: json['doctor_name'] ?? '',
      date: DateTime.parse(json['date']),
      diagnosis: json['diagnosis'] ?? '',
      prescription: json['prescription'] ?? '',
      notes: json['notes'] ?? '',
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'date': date.toIso8601String(),
      'diagnosis': diagnosis,
      'prescription': prescription,
      'notes': notes,
      'attachments': attachments,
    };
  }
}

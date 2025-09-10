import 'package:uuid/uuid.dart';

/// Enum for consultation status
enum ConsultationStatus {
  scheduled,
  waitingRoom,
  inQueue,
  inProgress,
  completed,
  cancelled,
  noShow,
  reconnecting,
}

/// Enum for participant roles in consultation
enum ParticipantRole { patient, doctor, observer, administrator }

/// Enum for queue priority levels
enum QueuePriority { low, normal, high, urgent, emergency }

/// Enum for consultation quality rating
enum ConsultationRating { poor, fair, good, excellent }

/// Extension for ConsultationStatus with display names
extension ConsultationStatusExtension on ConsultationStatus {
  String get displayName {
    switch (this) {
      case ConsultationStatus.scheduled:
        return 'Scheduled';
      case ConsultationStatus.waitingRoom:
        return 'Waiting Room';
      case ConsultationStatus.inQueue:
        return 'In Queue';
      case ConsultationStatus.inProgress:
        return 'In Progress';
      case ConsultationStatus.completed:
        return 'Completed';
      case ConsultationStatus.cancelled:
        return 'Cancelled';
      case ConsultationStatus.noShow:
        return 'No Show';
      case ConsultationStatus.reconnecting:
        return 'Reconnecting';
    }
  }

  bool get isActive {
    return [
      ConsultationStatus.waitingRoom,
      ConsultationStatus.inQueue,
      ConsultationStatus.inProgress,
      ConsultationStatus.reconnecting,
    ].contains(this);
  }
}

/// Extension for QueuePriority with display names and colors
extension QueuePriorityExtension on QueuePriority {
  String get displayName {
    switch (this) {
      case QueuePriority.low:
        return 'Low Priority';
      case QueuePriority.normal:
        return 'Normal';
      case QueuePriority.high:
        return 'High Priority';
      case QueuePriority.urgent:
        return 'Urgent';
      case QueuePriority.emergency:
        return 'Emergency';
    }
  }

  int get priorityValue {
    switch (this) {
      case QueuePriority.low:
        return 1;
      case QueuePriority.normal:
        return 2;
      case QueuePriority.high:
        return 3;
      case QueuePriority.urgent:
        return 4;
      case QueuePriority.emergency:
        return 5;
    }
  }
}

/// Model for video consultation participant
class ConsultationParticipant {
  final String id;
  final String userId;
  final String name;
  final String? avatarUrl;
  final ParticipantRole role;
  final bool isConnected;
  final bool isMuted;
  final bool isVideoEnabled;
  final DateTime joinedAt;
  final DateTime? leftAt;

  const ConsultationParticipant({
    required this.id,
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.role,
    this.isConnected = false,
    this.isMuted = false,
    this.isVideoEnabled = true,
    required this.joinedAt,
    this.leftAt,
  });

  ConsultationParticipant copyWith({
    String? id,
    String? userId,
    String? name,
    String? avatarUrl,
    ParticipantRole? role,
    bool? isConnected,
    bool? isMuted,
    bool? isVideoEnabled,
    DateTime? joinedAt,
    DateTime? leftAt,
  }) {
    return ConsultationParticipant(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      isConnected: isConnected ?? this.isConnected,
      isMuted: isMuted ?? this.isMuted,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'avatar_url': avatarUrl,
      'role': role.name,
      'is_connected': isConnected,
      'is_muted': isMuted,
      'is_video_enabled': isVideoEnabled,
      'joined_at': joinedAt.toIso8601String(),
      'left_at': leftAt?.toIso8601String(),
    };
  }

  factory ConsultationParticipant.fromJson(Map<String, dynamic> json) {
    return ConsultationParticipant(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
      role: ParticipantRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => ParticipantRole.patient,
      ),
      isConnected: json['is_connected'] ?? false,
      isMuted: json['is_muted'] ?? false,
      isVideoEnabled: json['is_video_enabled'] ?? true,
      joinedAt: DateTime.parse(json['joined_at']),
      leftAt: json['left_at'] != null ? DateTime.parse(json['left_at']) : null,
    );
  }
}

/// Model for queue position information
class QueuePosition {
  final int position;
  final int totalInQueue;
  final Duration estimatedWaitTime;
  final QueuePriority priority;

  const QueuePosition({
    required this.position,
    required this.totalInQueue,
    required this.estimatedWaitTime,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'position': position,
      'total_in_queue': totalInQueue,
      'estimated_wait_time_minutes': estimatedWaitTime.inMinutes,
      'priority': priority.name,
    };
  }

  factory QueuePosition.fromJson(Map<String, dynamic> json) {
    return QueuePosition(
      position: json['position'],
      totalInQueue: json['total_in_queue'],
      estimatedWaitTime: Duration(minutes: json['estimated_wait_time_minutes']),
      priority: QueuePriority.values.firstWhere(
        (priority) => priority.name == json['priority'],
        orElse: () => QueuePriority.normal,
      ),
    );
  }
}

/// Model for video consultation session
class VideoConsultation {
  final String id;
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final String patientName;
  final String doctorName;
  final String? patientAvatarUrl;
  final String? doctorAvatarUrl;
  final ConsultationStatus status;
  final QueuePriority priority;
  final DateTime scheduledAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final Duration? duration;
  final List<ConsultationParticipant> participants;
  final QueuePosition? queuePosition;
  final String? roomId;
  final String? sessionToken;
  final Map<String, dynamic>? metadata;
  final ConsultationRating? rating;
  final String? feedback;
  final String? prescription;
  final bool isRecorded;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VideoConsultation({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.doctorName,
    this.patientAvatarUrl,
    this.doctorAvatarUrl,
    required this.status,
    this.priority = QueuePriority.normal,
    required this.scheduledAt,
    this.startedAt,
    this.endedAt,
    this.duration,
    this.participants = const [],
    this.queuePosition,
    this.roomId,
    this.sessionToken,
    this.metadata,
    this.rating,
    this.feedback,
    this.prescription,
    this.isRecorded = false,
    required this.createdAt,
    required this.updatedAt,
  });

  VideoConsultation copyWith({
    String? id,
    String? appointmentId,
    String? patientId,
    String? doctorId,
    String? patientName,
    String? doctorName,
    String? patientAvatarUrl,
    String? doctorAvatarUrl,
    ConsultationStatus? status,
    QueuePriority? priority,
    DateTime? scheduledAt,
    DateTime? startedAt,
    DateTime? endedAt,
    Duration? duration,
    List<ConsultationParticipant>? participants,
    QueuePosition? queuePosition,
    String? roomId,
    String? sessionToken,
    Map<String, dynamic>? metadata,
    ConsultationRating? rating,
    String? feedback,
    String? prescription,
    bool? isRecorded,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VideoConsultation(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      patientAvatarUrl: patientAvatarUrl ?? this.patientAvatarUrl,
      doctorAvatarUrl: doctorAvatarUrl ?? this.doctorAvatarUrl,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      participants: participants ?? this.participants,
      queuePosition: queuePosition ?? this.queuePosition,
      roomId: roomId ?? this.roomId,
      sessionToken: sessionToken ?? this.sessionToken,
      metadata: metadata ?? this.metadata,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      prescription: prescription ?? this.prescription,
      isRecorded: isRecorded ?? this.isRecorded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isActive => status.isActive;

  bool get canJoin {
    return [
      ConsultationStatus.scheduled,
      ConsultationStatus.waitingRoom,
      ConsultationStatus.inQueue,
      ConsultationStatus.reconnecting,
    ].contains(status);
  }

  bool get isCompleted {
    return [
      ConsultationStatus.completed,
      ConsultationStatus.cancelled,
      ConsultationStatus.noShow,
    ].contains(status);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointment_id': appointmentId,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'patient_name': patientName,
      'doctor_name': doctorName,
      'patient_avatar_url': patientAvatarUrl,
      'doctor_avatar_url': doctorAvatarUrl,
      'status': status.name,
      'priority': priority.name,
      'scheduled_at': scheduledAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'duration_minutes': duration?.inMinutes,
      'participants': participants.map((p) => p.toJson()).toList(),
      'queue_position': queuePosition?.toJson(),
      'room_id': roomId,
      'session_token': sessionToken,
      'metadata': metadata,
      'rating': rating?.name,
      'feedback': feedback,
      'prescription': prescription,
      'is_recorded': isRecorded,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory VideoConsultation.fromJson(Map<String, dynamic> json) {
    return VideoConsultation(
      id: json['id'],
      appointmentId: json['appointment_id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      patientName: json['patient_name'],
      doctorName: json['doctor_name'],
      patientAvatarUrl: json['patient_avatar_url'],
      doctorAvatarUrl: json['doctor_avatar_url'],
      status: ConsultationStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => ConsultationStatus.scheduled,
      ),
      priority: QueuePriority.values.firstWhere(
        (priority) => priority.name == json['priority'],
        orElse: () => QueuePriority.normal,
      ),
      scheduledAt: DateTime.parse(json['scheduled_at']),
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'])
          : null,
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'])
          : null,
      duration: json['duration_minutes'] != null
          ? Duration(minutes: json['duration_minutes'])
          : null,
      participants: json['participants'] != null
          ? (json['participants'] as List)
                .map((p) => ConsultationParticipant.fromJson(p))
                .toList()
          : [],
      queuePosition: json['queue_position'] != null
          ? QueuePosition.fromJson(json['queue_position'])
          : null,
      roomId: json['room_id'],
      sessionToken: json['session_token'],
      metadata: json['metadata'],
      rating: json['rating'] != null
          ? ConsultationRating.values.firstWhere(
              (rating) => rating.name == json['rating'],
              orElse: () => ConsultationRating.good,
            )
          : null,
      feedback: json['feedback'],
      prescription: json['prescription'],
      isRecorded: json['is_recorded'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  factory VideoConsultation.create({
    required String appointmentId,
    required String patientId,
    required String doctorId,
    required String patientName,
    required String doctorName,
    String? patientAvatarUrl,
    String? doctorAvatarUrl,
    required DateTime scheduledAt,
    QueuePriority priority = QueuePriority.normal,
  }) {
    const uuid = Uuid();
    final now = DateTime.now();

    return VideoConsultation(
      id: uuid.v4(),
      appointmentId: appointmentId,
      patientId: patientId,
      doctorId: doctorId,
      patientName: patientName,
      doctorName: doctorName,
      patientAvatarUrl: patientAvatarUrl,
      doctorAvatarUrl: doctorAvatarUrl,
      status: ConsultationStatus.scheduled,
      priority: priority,
      scheduledAt: scheduledAt,
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// Model for consultation queue entry
class ConsultationQueue {
  final String id;
  final VideoConsultation consultation;
  final int position;
  final DateTime joinedAt;
  final Duration estimatedWaitTime;
  final Map<String, dynamic>? metadata;

  const ConsultationQueue({
    required this.id,
    required this.consultation,
    required this.position,
    required this.joinedAt,
    required this.estimatedWaitTime,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultation': consultation.toJson(),
      'position': position,
      'joined_at': joinedAt.toIso8601String(),
      'estimated_wait_time_minutes': estimatedWaitTime.inMinutes,
      'metadata': metadata,
    };
  }

  factory ConsultationQueue.fromJson(Map<String, dynamic> json) {
    return ConsultationQueue(
      id: json['id'],
      consultation: VideoConsultation.fromJson(json['consultation']),
      position: json['position'],
      joinedAt: DateTime.parse(json['joined_at']),
      estimatedWaitTime: Duration(minutes: json['estimated_wait_time_minutes']),
      metadata: json['metadata'],
    );
  }
}

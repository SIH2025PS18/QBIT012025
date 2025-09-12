class Doctor {
  final String id;
  final String doctorId;
  final String name;
  final String email;
  final String phone;
  final String specialization;
  final String qualification;
  final int experience;
  final String licenseNumber;
  final double consultationFee;
  final String status; // online, offline, busy
  final bool isAvailable;
  final List<String> languages;
  final double rating;
  final int totalRatings;
  final int totalConsultations;
  final String profileImage;

  Doctor({
    required this.id,
    required this.doctorId,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.qualification,
    required this.experience,
    required this.licenseNumber,
    required this.consultationFee,
    required this.status,
    required this.isAvailable,
    required this.languages,
    required this.rating,
    required this.totalRatings,
    required this.totalConsultations,
    this.profileImage = '',
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] ?? json['id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      specialization: json['speciality'] ?? json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      experience: (json['experience'] ?? 0).toInt(),
      licenseNumber: json['licenseNumber'] ?? 'N/A',
      consultationFee: (json['consultationFee'] ?? 0).toDouble(),
      status: json['status'] ?? 'offline',
      isAvailable: json['isAvailable'] ?? false,
      languages: (json['languages'] as List?)?.cast<String>() ?? ['English'],
      rating: (json['rating'] ?? 0).toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
      totalConsultations: json['totalConsultations'] ?? 0,
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'name': name,
      'email': email,
      'phone': phone,
      'speciality': specialization,
      'qualification': qualification,
      'experience': experience,
      'licenseNumber': licenseNumber,
      'consultationFee': consultationFee,
      'status': status,
      'isAvailable': isAvailable,
      'languages': languages,
      'rating': rating,
      'totalRatings': totalRatings,
      'totalConsultations': totalConsultations,
      'profileImage': profileImage,
    };
  }
}

class Patient {
  final String id;
  final String name;
  final String profileImage;
  final int age;
  final String gender;
  final String phone;
  final String email;
  final String symptoms;
  final DateTime appointmentTime;
  final String status;
  final List<String> medicalHistory;
  final List<String> attachments;

  Patient({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.age,
    required this.gender,
    required this.phone,
    required this.email,
    required this.symptoms,
    required this.appointmentTime,
    required this.status,
    this.medicalHistory = const [],
    this.attachments = const [],
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      symptoms: json['symptoms'] ?? '',
      appointmentTime:
          DateTime.tryParse(json['appointmentTime'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'waiting',
      medicalHistory: List<String>.from(json['medicalHistory'] ?? []),
      attachments: List<String>.from(json['attachments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'age': age,
      'gender': gender,
      'phone': phone,
      'email': email,
      'symptoms': symptoms,
      'appointmentTime': appointmentTime.toIso8601String(),
      'status': status,
      'medicalHistory': medicalHistory,
      'attachments': attachments,
    };
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isDoctor;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isDoctor,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderName: json['sender_name'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      isDoctor: json['is_doctor'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_doctor': isDoctor,
    };
  }
}

enum VideoCallStatus { idle, connecting, connected, ended }

enum Priority { low, normal, high, urgent }

class VideoCallSession {
  final String sessionId;
  final String doctorId;
  final String patientId;
  final String channelName;
  final VideoCallStatus status;
  final DateTime startTime;
  final DateTime? endTime;

  VideoCallSession({
    required this.sessionId,
    required this.doctorId,
    required this.patientId,
    required this.channelName,
    required this.status,
    required this.startTime,
    this.endTime,
  });

  factory VideoCallSession.fromJson(Map<String, dynamic> json) {
    return VideoCallSession(
      sessionId: json['session_id'] ?? '',
      doctorId: json['doctor_id'] ?? '',
      patientId: json['patient_id'] ?? '',
      channelName: json['channel_name'] ?? '',
      status: VideoCallStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => VideoCallStatus.idle,
      ),
      startTime: DateTime.tryParse(json['start_time'] ?? '') ?? DateTime.now(),
      endTime:
          json['end_time'] != null ? DateTime.tryParse(json['end_time']) : null,
    );
  }
}

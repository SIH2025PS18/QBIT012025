import 'dart:ui';

class Doctor {
  final String id;
  final String doctorId;
  final String name; // Changed from fullName
  final String email;
  final String phone; // Changed from phoneNumber
  final String speciality; // Changed from specialization to match backend
  final String qualification;
  final int experience; // Changed from experienceYears
  final String licenseNumber;
  final double consultationFee;
  final String status;
  final bool isAvailable;
  final List<String> languages;
  final double rating;
  final int totalRatings;
  final int totalConsultations;
  final int todayConsultations;
  final Map<String, dynamic>? address;
  final Map<String, dynamic>? workingHours;
  final bool isVerified;
  final String? profileImage;
  final List<dynamic> documents;
  final Map<String, dynamic>? socialMedia;
  final DateTime? lastActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Doctor({
    required this.id,
    this.doctorId = '',
    required this.name,
    required this.email,
    this.phone = '',
    required this.speciality,
    this.qualification = '',
    this.experience = 0,
    this.licenseNumber = '',
    this.consultationFee = 0.0,
    this.status = 'offline',
    this.isAvailable = true,
    this.languages = const ['Hindi', 'English'],
    this.rating = 0.0,
    this.totalRatings = 0,
    this.totalConsultations = 0,
    this.todayConsultations = 0,
    this.address,
    this.workingHours,
    this.isVerified = false,
    this.profileImage,
    this.documents = const [],
    this.socialMedia,
    this.lastActive,
    this.createdAt,
    this.updatedAt,
  });

  // Convert to Map for MongoDB Backend
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorId': doctorId,
      'name': name,
      'email': email,
      'phone': phone,
      'speciality': speciality,
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
      'todayConsultations': todayConsultations,
      'address': address,
      'workingHours': workingHours,
      'isVerified': isVerified,
      'profileImage': profileImage,
      'documents': documents,
      'socialMedia': socialMedia,
      'lastActive': lastActive?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from Map (from MongoDB Backend)
  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['_id']?.toString() ?? map['id']?.toString() ?? '',
      doctorId: map['doctorId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      speciality: map['speciality'] ?? '',
      qualification: map['qualification'] ?? '',
      experience: (map['experience'] as num?)?.toInt() ?? 0,
      licenseNumber: map['licenseNumber'] ?? '',
      consultationFee: (map['consultationFee'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'offline',
      isAvailable: map['isAvailable'] ?? true,
      languages: map['languages'] != null
          ? List<String>.from(map['languages'])
          : ['Hindi', 'English'],
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: (map['totalRatings'] as num?)?.toInt() ?? 0,
      totalConsultations: (map['totalConsultations'] as num?)?.toInt() ?? 0,
      todayConsultations: (map['todayConsultations'] as num?)?.toInt() ?? 0,
      address: map['address'] as Map<String, dynamic>?,
      workingHours: map['workingHours'] as Map<String, dynamic>?,
      isVerified: map['isVerified'] ?? false,
      profileImage: map['profileImage'],
      documents: map['documents'] ?? [],
      socialMedia: map['socialMedia'] as Map<String, dynamic>?,
      lastActive: map['lastActive'] != null
          ? DateTime.parse(map['lastActive'])
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  // Create updated instance
  Doctor copyWith({
    String? id,
    String? doctorId,
    String? name,
    String? email,
    String? phone,
    String? speciality,
    String? qualification,
    int? experience,
    String? licenseNumber,
    double? consultationFee,
    String? status,
    bool? isAvailable,
    List<String>? languages,
    double? rating,
    int? totalRatings,
    int? totalConsultations,
    int? todayConsultations,
    Map<String, dynamic>? address,
    Map<String, dynamic>? workingHours,
    bool? isVerified,
    String? profileImage,
    List<dynamic>? documents,
    Map<String, dynamic>? socialMedia,
    DateTime? lastActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Doctor(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      speciality: speciality ?? this.speciality,
      qualification: qualification ?? this.qualification,
      experience: experience ?? this.experience,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      consultationFee: consultationFee ?? this.consultationFee,
      status: status ?? this.status,
      isAvailable: isAvailable ?? this.isAvailable,
      languages: languages ?? this.languages,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      totalConsultations: totalConsultations ?? this.totalConsultations,
      todayConsultations: todayConsultations ?? this.todayConsultations,
      address: address ?? this.address,
      workingHours: workingHours ?? this.workingHours,
      isVerified: isVerified ?? this.isVerified,
      profileImage: profileImage ?? this.profileImage,
      documents: documents ?? this.documents,
      socialMedia: socialMedia ?? this.socialMedia,
      lastActive: lastActive ?? this.lastActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Doctor(id: $id, name: $name, speciality: $speciality, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Doctor && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Speciality constants to match backend enum
class DoctorSpecialities {
  static const List<String> all = [
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Neurologist',
    'General Practitioner',
    'Psychiatrist',
    'Orthopedic',
    'Gynecologist',
    'ENT Specialist',
    'Ophthalmologist',
  ];
}

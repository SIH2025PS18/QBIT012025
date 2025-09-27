class Doctor {
  final String id;
  final String doctorId;
  final String name;
  final String email;
  final String phone;
  final String speciality; // Changed from specialization to match backend
  final String qualification;
  final int experience;
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

  // New credential and status fields
  final bool isEnabled;
  final String? defaultPassword;
  final DateTime? lastPasswordReset;
  final bool hasTemporaryPassword;
  final String? emergencyContact;
  final String? licenseExpiryDate;
  final String? department;
  final String? employeeId;
  final List<String> permissions;
  final Map<String, dynamic>? loginHistory;

  Doctor({
    required this.id,
    this.doctorId = '',
    required this.name,
    required this.email,
    required this.phone,
    required this.speciality,
    required this.qualification,
    required this.experience,
    required this.licenseNumber,
    required this.consultationFee,
    this.status = 'offline',
    this.isAvailable = true,
    this.languages = const ['en'],
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
    // New credential and status fields
    this.isEnabled = true,
    this.defaultPassword,
    this.lastPasswordReset,
    this.hasTemporaryPassword = false,
    this.emergencyContact,
    this.licenseExpiryDate,
    this.department,
    this.employeeId,
    this.permissions = const ['consultation', 'profile_update'],
    this.loginHistory,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      doctorId: json['doctorId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      speciality: json['speciality'] ?? '',
      qualification: json['qualification'] ?? '',
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      licenseNumber: json['licenseNumber'] ?? '',
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'offline',
      isAvailable: json['isAvailable'] ?? true,
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : ['en'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
      totalConsultations: (json['totalConsultations'] as num?)?.toInt() ?? 0,
      todayConsultations: (json['todayConsultations'] as num?)?.toInt() ?? 0,
      address: json['address'] as Map<String, dynamic>?,
      workingHours: json['workingHours'] as Map<String, dynamic>?,
      isVerified: json['isVerified'] ?? false,
      profileImage: json['profileImage'],
      documents: json['documents'] ?? [],
      socialMedia: json['socialMedia'] as Map<String, dynamic>?,
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      // New credential and status fields
      isEnabled: json['isEnabled'] ?? true,
      defaultPassword: json['defaultPassword'],
      lastPasswordReset: json['lastPasswordReset'] != null
          ? DateTime.parse(json['lastPasswordReset'])
          : null,
      hasTemporaryPassword: json['hasTemporaryPassword'] ?? false,
      emergencyContact: json['emergencyContact'],
      licenseExpiryDate: json['licenseExpiryDate'],
      department: json['department'],
      employeeId: json['employeeId'],
      permissions: json['permissions'] != null
          ? List<String>.from(json['permissions'])
          : ['consultation', 'profile_update'],
      loginHistory: json['loginHistory'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
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
      // New credential and status fields
      'isEnabled': isEnabled,
      'defaultPassword': defaultPassword,
      'lastPasswordReset': lastPasswordReset?.toIso8601String(),
      'hasTemporaryPassword': hasTemporaryPassword,
      'emergencyContact': emergencyContact,
      'licenseExpiryDate': licenseExpiryDate,
      'department': department,
      'employeeId': employeeId,
      'permissions': permissions,
      'loginHistory': loginHistory,
    };
  }

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
    // New credential and status fields
    bool? isEnabled,
    String? defaultPassword,
    DateTime? lastPasswordReset,
    bool? hasTemporaryPassword,
    String? emergencyContact,
    String? licenseExpiryDate,
    String? department,
    String? employeeId,
    List<String>? permissions,
    Map<String, dynamic>? loginHistory,
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
      // New credential and status fields
      isEnabled: isEnabled ?? this.isEnabled,
      defaultPassword: defaultPassword ?? this.defaultPassword,
      lastPasswordReset: lastPasswordReset ?? this.lastPasswordReset,
      hasTemporaryPassword: hasTemporaryPassword ?? this.hasTemporaryPassword,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      department: department ?? this.department,
      employeeId: employeeId ?? this.employeeId,
      permissions: permissions ?? this.permissions,
      loginHistory: loginHistory ?? this.loginHistory,
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

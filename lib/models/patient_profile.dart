class PatientProfile {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final String gender;
  final String bloodGroup;
  final String address;
  final String emergencyContact;
  final String emergencyContactPhone;
  final String profilePhotoUrl;
  final List<String> allergies;
  final List<String> medications;
  final Map<String, dynamic> medicalHistory;
  final DateTime? lastVisit;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber = '',
    required this.dateOfBirth,
    required this.gender,
    this.bloodGroup = '',
    this.address = '',
    this.emergencyContact = '',
    this.emergencyContactPhone = '',
    this.profilePhotoUrl = '',
    this.allergies = const [],
    this.medications = const [],
    this.medicalHistory = const {},
    this.lastVisit,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for MongoDB backend
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'bloodGroup': bloodGroup,
      'address': address,
      'emergencyContact': emergencyContact,
      'emergencyContactPhone': emergencyContactPhone,
      'profilePhotoUrl': profilePhotoUrl,
      'allergies': allergies,
      'medications': medications,
      'medicalHistory': medicalHistory,
      'lastVisit': lastVisit?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map (MongoDB backend data)
  factory PatientProfile.fromMap(Map<String, dynamic> map) {
    return PatientProfile(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? map['full_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? map['phone_number'] ?? '',
      dateOfBirth: DateTime.parse(
        map['dateOfBirth'] ??
            map['date_of_birth'] ??
            DateTime.now().toIso8601String(),
      ),
      gender: map['gender'] ?? '',
      bloodGroup: map['bloodGroup'] ?? map['blood_group'] ?? '',
      address: map['address'] ?? '',
      emergencyContact:
          map['emergencyContact'] ?? map['emergency_contact'] ?? '',
      emergencyContactPhone:
          map['emergencyContactPhone'] ?? map['emergency_contact_phone'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'] ?? map['profile_photo_url'] ?? '',
      allergies: List<String>.from(map['allergies'] ?? []),
      medications: List<String>.from(map['medications'] ?? []),
      medicalHistory: Map<String, dynamic>.from(
        map['medicalHistory'] ?? map['medical_history'] ?? {},
      ),
      lastVisit: map['lastVisit'] != null || map['last_visit'] != null
          ? DateTime.parse(map['lastVisit'] ?? map['last_visit'])
          : null,
      createdAt: DateTime.parse(
        map['createdAt'] ??
            map['created_at'] ??
            DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ??
            map['updated_at'] ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  // Calculate age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return toMap();
  }

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile.fromMap(json);
  }

  // Copy with method for updates
  PatientProfile copyWith({
    String? fullName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodGroup,
    String? address,
    String? emergencyContact,
    String? emergencyContactPhone,
    String? profilePhotoUrl,
    List<String>? allergies,
    List<String>? medications,
    Map<String, dynamic>? medicalHistory,
    DateTime? lastVisit,
  }) {
    return PatientProfile(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      lastVisit: lastVisit ?? this.lastVisit,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

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

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'blood_group': bloodGroup,
      'address': address,
      'emergency_contact': emergencyContact,
      'emergency_contact_phone': emergencyContactPhone,
      'profile_photo_url': profilePhotoUrl,
      'allergies': allergies,
      'medications': medications,
      'medical_history': medicalHistory,
      'last_visit': lastVisit?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create from Map (Supabase data)
  factory PatientProfile.fromMap(Map<String, dynamic> map) {
    return PatientProfile(
      id: map['id'] ?? '',
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      dateOfBirth: DateTime.parse(map['date_of_birth']),
      gender: map['gender'] ?? '',
      bloodGroup: map['blood_group'] ?? '',
      address: map['address'] ?? '',
      emergencyContact: map['emergency_contact'] ?? '',
      emergencyContactPhone: map['emergency_contact_phone'] ?? '',
      profilePhotoUrl: map['profile_photo_url'] ?? '',
      allergies: List<String>.from(map['allergies'] ?? []),
      medications: List<String>.from(map['medications'] ?? []),
      medicalHistory: Map<String, dynamic>.from(map['medical_history'] ?? {}),
      lastVisit: map['last_visit'] != null
          ? DateTime.parse(map['last_visit'])
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
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

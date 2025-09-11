class Patient {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final String? patientId;
  final String? address;
  final String? emergencyContact;
  final String? medicalHistory;
  final List<String> allergies;
  final String? bloodGroup;
  final DateTime createdAt;
  final DateTime? lastVisit;
  final bool isActive;
  final String? profileImage;
  final List<String> medications;
  final List<String> medicalRecords;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    this.patientId,
    this.address,
    this.emergencyContact,
    this.medicalHistory,
    this.allergies = const [],
    this.bloodGroup,
    required this.createdAt,
    this.lastVisit,
    this.isActive = true,
    this.profileImage,
    this.medications = const [],
    this.medicalRecords = const [],
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      patientId: json['patientId'],
      address: json['address'],
      emergencyContact: json['emergencyContact'],
      medicalHistory: json['medicalHistory'],
      allergies:
          json['allergies'] != null ? List<String>.from(json['allergies']) : [],
      bloodGroup: json['bloodGroup'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastVisit:
          json['lastVisit'] != null ? DateTime.parse(json['lastVisit']) : null,
      isActive: json['isActive'] ?? true,
      profileImage: json['profileImage'],
      medications: json['medications'] != null
          ? List<String>.from(json['medications'])
          : [],
      medicalRecords: json['medicalRecords'] != null
          ? List<String>.from(json['medicalRecords'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'patientId': patientId,
      'address': address,
      'emergencyContact': emergencyContact,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'bloodGroup': bloodGroup,
      'createdAt': createdAt.toIso8601String(),
      'lastVisit': lastVisit?.toIso8601String(),
      'isActive': isActive,
      'profileImage': profileImage,
      'medications': medications,
      'medicalRecords': medicalRecords,
    };
  }

  Patient copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    int? age,
    String? gender,
    String? patientId,
    String? address,
    String? emergencyContact,
    String? medicalHistory,
    List<String>? allergies,
    String? bloodGroup,
    DateTime? createdAt,
    DateTime? lastVisit,
    bool? isActive,
    String? profileImage,
    List<String>? medications,
    List<String>? medicalRecords,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      patientId: patientId ?? this.patientId,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      allergies: allergies ?? this.allergies,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      createdAt: createdAt ?? this.createdAt,
      lastVisit: lastVisit ?? this.lastVisit,
      isActive: isActive ?? this.isActive,
      profileImage: profileImage ?? this.profileImage,
      medications: medications ?? this.medications,
      medicalRecords: medicalRecords ?? this.medicalRecords,
    );
  }
}

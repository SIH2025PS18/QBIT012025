/// User model for patient authentication and profile management
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // Always 'patient' for this app
  final bool isVerified;
  final DateTime? lastLoginAt;

  // Patient-specific fields
  final String? patientId;
  final int? age;
  final String? gender;
  final String? bloodGroup;
  final String? preferredLanguage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
    this.lastLoginAt,
    this.patientId,
    this.age,
    this.gender,
    this.bloodGroup,
    this.preferredLanguage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'patient', // Default to patient
      isVerified: json['isVerified'] ?? false,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,

      // Patient fields
      patientId: json['patientId'],
      age: json['age'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      preferredLanguage: json['preferredLanguage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isVerified': isVerified,
      'lastLoginAt': lastLoginAt?.toIso8601String(),

      // Patient fields
      if (patientId != null) 'patientId': patientId,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (bloodGroup != null) 'bloodGroup': bloodGroup,
      if (preferredLanguage != null) 'preferredLanguage': preferredLanguage,
    };
  }

  // Helper methods
  bool get isPatient => role == 'patient';

  String get displayName => name;
  String get roleDisplayName => name; // Simple display for patients

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isVerified,
    DateTime? lastLoginAt,
    String? patientId,
    int? age,
    String? gender,
    String? bloodGroup,
    String? preferredLanguage,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      patientId: patientId ?? this.patientId,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}

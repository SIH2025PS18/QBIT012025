class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final DateTime dateOfBirth;
  final String gender;
  final String bloodGroup;
  final String phoneNumber;
  final String email;
  final List<String> allergies;
  final List<String> medications;
  final Map<String, dynamic> medicalHistory;
  final bool isPrimaryContact;
  final DateTime createdAt;
  final DateTime updatedAt;

  FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.dateOfBirth,
    required this.gender,
    this.bloodGroup = '',
    this.phoneNumber = '',
    this.email = '',
    this.allergies = const [],
    this.medications = const [],
    this.medicalHistory = const {},
    this.isPrimaryContact = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate age
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Convert to Map for API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'bloodGroup': bloodGroup,
      'phoneNumber': phoneNumber,
      'email': email,
      'allergies': allergies,
      'medications': medications,
      'medicalHistory': medicalHistory,
      'isPrimaryContact': isPrimaryContact,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map (API response)
  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      id: map['id'] ?? map['_id'] ?? '',
      name: map['name'] ?? '',
      relation: map['relation'] ?? '',
      dateOfBirth: DateTime.parse(
        map['dateOfBirth'] ??
            map['date_of_birth'] ??
            DateTime.now().toIso8601String(),
      ),
      gender: map['gender'] ?? '',
      bloodGroup: map['bloodGroup'] ?? map['blood_group'] ?? '',
      phoneNumber: map['phoneNumber'] ?? map['phone_number'] ?? '',
      email: map['email'] ?? '',
      allergies: List<String>.from(map['allergies'] ?? []),
      medications: List<String>.from(map['medications'] ?? []),
      medicalHistory: Map<String, dynamic>.from(
        map['medicalHistory'] ?? map['medical_history'] ?? {},
      ),
      isPrimaryContact:
          map['isPrimaryContact'] ?? map['is_primary_contact'] ?? false,
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

  // Create a copy with updated fields
  FamilyMember copyWith({
    String? id,
    String? name,
    String? relation,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodGroup,
    String? phoneNumber,
    String? email,
    List<String>? allergies,
    List<String>? medications,
    Map<String, dynamic>? medicalHistory,
    bool? isPrimaryContact,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      isPrimaryContact: isPrimaryContact ?? this.isPrimaryContact,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Common relation types
class FamilyRelations {
  static const List<String> relations = [
    'Father',
    'Mother',
    'Spouse',
    'Son',
    'Daughter',
    'Brother',
    'Sister',
    'Grandfather',
    'Grandmother',
    'Uncle',
    'Aunt',
    'Cousin',
    'Other',
  ];
}

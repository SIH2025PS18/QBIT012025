class FamilyMember {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String relationship;
  final String? phoneNumber;
  final String? email;
  final DateTime? dateOfBirth;
  final String? medicalConditions;
  final String? allergies;
  final String? bloodGroup;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  FamilyMember({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.relationship,
    this.phoneNumber,
    this.email,
    this.dateOfBirth,
    this.medicalConditions,
    this.allergies,
    this.bloodGroup,
    this.isActive = true,
    required this.createdAt,
    this.lastUpdated,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      relationship: json['relationship'] ?? '',
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      medicalConditions: json['medicalConditions'],
      allergies: json['allergies'],
      bloodGroup: json['bloodGroup'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'relationship': relationship,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'medicalConditions': medicalConditions,
      'allergies': allergies,
      'bloodGroup': bloodGroup,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  FamilyMember copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? relationship,
    String? phoneNumber,
    String? email,
    DateTime? dateOfBirth,
    String? medicalConditions,
    String? allergies,
    String? bloodGroup,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      relationship: relationship ?? this.relationship,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      allergies: allergies ?? this.allergies,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class FamilyGroup {
  final String id;
  final String primaryMemberId;
  final String primaryMemberName;
  final String primaryMemberPhone;
  final String familyName;
  final String address;
  final String village;
  final String pincode;
  final List<FamilyMember> members;
  final String? emergencyContact;
  final String? emergencyPhone;
  final Map<String, dynamic>? healthInsurance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastUpdated;

  FamilyGroup({
    required this.id,
    required this.primaryMemberId,
    required this.primaryMemberName,
    required this.primaryMemberPhone,
    required this.familyName,
    required this.address,
    required this.village,
    required this.pincode,
    required this.members,
    this.emergencyContact,
    this.emergencyPhone,
    this.healthInsurance,
    this.isActive = true,
    required this.createdAt,
    this.lastUpdated,
  });

  factory FamilyGroup.fromJson(Map<String, dynamic> json) {
    return FamilyGroup(
      id: json['id'] ?? '',
      primaryMemberId: json['primaryMemberId'] ?? '',
      primaryMemberName: json['primaryMemberName'] ?? '',
      primaryMemberPhone: json['primaryMemberPhone'] ?? '',
      familyName: json['familyName'] ?? '',
      address: json['address'] ?? '',
      village: json['village'] ?? '',
      pincode: json['pincode'] ?? '',
      members: (json['members'] as List<dynamic>? ?? [])
          .map((member) => FamilyMember.fromJson(member))
          .toList(),
      emergencyContact: json['emergencyContact'],
      emergencyPhone: json['emergencyPhone'],
      healthInsurance: json['healthInsurance'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'primaryMemberId': primaryMemberId,
      'primaryMemberName': primaryMemberName,
      'primaryMemberPhone': primaryMemberPhone,
      'familyName': familyName,
      'address': address,
      'village': village,
      'pincode': pincode,
      'members': members.map((member) => member.toJson()).toList(),
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
      'healthInsurance': healthInsurance,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  int get totalMembers => members.length;
  int get activeMembers => members.where((m) => m.isActive).length;
  List<FamilyMember> get children => members
      .where((m) => m.relationship.toLowerCase().contains('child'))
      .toList();
  List<FamilyMember> get adults => members.where((m) => m.age >= 18).toList();

  FamilyGroup copyWith({
    String? id,
    String? primaryMemberId,
    String? primaryMemberName,
    String? primaryMemberPhone,
    String? familyName,
    String? address,
    String? village,
    String? pincode,
    List<FamilyMember>? members,
    String? emergencyContact,
    String? emergencyPhone,
    Map<String, dynamic>? healthInsurance,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return FamilyGroup(
      id: id ?? this.id,
      primaryMemberId: primaryMemberId ?? this.primaryMemberId,
      primaryMemberName: primaryMemberName ?? this.primaryMemberName,
      primaryMemberPhone: primaryMemberPhone ?? this.primaryMemberPhone,
      familyName: familyName ?? this.familyName,
      address: address ?? this.address,
      village: village ?? this.village,
      pincode: pincode ?? this.pincode,
      members: members ?? this.members,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      healthInsurance: healthInsurance ?? this.healthInsurance,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class CommunityHealthData {
  final String id;
  final String village;
  final String pincode;
  final String condition;
  final List<String> symptoms;
  final String severity;
  final String ageGroup;
  final String gender;
  final DateTime reportDate;
  final String? familyGroupId;
  final String? reportedBy;
  final Map<String, dynamic>? location;
  final bool isAnonymous;
  final String status; // active, resolved, monitoring
  final DateTime createdAt;

  CommunityHealthData({
    required this.id,
    required this.village,
    required this.pincode,
    required this.condition,
    required this.symptoms,
    required this.severity,
    required this.ageGroup,
    required this.gender,
    required this.reportDate,
    this.familyGroupId,
    this.reportedBy,
    this.location,
    this.isAnonymous = true,
    this.status = 'active',
    required this.createdAt,
  });

  factory CommunityHealthData.fromJson(Map<String, dynamic> json) {
    return CommunityHealthData(
      id: json['id'] ?? '',
      village: json['village'] ?? '',
      pincode: json['pincode'] ?? '',
      condition: json['condition'] ?? '',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      severity: json['severity'] ?? '',
      ageGroup: json['ageGroup'] ?? '',
      gender: json['gender'] ?? '',
      reportDate: DateTime.parse(json['reportDate']),
      familyGroupId: json['familyGroupId'],
      reportedBy: json['reportedBy'],
      location: json['location'],
      isAnonymous: json['isAnonymous'] ?? true,
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'village': village,
      'pincode': pincode,
      'condition': condition,
      'symptoms': symptoms,
      'severity': severity,
      'ageGroup': ageGroup,
      'gender': gender,
      'reportDate': reportDate.toIso8601String(),
      'familyGroupId': familyGroupId,
      'reportedBy': reportedBy,
      'location': location,
      'isAnonymous': isAnonymous,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CommunityHealthData copyWith({
    String? id,
    String? village,
    String? pincode,
    String? condition,
    List<String>? symptoms,
    String? severity,
    String? ageGroup,
    String? gender,
    DateTime? reportDate,
    String? familyGroupId,
    String? reportedBy,
    Map<String, dynamic>? location,
    bool? isAnonymous,
    String? status,
    DateTime? createdAt,
  }) {
    return CommunityHealthData(
      id: id ?? this.id,
      village: village ?? this.village,
      pincode: pincode ?? this.pincode,
      condition: condition ?? this.condition,
      symptoms: symptoms ?? this.symptoms,
      severity: severity ?? this.severity,
      ageGroup: ageGroup ?? this.ageGroup,
      gender: gender ?? this.gender,
      reportDate: reportDate ?? this.reportDate,
      familyGroupId: familyGroupId ?? this.familyGroupId,
      reportedBy: reportedBy ?? this.reportedBy,
      location: location ?? this.location,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HealthAlert {
  final String id;
  final String title;
  final String description;
  final String type; // outbreak, epidemic, warning, info
  final String severity; // low, medium, high, critical
  final List<String> affectedVillages;
  final String condition;
  final DateTime alertDate;
  final DateTime? expiryDate;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  HealthAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.severity,
    required this.affectedVillages,
    required this.condition,
    required this.alertDate,
    this.expiryDate,
    this.isActive = true,
    this.metadata,
  });

  factory HealthAlert.fromJson(Map<String, dynamic> json) {
    return HealthAlert(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      severity: json['severity'] ?? '',
      affectedVillages: List<String>.from(json['affectedVillages'] ?? []),
      condition: json['condition'] ?? '',
      alertDate: DateTime.parse(json['alertDate']),
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      isActive: json['isActive'] ?? true,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'severity': severity,
      'affectedVillages': affectedVillages,
      'condition': condition,
      'alertDate': alertDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  HealthAlert copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    String? severity,
    List<String>? affectedVillages,
    String? condition,
    DateTime? alertDate,
    DateTime? expiryDate,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return HealthAlert(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      affectedVillages: affectedVillages ?? this.affectedVillages,
      condition: condition ?? this.condition,
      alertDate: alertDate ?? this.alertDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }
}

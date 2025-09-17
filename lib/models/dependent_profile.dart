import 'family_member.dart';

/// Represents the caregiver mode state and configuration
class CaregiverMode {
  final bool isActive;
  final String activeDependentId;
  final String activeDependentName;
  final String activeDependentRelation;
  final DateTime? activatedAt;
  final List<String> enabledFeatures;

  const CaregiverMode({
    this.isActive = false,
    this.activeDependentId = '',
    this.activeDependentName = '',
    this.activeDependentRelation = '',
    this.activatedAt,
    this.enabledFeatures = const [],
  });

  CaregiverMode copyWith({
    bool? isActive,
    String? activeDependentId,
    String? activeDependentName,
    String? activeDependentRelation,
    DateTime? activatedAt,
    List<String>? enabledFeatures,
  }) {
    return CaregiverMode(
      isActive: isActive ?? this.isActive,
      activeDependentId: activeDependentId ?? this.activeDependentId,
      activeDependentName: activeDependentName ?? this.activeDependentName,
      activeDependentRelation:
          activeDependentRelation ?? this.activeDependentRelation,
      activatedAt: activatedAt ?? this.activatedAt,
      enabledFeatures: enabledFeatures ?? this.enabledFeatures,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isActive': isActive,
      'activeDependentId': activeDependentId,
      'activeDependentName': activeDependentName,
      'activeDependentRelation': activeDependentRelation,
      'activatedAt': activatedAt?.toIso8601String(),
      'enabledFeatures': enabledFeatures,
    };
  }

  factory CaregiverMode.fromMap(Map<String, dynamic> map) {
    return CaregiverMode(
      isActive: map['isActive'] ?? false,
      activeDependentId: map['activeDependentId'] ?? '',
      activeDependentName: map['activeDependentName'] ?? '',
      activeDependentRelation: map['activeDependentRelation'] ?? '',
      activatedAt: map['activatedAt'] != null
          ? DateTime.parse(map['activatedAt'])
          : null,
      enabledFeatures: List<String>.from(map['enabledFeatures'] ?? []),
    );
  }
}

/// Enhanced family member model with dependent profile capabilities
class DependentProfile extends FamilyMember {
  final String primaryUserId;
  final bool hasOwnAccount;
  final String? linkedAccountId;
  final bool allowIndependentAccess;
  final List<String> caregiverPermissions;
  final Map<String, dynamic> caregiverSettings;
  final List<String> medicalConditions;
  final Map<String, dynamic> emergencyInfo;
  final DateTime? lastCaregiverActivity;

  DependentProfile({
    required super.id,
    required super.name,
    required super.relation,
    required super.dateOfBirth,
    required super.gender,
    super.bloodGroup,
    super.phoneNumber,
    super.email,
    super.allergies,
    super.medications,
    super.medicalHistory,
    super.isPrimaryContact,
    required super.createdAt,
    required super.updatedAt,
    required this.primaryUserId,
    this.hasOwnAccount = false,
    this.linkedAccountId,
    this.allowIndependentAccess = false,
    this.caregiverPermissions = const [],
    this.caregiverSettings = const {},
    this.medicalConditions = const [],
    this.emergencyInfo = const {},
    this.lastCaregiverActivity,
  });

  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    baseMap.addAll({
      'primaryUserId': primaryUserId,
      'hasOwnAccount': hasOwnAccount,
      'linkedAccountId': linkedAccountId,
      'allowIndependentAccess': allowIndependentAccess,
      'caregiverPermissions': caregiverPermissions,
      'caregiverSettings': caregiverSettings,
      'medicalConditions': medicalConditions,
      'emergencyInfo': emergencyInfo,
      'lastCaregiverActivity': lastCaregiverActivity?.toIso8601String(),
    });
    return baseMap;
  }

  factory DependentProfile.fromMap(Map<String, dynamic> map) {
    final familyMember = FamilyMember.fromMap(map);
    return DependentProfile(
      id: familyMember.id,
      name: familyMember.name,
      relation: familyMember.relation,
      dateOfBirth: familyMember.dateOfBirth,
      gender: familyMember.gender,
      bloodGroup: familyMember.bloodGroup,
      phoneNumber: familyMember.phoneNumber,
      email: familyMember.email,
      allergies: familyMember.allergies,
      medications: familyMember.medications,
      medicalHistory: familyMember.medicalHistory,
      isPrimaryContact: familyMember.isPrimaryContact,
      createdAt: familyMember.createdAt,
      updatedAt: familyMember.updatedAt,
      primaryUserId: map['primaryUserId'] ?? '',
      hasOwnAccount: map['hasOwnAccount'] ?? false,
      linkedAccountId: map['linkedAccountId'],
      allowIndependentAccess: map['allowIndependentAccess'] ?? false,
      caregiverPermissions: List<String>.from(
        map['caregiverPermissions'] ?? [],
      ),
      caregiverSettings: Map<String, dynamic>.from(
        map['caregiverSettings'] ?? {},
      ),
      medicalConditions: List<String>.from(map['medicalConditions'] ?? []),
      emergencyInfo: Map<String, dynamic>.from(map['emergencyInfo'] ?? {}),
      lastCaregiverActivity: map['lastCaregiverActivity'] != null
          ? DateTime.parse(map['lastCaregiverActivity'])
          : null,
    );
  }

  factory DependentProfile.fromFamilyMember(
    FamilyMember familyMember,
    String primaryUserId,
  ) {
    return DependentProfile(
      id: familyMember.id,
      name: familyMember.name,
      relation: familyMember.relation,
      dateOfBirth: familyMember.dateOfBirth,
      gender: familyMember.gender,
      bloodGroup: familyMember.bloodGroup,
      phoneNumber: familyMember.phoneNumber,
      email: familyMember.email,
      allergies: familyMember.allergies,
      medications: familyMember.medications,
      medicalHistory: familyMember.medicalHistory,
      isPrimaryContact: familyMember.isPrimaryContact,
      createdAt: familyMember.createdAt,
      updatedAt: familyMember.updatedAt,
      primaryUserId: primaryUserId,
    );
  }

  DependentProfile copyWith({
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
    String? primaryUserId,
    bool? hasOwnAccount,
    String? linkedAccountId,
    bool? allowIndependentAccess,
    List<String>? caregiverPermissions,
    Map<String, dynamic>? caregiverSettings,
    List<String>? medicalConditions,
    Map<String, dynamic>? emergencyInfo,
    DateTime? lastCaregiverActivity,
  }) {
    return DependentProfile(
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
      primaryUserId: primaryUserId ?? this.primaryUserId,
      hasOwnAccount: hasOwnAccount ?? this.hasOwnAccount,
      linkedAccountId: linkedAccountId ?? this.linkedAccountId,
      allowIndependentAccess:
          allowIndependentAccess ?? this.allowIndependentAccess,
      caregiverPermissions: caregiverPermissions ?? this.caregiverPermissions,
      caregiverSettings: caregiverSettings ?? this.caregiverSettings,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      emergencyInfo: emergencyInfo ?? this.emergencyInfo,
      lastCaregiverActivity:
          lastCaregiverActivity ?? this.lastCaregiverActivity,
    );
  }
}

/// Represents a family health overview with all members
class FamilyHealthOverview {
  final String primaryUserId;
  final String primaryUserName;
  final List<DependentProfile> dependents;
  final int totalMembers;
  final int upcomingAppointments;
  final int pendingMedications;
  final int criticalAlerts;
  final Map<String, dynamic> healthSummary;
  final DateTime lastUpdated;

  const FamilyHealthOverview({
    required this.primaryUserId,
    required this.primaryUserName,
    this.dependents = const [],
    this.totalMembers = 0,
    this.upcomingAppointments = 0,
    this.pendingMedications = 0,
    this.criticalAlerts = 0,
    this.healthSummary = const {},
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'primaryUserId': primaryUserId,
      'primaryUserName': primaryUserName,
      'dependents': dependents.map((d) => d.toMap()).toList(),
      'totalMembers': totalMembers,
      'upcomingAppointments': upcomingAppointments,
      'pendingMedications': pendingMedications,
      'criticalAlerts': criticalAlerts,
      'healthSummary': healthSummary,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory FamilyHealthOverview.fromMap(Map<String, dynamic> map) {
    return FamilyHealthOverview(
      primaryUserId: map['primaryUserId'] ?? '',
      primaryUserName: map['primaryUserName'] ?? '',
      dependents:
          (map['dependents'] as List?)
              ?.map((d) => DependentProfile.fromMap(d))
              .toList() ??
          [],
      totalMembers: map['totalMembers'] ?? 0,
      upcomingAppointments: map['upcomingAppointments'] ?? 0,
      pendingMedications: map['pendingMedications'] ?? 0,
      criticalAlerts: map['criticalAlerts'] ?? 0,
      healthSummary: Map<String, dynamic>.from(map['healthSummary'] ?? {}),
      lastUpdated: DateTime.parse(
        map['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

/// Caregiver permissions and settings constants
class CaregiverPermissions {
  static const String viewMedicalHistory = 'view_medical_history';
  static const String bookAppointments = 'book_appointments';
  static const String manageeMedications = 'manage_medications';
  static const String receiveNotifications = 'receive_notifications';
  static const String emergencyAccess = 'emergency_access';
  static const String updateProfile = 'update_profile';
  static const String viewReports = 'view_reports';
  static const String manageInsurance = 'manage_insurance';

  static const List<String> allPermissions = [
    viewMedicalHistory,
    bookAppointments,
    manageeMedications,
    receiveNotifications,
    emergencyAccess,
    updateProfile,
    viewReports,
    manageInsurance,
  ];

  static const List<String> defaultPermissions = [
    viewMedicalHistory,
    bookAppointments,
    receiveNotifications,
    emergencyAccess,
  ];
}

/// User roles and permissions for the TeleMed application
/// This file defines all user roles and their associated permissions

/// Enum defining all possible user roles in the system
enum UserRole {
  patient('patient', 'Patient', 'P'),
  doctor('doctor', 'Doctor', 'D'),
  admin('admin', 'Administrator', 'A'),
  pharmacy('pharmacy', 'Pharmacy', 'PH');

  const UserRole(this.value, this.displayName, this.shortCode);

  final String value;
  final String displayName;
  final String shortCode;

  /// Convert string to UserRole enum
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value.toLowerCase(),
      orElse: () => UserRole.patient, // Default to patient if invalid
    );
  }

  /// Get all role values as strings
  static List<String> get allValues =>
      UserRole.values.map((role) => role.value).toList();

  /// Check if role is valid
  static bool isValidRole(String role) {
    return UserRole.values.any((r) => r.value == role.toLowerCase());
  }
}

/// Enum defining specific permissions within the system
enum Permission {
  // Patient permissions
  viewOwnProfile('view_own_profile'),
  editOwnProfile('edit_own_profile'),
  bookAppointment('book_appointment'),
  viewOwnAppointments('view_own_appointments'),
  viewOwnPrescriptions('view_own_prescriptions'),
  viewOwnHealthRecords('view_own_health_records'),
  uploadHealthDocuments('upload_health_documents'),

  // Doctor permissions
  viewPatientProfiles('view_patient_profiles'),
  viewAllAppointments('view_all_appointments'),
  createPrescriptions('create_prescriptions'),
  updateAppointmentStatus('update_appointment_status'),
  accessVideoConsultation('access_video_consultation'),
  viewPatientHealthRecords('view_patient_health_records'),

  // Admin permissions
  manageUsers('manage_users'),
  manageSystemSettings('manage_system_settings'),
  viewSystemAnalytics('view_system_analytics'),
  manageDoctors('manage_doctors'),
  managePharmacies('manage_pharmacies'),
  viewAllData('view_all_data'),
  systemBackup('system_backup'),

  // Pharmacy permissions
  viewPrescriptions('view_prescriptions'),
  updatePrescriptionStatus('update_prescription_status'),
  manageInventory('manage_inventory'),
  processPrescriptionOrders('process_prescription_orders');

  const Permission(this.value);

  final String value;

  /// Convert string to Permission enum
  static Permission? fromString(String value) {
    try {
      return Permission.values.firstWhere(
        (permission) => permission.value == value,
      );
    } catch (e) {
      return null;
    }
  }
}

/// Role-based access control configuration
class RolePermissions {
  static const Map<UserRole, List<Permission>> _rolePermissions = {
    UserRole.patient: [
      Permission.viewOwnProfile,
      Permission.editOwnProfile,
      Permission.bookAppointment,
      Permission.viewOwnAppointments,
      Permission.viewOwnPrescriptions,
      Permission.viewOwnHealthRecords,
      Permission.uploadHealthDocuments,
    ],

    UserRole.doctor: [
      Permission.viewOwnProfile,
      Permission.editOwnProfile,
      Permission.viewPatientProfiles,
      Permission.viewAllAppointments,
      Permission.createPrescriptions,
      Permission.updateAppointmentStatus,
      Permission.accessVideoConsultation,
      Permission.viewPatientHealthRecords,
    ],

    UserRole.admin: [
      Permission.manageUsers,
      Permission.manageSystemSettings,
      Permission.viewSystemAnalytics,
      Permission.manageDoctors,
      Permission.managePharmacies,
      Permission.viewAllData,
      Permission.systemBackup,
      Permission.viewOwnProfile,
      Permission.editOwnProfile,
    ],

    UserRole.pharmacy: [
      Permission.viewOwnProfile,
      Permission.editOwnProfile,
      Permission.viewPrescriptions,
      Permission.updatePrescriptionStatus,
      Permission.manageInventory,
      Permission.processPrescriptionOrders,
    ],
  };

  /// Get all permissions for a given role
  static List<Permission> getPermissionsForRole(UserRole role) {
    return _rolePermissions[role] ?? [];
  }

  /// Check if a role has a specific permission
  static bool hasPermission(UserRole role, Permission permission) {
    return _rolePermissions[role]?.contains(permission) ?? false;
  }

  /// Check if a role has any of the specified permissions
  static bool hasAnyPermission(UserRole role, List<Permission> permissions) {
    final rolePermissions = _rolePermissions[role] ?? [];
    return permissions.any(
      (permission) => rolePermissions.contains(permission),
    );
  }

  /// Check if a role has all of the specified permissions
  static bool hasAllPermissions(UserRole role, List<Permission> permissions) {
    final rolePermissions = _rolePermissions[role] ?? [];
    return permissions.every(
      (permission) => rolePermissions.contains(permission),
    );
  }

  /// Get all roles that have a specific permission
  static List<UserRole> getRolesWithPermission(Permission permission) {
    return _rolePermissions.entries
        .where((entry) => entry.value.contains(permission))
        .map((entry) => entry.key)
        .toList();
  }
}

/// Constants for JWT and authentication
class AuthConstants {
  // JWT Configuration
  static const String jwtSecretKey =
      'telemed_jwt_secret_2024'; // Should be from environment
  static const Duration accessTokenExpiry = Duration(hours: 1);
  static const Duration refreshTokenExpiry = Duration(days: 7);

  // Token types
  static const String accessTokenType = 'access_token';
  static const String refreshTokenType = 'refresh_token';

  // Claim keys
  static const String userIdClaim = 'user_id';
  static const String emailClaim = 'email';
  static const String roleClaim = 'role';
  static const String permissionsClaim = 'permissions';
  static const String tokenTypeClaim = 'token_type';
  static const String issuedAtClaim = 'iat';
  static const String expiresAtClaim = 'exp';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userRoleKey = 'user_role';
  static const String userPermissionsKey = 'user_permissions';

  // Error messages
  static const String invalidTokenError = 'Invalid or expired token';
  static const String insufficientPermissionsError = 'Insufficient permissions';
  static const String unauthorizedError = 'Unauthorized access';
  static const String tokenExpiredError = 'Token has expired';
  static const String invalidRoleError = 'Invalid user role';

  // API endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String logoutEndpoint = '/auth/logout';
  static const String userProfileEndpoint = '/user/profile';
}

/// Default role assignments for new registrations
class DefaultRoleAssignment {
  /// Get default role for user registration based on registration type
  static UserRole getDefaultRole({String? registrationType}) {
    switch (registrationType?.toLowerCase()) {
      case 'doctor':
        return UserRole.doctor;
      case 'pharmacy':
        return UserRole.pharmacy;
      case 'admin':
        return UserRole.admin;
      case 'patient':
      default:
        return UserRole.patient;
    }
  }

  /// Check if a role requires special verification
  static bool requiresVerification(UserRole role) {
    switch (role) {
      case UserRole.doctor:
      case UserRole.pharmacy:
      case UserRole.admin:
        return true;
      case UserRole.patient:
        return false;
    }
  }

  /// Get required verification documents for each role
  static List<String> getRequiredDocuments(UserRole role) {
    switch (role) {
      case UserRole.doctor:
        return [
          'medical_license',
          'qualification_certificate',
          'identity_proof',
        ];
      case UserRole.pharmacy:
        return ['pharmacy_license', 'drug_license', 'identity_proof'];
      case UserRole.admin:
        return ['employment_verification', 'identity_proof'];
      case UserRole.patient:
        return [];
    }
  }
}

/// Role hierarchy and access levels
class RoleHierarchy {
  static const Map<UserRole, int> _hierarchyLevels = {
    UserRole.patient: 1,
    UserRole.pharmacy: 2,
    UserRole.doctor: 3,
    UserRole.admin: 4,
  };

  /// Get hierarchy level for a role (higher number = more privileges)
  static int getHierarchyLevel(UserRole role) {
    return _hierarchyLevels[role] ?? 0;
  }

  /// Check if role1 has higher or equal privileges than role2
  static bool hasHigherOrEqualPrivileges(UserRole role1, UserRole role2) {
    return getHierarchyLevel(role1) >= getHierarchyLevel(role2);
  }

  /// Check if role1 has higher privileges than role2
  static bool hasHigherPrivileges(UserRole role1, UserRole role2) {
    return getHierarchyLevel(role1) > getHierarchyLevel(role2);
  }

  /// Get all roles with lower privileges than the given role
  static List<UserRole> getLowerPrivilegeRoles(UserRole role) {
    final currentLevel = getHierarchyLevel(role);
    return _hierarchyLevels.entries
        .where((entry) => entry.value < currentLevel)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get all roles with higher or equal privileges than the given role
  static List<UserRole> getHigherOrEqualPrivilegeRoles(UserRole role) {
    final currentLevel = getHierarchyLevel(role);
    return _hierarchyLevels.entries
        .where((entry) => entry.value >= currentLevel)
        .map((entry) => entry.key)
        .toList();
  }
}

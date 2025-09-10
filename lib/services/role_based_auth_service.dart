import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/user_roles.dart';
import '../models/patient_profile.dart';
import 'jwt_service.dart';

/// Role-based authentication service that integrates with Supabase and JWT
class RoleBasedAuthService {
  static final RoleBasedAuthService _instance =
      RoleBasedAuthService._internal();
  factory RoleBasedAuthService() => _instance;
  RoleBasedAuthService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final JWTService _jwtService = JWTService();

  /// Initialize the service
  Future<void> initialize() async {
    await _jwtService.initialize();
  }

  /// Login with email and password
  Future<AuthResult> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Authenticate with Supabase
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResult.failure(AuthConstants.unauthorizedError);
      }

      final user = response.user!;

      // Get user role and permissions from database
      final roleData = await _jwtService.getUserRoleAndPermissions(user.id);
      if (roleData == null) {
        return AuthResult.failure('User role not found');
      }

      final userRole = roleData['role'] as UserRole;
      final permissions = roleData['permissions'] as List<Permission>;
      final isVerified = roleData['is_verified'] as bool;

      if (!isVerified && userRole != UserRole.patient) {
        return AuthResult.failure('Account pending verification');
      }

      // Generate JWT tokens
      final tokens = await _jwtService.generateTokens(
        userId: user.id,
        email: user.email!,
        role: userRole,
        additionalPermissions: permissions,
      );

      if (tokens == null) {
        return AuthResult.failure('Failed to generate authentication tokens');
      }

      // Update last login
      await _updateLastLogin(user.id);

      return AuthResult.success(
        user: user,
        role: userRole,
        permissions: permissions,
        tokens: tokens,
      );
    } catch (e) {
      return AuthResult.failure('Login failed: ${e.toString()}');
    }
  }

  /// Register new user with role
  Future<AuthResult> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required UserRole role,
    String? specialization, // For doctors
    String? licenseNumber, // For doctors/pharmacies
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Register with Supabase Auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return AuthResult.failure('Registration failed');
      }

      final user = response.user!;

      // Create profile based on role
      await _createRoleBasedProfile(
        user: user,
        fullName: fullName,
        phoneNumber: phoneNumber,
        role: role,
        specialization: specialization,
        licenseNumber: licenseNumber,
        additionalData: additionalData,
      );

      // Assign role to user
      await _assignUserRole(user.id, role);

      // For patients, auto-verify. Others need manual verification
      final isVerified = role == UserRole.patient;
      if (isVerified) {
        await _verifyUserRole(user.id, role);
      }

      // Generate JWT tokens
      final permissions = RolePermissions.getPermissionsForRole(role);
      final tokens = await _jwtService.generateTokens(
        userId: user.id,
        email: user.email!,
        role: role,
        additionalPermissions: permissions,
      );

      return AuthResult.success(
        user: user,
        role: role,
        permissions: permissions,
        tokens: tokens,
        requiresVerification: !isVerified,
      );
    } catch (e) {
      return AuthResult.failure('Registration failed: ${e.toString()}');
    }
  }

  /// Get current authenticated user with role information
  Future<AuthenticatedUser?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null || !_jwtService.isAuthenticated()) {
        return null;
      }

      final role = _jwtService.getCurrentRole();
      final permissions = _jwtService.getCurrentPermissions();

      if (role == null || permissions == null) {
        // Try to refresh role and permissions
        final roleData = await _jwtService.getUserRoleAndPermissions(user.id);
        if (roleData == null) return null;

        return AuthenticatedUser(
          user: user,
          role: roleData['role'] as UserRole,
          permissions: roleData['permissions'] as List<Permission>,
          isVerified: roleData['is_verified'] as bool,
        );
      }

      return AuthenticatedUser(
        user: user,
        role: role,
        permissions: permissions,
        isVerified: true, // If we have tokens, assume verified
      );
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  /// Check if user has specific permission
  bool hasPermission(Permission permission) {
    return _jwtService.hasPermission(permission);
  }

  /// Check if user has any of the specified permissions
  bool hasAnyPermission(List<Permission> permissions) {
    return _jwtService.hasAnyPermission(permissions);
  }

  /// Check if user has all of the specified permissions
  bool hasAllPermissions(List<Permission> permissions) {
    return _jwtService.hasAllPermissions(permissions);
  }

  /// Check if user has specific role
  bool hasRole(UserRole role) {
    return _jwtService.hasRole(role);
  }

  /// Check if user has any of the specified roles
  bool hasAnyRole(List<UserRole> roles) {
    return _jwtService.hasAnyRole(roles);
  }

  /// Update user role (admin function)
  Future<bool> updateUserRole({
    required String userId,
    required UserRole newRole,
    String? reason,
  }) async {
    try {
      // Check admin permissions
      if (!hasPermission(Permission.manageUsers)) {
        throw Exception(AuthConstants.insufficientPermissionsError);
      }

      // Assign new role
      await _assignUserRole(userId, newRole);

      // Update profile table
      await _supabase
          .from('profiles')
          .update({
            'user_role': newRole.value,
            'role_verified': newRole == UserRole.patient,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);

      return true;
    } catch (e) {
      print('Error updating user role: $e');
      return false;
    }
  }

  /// Verify user role (admin function)
  Future<bool> verifyUserRole({
    required String userId,
    required UserRole role,
    String? notes,
  }) async {
    try {
      // Check admin permissions
      if (!hasPermission(Permission.manageUsers)) {
        throw Exception(AuthConstants.insufficientPermissionsError);
      }

      await _verifyUserRole(userId, role);
      return true;
    } catch (e) {
      print('Error verifying user role: $e');
      return false;
    }
  }

  /// Get users pending verification (admin function)
  Future<List<Map<String, dynamic>>> getPendingVerifications() async {
    try {
      if (!hasPermission(Permission.manageUsers)) {
        throw Exception(AuthConstants.insufficientPermissionsError);
      }

      final response = await _supabase
          .from('user_roles')
          .select('''
            *,
            profiles:user_id (
              full_name,
              email,
              phone_number,
              verification_documents
            )
          ''')
          .eq('is_verified', false)
          .neq('role', 'patient')
          .order('created_at');

      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting pending verifications: $e');
      return [];
    }
  }

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    try {
      final tokens = await _jwtService.refreshAccessToken();
      return tokens != null;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  /// Logout and clear all tokens
  Future<void> logout() async {
    try {
      await _jwtService.logout();
      await _supabase.auth.signOut();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _supabase.auth.currentUser != null && _jwtService.isAuthenticated();
  }

  /// Request role change (user function)
  Future<bool> requestRoleChange({
    required UserRole newRole,
    required String reason,
    List<String>? documentUrls,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Can't request admin role
      if (newRole == UserRole.admin) {
        throw Exception('Cannot request admin role');
      }

      // Create role request
      await _supabase.from('user_roles').insert({
        'user_id': user.id,
        'role': newRole.value,
        'is_verified': false,
        'verification_status': 'pending',
        'verification_documents': documentUrls ?? [],
      });

      return true;
    } catch (e) {
      print('Error requesting role change: $e');
      return false;
    }
  }

  /// Update user permissions (admin function)
  Future<bool> updateUserPermissions({
    required String userId,
    required List<Permission> permissions,
  }) async {
    return await _jwtService.updateUserPermissions(userId, permissions);
  }

  /// Get user's current role and permissions
  Future<Map<String, dynamic>?> getUserRoleAndPermissions(String userId) async {
    return await _jwtService.getUserRoleAndPermissions(userId);
  }

  // Private helper methods

  /// Create role-based profile
  Future<void> _createRoleBasedProfile({
    required User user,
    required String fullName,
    required String phoneNumber,
    required UserRole role,
    String? specialization,
    String? licenseNumber,
    Map<String, dynamic>? additionalData,
  }) async {
    // Create basic profile
    await _supabase.from('profiles').insert({
      'id': user.id,
      'full_name': fullName,
      'email': user.email,
      'phone_number': phoneNumber,
      'user_role': role.value,
      'role_verified': role == UserRole.patient,
      'account_verified': role == UserRole.patient,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Create role-specific profiles
    switch (role) {
      case UserRole.doctor:
        await _supabase.from('doctors').insert({
          'user_id': user.id,
          'full_name': fullName,
          'email': user.email!,
          'phone_number': phoneNumber,
          'specialization': specialization ?? 'General Medicine',
          'license_number': licenseNumber ?? 'PENDING',
          'qualification': additionalData?['qualification'] ?? 'MBBS',
          'experience_years': additionalData?['experience_years'] ?? 0,
          'consultation_fee': additionalData?['consultation_fee'] ?? 500.0,
          'verification_status': 'pending',
          'license_verified': false,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        break;

      case UserRole.pharmacy:
        await _supabase.from('pharmacy_profiles').insert({
          'user_id': user.id,
          'pharmacy_name': additionalData?['pharmacy_name'] ?? fullName,
          'license_number': licenseNumber ?? 'PENDING',
          'address': additionalData?['address'] ?? '',
          'city': additionalData?['city'] ?? '',
          'state': additionalData?['state'] ?? '',
          'pincode': additionalData?['pincode'] ?? '',
          'phone_number': phoneNumber,
          'email': user.email,
          'verification_status': 'pending',
          'license_verified': false,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        break;

      case UserRole.admin:
        await _supabase.from('admin_profiles').insert({
          'user_id': user.id,
          'admin_level': additionalData?['admin_level'] ?? 'standard',
          'department': additionalData?['department'] ?? 'General',
          'employee_id': additionalData?['employee_id'],
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });
        break;

      case UserRole.patient:
        // Patient profile already created above
        break;
    }
  }

  /// Assign role to user
  Future<void> _assignUserRole(String userId, UserRole role) async {
    final currentUserId = _supabase.auth.currentUser?.id;

    await _supabase.from('user_roles').insert({
      'user_id': userId,
      'role': role.value,
      'is_verified': role == UserRole.patient,
      'verification_status': role == UserRole.patient ? 'approved' : 'pending',
      'assigned_by': currentUserId,
      'assigned_at': DateTime.now().toIso8601String(),
    });
  }

  /// Verify user role
  Future<void> _verifyUserRole(String userId, UserRole role) async {
    final currentUserId = _supabase.auth.currentUser?.id;

    await _supabase
        .from('user_roles')
        .update({
          'is_verified': true,
          'verification_status': 'approved',
          'verified_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId)
        .eq('role', role.value);

    // Update profile verification status
    await _supabase
        .from('profiles')
        .update({
          'role_verified': true,
          'account_verified': true,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);
  }

  /// Update last login timestamp
  Future<void> _updateLastLogin(String userId) async {
    await _supabase
        .from('profiles')
        .update({'last_login_at': DateTime.now().toIso8601String()})
        .eq('id', userId);
  }
}

/// Authentication result class
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final User? user;
  final UserRole? role;
  final List<Permission>? permissions;
  final Map<String, String>? tokens;
  final bool requiresVerification;

  AuthResult._({
    required this.isSuccess,
    this.errorMessage,
    this.user,
    this.role,
    this.permissions,
    this.tokens,
    this.requiresVerification = false,
  });

  factory AuthResult.success({
    required User user,
    required UserRole role,
    required List<Permission> permissions,
    Map<String, String>? tokens,
    bool requiresVerification = false,
  }) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      role: role,
      permissions: permissions,
      tokens: tokens,
      requiresVerification: requiresVerification,
    );
  }

  factory AuthResult.failure(String errorMessage) {
    return AuthResult._(isSuccess: false, errorMessage: errorMessage);
  }
}

/// Authenticated user class with role information
class AuthenticatedUser {
  final User user;
  final UserRole role;
  final List<Permission> permissions;
  final bool isVerified;

  AuthenticatedUser({
    required this.user,
    required this.role,
    required this.permissions,
    required this.isVerified,
  });

  String get id => user.id;
  String? get email => user.email;
  DateTime? get lastSignInAt =>
      user.lastSignInAt != null ? DateTime.tryParse(user.lastSignInAt!) : null;
  DateTime get createdAt => DateTime.parse(user.createdAt);

  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  bool hasAnyPermission(List<Permission> requiredPermissions) {
    return requiredPermissions.any(
      (permission) => permissions.contains(permission),
    );
  }

  bool hasAllPermissions(List<Permission> requiredPermissions) {
    return requiredPermissions.every(
      (permission) => permissions.contains(permission),
    );
  }

  bool hasRole(UserRole requiredRole) {
    return role == requiredRole;
  }

  bool hasAnyRole(List<UserRole> requiredRoles) {
    return requiredRoles.contains(role);
  }

  bool get isPatient => role == UserRole.patient;
  bool get isDoctor => role == UserRole.doctor;
  bool get isAdmin => role == UserRole.admin;
  bool get isPharmacy => role == UserRole.pharmacy;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.value,
      'permissions': permissions.map((p) => p.value).toList(),
      'is_verified': isVerified,
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

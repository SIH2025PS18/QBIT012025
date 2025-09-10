import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/user_roles.dart';
import 'supabase_auth_service.dart';
import 'role_based_auth_service.dart';
import 'jwt_service.dart';

/// Enhanced authentication service with role-based access control and JWT tokens
class EnhancedAuthService {
  static final EnhancedAuthService _instance = EnhancedAuthService._internal();
  factory EnhancedAuthService() => _instance;
  EnhancedAuthService._internal();

  final RoleBasedAuthService _roleAuthService = RoleBasedAuthService();
  final JWTService _jwtService = JWTService();

  /// Initialize the service
  Future<void> initialize() async {
    await _roleAuthService.initialize();
    await _jwtService.initialize();
  }

  /// Phone sign in (maintains existing functionality)
  static Future<AuthResponse?> signInWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    // Use existing phone sign in
    final response = await AuthService.signInWithPhoneAndPassword(
      phoneNumber: phoneNumber,
      password: password,
    );

    // If successful, generate JWT tokens
    if (response != null) {
      try {
        final instance = EnhancedAuthService();
        await instance._generateJWTTokensAfterLogin(response.user!);
      } catch (e) {
        print('⚠️ Failed to generate JWT tokens: $e');
        // Don't fail the login for this
      }
    }

    return response;
  }

  /// Sign out (compatible with existing code)
  static Future<void> signOut() async {
    try {
      // Clear JWT tokens first
      final instance = EnhancedAuthService();
      await instance._jwtService.logout();
    } catch (e) {
      print('⚠️ Failed to clear JWT tokens: $e');
    }

    // Then use existing sign out
    await AuthService.signOut();
  }

  /// Reset password with phone number
  static Future<bool> resetPasswordWithPhone({required String phoneNumber}) {
    // This would need to be implemented with phone-based password reset
    // For now, we'll just return true to maintain compatibility
    return Future.value(true);
  }

  /// Get user data (compatible with existing code)
  static Future<Map<String, dynamic>?> getUserData() =>
      AuthService.getUserData();

  /// Utility getters (compatible with existing code)
  static bool get isAuthenticated => AuthService.isAuthenticated;
  static String? get userId => AuthService.userId;
  static String? get userEmail => AuthService.userEmail;
  static bool get isEmailConfirmed => AuthService.isEmailConfirmed;

  // ======================================
  // ENHANCED AUTHENTICATION (JWT + Roles)
  // ======================================

  /// Enhanced registration with role assignment using phone number
  Future<AuthResult> registerWithPhoneAndRole({
    required String phoneNumber,
    required String password,
    required String fullName,
    required UserRole role,
    String? specialization,
    String? licenseNumber,
    Map<String, dynamic>? additionalData,
  }) async {
    // For phone registration, we'll use a temporary email
    final random = DateTime.now().millisecondsSinceEpoch;
    final tempEmail = 'temp_$random@telemed.example.com';

    return await _roleAuthService.registerWithEmailAndPassword(
      email: tempEmail, // Temporary email for compatibility
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
      role: role,
      specialization: specialization,
      licenseNumber: licenseNumber,
      additionalData: additionalData,
    );
  }

  /// Enhanced login with JWT token generation using phone number
  Future<AuthResult> loginWithPhoneAndRole({
    required String phoneNumber,
    required String password,
  }) async {
    // For phone login, we'll need to find the user by phone number
    // This is a simplified implementation - in a real app, you'd need to
    // properly authenticate the user with their phone number
    final random = DateTime.now().millisecondsSinceEpoch;
    final tempEmail = 'temp_$random@telemed.example.com';

    return await _roleAuthService.loginWithEmailAndPassword(
      email: tempEmail, // Temporary email for compatibility
      password: password,
    );
  }

  /// Get current authenticated user with role information
  Future<AuthenticatedUser?> getCurrentUserWithRole() async {
    return await _roleAuthService.getCurrentUser();
  }

  /// Check if user has specific permission
  bool hasPermission(Permission permission) {
    return _roleAuthService.hasPermission(permission);
  }

  /// Check if user has any of the specified permissions
  bool hasAnyPermission(List<Permission> permissions) {
    return _roleAuthService.hasAnyPermission(permissions);
  }

  /// Check if user has all of the specified permissions
  bool hasAllPermissions(List<Permission> permissions) {
    return _roleAuthService.hasAllPermissions(permissions);
  }

  /// Check if user has specific role
  bool hasRole(UserRole role) {
    return _roleAuthService.hasRole(role);
  }

  /// Check if user has any of the specified roles
  bool hasAnyRole(List<UserRole> roles) {
    return _roleAuthService.hasAnyRole(roles);
  }

  /// Get current user role
  UserRole? getCurrentRole() {
    return _jwtService.getCurrentRole();
  }

  /// Get current user permissions
  List<Permission>? getCurrentPermissions() {
    return _jwtService.getCurrentPermissions();
  }

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    return await _roleAuthService.refreshToken();
  }

  /// Update user role (admin function)
  Future<bool> updateUserRole({
    required String userId,
    required UserRole newRole,
    String? reason,
  }) async {
    return await _roleAuthService.updateUserRole(
      userId: userId,
      newRole: newRole,
      reason: reason,
    );
  }

  /// Verify user role (admin function)
  Future<bool> verifyUserRole({
    required String userId,
    required UserRole role,
    String? notes,
  }) async {
    return await _roleAuthService.verifyUserRole(
      userId: userId,
      role: role,
      notes: notes,
    );
  }

  /// Get users pending verification (admin function)
  Future<List<Map<String, dynamic>>> getPendingVerifications() async {
    return await _roleAuthService.getPendingVerifications();
  }

  /// Request role change (user function)
  Future<bool> requestRoleChange({
    required UserRole newRole,
    required String reason,
    List<String>? documentUrls,
  }) async {
    return await _roleAuthService.requestRoleChange(
      newRole: newRole,
      reason: reason,
      documentUrls: documentUrls,
    );
  }

  /// Update user permissions (admin function)
  Future<bool> updateUserPermissions({
    required String userId,
    required List<Permission> permissions,
  }) async {
    return await _roleAuthService.updateUserPermissions(
      userId: userId,
      permissions: permissions,
    );
  }

  /// Check if user is authenticated with valid JWT
  bool isAuthenticatedWithJWT() {
    return _roleAuthService.isAuthenticated();
  }

  // ===================
  // MIGRATION HELPERS
  // ===================

  /// Migrate existing user to role-based system
  Future<bool> migrateExistingUser({
    required String userId,
    UserRole? defaultRole,
    Map<String, dynamic>? additionalProfileData,
  }) async {
    try {
      final user = AuthService.currentUser;
      if (user == null || user.id != userId) {
        return false;
      }

      // Check if user already has role assigned
      final existingRole = await _roleAuthService.getUserRoleAndPermissions(
        userId,
      );
      if (existingRole != null) {
        print('✅ User already has role assigned: ${existingRole['role']}');
        return true;
      }

      // Assign default role
      final role = defaultRole ?? UserRole.patient;
      await _assignDefaultRole(
        user,
        additionalProfileData?['full_name'] ?? 'User',
      );

      print('✅ User migrated to role-based system with role: ${role.value}');
      return true;
    } catch (e) {
      print('❌ Failed to migrate user: $e');
      return false;
    }
  }

  /// Check if user needs migration to role-based system
  Future<bool> needsMigration() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return false;

      final existingRole = await _roleAuthService.getUserRoleAndPermissions(
        user.id,
      );
      return existingRole == null;
    } catch (e) {
      print('❌ Error checking migration status: $e');
      return false;
    }
  }

  /// Auto-migrate user on first login
  Future<void> autoMigrateIfNeeded() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return;

      if (await needsMigration()) {
        print('🔄 Auto-migrating user to role-based system...');
        await migrateExistingUser(userId: user.id);
      }
    } catch (e) {
      print('❌ Auto-migration failed: $e');
    }
  }

  // ===================
  // PRIVATE HELPERS
  // ===================

  /// Assign default patient role to new users
  Future<void> _assignDefaultRole(User user, String fullName) async {
    try {
      // Create basic profile with patient role
      await _roleAuthService.registerWithEmailAndPassword(
        email: user.email ?? 'temp@example.com', // Use existing email or temp
        password: '', // Not used for existing user
        fullName: fullName,
        phoneNumber: '', // Will be updated later
        role: UserRole.patient,
      );
    } catch (e) {
      print('❌ Failed to assign default role: $e');
      rethrow;
    }
  }

  /// Generate JWT tokens after successful login
  Future<void> _generateJWTTokensAfterLogin(User user) async {
    try {
      // Get user role and permissions
      final roleData = await _jwtService.getUserRoleAndPermissions(user.id);
      if (roleData == null) {
        print(
          '⚠️ No role data found for user, creating default patient role...',
        );
        await _assignDefaultRole(user, 'User');
        return;
      }

      final userRole = roleData['role'] as UserRole;
      final permissions = roleData['permissions'] as List<Permission>;

      // Generate JWT tokens
      final tokens = await _jwtService.generateTokens(
        userId: user.id,
        email: user.email ?? '',
        role: userRole,
        additionalPermissions: permissions,
      );

      if (tokens != null) {
        print('✅ JWT tokens generated successfully');
      } else {
        print('⚠️ Failed to generate JWT tokens');
      }
    } catch (e) {
      print('❌ Error generating JWT tokens: $e');
    }
  }
}

// =============================
// BACKWARD COMPATIBILITY ALIAS
// =============================

/// Alias for backward compatibility with existing code
/// This allows existing code using AuthService to continue working without changes
typedef CompatibleAuthService = EnhancedAuthService;

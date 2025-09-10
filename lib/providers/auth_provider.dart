import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_auth_service.dart';
import '../services/enhanced_auth_service.dart';
import '../services/role_based_auth_service.dart';
import '../constants/user_roles.dart';

/// Provider class for managing authentication state with role-based access control
class AuthProvider extends ChangeNotifier {
  User? _user;
  AuthenticatedUser? _authenticatedUser;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  final EnhancedAuthService _enhancedAuth = EnhancedAuthService();

  // Getters
  User? get user => _user;
  AuthenticatedUser? get authenticatedUser => _authenticatedUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  // Role-based getters
  UserRole? get currentRole => _authenticatedUser?.role;
  List<Permission>? get currentPermissions => _authenticatedUser?.permissions;
  bool get isVerified => _authenticatedUser?.isVerified ?? false;

  /// Initialize the auth provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize enhanced auth service
      await _enhancedAuth.initialize();

      // Get current user session
      _user = AuthService.currentUser;

      // Get authenticated user with role information
      if (_user != null) {
        _authenticatedUser = await _enhancedAuth.getCurrentUserWithRole();

        // Auto-migrate if needed
        await _enhancedAuth.autoMigrateIfNeeded();

        // Refresh authenticated user after potential migration
        _authenticatedUser = await _enhancedAuth.getCurrentUserWithRole();
      }

      _isInitialized = true;

      // Listen to auth state changes
      AuthService.userStream.listen((AuthState authState) async {
        _user = authState.session?.user;

        // Update authenticated user with role information
        if (_user != null) {
          _authenticatedUser = await _enhancedAuth.getCurrentUserWithRole();
        } else {
          _authenticatedUser = null;
        }

        notifyListeners();
      });

      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize auth: $e');
    }
  }

  /// Sign in with phone number and password (enhanced with role support)
  Future<void> signIn(String phoneNumber, String password) async {
    _setLoading(true);
    _clearError();

    try {
      // Use basic phone auth directly since app is only for patients
      final authResponse = await AuthService.signInWithPhoneAndPassword(
        phoneNumber: phoneNumber,
        password: password,
      );

      if (authResponse != null) {
        _user = authResponse.user;

        // Get authenticated user with role information
        _authenticatedUser = await _enhancedAuth.getCurrentUserWithRole();

        notifyListeners();
      }
    } on AuthRetryableFetchException catch (e) {
      _setError('Network error during sign in. Please check your connection.');
      // Don't rethrow - allow app to continue in offline mode if possible
    } catch (e) {
      _setError('Sign in failed: $e');
      // Don't rethrow to prevent app crash
    } finally {
      _setLoading(false);
    }
  }

  /// Sign up with phone number and password (patient only)
  Future<void> signUp({
    required String phoneNumber,
    required String password,
    required String fullName,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await AuthService.registerWithPhone(
        phoneNumber: phoneNumber,
        password: password,
        fullName: fullName,
      );

      if (response != null && response.user != null) {
        _user = response.user;

        // Get authenticated user with role information
        _authenticatedUser = await _enhancedAuth.getCurrentUserWithRole();

        notifyListeners();
      }
    } catch (e) {
      _setError('Sign up failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out (enhanced with JWT token cleanup)
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await EnhancedAuthService.signOut();
      _user = null;
      _authenticatedUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Sign out failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password with phone number
  Future<void> resetPassword(String phoneNumber) async {
    _setLoading(true);
    _clearError();

    try {
      // Request OTP for password reset
      final success = await AuthService.requestPasswordResetOtp(
        phoneNumber: phoneNumber,
      );

      if (!success) {
        throw Exception('Failed to send OTP for password reset');
      }
    } catch (e) {
      _setError('Password reset failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    _setLoading(true);
    _clearError();

    try {
      // Access Supabase client directly since AuthService doesn't have this method
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      _setError('Password update failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Check if user is authenticated
  bool checkAuthStatus() {
    _user = AuthService.currentUser;
    notifyListeners();
    return _user != null;
  }

  /// Check if user has specific permission
  bool hasPermission(Permission permission) {
    return _enhancedAuth.hasPermission(permission);
  }

  /// Check if user has any of the specified permissions
  bool hasAnyPermission(List<Permission> permissions) {
    return _enhancedAuth.hasAnyPermission(permissions);
  }

  /// Check if user has all of the specified permissions
  bool hasAllPermissions(List<Permission> permissions) {
    return _enhancedAuth.hasAllPermissions(permissions);
  }

  /// Check if user has specific role
  bool hasRole(UserRole role) {
    return _enhancedAuth.hasRole(role);
  }

  /// Check if user has any of the specified roles
  bool hasAnyRole(List<UserRole> roles) {
    return _enhancedAuth.hasAnyRole(roles);
  }

  /// Request role change
  Future<void> requestRoleChange({
    required UserRole newRole,
    required String reason,
    List<String>? documentUrls,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _enhancedAuth.requestRoleChange(
        newRole: newRole,
        reason: reason,
        documentUrls: documentUrls,
      );

      if (!success) {
        throw Exception('Role change request failed');
      }
    } catch (e) {
      _setError('Role change request failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Update user role (admin function)
  Future<void> updateUserRole({
    required String userId,
    required UserRole newRole,
    String? reason,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _enhancedAuth.updateUserRole(
        userId: userId,
        newRole: newRole,
        reason: reason,
      );

      if (!success) {
        throw Exception('Failed to update user role');
      }

      // Refresh current user if it's the same user
      if (userId == _user?.id) {
        _authenticatedUser = await _enhancedAuth.getCurrentUserWithRole();
        notifyListeners();
      }
    } catch (e) {
      _setError('Role update failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Verify user role (admin function)
  Future<void> verifyUserRole({
    required String userId,
    required UserRole role,
    String? notes,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _enhancedAuth.verifyUserRole(
        userId: userId,
        role: role,
        notes: notes,
      );

      if (!success) {
        throw Exception('Failed to verify user role');
      }
    } catch (e) {
      _setError('Role verification failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Get pending verifications (admin function)
  Future<List<Map<String, dynamic>>> getPendingVerifications() async {
    try {
      return await _enhancedAuth.getPendingVerifications();
    } catch (e) {
      _setError('Failed to get pending verifications: $e');
      return [];
    }
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _enhancedAuth.refreshToken();
      if (!success) {
        throw Exception('Token refresh failed');
      }

      // Refresh user information
      _authenticatedUser = await _enhancedAuth.getCurrentUserWithRole();
      notifyListeners();
    } catch (e) {
      _setError('Token refresh failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Check if authenticated with valid JWT
  bool isAuthenticatedWithJWT() {
    return _enhancedAuth.isAuthenticatedWithJWT();
  }

  // =======================
  // ROLE-BASED GETTERS
  // =======================

  /// Check if user is a patient
  bool get isPatient => currentRole == UserRole.patient;

  /// Check if user is a doctor
  bool get isDoctor => currentRole == UserRole.doctor;

  /// Check if user is an admin
  bool get isAdmin => currentRole == UserRole.admin;

  /// Check if user is a pharmacy
  bool get isPharmacy => currentRole == UserRole.pharmacy;

  /// Get role display name
  String? get roleDisplayName => currentRole?.displayName;

  /// Check if user can access admin features
  bool get canAccessAdminFeatures => hasRole(UserRole.admin);

  /// Check if user can access doctor features
  bool get canAccessDoctorFeatures =>
      hasAnyRole([UserRole.doctor, UserRole.admin]);

  /// Check if user can access pharmacy features
  bool get canAccessPharmacyFeatures =>
      hasAnyRole([UserRole.pharmacy, UserRole.admin]);
}

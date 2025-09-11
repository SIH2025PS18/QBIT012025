import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

/// Provider class for managing authentication state
class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  final AuthService _authService = AuthService();

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  // Simple getters for patient-only app
  String? get currentRole => _user?.role;
  bool get isVerified => _user?.isVerified ?? false;
  bool get isPatient => true; // Always true for patient-only app
  String? get roleDisplayName => _user?.displayName;

  /// Initialize the auth provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize auth service
      await _authService.initialize();

      // Check for existing session
      final userProfileResult = await _authService.getUserProfile();
      if (userProfileResult.isSuccess && userProfileResult.user != null) {
        _user = userProfileResult.user;
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _setError('Failed to initialize auth: $e');
    }
  }

  /// Sign in with phone number and password
  Future<void> signIn(String phoneNumber, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.login(
        loginId: phoneNumber,
        password: password,
        userType: 'patient',
      );
      if (result.isSuccess && result.user != null) {
        _user = result.user;
        notifyListeners();
      } else {
        throw Exception(result.error);
      }
    } catch (e) {
      _setError('Sign in failed: $e');
      rethrow;
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
      final result = await _authService.registerWithMobile(
        name: fullName,
        phone: phoneNumber,
        password: password,
        age: 25, // Default age
        gender: 'other', // Default gender
      );

      if (result.isSuccess && result.user != null) {
        _user = result.user;
        notifyListeners();
      } else {
        throw Exception(result.error);
      }
    } catch (e) {
      _setError('Sign up failed: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.logout();
      _user = null;
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
      // Since the AuthService doesn't have resetPassword, we'll show an error message
      throw Exception(
        'Password reset functionality is not available. Please contact support.',
      );
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
      final result = await _authService.changePassword(
        currentPassword: 'current', // This would need to be passed as parameter
        newPassword: newPassword,
      );
      if (!result.isSuccess) {
        throw Exception(result.error);
      }
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
    return _user != null;
  }
}

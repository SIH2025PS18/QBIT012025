import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/auth_service.dart';
import '../database/offline_database.dart' if (dart.library.html) '../utils/web_stub.dart';
import '../core/service_locator.dart';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import 'dart:math';
import '../utils/network_logger.dart';

class PhoneAuthService {
  static final AuthService _authService = AuthService();
  static const String _phoneKey = 'user_phone';
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Hash password method
  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Show toast message
  static void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Check if user exists (simplified - no longer used but kept for compatibility)
  static Future<bool> checkUserExists(String phoneNumber) async {
    try {
      // For the unified backend, we don't pre-check existence
      // Let the registration/login attempt handle this
      return false; // Always return false to allow registration attempts
    } catch (e) {
      print('❌ Error checking user existence: $e');
      return false;
    }
  }

  // Simple registration without OTP - directly call unified backend
  static Future<bool> sendRegistrationOtp(String phoneNumber) async {
    try {
      print('📱 Preparing simple registration for: $phoneNumber');
      _showToast(
        'Ready for registration. Please enter your details and password.',
      );
      return true; // Always return true since we're not using OTP anymore
    } catch (e) {
      print('❌ Error in registration preparation: $e');
      _showToast('Registration preparation failed: $e', isError: true);
      return false;
    }
  }

  // Register with phone using unified backend (no OTP required)
  static Future<Map<String, dynamic>?> registerWithPhone({
    required String phoneNumber,
    required String password,
    required String fullName,
    required String otp, // Ignored since we're not using OTP
  }) async {
    try {
      print('🚧 Starting simple phone registration for: $phoneNumber');
      print('👤 Full Name: $fullName');
      print('🔒 Password Length: ${password.length} characters');
      print('🔢 OTP (ignored): $otp');

      // Use the unified backend via AuthService
      print('📡 Calling AuthService.registerWithMobile...');
      final startTime = DateTime.now();
      print(
        '🕒 Registration process started at: ${startTime.toIso8601String()}',
      );

      final result = await _authService.registerWithMobile(
        name: fullName,
        phone: phoneNumber,
        password: password,
        age: 25, // Default age, can be updated later
        gender: 'other', // Default, can be updated later
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('📥 Received response from AuthService.registerWithMobile');
      print('⏱️ Registration process duration: ${duration.inMilliseconds}ms');
      print('📊 Result Success: ${result.isSuccess}');
      print('👤 User Data Present: ${result.user != null}');

      if (result.isSuccess && result.user != null) {
        print('✅ Registration successful in backend');
        print('🆔 User ID: ${result.user!.id}');
        print(
          '📧 Phone (from email): ${result.user!.email}',
        ); // Changed from phone to email
        print('👤 Name: ${result.user!.name}');
        print('🎭 Role: ${result.user!.role}');

        final userData = {
          'id': result.user!.id,
          'phone_number': phoneNumber.trim(),
          'full_name': fullName.trim(),
          'name': fullName.trim(),
          'role': result.user!.role,
          'created_at': DateTime.now().toIso8601String(),
          'is_verified': true,
          'is_active': true,
        };

        // Store offline for future access
        print('💾 Storing user data offline...');
        await _storeUserDataOffline(userData);
        await _setLoggedInStatus(true);

        _showToast('Account created successfully! Welcome!');
        print('🎉 Registration process completed successfully');
        return userData;
      } else {
        print('❌ Registration failed in backend');
        print('💬 Error message: ${result.error}');

        // Check if it's a duplicate phone number error
        if (result.error != null &&
            (result.error!.contains('already exists') ||
                result.error!.contains('duplicate') ||
                result.error!.contains('phone number'))) {
          print('⚠️ Duplicate phone number error detected');
          throw Exception(
            'Phone number already registered. Please use a different number or sign in.',
          );
        }
        _showToast(result.error ?? 'Registration failed', isError: true);
        return null;
      }
    } catch (e) {
      print('❌ Registration error in PhoneAuthService: $e');
      print('📍 Stack trace: ${StackTrace.current}');
      _showToast('Registration failed: $e', isError: true);
      rethrow; // Re-throw to let the UI handle it properly
    }
  }

  // Create a test user when OTP verification fails (for development only)
  static Future<Map<String, dynamic>?> _createTestUser(
    String phoneNumber,
    String password,
    String fullName,
  ) async {
    try {
      // Generate a mock user ID
      final userId = 'test_${DateTime.now().millisecondsSinceEpoch}';
      final hashedPassword = _hashPassword(password);

      final userData = {
        'id': userId,
        'phone_number': phoneNumber.trim(),
        'password_hash': hashedPassword,
        'full_name': fullName.trim(),
        'email': null,
        'created_at': DateTime.now().toIso8601String(),
        'is_verified': true,
        'is_active': true,
      };

      // Store in user_profiles table
      // Store in offline database instead of
      // await _.from('user_profiles').insert(userData);
      print('User data stored locally: $userData');

      // Store offline for future access
      await _storeUserDataOffline(userData);
      await _setLoggedInStatus(true);

      print('✅ Test account created successfully! Welcome!');
      return userData;
    } catch (e) {
      print('❌ Error creating test user: $e');
      return null;
    }
  }

  // Sign in with phone number and password using unified backend
  static Future<Map<String, dynamic>?> signInWithPhone({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      print('🔐 Starting phone login for: $phoneNumber');
      print('🔒 Password Length: ${password.length} characters');

      // Use the unified backend via AuthService
      print('📡 Calling AuthService.login...');
      final result = await _authService.login(
        loginId: phoneNumber,
        password: password,
        userType: 'patient', // Default to patient for phone login
      );

      print('📥 Received response from AuthService.login');
      print('📊 Result Success: ${result.isSuccess}');
      print('👤 User Data Present: ${result.user != null}');

      if (result.isSuccess && result.user != null) {
        print('✅ Login successful');
        print('🆔 User ID: ${result.user!.id}');
        print(
          '📧 Phone (from email): ${result.user!.email}',
        ); // Changed from phone to email
        print('👤 Name: ${result.user!.name}');

        final userData = {
          'id': result.user!.id,
          'phone_number': phoneNumber.trim(),
          'full_name': result.user!.name,
          'name': result.user!.name,
          'role': result.user!.role,
          'is_verified': true,
          'is_active': true,
        };

        // Store offline for future access
        print('💾 Storing user data offline...');
        await _storeUserDataOffline(userData);
        await _setLoggedInStatus(true);

        _showToast('Signed in successfully!');
        print('🎉 Login process completed successfully');
        return userData;
      } else {
        print('❌ Login failed');
        print('💬 Error message: ${result.error}');
        _showToast(
          result.error ?? 'Invalid phone number or password',
          isError: true,
        );
        return null;
      }
    } catch (e) {
      print('❌ Sign in error: $e');
      _showToast('Sign in failed: $e', isError: true);
      return null;
    }
  }

  // Send OTP for password reset (simplified - no OTP)
  static Future<bool> sendOtpToPhone(String phoneNumber) async {
    try {
      _showToast(
        'Password reset available. Contact support or use "Forgot Password" option.',
      );
      return true; // Always return true since we're not using OTP
    } catch (e) {
      print('❌ Error in password reset preparation: $e');
      _showToast('Password reset preparation failed: $e', isError: true);
      return false;
    }
  }

  // Reset password (simplified - no OTP verification)
  static Future<bool> resetPasswordWithOtp({
    required String phoneNumber,
    required String otp, // Ignored
    required String newPassword,
  }) async {
    try {
      // Use the unified backend's change password functionality
      final result = await _authService.changePassword(
        currentPassword:
            'temporary', // This would need to be handled differently
        newPassword: newPassword,
      );

      if (result.isSuccess) {
        _showToast('Password reset successfully!');
        return true;
      } else {
        _showToast('Password reset failed: ${result.error}', isError: true);
        return false;
      }
    } catch (e) {
      print('❌ Password reset error: $e');
      _showToast(
        'Password reset functionality needs to be implemented via support.',
        isError: true,
      );
      return false;
    }
  }

  // Store user data for offline access
  static Future<void> _storeUserDataOffline(
    Map<String, dynamic> userData,
  ) async {
    try {
      print('💾 Storing user data offline...');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, jsonEncode(userData));
      await prefs.setString(_phoneKey, userData['phone_number']);
      print('✅ User data stored in SharedPreferences');

      // Also store in local database (mobile only)
      if (!kIsWeb) {
        try {
          // Get database from service locator with fallback
          late final OfflineDatabase db;
          try {
            db = await serviceLocator.getAsync<OfflineDatabase>();
          } catch (e) {
            // Fallback to direct instantiation if service locator fails
            db = OfflineDatabase();
          }
          await db.insertOrUpdateUser(userData);
          print('✅ User data stored in local database');
        } catch (e) {
          print('⚠️ Error storing user data in database: $e');
          // Continue without database storage for web
        }
      } else {
        print('🌐 Web platform: Skipping database storage');
      }
    } catch (e) {
      print('❌ Error storing user data offline: $e');
    }
  }

  // Get stored user data
  static Future<Map<String, dynamic>?> getStoredUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userDataKey);
      if (userData != null) {
        return jsonDecode(userData);
      }
      return null;
    } catch (e) {
      print('❌ Error getting stored user data: $e');
      return null;
    }
  }

  // Check if user is logged in with enhanced validation
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      final userData = await getStoredUserData();

      // If basic checks pass, verify with auth service
      if (isLoggedIn && userData != null) {
        // Additional validation: check if auth token is still valid
        try {
          if (_authService.isAuthenticated) {
            print('✅ User is authenticated with valid token');
            return true;
          } else {
            print('⚠️ Auth token expired, clearing login status');
            await _setLoggedInStatus(false);
            return false;
          }
        } catch (e) {
          print('⚠️ Error validating auth token: $e');
          // Keep user logged in if validation fails (offline mode)
          return true;
        }
      }

      return false;
    } catch (e) {
      print('❌ Error checking login status: $e');
      return false;
    }
  }

  // Set login status with enhanced persistence
  static Future<void> _setLoggedInStatus(bool status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, status);

      // Also store timestamp for session management
      if (status) {
        await prefs.setInt(
          'login_timestamp',
          DateTime.now().millisecondsSinceEpoch,
        );
        print('✅ Login status set to true with timestamp');
      } else {
        await prefs.remove('login_timestamp');
        print('✅ Login status cleared');
      }
    } catch (e) {
      print('❌ Error setting login status: $e');
    }
  }

  // Check if login session is still valid (24 hours)
  static Future<bool> isSessionValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginTimestamp = prefs.getInt('login_timestamp');

      if (loginTimestamp == null) return false;

      final sessionDuration =
          DateTime.now().millisecondsSinceEpoch - loginTimestamp;
      const maxSessionDuration =
          24 * 60 * 60 * 1000; // 24 hours in milliseconds

      return sessionDuration < maxSessionDuration;
    } catch (e) {
      print('❌ Error checking session validity: $e');
      return false;
    }
  }

  // Sign out using unified backend
  static Future<void> signOut() async {
    try {
      print('🔓 Starting sign out process...');
      
      // Sign out from unified backend
      await _authService.logout();
      print('✅ Signed out from backend');

      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.remove(_phoneKey);
      await prefs.remove(_isLoggedInKey);
      await prefs.remove('login_timestamp');
      print('✅ Local storage cleared');

      // Clear local database (mobile only)
      if (!kIsWeb) {
        try {
          final db = await serviceLocator.getAsync<OfflineDatabase>();
          await db.clearUserData();
          print('✅ Local database cleared');
        } catch (e) {
          print('⚠️ Error clearing database via service locator: $e');
          try {
            // Fallback if service locator fails
            final db = OfflineDatabase();
            await db.clearUserData();
            print('✅ Local database cleared (fallback)');
          } catch (fallbackError) {
            print('⚠️ Error clearing database (fallback): $fallbackError');
          }
        }
      } else {
        print('🌐 Web platform: Skipping database cleanup');
      }

      _showToast('Signed out successfully');
      print('🎉 Sign out completed successfully');
    } catch (e) {
      print('❌ Error signing out: $e');
      _showToast('Error signing out: $e', isError: true);
    }
  }

  // Get current user
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    return await getStoredUserData();
  }
}

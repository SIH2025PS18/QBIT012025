import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../utils/network_utils.dart';
import 'offline_auth_service.dart';
import 'dart:math';
import 'dart:math' as math;
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  static User? get currentUser => _supabase.auth.currentUser;

  // Get user stream
  static Stream<AuthState> get userStream => _supabase.auth.onAuthStateChange;

  // Check authentication status
  static bool get isAuthenticated => currentUser != null;

  // User ID and email getters
  static String? get userId => currentUser?.id;
  static String? get userEmail => currentUser?.email;

  // Check if email is confirmed
  static bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  // Test Supabase connection
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      print('🔍 Testing Supabase connection...');
      print('   URL: ${SupabaseConfig.url}');
      print('   Key: ${SupabaseConfig.anonKey.substring(0, 20)}...');

      // Test REST API access with timeout
      final response = await _supabase
          .from('profiles')
          .select('count')
          .limit(1);

      print('✅ Supabase connection successful');
      return {
        'status': 'success',
        'connection': 'working',
        'currentUser': currentUser?.email,
        'userId': currentUser?.id,
      };
    } catch (e) {
      print('❌ Supabase connection failed: $e');

      String errorType = 'unknown';
      String errorMessage = e.toString();

      if (errorMessage.toLowerCase().contains('socketexception') ||
          errorMessage.toLowerCase().contains('failed host lookup')) {
        errorType = 'network';
        errorMessage =
            'Network connectivity issue. Cannot reach Supabase servers.';
      } else if (errorMessage.toLowerCase().contains('timeout')) {
        errorType = 'timeout';
        errorMessage = 'Connection timeout. Server took too long to respond.';
      } else if (errorMessage.toLowerCase().contains('certificate') ||
          errorMessage.toLowerCase().contains('ssl')) {
        errorType = 'ssl';
        errorMessage =
            'SSL/Certificate error. Check device date/time settings.';
      }

      return {
        'status': 'error',
        'error': errorMessage,
        'connection': 'failed',
        'errorType': errorType,
        'originalError': e.toString(),
      };
    }
  }

  // Sign up with email confirmation flow
  static Future<AuthResponse?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      print('🚧 Starting registration for: ${email.trim()}');

      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName.trim()},
      );

      print('🚧 Registration response received');
      print('   User ID: ${response.user?.id}');
      print('   Session: ${response.session?.accessToken != null}');
      print('   Email confirmed: ${response.user?.emailConfirmedAt != null}');

      if (response.user != null) {
        if (response.session != null) {
          // User is immediately confirmed and signed in (email confirmation disabled)
          await _createUserProfile(
            response.user!,
            fullName.trim(),
            email.trim(),
          );
          _showToast('Account created successfully! Welcome!', isError: false);
        } else {
          // User created but needs email confirmation (email confirmation enabled)
          _showToast(
            'Account created! Please check your email to confirm your account before signing in.',
            isError: false,
          );
        }
        return response;
      }

      print('❌ No user returned from registration');
      _showToast('Registration failed. Please try again.', isError: true);
      return null;
    } on AuthException catch (e) {
      print('❌ Auth Exception: ${e.message}');
      _handleAuthError(e);
      return null;
    } catch (e) {
      print('❌ Unexpected registration error: $e');
      _handleNetworkError(e);
      return null;
    }
  }

  // Create user profile in database
  static Future<void> _createUserProfile(
    User user,
    String fullName,
    String email,
  ) async {
    try {
      print('🚧 Creating user profile in database...');
      await _supabase.from('profiles').insert({
        'id': user.id,
        'email': email,
        'full_name': fullName,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      print('✅ User profile created successfully');
    } catch (e) {
      print('⚠️ Failed to create user profile: $e');

      // Check if it's a database schema error
      if (e.toString().toLowerCase().contains('database') ||
          e.toString().toLowerCase().contains('schema') ||
          e.toString().toLowerCase().contains('table')) {
        print('❌ DATABASE SETUP REQUIRED:');
        print('   The profiles table doesn\'t exist in your Supabase database');
        print('   Please run the SQL setup file to create required tables');
        print(
          '   Go to: https://supabase.com/dashboard/project/szrxgxvypusvkkyykrjz',
        );
      }

      // Don't throw error - auth user still created
    }
  }

  // Sign in with email and password
  static Future<AuthResponse?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('🚧 Starting sign in for: ${email.trim()}');

      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      print('🚧 Sign in response received');
      print('   User ID: ${response.user?.id}');
      print('   Session: ${response.session?.accessToken != null}');
      print('   Email confirmed: ${response.user?.emailConfirmedAt != null}');

      if (response.user != null && response.session != null) {
        print('✅ User signed in successfully');

        // Store login credentials offline for future use
        await OfflineAuthService.storeLoginCredentials(
          email: email.trim(),
          userId: response.user!.id,
          fullName: response.user!.userMetadata?['full_name'] ?? 'User',
        );

        // Get and store full user profile offline
        final userData = await getUserData();
        if (userData != null) {
          await OfflineAuthService.storeUserProfile(userData);
        }

        // Update last sign in time
        await _updateLastSignIn(response.user!.id);

        _showToast('Welcome back!', isError: false);
        return response;
      } else if (response.user != null && response.session == null) {
        // User exists but email not confirmed
        print('❌ Sign in failed - email not confirmed');
        _showToast(
          'Please confirm your email address before signing in. Check your inbox for the confirmation link.',
          isError: true,
        );
        return null;
      } else {
        print('❌ Sign in failed - invalid credentials');
        _showToast('Invalid email or password.', isError: true);
        return null;
      }
    } on AuthException catch (e) {
      print('❌ Auth Exception: ${e.message}');
      _handleAuthError(e);
      return null;
    } catch (e) {
      print('❌ Unexpected sign in error: $e');
      _handleNetworkError(e);
      return null;
    }
  }

  // Sign in with phone and password
  static Future<AuthResponse?> signInWithPhoneAndPassword({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      print('🚧 Starting phone sign in for: ${phoneNumber.trim()}');

      // First, verify the phone number exists and get the user ID
      final profileResponse = await _supabase
          .from('profiles')
          .select('id, phone_password')
          .eq('phone_number', phoneNumber.trim())
          .limit(1);

      // Check if any user was found
      if (profileResponse.isEmpty) {
        _showToast('No account found with this phone number.', isError: true);
        return null;
      }

      final userData = profileResponse.first;

      // Verify password
      if (userData['phone_password'] != _hashPassword(password)) {
        _showToast('Invalid phone number or password.', isError: true);
        return null;
      }

      // Get the user ID
      final userId = userData['id'];

      // Create a temporary session for this user
      // In a real implementation, you would use a proper authentication method
      // For now, we'll simulate a successful login
      _showToast('Welcome back!', isError: false);

      // Store login credentials offline for future use
      await OfflineAuthService.storeLoginCredentials(
        email: '', // No email for phone auth
        userId: userId,
        fullName: 'User', // This would be fetched from the profile
      );

      // Get and store full user profile offline
      final userProfileData = await getUserData();
      if (userProfileData != null) {
        await OfflineAuthService.storeUserProfile(userProfileData);
      }

      // Update last sign in time
      await _updateLastSignIn(userId);

      // Return a mock AuthResponse for successful phone login
      return AuthResponse(
        session: null,
        user: User(
          id: userId,
          appMetadata: {},
          userMetadata: {},
          createdAt: DateTime.now().toIso8601String(),
          aud: 'authenticated',
        ),
      );
    } catch (e) {
      print('❌ Phone sign in error: $e');
      _showToast('Invalid phone number or password.', isError: true);
      return null;
    }
  }

  // Sign in with phone and OTP
  static Future<AuthResponse?> signInWithPhoneAndOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      print('🚧 Starting phone sign in for: ${phoneNumber.trim()}');

      final response = await _supabase.auth.verifyOTP(
        phone: phoneNumber.trim(),
        token: otp,
        type: OtpType.sms,
      );

      print('🚧 Phone sign in response received');
      print('   User ID: ${response.user?.id}');
      print('   Session: ${response.session?.accessToken != null}');

      if (response.user != null && response.session != null) {
        print('✅ User signed in successfully with phone');

        // Store login credentials offline for future use
        await OfflineAuthService.storeLoginCredentials(
          email: response.user!.email ?? '', // Use empty string if no email
          userId: response.user!.id,
          fullName: response.user!.userMetadata?['full_name'] ?? 'User',
        );

        // Get and store full user profile offline
        final userData = await getUserData();
        if (userData != null) {
          await OfflineAuthService.storeUserProfile(userData);
        }

        // Update last sign in time
        await _updateLastSignIn(response.user!.id);

        _showToast('Welcome back!', isError: false);
        return response;
      }

      print('❌ Phone sign in failed - no user or session returned');
      _showToast(
        'Phone sign in failed. Please check your phone number and OTP.',
        isError: true,
      );
      return null;
    } on AuthException catch (e) {
      print('❌ Auth Exception during phone sign in: ${e.message}');
      _handleAuthError(e);
      return null;
    } on AuthRetryableFetchException catch (e) {
      print('❌ Network error during phone sign in: ${e.message}');
      _handleNetworkError(e);
      return null;
    } catch (e) {
      print('❌ Unexpected phone sign in error: $e');
      _handleNetworkError(e);
      return null;
    }
  }

  // Send OTP to phone number
  static Future<bool> sendOtpToPhone({required String phoneNumber}) async {
    try {
      print('🚧 Sending OTP to: ${phoneNumber.trim()}');

      // First check if user exists with this phone number
      final userExists = await _checkIfUserExistsWithPhone(phoneNumber.trim());

      if (!userExists) {
        _showToast(
          'No account found with this phone number. Please register first.',
          isError: true,
        );
        return false;
      }

      // Send OTP
      await _supabase.auth.signInWithOtp(phone: phoneNumber.trim());

      print('✅ OTP sent successfully');
      _showToast(
        'OTP sent to your phone number! Check your messages.',
        isError: false,
      );
      return true;
    } on AuthException catch (e) {
      print('❌ OTP send error: ${e.message}');
      // Handle Twilio configuration issues
      if (e.message.contains('sms') ||
          e.message.contains('twilio') ||
          e.message.contains('provider')) {
        _showToast(
          'SMS service not configured. Use any 6-digit code for testing.',
          isError: true,
        );
        return true; // Allow proceeding in test mode
      }
      _handleAuthError(e);
      return false;
    } on AuthRetryableFetchException catch (e) {
      print('❌ Network error during OTP send: $e');
      _handleNetworkError(e);
      return false;
    } catch (e) {
      print('❌ Unexpected OTP send error: $e');
      // Handle Twilio configuration issues
      if (e.toString().contains('sms') ||
          e.toString().contains('twilio') ||
          e.toString().contains('provider')) {
        _showToast(
          'SMS service not configured. Use any 6-digit code for testing.',
          isError: true,
        );
        return true; // Allow proceeding in test mode
      }
      _handleNetworkError(e);
      return false;
    }
  }

  // Check if user exists with phone number
  static Future<bool> _checkIfUserExistsWithPhone(String phoneNumber) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('id')
          .eq('phone_number', phoneNumber)
          .limit(1);

      // Check if any rows were returned
      return response.isNotEmpty;
    } catch (e) {
      print('⚠️ Error checking if user exists with phone: $e');
      return false;
    }
  }

  // Public method to check if user exists with phone number
  static Future<bool> checkIfUserExistsWithPhone(String phoneNumber) async {
    return await _checkIfUserExistsWithPhone(phoneNumber);
  }

  // Register with phone number and password
  static Future<AuthResponse?> registerWithPhone({
    required String phoneNumber,
    required String password,
    required String fullName,
  }) async {
    try {
      print('🚧 Starting phone registration for: ${phoneNumber.trim()}');

      // Check if phone number already exists
      final phoneExists = await _checkIfUserExistsWithPhone(phoneNumber.trim());
      if (phoneExists) {
        _showToast(
          'An account with this phone number already exists. Please sign in instead.',
          isError: true,
        );
        return null;
      }

      // For demo purposes, we'll create a user with a temporary email
      // In a real implementation, you would integrate with Twilio or similar service
      // Generate a consistent temporary email based on phone number to avoid duplicates
      final phoneClean = phoneNumber.trim().replaceAll(
        RegExp(r'\D'),
        '',
      ); // Remove all non-digits
      final tempEmail = 'temp_$phoneClean@telemed.example.com';
      final tempPassword = 'TempPass${DateTime.now().millisecondsSinceEpoch}';

      final response = await _supabase.auth.signUp(
        email: tempEmail,
        password: tempPassword,
        data: {
          'full_name': fullName.trim(),
          'phone_number': phoneNumber.trim(),
        },
      );

      print('🚧 Registration response received');
      print('   User ID: ${response.user?.id}');

      if (response.user != null) {
        // Update the user's profile with phone number and hashed password
        await _supabase
            .from('profiles')
            .update({
              'phone_number': phoneNumber.trim(),
              'phone_password': _hashPassword(password),
              'full_name': fullName.trim(),
            })
            .eq('id', response.user!.id);

        // Mark phone as verified (in a real implementation, this would be done after OTP verification)
        await _supabase
            .from('profiles')
            .update({'phone_verified': true})
            .eq('id', response.user!.id);

        if (response.session != null) {
          _showToast('Account created successfully! Welcome!', isError: false);
        } else {
          _showToast(
            'Account created! Please check your phone for the OTP. In test mode, use any 6-digit code.',
            isError: false,
          );
        }
        return response;
      }

      print('❌ No user returned from registration');
      _showToast('Registration failed. Please try again.', isError: true);
      return null;
    } on AuthException catch (e) {
      print('❌ Auth Exception: ${e.message}');
      // Handle Twilio configuration issues
      if (e.message.contains('sms') ||
          e.message.contains('twilio') ||
          e.message.contains('provider')) {
        _showToast(
          'SMS service not configured. Continuing with test registration...',
          isError: true,
        );
        // Create a test user in test mode
        return await _createTestPhoneUser(phoneNumber, password, fullName);
      }
      _handleAuthError(e);
      return null;
    } catch (e) {
      print('❌ Unexpected registration error: $e');
      // Handle Twilio configuration issues
      if (e.toString().contains('sms') ||
          e.toString().contains('twilio') ||
          e.toString().contains('provider')) {
        _showToast(
          'SMS service not configured. Continuing with test registration...',
          isError: true,
        );
        // Create a test user in test mode
        return await _createTestPhoneUser(phoneNumber, password, fullName);
      }
      _handleNetworkError(e);
      return null;
    }
  }

  // Create a test user for phone registration when SMS is not configured
  static Future<AuthResponse?> _createTestPhoneUser(
    String phoneNumber,
    String password,
    String fullName,
  ) async {
    try {
      // Generate a mock user
      final userId = 'test_${DateTime.now().millisecondsSinceEpoch}';
      final phoneClean = phoneNumber.trim().replaceAll(RegExp(r'\D'), '');
      final tempEmail = 'temp_$phoneClean@telemed.example.com';

      // Create user profile directly
      await _supabase.from('profiles').insert({
        'id': userId,
        'email': tempEmail,
        'phone_number': phoneNumber.trim(),
        'phone_password': _hashPassword(password),
        'full_name': fullName.trim(),
        'phone_verified': true, // Mark as verified for test mode
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      _showToast('Test account created successfully! Welcome!', isError: false);

      // Return a mock AuthResponse
      return AuthResponse(
        session: null, // No session in test mode
        user: User(
          id: userId,
          appMetadata: {},
          userMetadata: {
            'full_name': fullName.trim(),
            'phone_number': phoneNumber.trim(),
          },
          createdAt: DateTime.now().toIso8601String(),
          aud: 'authenticated',
        ),
      );
    } catch (e) {
      print('❌ Error creating test user: $e');
      return null;
    }
  }

  // Hash password for storage
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // Request password reset with OTP
  static Future<bool> requestPasswordResetOtp({
    required String phoneNumber,
  }) async {
    try {
      print('🚧 Requesting password reset OTP for: ${phoneNumber.trim()}');

      // Check if user exists with this phone number
      final userExists = await _checkIfUserExistsWithPhone(phoneNumber.trim());
      if (!userExists) {
        _showToast('No account found with this phone number.', isError: true);
        return false;
      }

      // Send OTP for password reset
      await _supabase.auth.signInWithOtp(phone: phoneNumber.trim());

      print('✅ Password reset OTP sent successfully');
      _showToast(
        'Password reset OTP sent to your phone number!',
        isError: false,
      );
      return true;
    } on AuthException catch (e) {
      print('❌ Password reset OTP error: ${e.message}');
      _handleAuthError(e);
      return false;
    } on AuthRetryableFetchException catch (e) {
      print('❌ Network error during password reset OTP: $e');
      _handleNetworkError(e);
      return false;
    } catch (e) {
      print('❌ Unexpected password reset OTP error: $e');
      _handleNetworkError(e);
      return false;
    }
  }

  // Reset password with OTP
  static Future<bool> resetPasswordWithOtp({
    required String phoneNumber,
    required String otp,
    required String newPassword,
  }) async {
    try {
      print('🚧 Resetting password for: ${phoneNumber.trim()}');

      // Verify OTP
      final response = await _supabase.auth.verifyOTP(
        phone: phoneNumber.trim(),
        token: otp,
        type: OtpType.sms,
      );

      if (response.user != null) {
        // Update password in profiles table
        await _supabase
            .from('profiles')
            .update({
              'phone_password': _hashPassword(newPassword),
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('phone_number', phoneNumber.trim());

        print('✅ Password reset successfully');
        _showToast('Password reset successfully!', isError: false);
        return true;
      } else {
        _showToast('Invalid OTP. Please try again.', isError: true);
        return false;
      }
    } on AuthException catch (e) {
      print('❌ Password reset error: ${e.message}');
      _handleAuthError(e);
      return false;
    } on AuthRetryableFetchException catch (e) {
      print('❌ Network error during password reset: $e');
      _handleNetworkError(e);
      return false;
    } catch (e) {
      print('❌ Unexpected password reset error: $e');
      _handleNetworkError(e);
      return false;
    }
  }

  // Update last sign in timestamp
  static Future<void> _updateLastSignIn(String userId) async {
    try {
      await _supabase
          .from('profiles')
          .update({'last_sign_in': DateTime.now().toIso8601String()})
          .eq('id', userId);
      print('✅ Last sign in updated');
    } on AuthRetryableFetchException catch (e) {
      print('⚠️ Network error updating last sign in: $e');
      // Non-critical error, continue
    } catch (e) {
      print('⚠️ Failed to update last sign in: $e');

      // Check if it's a database schema error
      if (e.toString().toLowerCase().contains('database') ||
          e.toString().toLowerCase().contains('schema') ||
          e.toString().toLowerCase().contains('table')) {
        print('⚠️ Profiles table not found - continuing without update');
      }

      // Non-critical error, continue
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      print('🚧 Signing out user...');

      // Clear offline login data
      await OfflineAuthService.clearOfflineLoginData();

      // Sign out from Supabase
      await _supabase.auth.signOut();

      print('✅ User signed out successfully');
      _showToast('Signed out successfully', isError: false);
    } on AuthRetryableFetchException catch (e) {
      print('⚠️ Network error during sign out: $e');
      // Still clear offline data even if online sign out fails
      await OfflineAuthService.clearOfflineLoginData();
      _showToast('Signed out (offline mode)', isError: false);
    } catch (e) {
      print('❌ Sign out error: $e');
      // Still clear offline data even if online sign out fails
      await OfflineAuthService.clearOfflineLoginData();
      _showToast('Signed out (offline)', isError: false);
    }
  }

  // Reset password
  static Future<bool> resetPassword({required String email}) async {
    try {
      print('🚧 Sending password reset email to: ${email.trim()}');
      await _supabase.auth.resetPasswordForEmail(email.trim());
      print('✅ Password reset email sent');
      _showToast(
        'Password reset email sent! Check your inbox.',
        isError: false,
      );
      return true;
    } on AuthException catch (e) {
      print('❌ Password reset error: ${e.message}');
      _handleAuthError(e);
      return false;
    } on AuthRetryableFetchException catch (e) {
      print('❌ Network error during password reset: $e');
      _handleNetworkError(e);
      return false;
    } catch (e) {
      print('❌ Unexpected password reset error: $e');
      _handleNetworkError(e);
      return false;
    }
  }

  // Resend email confirmation
  static Future<bool> resendEmailConfirmation({required String email}) async {
    try {
      print('🚧 Resending email confirmation to: ${email.trim()}');
      await _supabase.auth.resend(type: OtpType.signup, email: email.trim());
      print('✅ Email confirmation resent');
      _showToast('Confirmation email sent! Check your inbox.', isError: false);
      return true;
    } on AuthException catch (e) {
      print('❌ Resend confirmation error: ${e.message}');
      _handleAuthError(e);
      return false;
    } on AuthRetryableFetchException catch (e) {
      print('❌ Network error during email confirmation resend: $e');
      _handleNetworkError(e);
      return false;
    } catch (e) {
      print('❌ Unexpected resend confirmation error: $e');
      _handleNetworkError(e);
      return false;
    }
  }

  // Handle network errors with better messages
  static void _handleNetworkError(dynamic error) {
    print('🔍 Handling network error: $error');

    // Use NetworkUtils for better error messages
    final message = NetworkUtils.getNetworkErrorMessage(error);

    // Additional debugging for socket exceptions
    if (error.toString().toLowerCase().contains('failed host lookup')) {
      print('🚨 DNS/Network Error: Cannot resolve Supabase hostname');
      print('   Solutions:');
      final tips = NetworkUtils.getTroubleshootingTips();
      for (int i = 0; i < tips.length && i < 5; i++) {
        print('   ${tips[i]}');
      }
    }

    // Handle AuthRetryableFetchException specifically
    if (error is AuthRetryableFetchException) {
      print(
        '🔄 Token refresh failed due to network issues. App will continue in offline mode.',
      );
      print('   Message: ${error.message}');
    }

    _showToast(message, isError: true);
  }

  // Handle Supabase Auth errors with better messages
  static void _handleAuthError(AuthException e) {
    String message;
    print('🔍 Handling auth error: ${e.message}');

    // Check for database schema error
    if (e.message.toLowerCase().contains('database error querying schema') ||
        e.message.toLowerCase().contains('unexpected_failure')) {
      message =
          'Database setup required. Please contact support or check your connection.';
      print('❌ DATABASE SCHEMA ERROR: Tables may not be created yet');
      print(
        '   Go to: https://supabase.com/dashboard/project/szrxgxvypusvkkyykrjz',
      );
      print('   Execute the SQL setup file to create required tables');
    } else {
      switch (e.message.toLowerCase()) {
        case 'invalid login credentials':
          message = 'Invalid email or password. Please check your credentials.';
          break;
        case 'email already registered':
        case 'user already registered':
          message = 'This email is already registered. Please sign in instead.';
          break;
        case 'weak password':
          message = 'Password must be at least 6 characters long.';
          break;
        case 'invalid email':
          message = 'Please enter a valid email address.';
          break;
        case 'email rate limit exceeded':
          message = 'Too many attempts. Please try again later.';
          break;
        case 'signup disabled':
          message = 'Account registration is currently disabled.';
          break;
        case 'email not confirmed':
          message = 'Please confirm your email address before signing in.';
          break;
        case 'invalid api key':
          message =
              'Authentication service configuration error. Please contact support.';
          break;
        default:
          message = e.message.isNotEmpty
              ? 'Error: ${e.message}'
              : 'An authentication error occurred';
      }
    }
    _showToast(message, isError: true);
  }

  // Show toast message
  static void _showToast(String message, {required bool isError}) {
    print(isError ? '❌ $message' : '✅ $message');
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError
          ? const Color(0xFFE53E3E)
          : const Color(0xFF38A169),
      textColor: const Color(0xFFFFFFFF),
    );
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (currentUser == null) return null;

      final response = await _supabase
          .from('profiles')
          .select('*')
          .eq('id', currentUser!.id)
          .limit(1);

      // Check if any user data was found
      if (response.isEmpty) {
        print('❌ No user data found for current user');
        return null;
      }

      return response.first;
    } catch (e) {
      print('❌ Error fetching user data: $e');
      return null;
    }
  }
}

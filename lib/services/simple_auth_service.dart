import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SimpleAuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  static User? get currentUser => _supabase.auth.currentUser;

  // Get user stream
  static Stream<AuthState> get userStream => _supabase.auth.onAuthStateChange;

  // Test connection to Supabase
  static Future<bool> testConnection() async {
    try {
      print('🔍 Testing Supabase connection...');

      // Simple ping to check if Supabase is accessible
      final response = await _supabase
          .from('profiles')
          .select('count(*)')
          .limit(1);

      print('✅ Supabase connection successful');
      return true;
    } catch (e) {
      print('❌ Supabase connection failed: $e');
      return false;
    }
  }

  // Simplified sign up - just create auth user, no profile
  static Future<AuthResponse?> signUpSimple({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      print('🚧 Starting simplified registration for: $email');

      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName.trim()},
      );

      print('🚧 Auth response received');
      print('   User ID: ${response.user?.id}');
      print(
        '   Session: ${response.session?.accessToken != null ? "YES" : "NO"}',
      );
      print(
        '   User confirmed: ${response.user?.emailConfirmedAt != null ? "YES" : "NO"}',
      );

      if (response.user != null) {
        if (response.session != null) {
          // User is confirmed and signed in
          _showToast('Account created and signed in!', isError: false);
        } else {
          // User created but needs email confirmation
          _showToast(
            'Account created! Check your email to confirm.',
            isError: false,
          );
        }
        return response;
      }

      print('❌ No user returned from signup');
      _showToast('Registration failed. Please try again.', isError: true);
      return null;
    } on AuthException catch (e) {
      print('❌ Auth Exception: ${e.message}');
      _handleAuthError(e);
      return null;
    } catch (e) {
      print('❌ Unexpected error: $e');
      _showToast('Unexpected error: ${e.toString()}', isError: true);
      return null;
    }
  }

  // Simplified sign in
  static Future<AuthResponse?> signInSimple({
    required String email,
    required String password,
  }) async {
    try {
      print('🚧 Starting sign in for: $email');

      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      print('🚧 SignIn response received');
      print('   User ID: ${response.user?.id}');
      print(
        '   Session: ${response.session?.accessToken != null ? "YES" : "NO"}',
      );

      if (response.user != null && response.session != null) {
        print('✅ Sign in successful');
        _showToast('Welcome back!', isError: false);
        return response;
      }

      print('❌ Sign in failed');
      _showToast(
        'Sign in failed. Please check your credentials.',
        isError: true,
      );
      return null;
    } on AuthException catch (e) {
      print('❌ Auth Exception: ${e.message}');
      _handleAuthError(e);
      return null;
    } catch (e) {
      print('❌ Unexpected error: $e');
      _showToast('Unexpected error: ${e.toString()}', isError: true);
      return null;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _showToast('Signed out successfully', isError: false);
    } catch (e) {
      print('❌ Sign out error: $e');
      _showToast('Error signing out', isError: true);
    }
  }

  // Handle auth errors
  static void _handleAuthError(AuthException e) {
    String message;
    switch (e.message.toLowerCase()) {
      case 'invalid login credentials':
        message = 'Invalid email or password';
        break;
      case 'email not confirmed':
        message = 'Please confirm your email first';
        break;
      case 'user not found':
        message = 'No account found with this email';
        break;
      case 'weak password':
        message = 'Password must be at least 6 characters';
        break;
      case 'invalid email':
        message = 'Please enter a valid email address';
        break;
      case 'signup disabled':
        message = 'Registration is currently disabled';
        break;
      default:
        message = e.message;
    }
    _showToast(message, isError: true);
  }

  // Show toast
  static void _showToast(String message, {required bool isError}) {
    print(isError ? '❌ $message' : '✅ $message');
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // Check authentication status
  static bool get isAuthenticated => currentUser != null;
  static String? get userId => currentUser?.id;
  static String? get userEmail => currentUser?.email;
}

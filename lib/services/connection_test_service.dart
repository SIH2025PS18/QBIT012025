import 'package:supabase_flutter/supabase_flutter.dart';

class ConnectionTestService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Test basic connection
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      print('🔍 Testing Supabase connection...');

      // Test 1: Simple REST API call
      final response = await _supabase
          .from('profiles')
          .select('count')
          .limit(1);

      print('✅ REST API test: SUCCESS');

      // Test 2: Check current auth state
      final currentUser = _supabase.auth.currentUser;
      print('   Current user: ${currentUser?.email ?? "None"}');

      return {
        'status': 'success',
        'connection': 'working',
        'currentUser': currentUser?.email,
        'userId': currentUser?.id,
      };
    } catch (e) {
      print('❌ Connection test failed: $e');
      return {'status': 'error', 'error': e.toString(), 'connection': 'failed'};
    }
  }

  // Test sign in with specific credentials
  static Future<Map<String, dynamic>> testSignIn(
    String email,
    String password,
  ) async {
    try {
      print('🔍 Testing sign in with: $email');

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null && response.session != null) {
        print('✅ Sign in SUCCESS');
        print('   User ID: ${response.user!.id}');
        print('   Email: ${response.user!.email}');
        print('   Email confirmed: ${response.user!.emailConfirmedAt != null}');

        return {
          'status': 'success',
          'userId': response.user!.id,
          'email': response.user!.email,
          'emailConfirmed': response.user!.emailConfirmedAt != null,
        };
      } else {
        print('❌ Sign in failed - no user/session returned');
        return {'status': 'failed', 'error': 'No user or session returned'};
      }
    } on AuthException catch (e) {
      print('❌ Auth error: ${e.message}');
      return {'status': 'auth_error', 'error': e.message};
    } catch (e) {
      print('❌ Unexpected error: $e');
      return {'status': 'error', 'error': e.toString()};
    }
  }

  // Check if user exists in auth.users table
  static Future<Map<String, dynamic>> checkUserExists(String email) async {
    try {
      print('🔍 Checking if user exists: $email');

      // We can't directly query auth.users, but we can try to sign in
      // and check the error message
      final result = await testSignIn(email, 'dummy_password');

      if (result['status'] == 'auth_error') {
        final error = result['error'] as String;
        if (error.contains('Invalid login credentials')) {
          return {
            'status': 'user_exists',
            'message': 'User exists but password is wrong',
          };
        } else if (error.contains('User not found')) {
          return {'status': 'user_not_found', 'message': 'User does not exist'};
        }
      }

      return result;
    } catch (e) {
      return {'status': 'error', 'error': e.toString()};
    }
  }
}

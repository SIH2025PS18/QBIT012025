import 'package:flutter/material.dart';
import '../services/phone_auth_service.dart';
import 'auth/phone_login_with_password_screen.dart';
import 'splash_screen.dart';
import 'nabha_home_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isCheckingAuth = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    print('🔍 Checking auth status...');
    setState(() => _isCheckingAuth = true);

    try {
      // Check if user is logged in with enhanced validation
      print('📱 Checking if user is logged in...');
      final isLoggedIn = await PhoneAuthService.isLoggedIn();
      print('🔐 Is logged in: $isLoggedIn');

      // Additional session validity check
      if (isLoggedIn) {
        print('⏰ Checking session validity...');
        final isSessionValid = await PhoneAuthService.isSessionValid();
        print('✅ Session valid: $isSessionValid');
        
        if (!isSessionValid) {
          print('⚠️ Session expired, requiring re-login');
          setState(() => _isLoggedIn = false);
        } else {
          print('✅ User session is valid, auto-login successful');
          setState(() => _isLoggedIn = true);
        }
      } else {
        print('❌ User not logged in');
        setState(() => _isLoggedIn = false);
      }
    } catch (e) {
      print('❌ Error checking auth status: $e');
      // Default to not logged in on error
      setState(() => _isLoggedIn = false);
    }

    setState(() => _isCheckingAuth = false);
    print('🎯 Auth check completed. Logged in: $_isLoggedIn');
  }

  @override
  Widget build(BuildContext context) {
    // Show splash screen while checking auth
    if (_isCheckingAuth) {
      return const SplashScreen();
    }

    // Navigate based on auth status
    if (_isLoggedIn) {
      return const NabhaHomeScreen();
    } else {
      return const PhoneLoginWithPasswordScreen();
    }
  }
}

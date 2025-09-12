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
    setState(() => _isCheckingAuth = true);

    try {
      // Check if user is logged in with enhanced validation
      final isLoggedIn = await PhoneAuthService.isLoggedIn();

      // Additional session validity check
      if (isLoggedIn) {
        final isSessionValid = await PhoneAuthService.isSessionValid();
        if (!isSessionValid) {
          print('⚠️ Session expired, requiring re-login');
          setState(() => _isLoggedIn = false);
        } else {
          print('✅ User session is valid, auto-login successful');
          setState(() => _isLoggedIn = true);
        }
      } else {
        setState(() => _isLoggedIn = false);
      }
    } catch (e) {
      print('Error checking auth status: $e');
      setState(() => _isLoggedIn = false);
    }

    setState(() => _isCheckingAuth = false);
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

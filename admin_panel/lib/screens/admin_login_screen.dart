import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../providers/admin_theme_provider.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://telemed18.onrender.com/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'loginId':
              _emailController.text.trim(), // Changed from 'email' to 'loginId'
          'password': _passwordController.text,
          'userType': 'admin',
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Store the token and user data using auth service
        final token = data['data']['token'];
        final user = data['data']['user'] ?? {};

        // Store authentication data
        await AuthService().setAuth(token: token, user: user);

        print('Admin logged in successfully with token: $token');

        // Navigate to admin dashboard
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        _showErrorSnackBar(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showErrorSnackBar('Network error. Please check your connection.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Demo login for testing purposes
  Future<void> _demoLogin() async {
    setState(() => _isLoading = true);

    try {
      // First ensure admin user exists
      await http.post(
        Uri.parse('https://telemed18.onrender.com/api/auth/reset-admin'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // Login with real admin credentials: admin@telemed.com / password
      final response = await http.post(
        Uri.parse('https://telemed18.onrender.com/api/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'loginId': 'admin@telemed.com',
          'password': 'password',
          'userType': 'admin',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data']?['token'] != null) {
          // Store real authentication data
          await AuthService().setAuth(
            token: data['data']['token'],
            user: data['data']['user'],
          );

          // Navigate to dashboard
          Navigator.of(context).pushReplacementNamed('/dashboard');
        } else {
          _showErrorSnackBar('Demo login failed: ${data['message']}');
        }
      } else {
        _showErrorSnackBar(
            'Demo login failed with status: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Demo login failed: Network error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
        builder: (context, themeProvider, child) {
      return Scaffold(
        backgroundColor: themeProvider.primaryBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: themeProvider.cardBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.shadowColor,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Theme toggle at top right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => themeProvider.toggleTheme(),
                          icon: Icon(
                            themeProvider.isDarkMode
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: themeProvider.primaryTextColor,
                          ),
                          tooltip: themeProvider.isDarkMode
                              ? 'Switch to Light Mode'
                              : 'Switch to Dark Mode',
                        ),
                      ],
                    ),
                    // Logo and Title
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: themeProvider.accentColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Hospital+ Admin',
                      style: TextStyle(
                        color: themeProvider.primaryTextColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to your admin account',
                      style: TextStyle(
                        color: themeProvider.secondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: themeProvider.primaryTextColor),
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        labelStyle:
                            TextStyle(color: themeProvider.secondaryTextColor),
                        hintText: 'Enter your email',
                        hintStyle:
                            TextStyle(color: themeProvider.secondaryTextColor),
                        prefixIcon: Icon(Icons.email,
                            color: themeProvider.secondaryTextColor),
                        filled: true,
                        fillColor: themeProvider.isDarkMode
                            ? const Color(0xFF1A1D29)
                            : Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: themeProvider.accentColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: themeProvider.errorColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: TextStyle(color: themeProvider.primaryTextColor),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: themeProvider.secondaryTextColor),
                        hintText: 'Enter your password',
                        hintStyle:
                            TextStyle(color: themeProvider.secondaryTextColor),
                        prefixIcon: Icon(Icons.lock,
                            color: themeProvider.secondaryTextColor),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: themeProvider.secondaryTextColor,
                          ),
                        ),
                        filled: true,
                        fillColor: themeProvider.isDarkMode
                            ? const Color(0xFF1A1D29)
                            : Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: themeProvider.accentColor),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: themeProvider.errorColor),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider.accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Demo Login Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _demoLogin,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: themeProvider.accentColor),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Demo Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: themeProvider.accentColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Demo credentials info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkMode
                            ? themeProvider.infoColor.withOpacity(0.2)
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: themeProvider.isDarkMode
                              ? themeProvider.infoColor.withOpacity(0.5)
                              : Colors.blue[200]!,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outlined,
                                color: themeProvider.infoColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Demo Credentials',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: themeProvider.infoColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Click "Demo Login" to automatically sign in\nwith admin@telemed.com / password',
                            style: TextStyle(
                              fontSize: 12,
                              color: themeProvider.infoColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

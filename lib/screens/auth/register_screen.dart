import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/phone_auth_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../providers/language_provider.dart';
import '../../generated/l10n/app_localizations.dart';
import 'phone_login_with_password_screen.dart';
import '../health_profile_setup_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String? _phoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Widget _buildLanguageButton(
    LanguageProvider languageProvider,
    String languageCode,
    String languageText, {
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        languageProvider.changeLanguage(languageCode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          languageText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    // Clear any previous phone error
    setState(() {
      _phoneError = null;
      _isLoading = true;
    });

    // Log registration attempt
    print('📱 Registration attempt started');
    print('Full Name: ${_fullNameController.text.trim()}');
    print('Phone Number: ${_phoneController.text.trim()}');
    print('Password Length: ${_passwordController.text.length} characters');
    print(
      'Confirm Password Length: ${_confirmPasswordController.text.length} characters',
    );
    print(
      'Passwords Match: ${_passwordController.text == _confirmPasswordController.text}',
    );

    try {
      // Use the PhoneAuthService method for registration
      print('📤 Sending registration request to backend...');
      final startTime = DateTime.now();
      print(
        '🕒 Registration request started at: ${startTime.toIso8601String()}',
      );

      final response = await PhoneAuthService.registerWithPhone(
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        otp: '', // Empty OTP since we're not using it
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('📥 Received response from backend');
      print('⏱️ Registration request duration: ${duration.inMilliseconds}ms');

      if (response != null && response['id'] != null && mounted) {
        print('✅ Registration successful for user: ${response['id']}');
        print('👤 User Name: ${response['full_name']}');
        print('📱 User Phone: ${response['phone_number']}');
        print('🎭 User Role: ${response['role']}');
        print('🕒 Registration completed at: ${endTime.toIso8601String()}');

        setState(() {
          _isLoading = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account created successfully! Welcome ${_fullNameController.text}!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Successfully registered, navigate to health profile setup screen
        print('➡️ Navigating to health profile setup screen...');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HealthProfileSetupScreen(),
          ),
        );
      } else if (mounted) {
        print('❌ Registration failed - no response or missing user ID');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.registrationFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Registration error caught in UI layer: $e');
      print('📍 Stack trace: ${StackTrace.current}');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        String errorMessage = 'Registration failed: $e';

        // Check for duplicate phone number error
        if (e.toString().contains('already exists') ||
            e.toString().contains('duplicate') ||
            e.toString().contains('phone number')) {
          print('⚠️ Duplicate phone number detected');
          setState(() {
            _phoneError =
                'This phone number is already registered. Please use a different number or sign in.';
          });
          errorMessage = 'Phone number already registered';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.createAccount,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLanguageButton(
                      languageProvider,
                      'en',
                      'English',
                      isSelected: languageProvider.currentLanguageCode == 'en',
                    ),
                    _buildLanguageButton(
                      languageProvider,
                      'hi',
                      'हिंदी',
                      isSelected: languageProvider.currentLanguageCode == 'hi',
                    ),
                    _buildLanguageButton(
                      languageProvider,
                      'pa',
                      'ਪੰਜਾਬੀ',
                      isSelected: languageProvider.currentLanguageCode == 'pa',
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header with icon
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.person_add,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Join Our Platform',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your account with phone number',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Full name field
                CustomTextField(
                  controller: _fullNameController,
                  labelText: AppLocalizations.of(context)!.fullName,
                  hintText: AppLocalizations.of(context)!.enterFullName,
                  prefixIcon: Icons.person,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.fieldRequired;
                    }
                    if (value.trim().length < 2) {
                      return 'Please enter a valid name (at least 2 characters)';
                    }
                    // Check for at least one letter (avoid numbers-only names)
                    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
                      return 'Name must contain at least one letter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Phone number field with error handling
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _phoneController,
                      labelText: AppLocalizations.of(context)!.phoneNumber,
                      hintText: AppLocalizations.of(
                        context,
                      )!.enterTenDigitPhone,
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid 10-digit phone number';
                        }
                        // Basic Indian mobile number validation
                        if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
                          return 'Please enter a valid Indian mobile number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // Clear phone error when user starts typing
                        if (_phoneError != null) {
                          setState(() {
                            _phoneError = null;
                          });
                        }
                      },
                    ),
                    // Show phone-specific error if exists
                    if (_phoneError != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade600,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _phoneError!,
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 20),

                // Password field
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password (min 6 characters)',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirm password field
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: !_confirmPasswordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Terms and conditions info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'By creating an account, you agree to our Terms of Service and Privacy Policy',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Register button
                CustomButton(
                  text: l10n.createAccount,
                  onPressed: _register,
                  isLoading: _isLoading,
                  icon: Icons.person_add,
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),

                const SizedBox(height: 24),

                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PhoneLoginWithPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

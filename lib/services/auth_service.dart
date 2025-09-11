import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../utils/network_logger.dart';

/// Authentication service for the telemedicine backend
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  UserModel? _currentUser;
  String? _authToken;

  // Getters
  UserModel? get currentUser => _currentUser;
  String? get authToken => _authToken;
  bool get isAuthenticated => _currentUser != null && _authToken != null;

  /// Initialize auth service - check for stored credentials
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userJson = prefs.getString('user_data');

      if (token != null && userJson != null) {
        _authToken = token;
        _apiService.setAuthToken(token);
        _currentUser = UserModel.fromJson(jsonDecode(userJson));

        // Verify token is still valid
        final response = await _apiService.get(ApiConfig.authProfile);
        if (!response.isSuccess) {
          await logout(); // Token expired, clear credentials
        }
      }
    } catch (e) {
      print('Error initializing auth service: $e');
      await logout(); // Clear invalid data
    }
  }

  /// Login with mobile number/email and password
  Future<AuthResult> login({
    required String loginId, // Can be mobile number or email
    required String password,
    String? userType, // 'doctor', 'patient', 'admin'
  }) async {
    try {
      final body = {
        'loginId': loginId,
        'password': password,
        if (userType != null) 'userType': userType,
      };

      // Debug logging to see what URL is being used
      print('🔐 Login attempt to: ${ApiConfig.authLogin}');
      print('📦 Login body: $body');

      NetworkLogger.logRequest(
        method: 'POST',
        url: ApiConfig.authLogin,
        body: body,
      );

      final response = await _apiService.post(ApiConfig.authLogin, body: body);

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user']);
        final token = data['token'] as String;

        await _saveAuthData(user, token);
        return AuthResult.success(user);
      } else {
        return AuthResult.error(response.error ?? 'Login failed');
      }
    } catch (e) {
      print('💥 Login error: $e');
      return AuthResult.error('Login error: ${e.toString()}');
    }
  }

  /// Simple registration with mobile number + password
  Future<AuthResult> registerWithMobile({
    required String name,
    required String phone,
    required String password,
    required int age,
    required String gender,
  }) async {
    try {
      print('📱 AuthService.registerWithMobile called');
      print('👤 Name: $name');
      print('📱 Phone: $phone');
      print('🎂 Age: $age');
      print('⚧ Gender: $gender');
      print('🔒 Password Length: ${password.length} characters');

      final body = {
        'name': name,
        'phone': phone,
        'password': password,
        'age': age,
        'gender': gender,
      };

      print(
        '📤 Sending POST request to: ${ApiConfig.baseUrl}/auth/patient/register-mobile',
      );
      print('📦 Request Body: ${body.toString()}');
      print('🔑 Auth Token Present: ${_authToken != null}');

      final startTime = DateTime.now();
      print('🕒 Request started at: ${startTime.toIso8601String()}');

      final response = await _apiService.post(
        '${ApiConfig.baseUrl}/auth/patient/register-mobile',
        body: body,
      );

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      print('📥 Response received at: ${endTime.toIso8601String()}');
      print('⏱️ Request duration: ${duration.inMilliseconds}ms');
      print('📊 Response Success: ${response.isSuccess}');
      print('💬 Response Message: ${response.message}');
      print('❌ Response Error: ${response.error}');

      if (response.isSuccess && response.data != null) {
        print('✅ API call successful, parsing user data...');
        final data = response.data as Map<String, dynamic>;
        print('📄 Response Data: ${data.toString()}');

        final user = UserModel.fromJson(data['user']);
        final token = data['token'] as String;

        print('👤 Parsed User ID: ${user.id}');
        print(
          '📧 Parsed User Email: ${user.email}',
        ); // Changed from phone to email
        print('🔑 Token Length: ${token.length} characters');

        await _saveAuthData(user, token);
        print('💾 Authentication data saved successfully');

        // Auto-fetch profile details after successful registration
        await _initializeProfileAfterSignup(user);

        return AuthResult.success(user);
      } else {
        print('❌ API call failed');
        print('💬 Error message: ${response.error}');
        return AuthResult.error(response.error ?? 'Registration failed');
      }
    } catch (e) {
      print('💥 Exception in AuthService.registerWithMobile: $e');
      print('📍 Stack trace: ${StackTrace.current}');
      return AuthResult.error('Registration error: ${e.toString()}');
    }
  }

  Future<AuthResult> registerPatient({
    required String name,
    required String email,
    required String password,
    required String phone,
    required DateTime dateOfBirth,
    required String gender,
    Map<String, dynamic>? address,
    List<Map<String, dynamic>>? emergencyContacts,
    String? preferredLanguage,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        if (address != null) 'address': address,
        if (emergencyContacts != null) 'emergencyContacts': emergencyContacts,
        if (preferredLanguage != null) 'preferredLanguage': preferredLanguage,
      };

      NetworkLogger.logRequest(
        method: 'POST',
        url: ApiConfig.authPatientRegister,
        body: body,
      );

      final response = await _apiService.post(
        ApiConfig.authPatientRegister,
        body: body,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['patient']);
        final token = data['token'] as String;

        await _saveAuthData(user, token);

        // Auto-fetch profile details after successful registration
        await _initializeProfileAfterSignup(user);

        return AuthResult.success(user);
      } else {
        return AuthResult.error(response.error ?? 'Registration failed');
      }
    } catch (e) {
      return AuthResult.error('Registration error: ${e.toString()}');
    }
  }

  /// Register as doctor
  Future<AuthResult> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String speciality,
    required String qualification,
    required int experience,
    required String licenseNumber,
    required double consultationFee,
    Map<String, dynamic>? address,
    List<String>? languages,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'speciality': speciality,
        'qualification': qualification,
        'experience': experience,
        'licenseNumber': licenseNumber,
        'consultationFee': consultationFee,
        if (address != null) 'address': address,
        if (languages != null) 'languages': languages,
      };

      NetworkLogger.logRequest(
        method: 'POST',
        url: ApiConfig.authDoctorRegister,
        body: body,
      );

      final response = await _apiService.post(
        ApiConfig.authDoctorRegister,
        body: body,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['doctor']);
        final token = data['token'] as String;

        await _saveAuthData(user, token);
        return AuthResult.success(user);
      } else {
        return AuthResult.error(response.error ?? 'Doctor registration failed');
      }
    } catch (e) {
      return AuthResult.error('Doctor registration error: ${e.toString()}');
    }
  }

  /// Change password
  Future<AuthResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final body = {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      };

      NetworkLogger.logRequest(
        method: 'PUT',
        url: ApiConfig.authChangePassword,
        body: body,
      );

      final response = await _apiService.put(
        ApiConfig.authChangePassword,
        body: body,
      );

      if (response.isSuccess) {
        return AuthResult.success(_currentUser!);
      } else {
        return AuthResult.error(response.error ?? 'Password change failed');
      }
    } catch (e) {
      return AuthResult.error('Password change error: ${e.toString()}');
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  /// Get current user profile
  Future<AuthResult> getUserProfile() async {
    try {
      NetworkLogger.logRequest(method: 'GET', url: ApiConfig.authProfile);

      final response = await _apiService.get(ApiConfig.authProfile);

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user']);

        _currentUser = user;
        await _saveUserData(user);

        return AuthResult.success(user);
      } else {
        return AuthResult.error(response.error ?? 'Failed to get profile');
      }
    } catch (e) {
      return AuthResult.error('Profile error: ${e.toString()}');
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Call logout API if we have a token
      if (_authToken != null) {
        NetworkLogger.logRequest(method: 'POST', url: ApiConfig.authLogout);

        await _apiService.post(ApiConfig.authLogout);
      }
    } catch (e) {
      print('Logout API error: $e');
    } finally {
      // Clear local data regardless of API result
      await _clearAuthData();
    }
  }

  /// Save authentication data locally
  Future<void> _saveAuthData(UserModel user, String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_data', jsonEncode(user.toJson()));

      _currentUser = user;
      _authToken = token;
      _apiService.setAuthToken(token);
      notifyListeners(); // Notify UI about authentication state change
    } catch (e) {
      print('Error saving auth data: $e');
    }
  }

  /// Save user data locally
  Future<void> _saveUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(user.toJson()));
      _currentUser = user;
      notifyListeners(); // Notify UI about user data change
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  /// Clear authentication data
  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');

      _currentUser = null;
      _authToken = null;
      _apiService.clearAuthToken();
      notifyListeners(); // Notify UI about logout
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  /// Initialize profile after successful signup
  Future<void> _initializeProfileAfterSignup(UserModel user) async {
    try {
      print('🔄 Initializing profile after signup for user: ${user.id}');

      // Create basic profile from user data
      final profileData = {
        'fullName': user.name,
        'email': user.email,
        'phoneNumber': '', // Will be updated when user provides phone
        'dateOfBirth': DateTime.now()
            .subtract(const Duration(days: 365 * 25))
            .toIso8601String(),
        'gender': user.gender ?? 'Not specified',
        'bloodGroup': user.bloodGroup ?? '',
        'address': '',
        'emergencyContact': '',
        'emergencyContactPhone': '',
        'profilePhotoUrl': '',
        'allergies': [],
        'medications': [],
        'medicalHistory': {},
        'familyMembers': [],
      };

      // Try to create profile in backend
      try {
        final response = await _apiService.post(
          '${ApiConfig.baseUrl}/patients/profile',
          body: profileData,
        );

        if (response.isSuccess) {
          print('✅ Profile initialized successfully in backend');
        } else {
          print(
            '⚠️ Failed to initialize profile in backend: ${response.error}',
          );
        }
      } catch (e) {
        print('⚠️ Error initializing profile in backend: $e');
      }

      print('✅ Profile initialization completed');
    } catch (e) {
      print('💥 Error in profile initialization: $e');
    }
  }
}

/// Authentication result wrapper
class AuthResult {
  final bool success;
  final UserModel? user;
  final String? error;

  AuthResult._({required this.success, this.user, this.error});

  factory AuthResult.success(UserModel user) {
    return AuthResult._(success: true, user: user);
  }

  factory AuthResult.error(String error) {
    return AuthResult._(success: false, error: error);
  }

  bool get isSuccess => success;
  bool get isError => !success;
}

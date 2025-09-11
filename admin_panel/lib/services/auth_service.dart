import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'admin_token';
  static const String _userKey = 'admin_user';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;
  Map<String, dynamic>? _user;

  // Getters
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;

  // Initialize auth service - load token from storage
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_tokenKey);
      final userString = prefs.getString(_userKey);
      if (userString != null) {
        _user = Map<String, dynamic>.from(json.decode(userString));
      }
    } catch (e) {
      print('Error initializing auth service: $e');
    }
  }

  // Store authentication data
  Future<void> setAuth({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    try {
      _token = token;
      _user = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setString(_userKey, json.encode(user));
    } catch (e) {
      print('Error storing auth data: $e');
    }
  }

  // Get authorization headers
  Map<String, String> get authHeaders {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Clear authentication data (logout)
  Future<void> clearAuth() async {
    try {
      _token = null;
      _user = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }
}

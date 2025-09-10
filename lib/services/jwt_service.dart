import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/user_roles.dart';

/// JWT Service for token management in the TeleMed application
/// Integrates with Supabase authentication and provides role-based token handling
class JWTService {
  static final JWTService _instance = JWTService._internal();
  factory JWTService() => _instance;
  JWTService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // In-memory token storage for quick access
  String? _accessToken;
  String? _refreshToken;
  UserRole? _userRole;
  List<Permission>? _userPermissions;
  DateTime? _tokenExpiry;

  /// Initialize JWT service and load stored tokens
  Future<void> initialize() async {
    await _loadStoredTokens();
  }

  /// Generate a custom JWT token with role and permissions
  Future<Map<String, String>?> generateTokens({
    required String userId,
    required String email,
    required UserRole role,
    List<Permission>? additionalPermissions,
  }) async {
    try {
      final now = DateTime.now();
      final accessExpiry = now.add(AuthConstants.accessTokenExpiry);
      final refreshExpiry = now.add(AuthConstants.refreshTokenExpiry);

      // Get role-based permissions
      final rolePermissions = RolePermissions.getPermissionsForRole(role);
      final allPermissions = [
        ...rolePermissions,
        if (additionalPermissions != null) ...additionalPermissions,
      ];

      // Create access token payload
      final accessPayload = {
        AuthConstants.userIdClaim: userId,
        AuthConstants.emailClaim: email,
        AuthConstants.roleClaim: role.value,
        AuthConstants.permissionsClaim: allPermissions
            .map((p) => p.value)
            .toList(),
        AuthConstants.tokenTypeClaim: AuthConstants.accessTokenType,
        AuthConstants.issuedAtClaim: now.millisecondsSinceEpoch ~/ 1000,
        AuthConstants.expiresAtClaim:
            accessExpiry.millisecondsSinceEpoch ~/ 1000,
      };

      // Create refresh token payload
      final refreshPayload = {
        AuthConstants.userIdClaim: userId,
        AuthConstants.emailClaim: email,
        AuthConstants.roleClaim: role.value,
        AuthConstants.tokenTypeClaim: AuthConstants.refreshTokenType,
        AuthConstants.issuedAtClaim: now.millisecondsSinceEpoch ~/ 1000,
        AuthConstants.expiresAtClaim:
            refreshExpiry.millisecondsSinceEpoch ~/ 1000,
      };

      // Generate tokens
      final accessToken = _createToken(accessPayload);
      final refreshToken = _createToken(refreshPayload);

      // Store tokens in database for tracking
      await _storeTokenInDatabase(
        userId,
        accessToken,
        AuthConstants.accessTokenType,
        accessExpiry,
      );
      await _storeTokenInDatabase(
        userId,
        refreshToken,
        AuthConstants.refreshTokenType,
        refreshExpiry,
      );

      // Store in memory and local storage
      await _storeTokensLocally(
        accessToken,
        refreshToken,
        role,
        allPermissions,
      );

      return {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'token_type': 'Bearer',
        'expires_in': AuthConstants.accessTokenExpiry.inSeconds.toString(),
      };
    } catch (e) {
      print('Error generating tokens: $e');
      return null;
    }
  }

  /// Validate and decode a JWT token
  Map<String, dynamic>? validateToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode payload
      final payload = _decodeBase64Url(parts[1]);
      final claims = json.decode(payload) as Map<String, dynamic>;

      // Check expiration
      final exp = claims[AuthConstants.expiresAtClaim] as int?;
      if (exp != null) {
        final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        if (DateTime.now().isAfter(expiry)) {
          return null; // Token expired
        }
      }

      // Verify signature (simplified - in production use proper JWT library)
      final header = json.decode(_decodeBase64Url(parts[0]));
      final signature = _generateSignature('${parts[0]}.${parts[1]}');
      if (signature != parts[2]) {
        return null; // Invalid signature
      }

      return claims;
    } catch (e) {
      print('Error validating token: $e');
      return null;
    }
  }

  /// Refresh access token using refresh token
  Future<Map<String, String>?> refreshAccessToken() async {
    if (_refreshToken == null) return null;

    try {
      final claims = validateToken(_refreshToken!);
      if (claims == null) {
        await clearTokens();
        return null;
      }

      final userId = claims[AuthConstants.userIdClaim] as String;
      final email = claims[AuthConstants.emailClaim] as String;
      final roleString = claims[AuthConstants.roleClaim] as String;
      final role = UserRole.fromString(roleString);

      // Check if refresh token is blacklisted
      final isBlacklisted = await _isTokenBlacklisted(_refreshToken!);
      if (isBlacklisted) {
        await clearTokens();
        return null;
      }

      // Generate new access token
      return await generateTokens(userId: userId, email: email, role: role);
    } catch (e) {
      print('Error refreshing token: $e');
      await clearTokens();
      return null;
    }
  }

  /// Check if user has specific permission
  bool hasPermission(Permission permission) {
    if (_userPermissions == null) return false;
    return _userPermissions!.contains(permission);
  }

  /// Check if user has any of the specified permissions
  bool hasAnyPermission(List<Permission> permissions) {
    if (_userPermissions == null) return false;
    return permissions.any(
      (permission) => _userPermissions!.contains(permission),
    );
  }

  /// Check if user has all of the specified permissions
  bool hasAllPermissions(List<Permission> permissions) {
    if (_userPermissions == null) return false;
    return permissions.every(
      (permission) => _userPermissions!.contains(permission),
    );
  }

  /// Check if user has specific role
  bool hasRole(UserRole role) {
    return _userRole == role;
  }

  /// Check if user has any of the specified roles
  bool hasAnyRole(List<UserRole> roles) {
    return _userRole != null && roles.contains(_userRole);
  }

  /// Get current user role
  UserRole? getCurrentRole() => _userRole;

  /// Get current user permissions
  List<Permission>? getCurrentPermissions() => _userPermissions;

  /// Get current access token
  String? getAccessToken() => _accessToken;

  /// Get current refresh token
  String? getRefreshToken() => _refreshToken;

  /// Check if tokens are valid and not expired
  bool isAuthenticated() {
    if (_accessToken == null || _tokenExpiry == null) return false;
    return DateTime.now().isBefore(_tokenExpiry!);
  }

  /// Blacklist current tokens and clear local storage
  Future<void> logout() async {
    if (_accessToken != null) {
      await _blacklistToken(_accessToken!);
    }
    if (_refreshToken != null) {
      await _blacklistToken(_refreshToken!);
    }
    await clearTokens();
  }

  /// Clear all stored tokens
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _userRole = null;
    _userPermissions = null;
    _tokenExpiry = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthConstants.accessTokenKey);
    await prefs.remove(AuthConstants.refreshTokenKey);
    await prefs.remove(AuthConstants.userRoleKey);
    await prefs.remove(AuthConstants.userPermissionsKey);
  }

  /// Update user permissions (admin function)
  Future<bool> updateUserPermissions(
    String userId,
    List<Permission> permissions,
  ) async {
    try {
      // Check if current user has admin privileges
      if (!hasPermission(Permission.manageUsers)) {
        throw Exception(AuthConstants.insufficientPermissionsError);
      }

      // Update permissions in database
      await _supabase.from('user_permissions').delete().eq('user_id', userId);

      for (final permission in permissions) {
        await _supabase.from('user_permissions').insert({
          'user_id': userId,
          'permission': permission.value,
          'granted_by': _supabase.auth.currentUser?.id,
          'granted_at': DateTime.now().toIso8601String(),
          'is_active': true,
        });
      }

      return true;
    } catch (e) {
      print('Error updating user permissions: $e');
      return false;
    }
  }

  /// Get user's role and permissions from database
  Future<Map<String, dynamic>?> getUserRoleAndPermissions(String userId) async {
    try {
      // Get user roles
      final rolesResponse = await _supabase
          .from('user_roles')
          .select()
          .eq('user_id', userId)
          .eq('is_verified', true);

      // Get explicit permissions
      final permissionsResponse = await _supabase
          .from('user_permissions')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true);

      if (rolesResponse.isEmpty) return null;

      // Get highest privilege role
      final roles = rolesResponse
          .map((r) => UserRole.fromString(r['role']))
          .toList();
      roles.sort(
        (a, b) => RoleHierarchy.getHierarchyLevel(
          b,
        ).compareTo(RoleHierarchy.getHierarchyLevel(a)),
      );
      final primaryRole = roles.first;

      // Combine role-based and explicit permissions
      final rolePermissions = RolePermissions.getPermissionsForRole(
        primaryRole,
      );
      final explicitPermissions = permissionsResponse
          .map((p) => Permission.fromString(p['permission']))
          .where((p) => p != null)
          .cast<Permission>()
          .toList();

      final allPermissions = [...rolePermissions, ...explicitPermissions];

      return {
        'role': primaryRole,
        'permissions': allPermissions,
        'is_verified': rolesResponse.first['is_verified'],
      };
    } catch (e) {
      print('Error getting user role and permissions: $e');
      return null;
    }
  }

  // Private helper methods

  /// Create a JWT token with payload
  String _createToken(Map<String, dynamic> payload) {
    final header = {'alg': 'HS256', 'typ': 'JWT'};

    final encodedHeader = _encodeBase64Url(json.encode(header));
    final encodedPayload = _encodeBase64Url(json.encode(payload));
    final signature = _generateSignature('$encodedHeader.$encodedPayload');

    return '$encodedHeader.$encodedPayload.$signature';
  }

  /// Generate HMAC signature for JWT
  String _generateSignature(String data) {
    final key = utf8.encode(AuthConstants.jwtSecretKey);
    final bytes = utf8.encode(data);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return _encodeBase64Url(digest.bytes);
  }

  /// Base64 URL encode
  String _encodeBase64Url(dynamic data) {
    String encoded;
    if (data is String) {
      encoded = base64Url.encode(utf8.encode(data));
    } else if (data is List<int>) {
      encoded = base64Url.encode(data);
    } else {
      throw ArgumentError('Invalid data type for encoding');
    }
    return encoded.replaceAll('=', '');
  }

  /// Base64 URL decode
  String _decodeBase64Url(String encoded) {
    String padded = encoded;
    while (padded.length % 4 != 0) {
      padded += '=';
    }
    return utf8.decode(base64Url.decode(padded));
  }

  /// Store token in database for tracking
  Future<void> _storeTokenInDatabase(
    String userId,
    String token,
    String tokenType,
    DateTime expiry,
  ) async {
    try {
      final tokenHash = sha256.convert(utf8.encode(token)).toString();

      await _supabase.from('jwt_tokens').insert({
        'user_id': userId,
        'token_type': tokenType,
        'token_hash': tokenHash,
        'expires_at': expiry.toIso8601String(),
        'is_blacklisted': false,
      });
    } catch (e) {
      print('Error storing token in database: $e');
    }
  }

  /// Store tokens locally
  Future<void> _storeTokensLocally(
    String accessToken,
    String refreshToken,
    UserRole role,
    List<Permission> permissions,
  ) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _userRole = role;
    _userPermissions = permissions;

    final claims = validateToken(accessToken);
    if (claims != null) {
      final exp = claims[AuthConstants.expiresAtClaim] as int?;
      if (exp != null) {
        _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthConstants.accessTokenKey, accessToken);
    await prefs.setString(AuthConstants.refreshTokenKey, refreshToken);
    await prefs.setString(AuthConstants.userRoleKey, role.value);
    await prefs.setStringList(
      AuthConstants.userPermissionsKey,
      permissions.map((p) => p.value).toList(),
    );
  }

  /// Load stored tokens from local storage
  Future<void> _loadStoredTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _accessToken = prefs.getString(AuthConstants.accessTokenKey);
      _refreshToken = prefs.getString(AuthConstants.refreshTokenKey);

      final roleString = prefs.getString(AuthConstants.userRoleKey);
      if (roleString != null) {
        _userRole = UserRole.fromString(roleString);
      }

      final permissionStrings = prefs.getStringList(
        AuthConstants.userPermissionsKey,
      );
      if (permissionStrings != null) {
        _userPermissions = permissionStrings
            .map((p) => Permission.fromString(p))
            .where((p) => p != null)
            .cast<Permission>()
            .toList();
      }

      // Validate tokens and set expiry
      if (_accessToken != null) {
        final claims = validateToken(_accessToken!);
        if (claims != null) {
          final exp = claims[AuthConstants.expiresAtClaim] as int?;
          if (exp != null) {
            _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
          }
        } else {
          // Invalid token, clear everything
          await clearTokens();
        }
      }
    } catch (e) {
      print('Error loading stored tokens: $e');
      await clearTokens();
    }
  }

  /// Check if token is blacklisted
  Future<bool> _isTokenBlacklisted(String token) async {
    try {
      final tokenHash = sha256.convert(utf8.encode(token)).toString();

      final response = await _supabase
          .from('jwt_tokens')
          .select('is_blacklisted')
          .eq('token_hash', tokenHash)
          .maybeSingle();

      return response?['is_blacklisted'] ?? false;
    } catch (e) {
      print('Error checking token blacklist: $e');
      return true; // Assume blacklisted on error for security
    }
  }

  /// Blacklist a token
  Future<void> _blacklistToken(String token) async {
    try {
      final tokenHash = sha256.convert(utf8.encode(token)).toString();

      await _supabase
          .from('jwt_tokens')
          .update({
            'is_blacklisted': true,
            'blacklisted_at': DateTime.now().toIso8601String(),
            'blacklisted_reason': 'User logout',
          })
          .eq('token_hash', tokenHash);
    } catch (e) {
      print('Error blacklisting token: $e');
    }
  }

  /// Clean up expired tokens from database (should be called periodically)
  Future<void> cleanupExpiredTokens() async {
    try {
      await _supabase
          .from('jwt_tokens')
          .delete()
          .lt('expires_at', DateTime.now().toIso8601String());
    } catch (e) {
      print('Error cleaning up expired tokens: $e');
    }
  }
}

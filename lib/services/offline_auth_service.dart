import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telemed/database/offline_database.dart';
import 'package:telemed/core/service_locator.dart';
import '../services/sync_service.dart';

class OfflineAuthService {
  static const String _userDataKey = 'offline_user_data';
  static const String _isLoggedInKey = 'is_logged_in_offline';
  static const String _loginCredentialsKey = 'login_credentials';
  static const String _lastLoginTimeKey = 'last_login_time';

  // Store user profile data for offline access
  static Future<void> storeUserProfile(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Get database from service locator with fallback
      late final OfflineDatabase database;
      try {
        database = await serviceLocator.getAsync<OfflineDatabase>();
      } catch (e) {
        // Fallback to direct instantiation if service locator fails
        database = OfflineDatabase();
      }

      // Store in SharedPreferences for quick access
      await prefs.setString(_userDataKey, jsonEncode(userData));

      // Store in SQLite database for medical records integration
      await database.storeUserProfile(userData);

      print('✅ User profile stored offline');
    } catch (e) {
      print('❌ Error storing user profile: $e');
    }
  }

  // Store user login credentials for offline access
  static Future<void> storeLoginCredentials({
    required String email,
    required String userId,
    required String fullName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final credentials = {
        'email': email,
        'userId': userId,
        'fullName': fullName,
        'loginTime': DateTime.now().toIso8601String(),
      };

      await prefs.setString(_loginCredentialsKey, jsonEncode(credentials));
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(
        _lastLoginTimeKey,
        DateTime.now().toIso8601String(),
      );

      print('✅ Login credentials stored offline');
    } catch (e) {
      print('❌ Error storing login credentials: $e');
    }
  }

  // Get stored login credentials
  static Future<Map<String, dynamic>?> getStoredCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final credentialsJson = prefs.getString(_loginCredentialsKey);

      if (credentialsJson != null) {
        final credentials = jsonDecode(credentialsJson) as Map<String, dynamic>;
        return credentials;
      }
      return null;
    } catch (e) {
      print('❌ Error getting stored credentials: $e');
      return null;
    }
  }

  // Get stored user profile data
  static Future<Map<String, dynamic>?> getStoredUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataJson = prefs.getString(_userDataKey);

      if (userDataJson != null) {
        final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
        return userData;
      }
      return null;
    } catch (e) {
      print('❌ Error getting stored user profile: $e');
      return null;
    }
  }

  // Check if user is logged in offline
  static Future<bool> isLoggedInOffline() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('❌ Error checking offline login status: $e');
      return false;
    }
  }

  // Get last login time
  static Future<DateTime?> getLastLoginTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastLoginStr = prefs.getString(_lastLoginTimeKey);

      if (lastLoginStr != null) {
        return DateTime.parse(lastLoginStr);
      }
      return null;
    } catch (e) {
      print('❌ Error getting last login time: $e');
      return null;
    }
  }

  // Clear offline login data (for logout)
  static Future<void> clearOfflineLoginData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_userDataKey);
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_loginCredentialsKey);
      await prefs.remove(_lastLoginTimeKey);

      print('✅ Offline login data cleared');
    } catch (e) {
      print('❌ Error clearing offline login data: $e');
    }
  }

  // Auto-login with stored credentials (offline mode)
  static Future<Map<String, dynamic>?> autoLoginOffline() async {
    try {
      final isLoggedIn = await isLoggedInOffline();
      if (!isLoggedIn) return null;

      final credentials = await getStoredCredentials();
      final userProfile = await getStoredUserProfile();

      if (credentials != null && userProfile != null) {
        // Check if login is still valid (within 30 days)
        final lastLogin = await getLastLoginTime();
        if (lastLogin != null) {
          final daysSinceLogin = DateTime.now().difference(lastLogin).inDays;
          if (daysSinceLogin > 30) {
            // Login expired, clear data
            await clearOfflineLoginData();
            return null;
          }
        }

        print('✅ Auto-login successful (offline mode)');
        return userProfile;
      }

      return null;
    } catch (e) {
      print('❌ Error during auto-login: $e');
      return null;
    }
  }

  // Update stored profile with new data
  static Future<void> updateStoredProfile(Map<String, dynamic> updates) async {
    try {
      final currentProfile = await getStoredUserProfile();
      if (currentProfile != null) {
        // Merge updates with existing data
        final updatedProfile = {...currentProfile, ...updates};
        await storeUserProfile(updatedProfile);
        print('✅ Profile updated offline');
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
    }
  }

  // Sync offline data with online when connection is restored
  static Future<void> syncWithOnline() async {
    try {
      // This method would be called when internet connection is restored
      // to sync any offline changes with the online database
      print('🔄 Syncing offline data with online...');

      // Get the sync service to handle the heavy lifting
      late final SyncService syncService;
      try {
        syncService = await serviceLocator.getAsync<SyncService>();
      } catch (e) {
        // Fallback to direct instantiation if service locator fails
        syncService = SyncService();
      }

      // 1. Get current user credentials
      final credentials = await getStoredCredentials();
      final userProfile = await getStoredUserProfile();

      if (credentials == null || userProfile == null) {
        print('⚠️ No offline data to sync');
        return;
      }

      // 2. Trigger full sync through the sync service
      await syncService.syncNow();

      // 3. Update last sync time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'last_offline_sync',
        DateTime.now().toIso8601String(),
      );

      print('✅ Offline data synced with MongoDB backend successfully');
    } catch (e) {
      print('❌ Error syncing with online: $e');
    }
  }
}

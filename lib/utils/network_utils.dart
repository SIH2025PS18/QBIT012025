import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkUtils {
  /// Test basic internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      // Test multiple DNS servers for better reliability
      final results = await Future.wait([
        _testConnection('8.8.8.8', 53), // Google DNS
        _testConnection('1.1.1.1', 53), // Cloudflare DNS
        _testConnection('208.67.222.222', 53), // OpenDNS
      ]);

      // Return true if any connection succeeds
      return results.any((connected) => connected);
    } catch (e) {
      debugPrint('🔍 Internet connectivity test failed: $e');
      return false;
    }
  }

  /// Test connection to a specific host and port
  static Future<bool> _testConnection(String host, int port) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
      );
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Test Supabase hostname specifically
  static Future<bool> canReachSupabase(String supabaseUrl) async {
    try {
      // Extract hostname from URL
      final uri = Uri.parse(supabaseUrl);
      final hostname = uri.host;

      debugPrint('🔍 Testing connectivity to Supabase: $hostname');

      // Test HTTPS port (443)
      final socket = await Socket.connect(
        hostname,
        443,
        timeout: const Duration(seconds: 10),
      );
      socket.destroy();

      debugPrint('✅ Successfully connected to Supabase hostname');
      return true;
    } catch (e) {
      debugPrint('❌ Cannot reach Supabase hostname: $e');
      return false;
    }
  }

  /// Get detailed network diagnostics
  static Future<Map<String, dynamic>> getNetworkDiagnostics(
    String supabaseUrl,
  ) async {
    final diagnostics = <String, dynamic>{};

    try {
      // Test basic internet
      final hasInternet = await hasInternetConnection();
      diagnostics['hasInternet'] = hasInternet;

      // Test Supabase connectivity
      final canReachSupabase = await NetworkUtils.canReachSupabase(supabaseUrl);
      diagnostics['canReachSupabase'] = canReachSupabase;

      // Get platform info
      diagnostics['platform'] = Platform.operatingSystem;
      diagnostics['timestamp'] = DateTime.now().toIso8601String();

      return diagnostics;
    } catch (e) {
      diagnostics['error'] = e.toString();
      return diagnostics;
    }
  }

  /// Get user-friendly network error message
  static String getNetworkErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('failed host lookup')) {
      return '🌐 Cannot connect to server. Please check your internet connection and try again.';
    } else if (errorString.contains('socketexception')) {
      return '🌐 Network error. Please check your internet connection.';
    } else if (errorString.contains('timeout')) {
      return '⏱️ Connection timeout. Please try again.';
    } else if (errorString.contains('certificate') ||
        errorString.contains('ssl')) {
      return '🔒 Security certificate error. Please check your device date/time settings.';
    } else if (errorString.contains('clientexception')) {
      return '🌐 Connection failed. Please check your internet connection.';
    } else {
      return 'Connection error: Please try again.';
    }
  }

  /// Network troubleshooting tips
  static List<String> getTroubleshootingTips() {
    return [
      '1. Check your internet connection',
      '2. Try switching between WiFi and mobile data',
      '3. Restart your device',
      '4. Check if your firewall/antivirus is blocking the connection',
      '5. If using emulator, check network settings',
      '6. Verify your device date and time are correct',
      '7. Try connecting from a different network',
    ];
  }
}

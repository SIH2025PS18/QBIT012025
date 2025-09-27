import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminThemeProvider extends ChangeNotifier {
  bool _isDarkMode =
      false; // Start with light mode as current default for admin
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  // Light theme for admin panel
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFFF6B9D),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B9D),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.black87,
          iconColor: Colors.black54,
        ),
        textTheme: const TextTheme(
          displayLarge:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          displayMedium:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          displaySmall:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          headlineLarge:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          headlineMedium:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          headlineSmall:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          titleLarge:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          titleMedium:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
          titleSmall:
              TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          bodySmall: TextStyle(color: Colors.black54),
          labelLarge: TextStyle(color: Colors.black87),
          labelMedium: TextStyle(color: Colors.black87),
          labelSmall: TextStyle(color: Colors.black54),
        ),
      );

  // Dark theme for admin panel (current style)
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFF6B9D),
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6B9D),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1D29),
          foregroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1A1D29),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF1A1D29),
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.white70,
        ),
        textTheme: const TextTheme(
          displayLarge:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          displayMedium:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          displaySmall:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headlineLarge:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          headlineMedium:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          headlineSmall:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          titleLarge:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          titleMedium:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          titleSmall:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white70),
        ),
      );

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  Future<void> initializeTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode =
        _prefs.getBool('admin_isDarkMode') ?? false; // Default to light mode
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('admin_isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('admin_isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Helper methods for consistent colors across the admin panel
  Color get primaryBackgroundColor =>
      _isDarkMode ? const Color(0xFF0A0E27) : const Color(0xFFF8FAFC);
  Color get secondaryBackgroundColor =>
      _isDarkMode ? const Color(0xFF1A1D29) : Colors.white;
  Color get cardBackgroundColor =>
      _isDarkMode ? const Color(0xFF1A1D29) : Colors.white;
  Color get primaryTextColor => _isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryTextColor => _isDarkMode ? Colors.white70 : Colors.black54;
  Color get borderColor => _isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
  Color get dividerColor => _isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  Color get shadowColor =>
      _isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.2);
  Color get accentColor => const Color(0xFFFF6B9D);
  Color get successColor =>
      _isDarkMode ? const Color(0xFF10B981) : const Color(0xFF059669);
  Color get warningColor =>
      _isDarkMode ? const Color(0xFFF59E0B) : const Color(0xFFD97706);
  Color get errorColor =>
      _isDarkMode ? const Color(0xFFEF4444) : const Color(0xFFDC2626);
  Color get infoColor =>
      _isDarkMode ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);
}

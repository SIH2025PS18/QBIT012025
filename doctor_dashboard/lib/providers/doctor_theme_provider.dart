import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Start with light mode as default
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  // Light theme for doctor dashboard
  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF6366F1),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
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

  // Dark theme for doctor dashboard (current style)
  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6366F1),
        scaffoldBackgroundColor: const Color(0xFF1A1B23),
        fontFamily: 'Inter',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1B23),
          foregroundColor: Colors.white,
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2A2D3A),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF1A1B23),
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
        _prefs.getBool('doctor_isDarkMode') ?? false; // Default to light
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('doctor_isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('doctor_isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Helper methods for consistent colors across the doctor dashboard
  Color get primaryBackgroundColor =>
      _isDarkMode ? const Color(0xFF1A1B23) : const Color(0xFFF8FAFC);
  Color get secondaryBackgroundColor =>
      _isDarkMode ? const Color(0xFF2A2D3A) : Colors.white;
  Color get cardBackgroundColor =>
      _isDarkMode ? const Color(0xFF2A2D3A) : Colors.white;
  Color get primaryTextColor => _isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryTextColor => _isDarkMode ? Colors.white70 : Colors.black54;
  Color get borderColor => _isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
  Color get dividerColor => _isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
  Color get shadowColor =>
      _isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.2);
  Color get accentColor => const Color(0xFF6366F1);
}

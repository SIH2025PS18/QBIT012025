import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language provider for managing app language preferences
class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  // Default language is English
  Locale _currentLocale = const Locale('en');

  /// Available supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('hi'), // Hindi
    Locale('pa'), // Punjabi
  ];

  /// Get current locale
  Locale get currentLocale => _currentLocale;

  /// Get current language code
  String get currentLanguageCode => _currentLocale.languageCode;

  /// Get current language name
  String get currentLanguageName {
    switch (_currentLocale.languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      case 'pa':
        return 'ਪੰਜਾਬੀ';
      default:
        return 'English';
    }
  }

  /// Initialize language from shared preferences
  Future<void> initializeLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey);

      if (savedLanguageCode != null) {
        // Check if the saved language is supported
        final supportedLanguageCodes = supportedLocales
            .map((locale) => locale.languageCode)
            .toList();

        if (supportedLanguageCodes.contains(savedLanguageCode)) {
          _currentLocale = Locale(savedLanguageCode);
        } else {
          // Fall back to device language if supported, otherwise English
          _currentLocale = _getDeviceLanguageOrDefault();
        }
      } else {
        // No saved language, use device language if supported
        _currentLocale = _getDeviceLanguageOrDefault();
      }

      notifyListeners();
    } catch (e) {
      // If any error occurs, default to English
      _currentLocale = const Locale('en');
      notifyListeners();
    }
  }

  /// Get device language if supported, otherwise return English
  Locale _getDeviceLanguageOrDefault() {
    final deviceLocale = ui.window.locale;
    final supportedLanguageCodes = supportedLocales
        .map((locale) => locale.languageCode)
        .toList();

    if (supportedLanguageCodes.contains(deviceLocale.languageCode)) {
      return Locale(deviceLocale.languageCode);
    }

    return const Locale('en'); // Default to English
  }

  /// Change language and save to preferences
  Future<void> changeLanguage(String languageCode) async {
    try {
      // Validate language code
      final supportedLanguageCodes = supportedLocales
          .map((locale) => locale.languageCode)
          .toList();

      if (!supportedLanguageCodes.contains(languageCode)) {
        throw Exception('Unsupported language code: $languageCode');
      }

      _currentLocale = Locale(languageCode);

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      notifyListeners();
    } catch (e) {
      debugPrint('Error changing language: $e');
      // Revert to previous locale if error occurs
      notifyListeners();
    }
  }

  /// Change language by locale
  Future<void> changeLocale(Locale locale) async {
    await changeLanguage(locale.languageCode);
  }

  /// Get language name by language code
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      case 'pa':
        return 'ਪੰਜਾਬੀ';
      default:
        return 'English';
    }
  }

  /// Get language display name with native script
  static String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी (Hindi)';
      case 'pa':
        return 'ਪੰਜਾਬੀ (Punjabi)';
      default:
        return 'English';
    }
  }

  /// Check if a language is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLocales.any(
      (locale) => locale.languageCode == languageCode,
    );
  }

  /// Get all supported languages with their display names
  static Map<String, String> getSupportedLanguagesWithNames() {
    return {'en': 'English', 'hi': 'हिंदी', 'pa': 'ਪੰਜਾਬੀ'};
  }

  /// Reset language to device default or English
  Future<void> resetToDeviceLanguage() async {
    final deviceLanguage = _getDeviceLanguageOrDefault();
    await changeLanguage(deviceLanguage.languageCode);
  }

  /// Clear saved language preference (will use device language on next init)
  Future<void> clearLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_languageKey);

      // Reset to device language
      await resetToDeviceLanguage();
    } catch (e) {
      debugPrint('Error clearing language preference: $e');
    }
  }
}

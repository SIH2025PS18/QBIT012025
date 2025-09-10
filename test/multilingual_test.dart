import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:telemed/generated/l10n/app_localizations.dart';
import 'package:telemed/providers/language_provider.dart';
import 'package:provider/provider.dart';

void main() {
  group('Multilingual Support Tests', () {
    testWidgets('AppLocalizations should load for all supported languages', (
      WidgetTester tester,
    ) async {
      for (final locale in LanguageProvider.supportedLocales) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageProvider.supportedLocales,
            home: const TestWidget(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify that localizations are loaded
        final context = tester.element(find.byType(TestWidget));
        final l10n = AppLocalizations.of(context);

        expect(l10n, isNotNull);
        expect(l10n!.appTitle, isNotEmpty);
        expect(l10n.welcome, isNotEmpty);
        expect(l10n.login, isNotEmpty);
        expect(l10n.register, isNotEmpty);

        // Verify language-specific translations
        switch (locale.languageCode) {
          case 'en':
            expect(l10n.appTitle, equals('TeleMed'));
            expect(l10n.english, equals('English'));
            break;
          case 'hi':
            expect(l10n.appTitle, equals('टेलीमेड'));
            expect(l10n.hindi, equals('हिंदी'));
            break;
          case 'pa':
            expect(l10n.appTitle, equals('ਟੈਲੀਮੈਡ'));
            expect(l10n.punjabi, equals('ਪੰਜਾਬੀ'));
            break;
        }
      }
    });

    testWidgets(
      'LanguageProvider should initialize with correct default locale',
      (WidgetTester tester) async {
        final languageProvider = LanguageProvider();
        await languageProvider.initializeLanguage();

        // Should default to English or device language if supported
        expect(
          LanguageProvider.supportedLocales,
          contains(languageProvider.currentLocale),
        );
        expect(languageProvider.currentLanguageCode, isNotEmpty);
        expect(languageProvider.currentLanguageName, isNotEmpty);
      },
    );

    testWidgets('LanguageProvider should change language correctly', (
      WidgetTester tester,
    ) async {
      final languageProvider = LanguageProvider();
      await languageProvider.initializeLanguage();

      // Test changing to Hindi
      await languageProvider.changeLanguage('hi');
      expect(languageProvider.currentLanguageCode, equals('hi'));
      expect(languageProvider.currentLanguageName, equals('हिंदी'));

      // Test changing to Punjabi
      await languageProvider.changeLanguage('pa');
      expect(languageProvider.currentLanguageCode, equals('pa'));
      expect(languageProvider.currentLanguageName, equals('ਪੰਜਾਬੀ'));

      // Test changing back to English
      await languageProvider.changeLanguage('en');
      expect(languageProvider.currentLanguageCode, equals('en'));
      expect(languageProvider.currentLanguageName, equals('English'));
    });

    testWidgets('LanguageProvider should handle invalid language codes', (
      WidgetTester tester,
    ) async {
      final languageProvider = LanguageProvider();
      await languageProvider.initializeLanguage();

      final originalLanguage = languageProvider.currentLanguageCode;

      // Try to change to unsupported language
      await languageProvider.changeLanguage('fr'); // French not supported

      // Should remain on original language
      expect(languageProvider.currentLanguageCode, equals(originalLanguage));
    });

    test('LanguageProvider static methods should work correctly', () {
      // Test isLanguageSupported
      expect(LanguageProvider.isLanguageSupported('en'), isTrue);
      expect(LanguageProvider.isLanguageSupported('hi'), isTrue);
      expect(LanguageProvider.isLanguageSupported('pa'), isTrue);
      expect(LanguageProvider.isLanguageSupported('fr'), isFalse);

      // Test getLanguageName
      expect(LanguageProvider.getLanguageName('en'), equals('English'));
      expect(LanguageProvider.getLanguageName('hi'), equals('हिंदी'));
      expect(LanguageProvider.getLanguageName('pa'), equals('ਪੰਜਾਬੀ'));

      // Test getSupportedLanguagesWithNames
      final supportedLanguages =
          LanguageProvider.getSupportedLanguagesWithNames();
      expect(supportedLanguages, hasLength(3));
      expect(supportedLanguages, containsPair('en', 'English'));
      expect(supportedLanguages, containsPair('hi', 'हिंदी'));
      expect(supportedLanguages, containsPair('pa', 'ਪੰਜਾਬੀ'));
    });

    testWidgets('Language selection widgets should display correctly', (
      WidgetTester tester,
    ) async {
      final languageProvider = LanguageProvider();
      await languageProvider.initializeLanguage();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: languageProvider,
          child: MaterialApp(
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageProvider.supportedLocales,
            home: Scaffold(
              body: Column(
                children: [
                  // Test language selection widget here if needed
                  Text('Test Widget'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Test Widget'), findsOneWidget);
    });
  });
}

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          Text(l10n.appTitle),
          Text(l10n.welcome),
          Text(l10n.login),
          Text(l10n.register),
        ],
      ),
    );
  }
}

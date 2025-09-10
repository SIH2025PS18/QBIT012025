import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'core/service_locator.dart';
import 'services/video_consultation_service.dart';
import 'services/connectivity_service.dart';
import 'providers/language_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_wrapper.dart';
import 'screens/medical_records_screen.dart';
import 'screens/symptom_chat_screen.dart';
import 'screens/auth/phone_login_screen.dart'; // Add this import
import 'screens/auth/register_screen.dart'; // Add this import
import 'screens/auth/phone_register_screen.dart'; // Add this import
import 'screens/auth/phone_login_with_password_screen.dart'; // Add this import
import 'screens/auth/phone_forgot_password_screen.dart'; // Add this import
import 'screens/nabha_home_screen.dart'; // Add this import
import 'generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase with real configuration
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // Initialize service locator for dependency injection
  await initializeServiceLocator();

  runApp(const TelemedApp());
}

class TelemedApp extends StatelessWidget {
  const TelemedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Language provider
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) => LanguageProvider()..initializeLanguage(),
        ),

        // Connectivity service
        ChangeNotifierProvider<ConnectivityService>(
          create: (_) => ConnectivityService()..initialize(),
        ),

        // Video consultation service
        ChangeNotifierProvider<VideoConsultationService>(
          create: (context) =>
              VideoConsultationService(context.read<ConnectivityService>()),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Telemedicine Platform',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              appBarTheme: const AppBarTheme(centerTitle: true, elevation: 1),
            ),
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SplashScreen(), // Use splash screen as initial route
            // For testing phone login directly, you can use this instead:
            // home: const PhoneLoginScreen(), // Direct access to phone login for testing
            routes: {
              '/auth': (context) => const AuthWrapper(),
              '/symptom-chat': (context) => const SymptomChatScreen(),
              '/phone-login': (context) =>
                  const PhoneLoginScreen(), // Add phone login route
              '/phone-login-password': (context) =>
                  const PhoneLoginWithPasswordScreen(), // Add phone login with password route
              '/phone-register': (context) =>
                  const PhoneRegisterScreen(), // Add phone register route
              '/phone-forgot-password': (context) =>
                  const PhoneForgotPasswordScreen(), // Add phone forgot password route
              '/register': (context) =>
                  const RegisterScreen(), // Add register route
              '/home': (context) => const NabhaHomeScreen(), // Add home route
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

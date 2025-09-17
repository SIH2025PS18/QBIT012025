import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/service_locator.dart';
import 'services/video_consultation_service.dart';
import 'services/connectivity_service.dart';
import 'services/auth_service.dart';
import 'services/doctor_provider.dart';
import 'services/facility_service.dart';
import 'providers/language_provider.dart';
import 'providers/patient_profile_provider.dart';
import 'providers/emergency_data_provider.dart';
import 'providers/family_profile_provider.dart';
import 'providers/smart_pharmacy_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_wrapper.dart';
import 'screens/symptom_chat_screen.dart';
import 'screens/auth/phone_login_with_password_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/phone_forgot_password_screen.dart';
import 'screens/nabha_home_screen.dart';
import 'screens/doctor_queue_screen.dart';
import 'screens/queue_waiting_screen.dart';
import 'screens/facility_search_screen.dart';
import 'screens/emergency_access_screen.dart';
import 'widgets/emergency_access_monitor.dart';
import 'generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator for dependency injection
  await initializeServiceLocator();

  // Initialize auth service
  final authService = AuthService();
  await authService.initialize();

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

        // Auth service
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),

        // Doctor service
        ChangeNotifierProvider<DoctorService>(create: (_) => DoctorService()),

        // Facility service
        ChangeNotifierProvider<FacilityService>(
          create: (_) => FacilityService(),
        ),

        // Patient profile provider
        ChangeNotifierProvider<PatientProfileProvider>(
          create: (_) => PatientProfileProvider(),
        ),

        // Emergency data provider
        ChangeNotifierProvider<EmergencyDataProvider>(
          create: (_) => EmergencyDataProvider(),
        ),

        // Family profile provider
        ChangeNotifierProvider<FamilyProfileProvider>(
          create: (_) => FamilyProfileProvider(),
        ),

        // Smart pharmacy provider
        ChangeNotifierProvider<SmartPharmacyProvider>(
          create: (_) => SmartPharmacyProvider(),
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
                  const PhoneLoginWithPasswordScreen(), // Add phone login route
              '/phone-login-password': (context) =>
                  const PhoneLoginWithPasswordScreen(), // Add phone login with password route
              '/phone-forgot-password': (context) =>
                  const PhoneForgotPasswordScreen(), // Add phone forgot password route
              '/register': (context) =>
                  const RegisterScreen(), // Add register route
              '/home': (context) => const NabhaHomeScreen(), // Add home route
              '/doctor-queue': (context) =>
                  const DoctorQueueScreen(), // Add doctor queue route
              '/facility-search': (context) =>
                  const FacilitySearchScreen(), // Add facility search route
              '/emergency-access': (context) {
                final args =
                    ModalRoute.of(context)!.settings.arguments
                        as Map<String, String>;
                return EmergencyAccessScreen(
                  patientId: args['patientId']!,
                  patientName: args['patientName']!,
                );
              }, // Add emergency access route
              '/emergency-monitor': (context) {
                final patientId =
                    ModalRoute.of(context)!.settings.arguments as String;
                return EmergencyAccessMonitor(patientId: patientId);
              }, // Add emergency access monitor route
              '/queue-waiting': (context) {
                final doctor =
                    ModalRoute.of(context)!.settings.arguments as LiveDoctor;
                return QueueWaitingScreen(doctor: doctor);
              }, // Add queue waiting route
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

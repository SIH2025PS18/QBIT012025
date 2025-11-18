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
import 'providers/theme_provider.dart';
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
import 'screens/family_management_screen.dart';
import 'widgets/emergency_access_monitor.dart';
import 'screens/doctor_test_screen.dart';
import 'generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize service locator for dependency injection
    print('🚀 Initializing service locator...');
    await initializeServiceLocator();
    print('✅ Service locator initialized');

    // Initialize auth service
    print('🔐 Initializing auth service...');
    final authService = AuthService();
    await authService.initialize();
    print('✅ Auth service initialized');

    print('🎯 Starting TelemedApp...');
    runApp(const TelemedApp());
  } catch (e, stackTrace) {
    print('❌ Error during app initialization: $e');
    print('📍 Stack trace: $stackTrace');
    
    // Run a minimal app if initialization fails
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Initialization Error',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class TelemedApp extends StatelessWidget {
  const TelemedApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('🏗️ Building TelemedApp...');
    
    return MultiProvider(
      providers: [
        // Theme provider
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) {
            print('🎨 Creating ThemeProvider...');
            return ThemeProvider()..initializeTheme();
          },
        ),

        // Language provider
        ChangeNotifierProvider<LanguageProvider>(
          create: (_) {
            print('🌐 Creating LanguageProvider...');
            return LanguageProvider()..initializeLanguage();
          },
        ),

        // Connectivity service
        ChangeNotifierProvider<ConnectivityService>(
          create: (_) {
            print('📡 Creating ConnectivityService...');
            return ConnectivityService()..initialize();
          },
        ),

        // Auth service
        ChangeNotifierProvider<AuthService>(
          create: (_) {
            print('🔐 Creating AuthService...');
            return AuthService();
          },
        ),

        // Doctor service
        ChangeNotifierProvider<DoctorService>(
          create: (_) {
            print('👩‍⚕️ Creating DoctorService...');
            return DoctorService();
          },
        ),

        // Facility service
        ChangeNotifierProvider<FacilityService>(
          create: (_) {
            print('🏥 Creating FacilityService...');
            return FacilityService();
          },
        ),

        // Patient profile provider
        ChangeNotifierProvider<PatientProfileProvider>(
          create: (_) {
            print('👤 Creating PatientProfileProvider...');
            return PatientProfileProvider();
          },
        ),

        // Emergency data provider
        ChangeNotifierProvider<EmergencyDataProvider>(
          create: (_) {
            print('🚨 Creating EmergencyDataProvider...');
            return EmergencyDataProvider();
          },
        ),

        // Family profile provider
        ChangeNotifierProvider<FamilyProfileProvider>(
          create: (_) {
            print('👨‍👩‍👧‍👦 Creating FamilyProfileProvider...');
            return FamilyProfileProvider();
          },
        ),

        // Smart pharmacy provider
        ChangeNotifierProvider<SmartPharmacyProvider>(
          create: (_) {
            print('💊 Creating SmartPharmacyProvider...');
            return SmartPharmacyProvider();
          },
        ),

        // Video consultation service
        ChangeNotifierProvider<VideoConsultationService>(
          create: (context) {
            print('📹 Creating VideoConsultationService...');
            return VideoConsultationService(context.read<ConnectivityService>());
          },
        ),
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          print('🎯 Building MaterialApp with theme and locale...');
          print('🌐 Current locale: ${languageProvider.currentLocale}');
          print('🎨 Dark mode: ${themeProvider.isDarkMode}');
          
          return MaterialApp(
            title: 'Sehat Sarthi',
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
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
              '/family-management': (context) =>
                  const FamilyManagementScreen(), // Add family management route
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
              '/doctor-test': (context) =>
                  const DoctorTestScreen(), // Add doctor test route
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

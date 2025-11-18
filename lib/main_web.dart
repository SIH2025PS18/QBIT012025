import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/phone_login_with_password_screen.dart';
import 'screens/nabha_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TelemedWebApp());
}

class TelemedWebApp extends StatelessWidget {
  const TelemedWebApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, languageProvider, themeProvider, child) {
          return MaterialApp(
            title: 'Telemed - Rural Healthcare Platform',
            debugShowCheckedModeBanner: false,
            
            // Theme configuration
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF10B981),
                brightness: Brightness.light,
              ),
              fontFamily: 'Roboto',
            ),
            
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF10B981),
                brightness: Brightness.dark,
              ),
              fontFamily: 'Roboto',
            ),
            
            themeMode: themeProvider.themeMode,
            
            // Localization
            locale: Locale(languageProvider.currentLanguageCode),
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('hi', 'IN'),
              Locale('pa', 'IN'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // Routes
            home: const WebDemoScreen(),
            routes: {
              '/login': (context) => const PhoneLoginWithPasswordScreen(),
              '/home': (context) => const NabhaHomeScreen(),
            },
          );
        },
      ),
    );
  }
}

class WebDemoScreen extends StatelessWidget {
  const WebDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10B981),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Title
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    size: 60,
                    color: Color(0xFF10B981),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                const Text(
                  'Telemed',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const Text(
                  'Rural Healthcare Platform',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Feature Cards
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      icon: Icons.video_call,
                      title: 'Video Consultations',
                      description: 'HD video calls with doctors',
                    ),
                    _buildFeatureCard(
                      icon: Icons.psychology,
                      title: 'AI Symptom Checker',
                      description: 'Smart symptom analysis',
                    ),
                    _buildFeatureCard(
                      icon: Icons.local_pharmacy,
                      title: 'Smart Pharmacy',
                      description: 'Medicine finder & delivery',
                    ),
                    _buildFeatureCard(
                      icon: Icons.queue,
                      title: 'Queue Management',
                      description: 'Real-time waiting updates',
                    ),
                    _buildFeatureCard(
                      icon: Icons.qr_code,
                      title: 'Emergency QR',
                      description: 'Rapid patient identification',
                    ),
                    _buildFeatureCard(
                      icon: Icons.language,
                      title: 'Multilingual',
                      description: 'English, Hindi, Punjabi',
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // Action Buttons
                Column(
                  children: [
                    SizedBox(
                      width: 280,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF10B981),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Patient Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      width: 280,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/home'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Explore Dashboard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Footer
                const Text(
                  '🏥 Bringing Healthcare to Every Village',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
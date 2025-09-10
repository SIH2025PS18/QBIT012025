import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import 'nabha_profile_setup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2563EB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Language selector at top
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Consumer<LanguageProvider>(
                    builder: (context, languageProvider, child) {
                      return PopupMenuButton<String>(
                        icon: const Icon(Icons.language, color: Colors.white),
                        onSelected: (String languageCode) {
                          languageProvider.changeLanguage(languageCode);
                        },
                        color: Colors.white,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'en',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🇺🇸'),
                                const SizedBox(width: 8),
                                const Text('English'),
                                if (languageProvider.currentLanguageCode ==
                                    'en')
                                  const SizedBox(width: 8),
                                if (languageProvider.currentLanguageCode ==
                                    'en')
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'hi',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🇮🇳'),
                                const SizedBox(width: 8),
                                const Text('हिंदी'),
                                if (languageProvider.currentLanguageCode ==
                                    'hi')
                                  const SizedBox(width: 8),
                                if (languageProvider.currentLanguageCode ==
                                    'hi')
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'pa',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🇮🇳'),
                                const SizedBox(width: 8),
                                const Text('ਪੰਜਾਬੀ'),
                                if (languageProvider.currentLanguageCode ==
                                    'pa')
                                  const SizedBox(width: 8),
                                if (languageProvider.currentLanguageCode ==
                                    'pa')
                                  const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              const Spacer(),

              // Welcome content
              Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.medical_services,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    '🙏 Welcome to TeleMed',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Your Health Journey Starts Here',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          Icons.video_call,
                          'Video Consultations',
                          'Connect with doctors from home',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          Icons.language,
                          'Multi-language Support',
                          'Available in English, हिंदी, ਪੰਜਾਬੀ',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          Icons.security,
                          'Secure & Private',
                          'Your health data is protected',
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Get Started button
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const NabhaProfileSetupScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get Started 🚀',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Let\'s set up your health profile',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

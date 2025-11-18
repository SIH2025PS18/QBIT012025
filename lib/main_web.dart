import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TelemedWebApp());
}

class TelemedWebApp extends StatelessWidget {
  const TelemedWebApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      
      // Routes
      home: const WebDemoScreen(),
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
                
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Text(
                    '🚀 Web Demo Active • SIH 2025',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Feature Cards
                Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Wrap(
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
                ),
                
                const SizedBox(height: 48),
                
                // Action Buttons
                Column(
                  children: [
                    Container(
                      width: 280,
                      child: ElevatedButton(
                        onPressed: () {
                          _showDemoDialog(context, 'Patient Login', 
                            'Patient login functionality includes:\n\n'
                            '• Phone number authentication\n'
                            '• Health profile management\n'
                            '• Appointment booking\n'
                            '• Video consultation access\n'
                            '• Prescription tracking\n'
                            '• Health records');
                        },
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
                          'Patient Login Demo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      width: 280,
                      child: OutlinedButton(
                        onPressed: () {
                          _showDemoDialog(context, 'Doctor Dashboard', 
                            'Doctor dashboard features include:\n\n'
                            '• Patient queue management\n'
                            '• Video consultation tools\n'
                            '• Medical record access\n'
                            '• Prescription writing\n'
                            '• Appointment scheduling\n'
                            '• Real-time notifications');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Doctor Dashboard Demo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    
                    Container(
                      width: 280,
                      child: OutlinedButton(
                        onPressed: () {
                          _showDemoDialog(context, 'Admin Panel', 
                            'Hospital admin features include:\n\n'
                            '• Hospital staff management\n'
                            '• Resource allocation\n'
                            '• System configuration\n'
                            '• Analytics & reporting\n'
                            '• Inventory management\n'
                            '• Quality monitoring');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Admin Panel Demo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // Technical Info
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Platform Architecture',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Frontend', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('• Flutter Web & Mobile', style: TextStyle(color: Colors.white70)),
                                Text('• Progressive Web App', style: TextStyle(color: Colors.white70)),
                                Text('• Responsive Design', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Backend', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('• Node.js + Express', style: TextStyle(color: Colors.white70)),
                                Text('• MongoDB Database', style: TextStyle(color: Colors.white70)),
                                Text('• Socket.io Real-time', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Video', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('• Agora RTC SDK', style: TextStyle(color: Colors.white70)),
                                Text('• HD Video Quality', style: TextStyle(color: Colors.white70)),
                                Text('• Screen Sharing', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Features', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('• Offline-First Design', style: TextStyle(color: Colors.white70)),
                                Text('• Multi-language Support', style: TextStyle(color: Colors.white70)),
                                Text('• AI-Powered Tools', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                
                const SizedBox(height: 8),
                
                const Text(
                  'Smart India Hackathon 2025 • Problem Statement PS18',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // GitHub Link
                OutlinedButton.icon(
                  onPressed: () {
                    // In a real app, this would open the GitHub repository
                    _showDemoDialog(context, 'Source Code', 
                      'The complete source code is available on GitHub:\n\n'
                      'Repository: SIH2025PS18/telemed18\n\n'
                      'Includes:\n'
                      '• Flutter mobile and web apps\n'
                      '• Node.js backend server\n'
                      '• MongoDB database schemas\n'
                      '• Docker deployment configs\n'
                      '• Complete documentation\n'
                      '• API specifications');
                  },
                  icon: const Icon(Icons.code, color: Colors.white),
                  label: const Text('View Source Code'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
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
  
  void _showDemoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Learn More'),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title documentation would open here'),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
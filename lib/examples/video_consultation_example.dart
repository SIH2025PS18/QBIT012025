import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/video_consultation_service.dart';
import '../services/connectivity_service.dart';
import '../screens/video_consultation_screen.dart';
import '../screens/doctor_dashboard_screen.dart';

/// Example of how to integrate video consultation into your app
class VideoConsultationExample extends StatefulWidget {
  const VideoConsultationExample({Key? key}) : super(key: key);

  @override
  State<VideoConsultationExample> createState() => _VideoConsultationExampleState();
}

class _VideoConsultationExampleState extends State<VideoConsultationExample> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add your service providers
        Provider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
        ChangeNotifierProvider<VideoConsultationService>(
          create: (context) => VideoConsultationService(
            context.read<ConnectivityService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Telemedicine Video Consultation',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const ConsultationHomeScreen(),
        routes: {
          '/patient-consultation': (context) => const VideoConsultationScreen(
                userId: 'patient-123',
                isDoctor: false,
              ),
          '/doctor-dashboard': (context) => const DoctorDashboardScreen(
                doctorId: 'doctor-123',
              ),
        },
      ),
    );
  }
}

class ConsultationHomeScreen extends StatelessWidget {
  const ConsultationHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telemedicine Platform'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or hero image
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.video_call,
                  size: 60,
                  color: Colors.blue,
                ),
              ),
              
              const SizedBox(height: 32),
              
              const Text(
                'Video Consultation Platform',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Connect with healthcare professionals through secure video consultations',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Patient interface button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VideoConsultationScreen(
                          userId: 'patient-123',
                          isDoctor: false,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Join as Patient'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Doctor interface button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorDashboardScreen(
                          doctorId: 'doctor-123',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.medical_services),
                  label: const Text('Doctor Dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Demo features
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Features Included:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureItem(Icons.queue, 'Queue Management System'),
                      _buildFeatureItem(Icons.meeting_room, 'Virtual Waiting Room'),
                      _buildFeatureItem(Icons.videocam, 'HD Video Consultation'),
                      _buildFeatureItem(Icons.chat, 'Real-time Chat'),
                      _buildFeatureItem(Icons.dashboard, 'Doctor Dashboard'),
                      _buildFeatureItem(Icons.history, 'Consultation History'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

/*
 * INTEGRATION GUIDE:
 * 
 * 1. VIDEO SDK INTEGRATION:
 *    - Choose a video SDK: Agora, Jitsi Meet, WebRTC, Twilio Video
 *    - Add the SDK dependency to pubspec.yaml
 *    - Initialize the SDK in video_call_screen.dart
 *    - Replace placeholder video views with actual video widgets
 * 
 * 2. BACKEND SETUP:
 *    - Ensure Supabase tables are created for video_consultations
 *    - Set up real-time subscriptions for queue updates
 *    - Implement chat message storage and real-time sync
 * 
 * 3. PERMISSIONS:
 *    - Add camera and microphone permissions in Android/iOS manifests
 *    - Request runtime permissions before starting video calls
 * 
 * 4. WEB DEPLOYMENT:
 *    - Build doctor dashboard for web: flutter build web
 *    - Deploy to your preferred hosting platform
 *    - Ensure HTTPS for video API access
 * 
 * 5. CUSTOMIZATION:
 *    - Update UI colors and branding in theme
 *    - Add custom consultation types and specialties
 *    - Implement prescription and report generation
 * 
 * RECOMMENDED VIDEO SDKs:
 * 
 * 1. AGORA (Most Popular):
 *    dependencies:
 *      agora_rtc_engine: ^6.3.2
 * 
 * 2. JITSI MEET:
 *    dependencies:
 *      jitsi_meet_flutter_sdk: ^10.2.0
 * 
 * 3. WebRTC:
 *    dependencies:
 *      flutter_webrtc: ^0.9.48
 * 
 * 4. TWILIO VIDEO:
 *    dependencies:
 *      twilio_programmable_video: ^0.13.1
 */
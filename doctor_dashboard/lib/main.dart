import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/doctor_login_screen.dart';
import 'providers/doctor_provider.dart';
import 'providers/video_call_provider.dart';
import 'providers/chat_provider.dart';

void main() {
  runApp(const DoctorDashboardApp());
}

class DoctorDashboardApp extends StatelessWidget {
  const DoctorDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => VideoCallProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Doctor Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF6366F1),
          scaffoldBackgroundColor: const Color(0xFF1A1B23),
          fontFamily: 'Inter',
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            brightness: Brightness.dark,
          ),
        ),
        home: const DoctorLoginScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/doctor_login_screen.dart';
import 'providers/doctor_provider.dart';
import 'providers/doctor_theme_provider.dart';
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
        ChangeNotifierProvider(
            create: (_) => DoctorThemeProvider()..initializeTheme()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => VideoCallProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<DoctorThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Doctor Dashboard',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/login',
            routes: {
              '/login': (context) => const DoctorLoginScreen(),
            },
            home: const DoctorLoginScreen(),
          );
        },
      ),
    );
  }
}

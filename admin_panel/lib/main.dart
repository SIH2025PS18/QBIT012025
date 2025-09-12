import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/admin_dashboard_screen_new.dart';
import 'screens/admin_login_screen.dart';
import 'screens/doctor_management_screen.dart';
import 'screens/add_doctor_screen_new.dart';
import 'providers/doctor_provider.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize auth service
  await AuthService().init();

  // Clear any existing auth to force fresh login
  await AuthService().clearAuth();

  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({Key? key}) : super(key: key);

  // Check authentication status
  Widget _getInitialScreen() {
    // Always start with login screen to ensure fresh authentication
    return const AdminLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
      ],
      child: MaterialApp(
        title: 'Hospital Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFFFF6B9D),
          scaffoldBackgroundColor: const Color(0xFF0A0E27),
          fontFamily: 'Inter',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => _getInitialScreen(),
          '/login': (context) => const AdminLoginScreen(),
          '/dashboard': (context) => const AdminDashboardScreen(),
          '/doctors': (context) => const DoctorManagementScreen(),
          '/add-doctor': (context) => const AddDoctorScreen(),
          '/patients': (context) => const PlaceholderScreen(title: 'Patients'),
          '/appointments': (context) =>
              const PlaceholderScreen(title: 'Appointments'),
          '/departments': (context) =>
              const PlaceholderScreen(title: 'Departments'),
          '/settings': (context) => const PlaceholderScreen(title: 'Settings'),
        },
      ),
    );
  }
}

// Placeholder screen for unimplemented features
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF1A1D29),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '$title Feature',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon!',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B9D),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

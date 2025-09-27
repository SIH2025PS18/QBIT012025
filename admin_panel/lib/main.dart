import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/modern_hospital_dashboard.dart';
import 'screens/admin_login_screen.dart';
import 'screens/modern_doctor_management_screen.dart';
import 'screens/add_doctor_screen_new.dart';
import 'screens/pharmacy_management_screen.dart';
import 'screens/bulk_upload_screen.dart';
import 'screens/modern_patient_management_screen.dart';
import 'screens/modern_appointment_management_screen.dart';
import 'screens/modern_analytics_screen.dart';
import 'screens/department_management_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/family_hub_screen.dart';
import 'screens/bulk_reports_screen.dart';
import 'screens/modern_reports_screen.dart';
import 'screens/modern_add_doctor_screen.dart';
import 'providers/doctor_provider.dart';
import 'providers/pharmacy_provider.dart';
import 'providers/patient_provider.dart';
import 'providers/family_hub_provider.dart';
import 'providers/admin_theme_provider.dart';
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
        ChangeNotifierProvider(create: (_) => PharmacyProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => FamilyHubProvider()),
        ChangeNotifierProvider(
            create: (_) => AdminThemeProvider()..initializeTheme()),
      ],
      child: Consumer<AdminThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Hospital Admin Panel',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => _getInitialScreen(),
              '/login': (context) => const AdminLoginScreen(),
              '/dashboard': (context) => const ModernHospitalDashboard(),
              '/doctors': (context) => const ModernDoctorManagementScreen(),
              '/add-doctor': (context) => const AddDoctorScreen(),
              '/modern-add-doctor': (context) => const ModernAddDoctorScreen(),
              '/patients': (context) => const ModernPatientManagementScreen(),
              '/patients/bulk-upload': (context) => const BulkUploadScreen(),
              '/pharmacies': (context) => const PharmacyManagementScreen(),
              '/pharmacies/all': (context) => const PharmacyManagementScreen(),
              '/appointments': (context) =>
                  const ModernAppointmentManagementScreen(),
              '/analytics': (context) => const ModernAnalyticsScreen(),
              '/departments': (context) => const DepartmentManagementScreen(),
              '/family-hub': (context) => const FamilyHubScreen(),
              '/bulk-reports': (context) => const BulkReportsScreen(),
              '/modern-reports': (context) => const ModernReportsScreen(),
              '/bulk-reports/patients': (context) => const BulkReportsScreen(),
              '/bulk-reports/doctors': (context) => const BulkReportsScreen(),
              '/bulk-reports/appointments': (context) =>
                  const BulkReportsScreen(),
              '/bulk-reports/community': (context) => const BulkReportsScreen(),
              '/bulk-reports/financial': (context) => const BulkReportsScreen(),
              '/bulk-reports/inventory': (context) => const BulkReportsScreen(),
              '/bulk-reports/custom': (context) => const BulkReportsScreen(),
              '/settings': (context) => const SettingsScreen(),
            },
          );
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

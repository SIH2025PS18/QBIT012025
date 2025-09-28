import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pharmacy_provider.dart';
import 'providers/prescription_provider.dart';
import 'providers/pharmacy_theme_provider.dart';
import 'providers/inventory_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PharmacyDashboardApp());
}

class PharmacyDashboardApp extends StatelessWidget {
  const PharmacyDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PharmacyProvider()),
        ChangeNotifierProvider(create: (_) => PrescriptionProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(
          create: (_) => PharmacyThemeProvider()..initializeTheme(),
        ),
      ],
      child: Consumer<PharmacyThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Sehat Sarthi - Pharmacy Dashboard',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(
      builder: (context, pharmacyProvider, child) {
        if (pharmacyProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (pharmacyProvider.isAuthenticated) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

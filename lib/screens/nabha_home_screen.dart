import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/doctor_provider.dart';
import '../models/doctor.dart';
import '../generated/l10n/app_localizations.dart';
import 'auth/phone_login_with_password_screen.dart';
import 'digital_health_locker_screen.dart';
import 'offline_symptom_checker_screen.dart';
import 'medicine_checker_screen.dart';
import 'settings_screen.dart';
import 'patient_profile_screen.dart';
import 'doctor_selection_screen.dart';
import 'doctor_appointment_screen.dart';
import 'smart_pharmacy/pharmacy_locator_screen.dart';
import 'family_dashboard_screen.dart';
import '../services/phone_auth_service.dart';
import '../services/auth_service.dart';

class NabhaHomeScreen extends StatefulWidget {
  const NabhaHomeScreen({super.key});

  @override
  State<NabhaHomeScreen> createState() => _NabhaHomeScreenState();
}

class _NabhaHomeScreenState extends State<NabhaHomeScreen> {
  bool _isOnline = true;
  String _userName = 'Patient'; // Add user name variable

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // Initialize doctor service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final doctorService = Provider.of<DoctorService>(context, listen: false);
      doctorService.initialize();
    });
  }

  Future<void> _loadUserData() async {
    // In a real implementation, this would fetch user data from the service
    // For now, we'll use a mock name
    setState(() {
      _userName = 'Shaurya'; // This would be dynamic in real implementation
    });
  }

  String _getOnlineText() {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    switch (languageProvider.currentLanguageCode) {
      case 'hi':
        return 'ऑनलाइन';
      case 'pa':
        return 'ਔਨਲਾਈਨ';
      default:
        return 'Online';
    }
  }

  Future<void> _signOut() async {
    // Sign out the user from  and clear offline data
    await PhoneAuthService.signOut();

    // Navigate to login screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const PhoneLoginWithPasswordScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.black87, size: 28),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PatientProfileScreen(),
              ),
            );
          },
        ),
        title: Text(
          AppLocalizations.of(context).appTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          // Network status indicator
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _isOnline ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isOnline ? Icons.wifi : Icons.wifi_off,
                    size: 16,
                    color: _isOnline ? Colors.green[700] : Colors.orange[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isOnline
                        ? _getOnlineText()
                        : AppLocalizations.of(context).offline,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _isOnline ? Colors.green[700] : Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red, size: 28),
            onPressed: () => _signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.waving_hand,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context).welcome,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Language selection
                      Consumer<LanguageProvider>(
                        builder: (context, languageProvider, child) {
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    languageProvider.changeLanguage('en'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        languageProvider.currentLanguageCode ==
                                            'en'
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        languageProvider.currentLanguageCode ==
                                            'en'
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    'English',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight:
                                          languageProvider
                                                  .currentLanguageCode ==
                                              'en'
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () =>
                                    languageProvider.changeLanguage('hi'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        languageProvider.currentLanguageCode ==
                                            'hi'
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        languageProvider.currentLanguageCode ==
                                            'hi'
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    'हिंदी',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight:
                                          languageProvider
                                                  .currentLanguageCode ==
                                              'hi'
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () =>
                                    languageProvider.changeLanguage('pa'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        languageProvider.currentLanguageCode ==
                                            'pa'
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        languageProvider.currentLanguageCode ==
                                            'pa'
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    'ਪੰਜਾਬੀ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight:
                                          languageProvider
                                                  .currentLanguageCode ==
                                              'pa'
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _userName, // Use dynamic user name
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).healthJourneyStarts,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Dynamic Doctor Status Bar
            _buildDoctorStatusBar(),

            const SizedBox(height: 24),

            // Quick Access Shortcuts
            Text(
              AppLocalizations.of(context).quickAccess,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            _buildQuickAccessShortcuts(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // Navigate to video call with Dr. SATYAM for testing
      //     final testDoctor = Doctor(
      //       id: '68c3dad2fe137120af5dceba',
      //       name: 'SATYAM',
      //       email: 'new@satyma.com',
      //       speciality: 'Gynecologist',
      //       qualification: 'MD',
      //       experience: 5,
      //       consultationFee: 0.0,
      //       rating: 0.0,
      //       isAvailable: true,
      //       languages: ['English', 'Hindi'],
      //       profileImage: '',
      //     );

      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => RealtimeVideoCallScreen(
      //           doctor: testDoctor,
      //           patientId: '68c2cf5e3f1d8dc55cabdd9f',
      //           patientName: 'Test Patient',
      //           symptoms: 'Testing video call functionality',
      //         ),
      //       ),
      //     );
      //   },
      //   backgroundColor: Colors.green,
      //   icon: const Icon(Icons.video_call),
      //   label: const Text('Test Video Call'),
      // ),
    );
  }

  Widget _buildDoctorStatusBar() {
    print(
      '🏥 DEBUG: Building doctor status bar with appointment button',
    ); // Debug line
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Consumer<DoctorService>(
        builder: (context, doctorService, child) {
          final onlineDoctors = doctorService.onlineDoctors;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(
                  context,
                ).generalDoctorsOnline(onlineDoctors.length),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Live doctor preview
              Column(
                children: onlineDoctors.take(2).map((doctor) {
                  return _buildDoctorStatusItem(doctor);
                }).toList(),
              ),

              const SizedBox(height: 16),

              // See all doctors button
              Container(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    final authService = Provider.of<AuthService>(
                      context,
                      listen: false,
                    );
                    final user = authService.currentUser;

                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorSelectionScreen(
                            patientId: user.id,
                            patientName: user.name,
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.queue),
                  label: Text(AppLocalizations.of(context).joinLiveDoctorQueue),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.blue[600]!),
                    foregroundColor: Colors.blue[600],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Book appointment button - PROMINENTLY DISPLAYED
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    print(
                      '📅 DEBUG: Book Appointment button pressed!',
                    ); // Debug line
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorAppointmentScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.calendar_today, size: 20),
                  label: Text(
                    AppLocalizations.of(context).bookAppointment,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDoctorStatusItem(Doctor doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: doctor.status == 'online' ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          // Doctor info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context).doctorTitle} ${doctor.name}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  doctor.speciality,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Status text
          Text(
            doctor.status == 'online'
                ? AppLocalizations.of(context).available
                : AppLocalizations.of(context).offline,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: doctor.status == 'online'
                  ? Colors.green[700]
                  : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessShortcuts() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildShortcutCard(
          icon: Icons.local_hospital,
          title: AppLocalizations.of(context).findHospitalsLabs,
          color: const Color(0xFF2E7D32),
          onTap: () {
            Navigator.of(context).pushNamed('/facility-search');
          },
        ),
        _buildShortcutCard(
          icon: Icons.folder_open,
          title: AppLocalizations.of(context).myHealthRecords,
          color: Colors.blue,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DigitalHealthLockerScreen(),
              ),
            );
          },
        ),
        _buildShortcutCard(
          icon: Icons.medication,
          title: AppLocalizations.of(context).medicineStock,
          color: Colors.green,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MedicineCheckerScreen(),
              ),
            );
          },
        ),
        _buildShortcutCard(
          icon: Icons.local_pharmacy,
          title: AppLocalizations.of(context).smartPharmacy,
          color: Colors.teal,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PharmacyLocatorScreen(),
              ),
            );
          },
        ),
        _buildShortcutCard(
          icon: Icons.family_restroom,
          title: AppLocalizations.of(context).familyMembers,
          color: Colors.indigo,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FamilyDashboardScreen(),
              ),
            );
          },
        ),
        _buildShortcutCard(
          icon: Icons.health_and_safety,
          title: AppLocalizations.of(context).firstAidTips,
          color: Colors.orange,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OfflineSymptomCheckerScreen(),
              ),
            );
          },
        ),
        _buildShortcutCard(
          icon: Icons.qr_code_2,
          title: AppLocalizations.of(context).emergencyQR,
          color: Colors.red.shade700,
          onTap: () {
            Navigator.of(context).pushNamed(
              '/emergency-access',
              arguments: {
                'patientId': 'demo-patient-123', // This would be dynamic
                'patientName': _userName,
              },
            );
          },
        ),
        _buildShortcutCard(
          icon: Icons.settings,
          title: AppLocalizations.of(context).settings,
          color: Colors.purple,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShortcutCard({
    required IconData icon,
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

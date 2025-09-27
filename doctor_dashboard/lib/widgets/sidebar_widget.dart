import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/video_call_provider.dart';
import '../providers/doctor_theme_provider.dart';

class SidebarWidget extends StatelessWidget {
  final VoidCallback? onDashboardTap;
  final VoidCallback? onPatientsQueueTap;
  final VoidCallback? onAppointmentsTap;
  final VoidCallback? onReportsTap;
  final VoidCallback? onSettingsTap;

  const SidebarWidget({
    super.key,
    this.onDashboardTap,
    this.onPatientsQueueTap,
    this.onAppointmentsTap,
    this.onReportsTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorThemeProvider>(
      builder: (context, themeProvider, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final sidebarWidth = screenWidth < 1200 ? 260.0 : 280.0;

        return SizedBox(
          width: sidebarWidth,
          child: Container(
            decoration: BoxDecoration(
              color: themeProvider.cardBackgroundColor,
              border: Border(
                  right:
                      BorderSide(color: themeProvider.borderColor, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Logo and branding
                _buildHeader(themeProvider),

                // Doctor profile section
                _buildDoctorProfile(context, themeProvider),

                // Navigation menu
                Expanded(child: _buildNavigationMenu(context, themeProvider)),

                // Footer with logout
                _buildFooter(context, themeProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(DoctorThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF6366F1),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: const Icon(
              Icons.medical_services,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Sehat Sarthi',
            style: TextStyle(
              color: themeProvider.primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorProfile(
      BuildContext context, DoctorThemeProvider themeProvider) {
    return Consumer<DoctorProvider>(
      builder: (context, doctorProvider, child) {
        final doctor = doctorProvider.currentDoctor;
        if (doctor == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeProvider.secondaryBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Doctor avatar and info
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF6366F1),
                    child: Text(
                      doctor.name.split(' ').map((e) => e[0]).take(2).join(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: TextStyle(
                            color: themeProvider.primaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          doctor.specialization,
                          style: TextStyle(
                            color: themeProvider.secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: themeProvider.isDarkMode
                                  ? Colors.green
                                  : Colors.green[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'ONLINE',
                              style: TextStyle(
                                color: themeProvider.isDarkMode
                                    ? Colors.green
                                    : Colors.green[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                        '0', 'Today\'s Calls', Icons.phone, themeProvider),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                        '7', 'Queue', Icons.people, themeProvider),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String value, String title, IconData icon,
      DoctorThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themeProvider.primaryBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeProvider.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: themeProvider.secondaryTextColor,
            size: 16,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: themeProvider.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: themeProvider.secondaryTextColor,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu(
      BuildContext context, DoctorThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Main navigation
            _buildNavItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              themeProvider: themeProvider,
              isActive: true,
              onTap: onDashboardTap,
            ),

            _buildNavItem(
              icon: Icons.people,
              title: 'Patient Queue',
              themeProvider: themeProvider,
              badge: Consumer<VideoCallProvider>(
                builder: (context, provider, child) {
                  final queueCount = 7; // This should come from your data
                  if (queueCount > 0) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        queueCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              onTap: onPatientsQueueTap,
            ),

            _buildNavItem(
              icon: Icons.calendar_today,
              title: 'Appointments',
              themeProvider: themeProvider,
              onTap: onAppointmentsTap,
            ),

            _buildNavItem(
              icon: Icons.video_call,
              title: 'Video Calls',
              themeProvider: themeProvider,
              subtitle: 'Current Session',
              onTap: () {
                // Handle video calls
              },
            ),

            const SizedBox(height: 24),

            // Emergency section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? Colors.red[900]?.withOpacity(0.2)
                    : Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: themeProvider.isDarkMode
                      ? Colors.red[700]!
                      : Colors.red[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.red[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'EMERGENCY',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'NOT FOR OVERWHELMING BY 17 CALLS',
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.red[300]
                          : Colors.red[700],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            _buildNavItem(
              icon: Icons.assessment,
              title: 'Reports',
              themeProvider: themeProvider,
              onTap: onReportsTap,
            ),

            _buildNavItem(
              icon: Icons.settings,
              title: 'Settings',
              themeProvider: themeProvider,
              onTap: onSettingsTap,
            ),

            _buildNavItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              themeProvider: themeProvider,
              onTap: () {
                // Handle help
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required DoctorThemeProvider themeProvider,
    String? subtitle,
    bool isActive = false,
    VoidCallback? onTap,
    Widget? badge,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isActive ? themeProvider.accentColor.withOpacity(0.1) : null,
              borderRadius: BorderRadius.circular(8),
              border: isActive
                  ? Border.all(
                      color: themeProvider.accentColor.withOpacity(0.3),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? themeProvider.accentColor
                      : themeProvider.secondaryTextColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isActive
                              ? themeProvider.accentColor
                              : themeProvider.primaryTextColor,
                          fontSize: 14,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: themeProvider.secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (badge != null) badge,
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, DoctorThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Theme toggle
          Container(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => themeProvider.toggleTheme(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: themeProvider.secondaryTextColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                        style: TextStyle(
                          color: themeProvider.primaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Logout button
          Container(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showLogoutDialog(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red[400],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

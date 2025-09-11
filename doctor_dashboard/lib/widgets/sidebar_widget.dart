import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/video_call_provider.dart';

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
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1B23),
        border: Border(right: BorderSide(color: Color(0xFF3A3D47), width: 1)),
      ),
      child: Column(
        children: [
          // Logo and branding
          _buildHeader(),

          // Doctor profile section
          _buildDoctorProfile(context),

          // Navigation menu
          Expanded(child: _buildNavigationMenu(context)),

          // Footer with logout
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
          const Text(
            'TeleMed Pro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorProfile(BuildContext context) {
    return Consumer<DoctorProvider>(
      builder: (context, doctorProvider, child) {
        final doctor = doctorProvider.currentDoctor;
        if (doctor == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D37),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          doctor.specialization,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Online status indicator
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quick stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Today\'s Calls',
                      '${doctorProvider.todaysCallsCount}',
                      Icons.video_call,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildStatCard(
                      'Queue',
                      '${doctorProvider.waitingPatientsCount}',
                      Icons.people,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3D47),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 16),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Navigation items
          _buildNavItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            isActive: true,
            onTap: onDashboardTap,
          ),

          _buildNavItem(
            icon: Icons.people_outline,
            title: 'Patient Queue',
            onTap: onPatientsQueueTap,
            badge: Consumer<DoctorProvider>(
              builder: (context, provider, child) {
                final count = provider.waitingPatientsCount;
                if (count > 0) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),

          _buildNavItem(
            icon: Icons.calendar_today,
            title: 'Appointments',
            onTap: onAppointmentsTap,
          ),

          _buildNavItem(
            icon: Icons.video_call,
            title: 'Video Calls',
            subtitle: 'Current Session',
            onTap: () {
              // Switch to video call view if active
              final videoProvider = context.read<VideoCallProvider>();
              if (videoProvider.isInCall) {
                // Handle switching to video call view
              }
            },
            trailing: Consumer<VideoCallProvider>(
              builder: (context, provider, child) {
                return provider.isInCall
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),

          const SizedBox(height: 16),

          // Section divider
          Container(
            height: 1,
            color: const Color(0xFF3A3D47),
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),

          _buildNavItem(
            icon: Icons.assessment,
            title: 'Reports',
            onTap: onReportsTap,
          ),

          _buildNavItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: onSettingsTap,
          ),

          _buildNavItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // Handle help
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
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
              color: isActive
                  ? const Color(0xFF6366F1).withValues(alpha: 0.1)
                  : null,
              borderRadius: BorderRadius.circular(8),
              border: isActive
                  ? Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? const Color(0xFF6366F1) : Colors.grey,
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
                              ? const Color(0xFF6366F1)
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
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

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Emergency contact button
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Handle emergency contact
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Emergency contact feature coming soon'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              icon: const Icon(Icons.emergency, size: 16),
              label: const Text('Emergency'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Logout button
          Container(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                _showLogoutDialog(context);
              },
              icon: const Icon(Icons.logout, color: Colors.grey, size: 16),
              label: const Text('Logout', style: TextStyle(color: Colors.grey)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2D37),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

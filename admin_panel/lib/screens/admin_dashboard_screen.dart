import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/sidebar.dart';
import '../services/admin_service.dart';
import '../models/doctor.dart';
import '../models/dashboard_stats.dart';
import '../providers/admin_theme_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService _adminService = AdminService();
  DashboardStats? _stats;
  List<Doctor> _recentDoctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final stats = await _adminService.getDashboardStats();
      final doctors = await _adminService.getAllDoctors();

      setState(() {
        _stats = stats;
        _recentDoctors = doctors.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryBackgroundColor,
          body: Row(
            children: [
              const AdminSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildHeader(themeProvider),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  _buildStatsCards(themeProvider),
                                  const SizedBox(height: 24),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            _buildCommunityHealthSection(
                                                themeProvider),
                                            const SizedBox(height: 24),
                                            _buildChartsSection(themeProvider),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            _buildRecentDoctors(themeProvider),
                                            const SizedBox(height: 24),
                                            _buildAnalyticsSection(
                                                themeProvider),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  _buildQuickActions(themeProvider),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(AdminThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        border: Border(
          bottom: BorderSide(color: themeProvider.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hospital Dashboard',
                  style: TextStyle(
                    color: themeProvider.primaryTextColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome back! Here\'s what\'s happening at your hospital today.',
                  style: TextStyle(
                    color: themeProvider.secondaryTextColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: themeProvider.cardBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: themeProvider.secondaryTextColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Today: ${_getCurrentDate()}',
                  style: TextStyle(color: themeProvider.secondaryTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(AdminThemeProvider themeProvider) {
    if (_stats == null) return const CircularProgressIndicator();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Doctors',
            _stats!.totalDoctors.toString(),
            Icons.local_hospital,
            const Color(0xFFFF6B9D),
            '+12%',
            themeProvider,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total Patients',
            _stats!.totalPatients.toString(),
            Icons.people,
            const Color(0xFF4ECDC4),
            '+8%',
            themeProvider,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Appointments Today',
            (_stats!.todayAppointments ?? _stats!.activeAppointments)
                .toString(),
            Icons.calendar_month,
            const Color(0xFFFFE66D),
            '+15%',
            themeProvider,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Public Health Programs',
            '12',
            Icons.group_work,
            const Color(0xFF6C5CE7),
            '+2 this month',
            themeProvider,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color,
      String growth, AdminThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  growth,
                  style: TextStyle(
                    color: themeProvider.successColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: themeProvider.primaryTextColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: themeProvider.secondaryTextColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityHealthSection(AdminThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeProvider.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.health_and_safety,
                color: themeProvider.successColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Community Health Overview',
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Health metrics grid
          Row(
            children: [
              Expanded(
                child: _buildHealthMetricCard(
                  'Vaccination Rate',
                  '85.3%',
                  Icons.vaccines,
                  themeProvider.successColor,
                  themeProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHealthMetricCard(
                  'Disease Prevention',
                  '92.1%',
                  Icons.shield,
                  themeProvider.infoColor,
                  themeProvider,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildHealthMetricCard(
                  'Health Screenings',
                  '78.6%',
                  Icons.health_and_safety,
                  themeProvider.warningColor,
                  themeProvider,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHealthMetricCard(
                  'Emergency Response',
                  '96.4%',
                  Icons.emergency,
                  themeProvider.errorColor,
                  themeProvider,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Recent health initiatives
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? themeProvider.successColor.withOpacity(0.1)
                  : Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeProvider.isDarkMode
                    ? themeProvider.successColor.withOpacity(0.3)
                    : Colors.green[200]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.campaign,
                      color: themeProvider.successColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Latest Health Initiatives',
                      style: TextStyle(
                        color: themeProvider.successColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildHealthInitiative(
                  'Free Health Checkup Camp - Rural Areas',
                  'Scheduled for Oct 2025',
                  themeProvider,
                ),
                const SizedBox(height: 8),
                _buildHealthInitiative(
                  'COVID-19 Booster Drive',
                  '85% completion rate',
                  themeProvider,
                ),
                const SizedBox(height: 8),
                _buildHealthInitiative(
                  'Mental Health Awareness Program',
                  'Reaching 50+ communities',
                  themeProvider,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    AdminThemeProvider themeProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeProvider.borderColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: themeProvider.secondaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInitiative(
    String title,
    String status,
    AdminThemeProvider themeProvider,
  ) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: themeProvider.successColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: themeProvider.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartsSection(AdminThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Statistics',
            style: TextStyle(
              color: themeProvider.primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: _buildSimpleChart(themeProvider),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildChartLegend('Completed', Colors.green,
                  _stats!.completedAppointments ?? 0, themeProvider),
              const SizedBox(width: 24),
              _buildChartLegend('Pending', Colors.orange,
                  _stats!.pendingAppointments ?? 0, themeProvider),
              const SizedBox(width: 24),
              _buildChartLegend('Cancelled', Colors.red,
                  _stats!.cancelledAppointments ?? 0, themeProvider),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleChart(AdminThemeProvider themeProvider) {
    if (_stats?.appointmentChart == null) {
      return const Center(child: Text('No chart data available'));
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _stats!.appointmentChart!.map((data) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: (data.value / 40) * 150,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B9D),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data.label,
                              style: TextStyle(
                                color: themeProvider.secondaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartLegend(
      String label, Color color, int value, AdminThemeProvider themeProvider) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: $value',
          style: TextStyle(
            color: themeProvider.secondaryTextColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentDoctors(AdminThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recently Added Doctors',
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/doctors'),
                child: Text(
                  'View All',
                  style: TextStyle(color: themeProvider.accentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_recentDoctors.isEmpty)
            Center(
              child: Text(
                'No doctors added yet',
                style: TextStyle(color: themeProvider.secondaryTextColor),
              ),
            )
          else
            ...(_recentDoctors
                .map((doctor) => _buildDoctorItem(doctor, themeProvider))),
        ],
      ),
    );
  }

  Widget _buildDoctorItem(Doctor doctor, AdminThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: themeProvider.accentColor,
            child: Text(
              doctor.name.substring(0, 2).toUpperCase(),
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  doctor.speciality,
                  style: TextStyle(
                    color: themeProvider.secondaryTextColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: doctor.isAvailable
                  ? themeProvider.successColor
                  : themeProvider.errorColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              doctor.isAvailable ? 'Active' : 'Inactive',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(AdminThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeProvider.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: themeProvider.infoColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Healthcare Analytics',
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Patient flow analytics
          _buildAnalyticsItem(
            'Patient Flow Efficiency',
            '92.3%',
            'Average wait time: 15 mins',
            Icons.timeline,
            themeProvider.successColor,
            themeProvider,
          ),
          const SizedBox(height: 16),

          _buildAnalyticsItem(
            'Doctor Utilization',
            '87.6%',
            '43 active doctors',
            Icons.person_search,
            themeProvider.infoColor,
            themeProvider,
          ),
          const SizedBox(height: 16),

          _buildAnalyticsItem(
            'Resource Allocation',
            '78.4%',
            'Optimal distribution',
            Icons.pie_chart,
            themeProvider.warningColor,
            themeProvider,
          ),
          const SizedBox(height: 16),

          _buildAnalyticsItem(
            'Patient Satisfaction',
            '94.7%',
            'Based on 1,247 reviews',
            Icons.sentiment_very_satisfied,
            themeProvider.successColor,
            themeProvider,
          ),
          const SizedBox(height: 20),

          // Quick insights
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? themeProvider.infoColor.withOpacity(0.1)
                  : Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeProvider.isDarkMode
                    ? themeProvider.infoColor.withOpacity(0.3)
                    : Colors.blue[200]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: themeProvider.infoColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Key Insights',
                      style: TextStyle(
                        color: themeProvider.infoColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Peak hours: 10 AM - 2 PM',
                  style: TextStyle(
                    color: themeProvider.primaryTextColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Most common specialty: General Medicine',
                  style: TextStyle(
                    color: themeProvider.primaryTextColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Telemedicine adoption: +45% this month',
                  style: TextStyle(
                    color: themeProvider.primaryTextColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsItem(
    String title,
    String value,
    String description,
    IconData icon,
    Color color,
    AdminThemeProvider themeProvider,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: themeProvider.primaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color: themeProvider.secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(AdminThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeProvider.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeProvider.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              color: themeProvider.primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  themeProvider,
                  'Add Doctor',
                  Icons.person_add,
                  themeProvider.accentColor,
                  () => Navigator.pushNamed(context, '/add-doctor'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  themeProvider,
                  'View Doctors',
                  Icons.local_hospital,
                  const Color(0xFF4ECDC4),
                  () => Navigator.pushNamed(context, '/doctors'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  themeProvider,
                  'View Patients',
                  Icons.people,
                  const Color(0xFFFFE66D),
                  () => Navigator.pushNamed(context, '/patients'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  themeProvider,
                  'Appointments',
                  Icons.calendar_month,
                  const Color(0xFF6C5CE7),
                  () => Navigator.pushNamed(context, '/appointments'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(AdminThemeProvider themeProvider, String title,
      IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${now.day} ${months[now.month - 1]}, ${now.year}';
  }
}

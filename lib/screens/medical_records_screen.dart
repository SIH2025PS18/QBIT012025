import 'package:flutter/material.dart';
import '../database/offline_database.dart';
import '../services/phone_auth_service.dart';
import '../core/service_locator.dart'; // Add this import

class MedicalRecordsScreen extends StatefulWidget {
  final String? patientId; // Make patientId optional

  const MedicalRecordsScreen({Key? key, this.patientId}) : super(key: key);

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late OfflineDatabase _database;

  Map<String, dynamic>? _patientProfile;
  List<Map<String, dynamic>> _medicalReports = [];
  List<Map<String, dynamic>> _vitalSigns = [];
  bool _isLoading = true;
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Initialize database from service locator
    _initializeDatabase();
    _initializeData();
  }

  // Initialize database from service locator
  Future<void> _initializeDatabase() async {
    try {
      _database = await serviceLocator.getAsync<OfflineDatabase>();
    } catch (e) {
      // Fallback to direct instantiation if service locator fails
      _database = OfflineDatabase();
    }
  }

  Future<void> _initializeData() async {
    setState(() => _isLoading = true);

    try {
      // Check connectivity - simplified for now
      _isOnline = false; // Assume offline for demonstration

      // Get patient ID from auth service if not provided
      String patientId = widget.patientId ?? 'default-patient';

      // Try to get current user data
      final userData = await PhoneAuthService.getCurrentUser();
      if (userData != null && userData['id'] != null) {
        patientId = userData['id'];
      }

      // Load patient profile from database first
      final profile = await _database.getPatientProfile(patientId);
      if (profile != null) {
        _patientProfile = {
          'id': profile.id,
          'name': profile.name,
          'age': profile.age,
          'gender': profile.gender,
          'phone': profile.phone,
          'email': profile.email,
          'medicalHistory': profile.medicalHistory,
          'profileImage': profile.profileImage,
        };
      } else {
        // Try to get from auth service and store offline
        final userData = await PhoneAuthService.getCurrentUser();
        if (userData != null) {
          // Store user profile for offline access
          await _database.storeUserProfile(userData);

          _patientProfile = {
            'id': patientId,
            'name': userData['full_name'] ?? userData['name'] ?? 'Unknown User',
            'age': _calculateAge(userData['date_of_birth']),
            'gender': userData['gender'] ?? 'Not specified',
            'phone':
                userData['phone'] ?? userData['phone_number'] ?? 'Not provided',
            'email': userData['email'] ?? 'Not provided',
            'medicalHistory':
                userData['medical_history'] ?? 'No medical history recorded',
            'profileImage': userData['profile_image'] ?? userData['avatar_url'],
          };
        } else {
          // Create demo profile with dummy data if no user data available
          final demoProfile = {
            'id': patientId,
            'full_name': 'Shaurya Shakya',
            'email': 'adhshauryashakya8055@gmail.com',
            'phone': '+91 9876543210',
            'date_of_birth': '1995-08-15',
            'gender': 'Male',
            'medical_history': 'No known allergies. Regular checkups.',
          };

          await _database.storeUserProfile(demoProfile);

          _patientProfile = {
            'id': patientId,
            'name': demoProfile['full_name']!,
            'age': _calculateAge(demoProfile['date_of_birth']),
            'gender': demoProfile['gender']!,
            'phone': demoProfile['phone']!,
            'email': demoProfile['email']!,
            'medicalHistory': demoProfile['medical_history']!,
            'profileImage': null,
          };
        }
      }

      // Load medical reports
      _medicalReports = await _database.getPatientMedicalReports(patientId);

      // Load vital signs
      _vitalSigns = await _database.getPatientVitalSigns(patientId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading medical records: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  String _calculateAge(String? dateOfBirth) {
    if (dateOfBirth == null) return 'N/A';

    try {
      final birthDate = DateTime.parse(dateOfBirth);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return 'N/A';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Note: We should not close the database here as it's a singleton
    // _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isOnline ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isOnline ? Icons.wifi : Icons.wifi_off,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  _isOnline ? 'Online' : 'Offline',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeData,
            tooltip: 'Refresh Data',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Profile'),
            Tab(icon: Icon(Icons.description), text: 'Reports'),
            Tab(icon: Icon(Icons.monitor_heart), text: 'Vital Signs'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text('Loading medical records...'),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildReportsTab(),
                _buildVitalSignsTab(),
              ],
            ),
    );
  }

  Widget _buildProfileTab() {
    if (_patientProfile == null) {
      return const Center(child: Text('No profile data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.teal.shade100,
                    backgroundImage: _patientProfile!['profileImage'] != null
                        ? NetworkImage(_patientProfile!['profileImage'])
                        : null,
                    child: _patientProfile!['profileImage'] == null
                        ? Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.teal.shade700,
                          )
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _patientProfile!['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Age: ${_patientProfile!['age']} • ${_patientProfile!['gender']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (!_isOnline)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.offline_bolt,
                                  size: 16,
                                  color: Colors.orange.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Offline Mode',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Contact Information
          _buildInfoSection('Contact Information', [
            _buildInfoRow(Icons.phone, 'Phone', _patientProfile!['phone']),
            _buildInfoRow(Icons.email, 'Email', _patientProfile!['email']),
          ]),

          const SizedBox(height: 20),

          // Medical History
          _buildInfoSection('Medical History', [
            _buildInfoRow(
              Icons.medical_information,
              'Conditions',
              _patientProfile!['medicalHistory'] ??
                  'No medical history recorded',
            ),
          ]),

          const SizedBox(height: 20),

          // Quick Stats
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    if (_medicalReports.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No medical reports available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _medicalReports.length,
      itemBuilder: (context, index) {
        final report = _medicalReports[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildVitalSignsTab() {
    if (_vitalSigns.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monitor_heart, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No vital signs recorded',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _vitalSigns.length,
      itemBuilder: (context, index) {
        final vital = _vitalSigns[index];
        return _buildVitalSignCard(vital);
      },
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Reports',
                    _medicalReports.length.toString(),
                    Icons.description,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Vital Records',
                    _vitalSigns.length.toString(),
                    Icons.monitor_heart,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    final reportDate = report['reportDate'] as DateTime;
    final isEmergency = report['isEmergency'] as bool;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showReportDetails(report),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isEmergency
                          ? Colors.red.shade100
                          : Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getReportIcon(report['reportType']),
                      color: isEmergency ? Colors.red : Colors.teal,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          report['reportType'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isEmergency)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'URGENT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Hospital and Doctor Info
              Row(
                children: [
                  Icon(
                    Icons.local_hospital,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    report['hospitalName'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    report['doctorName'],
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${reportDate.day}/${reportDate.month}/${reportDate.year}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const Spacer(),
                  if (!_isOnline)
                    Row(
                      children: [
                        Icon(
                          Icons.offline_bolt,
                          size: 14,
                          color: Colors.orange.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Offline',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.orange.shade600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Summary
              Text(
                report['summary'],
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVitalSignCard(Map<String, dynamic> vital) {
    final recordedDate = vital['recordedDate'] as DateTime;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.monitor_heart, color: Colors.red, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vital Signs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${recordedDate.day}/${recordedDate.month}/${recordedDate.year} ${recordedDate.hour}:${recordedDate.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Vital Signs Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 8,
              children: [
                if (vital['bloodPressureSystolic'] != null)
                  _buildVitalItem(
                    'Blood Pressure',
                    '${vital['bloodPressureSystolic']}/${vital['bloodPressureDiastolic']} mmHg',
                    Icons.favorite,
                    Colors.red,
                  ),
                if (vital['heartRate'] != null)
                  _buildVitalItem(
                    'Heart Rate',
                    '${vital['heartRate']} bpm',
                    Icons.monitor_heart,
                    Colors.pink,
                  ),
                if (vital['temperature'] != null)
                  _buildVitalItem(
                    'Temperature',
                    '${vital['temperature']}°F',
                    Icons.thermostat,
                    Colors.orange,
                  ),
                if (vital['oxygenSaturation'] != null)
                  _buildVitalItem(
                    'Oxygen Sat.',
                    '${vital['oxygenSaturation']}%',
                    Icons.air,
                    Colors.blue,
                  ),
              ],
            ),

            if (vital['notes'] != null && vital['notes'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Notes: ${vital['notes']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVitalItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getReportIcon(String reportType) {
    switch (reportType.toLowerCase()) {
      case 'blood test':
        return Icons.bloodtype;
      case 'x-ray':
        return Icons.medical_information;
      case 'mri':
        return Icons.scanner;
      case 'ct scan':
        return Icons.medical_services;
      default:
        return Icons.description;
    }
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      report['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection('Summary', report['summary']),

                    if (report['findings'] is List &&
                        report['findings'].isNotEmpty)
                      _buildDetailSection(
                        'Findings',
                        (report['findings'] as List).join('\n• '),
                      ),

                    if (report['recommendations'] is List &&
                        report['recommendations'].isNotEmpty)
                      _buildDetailSection(
                        'Recommendations',
                        (report['recommendations'] as List).join('\n• '),
                      ),

                    if (report['testResults'] != null &&
                        report['testResults'].isNotEmpty)
                      _buildDetailSection(
                        'Test Results',
                        report['testResults'],
                      ),

                    _buildDetailSection(
                      'Hospital',
                      '${report['hospitalName']}\nDr. ${report['doctorName']} (${report['doctorSpecialization']})',
                    ),

                    _buildDetailSection(
                      'Status',
                      '${report['status']} • Severity: ${report['severity']}',
                    ),

                    if (!_isOnline)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.offline_bolt,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'This report is available offline. Full attachments and additional details may require internet connection.',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

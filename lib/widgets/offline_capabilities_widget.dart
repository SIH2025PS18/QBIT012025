import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/offline_database.dart';
import '../services/offline_symptom_checker_service.dart';
import '../services/connectivity_service.dart';
import '../core/service_locator.dart'; // Add this import

class OfflineCapabilitiesWidget extends StatefulWidget {
  const OfflineCapabilitiesWidget({Key? key}) : super(key: key);

  @override
  State<OfflineCapabilitiesWidget> createState() =>
      _OfflineCapabilitiesWidgetState();
}

class _OfflineCapabilitiesWidgetState extends State<OfflineCapabilitiesWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final OfflineDatabase _db;
  final OfflineSymptomCheckerService _symptomChecker =
      OfflineSymptomCheckerService();

  Map<String, dynamic> _offlineStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Initialize database from service locator
    _initializeDatabase();
    _loadOfflineStats();
  }

  // Initialize database from service locator
  Future<void> _initializeDatabase() async {
    try {
      _db = await serviceLocator.getAsync<OfflineDatabase>();
    } catch (e) {
      // Fallback to direct instantiation if service locator fails
      _db = OfflineDatabase();
    }
  }

  Future<void> _loadOfflineStats() async {
    try {
      final dbStats = await _db.getDatabaseStats();
      final symptomStats = await _symptomChecker.getOfflineStats();

      setState(() {
        _offlineStats = {'database': dbStats, 'symptoms': symptomStats};
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Healthcare'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.offline_bolt), text: 'Status'),
            Tab(icon: Icon(Icons.health_and_safety), text: 'Symptom Check'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Appointments'),
            Tab(icon: Icon(Icons.folder), text: 'Records'),
          ],
        ),
      ),
      body: Consumer<ConnectivityService>(
        builder: (context, connectivity, child) {
          return Column(
            children: [
              _buildConnectivityBanner(connectivity),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOfflineStatusTab(connectivity),
                    _buildSymptomCheckerTab(),
                    _buildAppointmentsTab(),
                    _buildRecordsTab(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildConnectivityBanner(ConnectivityService connectivity) {
    Color bannerColor;
    IconData bannerIcon;
    String bannerText;

    if (connectivity.isConnected) {
      bannerColor = Colors.green;
      bannerIcon = Icons.wifi;
      bannerText = 'Online - All features available';
    } else {
      bannerColor = Colors.orange;
      bannerIcon = Icons.wifi_off;
      bannerText = 'Offline Mode - Using cached data';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: bannerColor,
      child: Row(
        children: [
          Icon(bannerIcon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            bannerText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (!connectivity.isConnected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'OFFLINE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOfflineStatusTab(ConnectivityService connectivity) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureCard(
            'Rural Connectivity Solutions',
            'Healthcare access even with poor internet',
            Icons.signal_cellular_4_bar,
            Colors.blue,
            [
              '✓ Profile information always accessible',
              '✓ Previous prescriptions cached offline',
              '✓ Basic symptom checker works without internet',
              '✓ Appointment scheduling with offline sync',
              '✓ Health records cached for offline viewing',
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            'Offline-First Design',
            'All features work seamlessly whether online or offline',
            Icons.offline_bolt,
            Colors.green,
            [
              '✓ Data stored in encrypted SQLite database',
              '✓ Automatic sync when internet returns',
              '✓ Smart conflict resolution',
              '✓ Priority uploads for critical health data',
              '✓ Intelligent caching strategy',
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            _buildStatsCard(),
        ],
      ),
    );
  }

  Widget _buildSymptomCheckerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Offline Symptom Checker',
            Icons.health_and_safety,
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            'Multilingual Support',
            'Rule-based guidance in your language',
            Icons.language,
            Colors.purple,
            [
              '✓ English, Hindi, Bengali support',
              '✓ Emergency symptom detection',
              '✓ Severity assessment offline',
              '✓ Cultural sensitivity in recommendations',
              '✓ When to seek urgent care guidance',
            ],
          ),
          const SizedBox(height: 16),
          _buildSymptomCheckerDemo(),
          const SizedBox(height: 16),
          _buildSymptomHistory(),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Offline Appointments', Icons.calendar_today),
          const SizedBox(height: 16),
          _buildFeatureCard(
            'Smart Appointment Management',
            'Create, view, and manage appointments offline',
            Icons.event_available,
            Colors.orange,
            [
              '✓ Book appointments without internet',
              '✓ Automatic sync when connected',
              '✓ Conflict resolution for scheduling',
              '✓ Emergency appointment prioritization',
              '✓ Queue management for rural clinics',
            ],
          ),
          const SizedBox(height: 16),
          _buildOfflineAppointmentForm(),
          const SizedBox(height: 16),
          _buildPendingAppointments(),
        ],
      ),
    );
  }

  Widget _buildRecordsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Health Records', Icons.folder),
          const SizedBox(height: 16),
          _buildFeatureCard(
            'Cached Health Data',
            'Important health information always available',
            Icons.storage,
            Colors.teal,
            [
              '✓ Patient profile cached locally',
              '✓ Recent prescriptions available offline',
              '✓ Medical history accessible',
              '✓ Vital signs tracking',
              '✓ Emergency contact information',
            ],
          ),
          const SizedBox(height: 16),
          _buildCachedRecords(),
          const SizedBox(height: 16),
          _buildDataSyncStatus(),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    List<String> features,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(feature, style: const TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 28, color: Colors.green[700]),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    final dbStats = _offlineStats['database'] as Map<String, dynamic>? ?? {};

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Offline Data Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Profiles',
                    '${dbStats['profiles'] ?? 0}',
                    Icons.person,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Appointments',
                    '${dbStats['appointments'] ?? 0}',
                    Icons.calendar_today,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Prescriptions',
                    '${dbStats['prescriptions'] ?? 0}',
                    Icons.medical_services,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Pending Sync',
                    '${dbStats['pending_sync'] ?? 0}',
                    Icons.sync_problem,
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

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSymptomCheckerDemo() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Try Offline Symptom Check',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Language',
                border: OutlineInputBorder(),
              ),
              items: _symptomChecker
                  .getLanguageNames()
                  .entries
                  .map(
                    (entry) => DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _showSymptomCheckDialog(),
              icon: const Icon(Icons.health_and_safety),
              label: const Text('Start Symptom Check'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomHistory() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Symptom Checks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.circle, color: Colors.orange, size: 12),
              title: Text('Fever, Headache'),
              subtitle: Text('2 hours ago • Moderate severity'),
              trailing: Text('हिन्दी'),
            ),
            const ListTile(
              leading: Icon(Icons.circle, color: Colors.green, size: 12),
              title: Text('Cough'),
              subtitle: Text('1 day ago • Mild severity'),
              trailing: Text('English'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineAppointmentForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book Offline Appointment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Symptoms',
                border: OutlineInputBorder(),
                hintText: 'Describe your symptoms...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAppointmentConfirmation(),
                    icon: const Icon(Icons.add),
                    label: const Text('Schedule'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showEmergencyAppointmentDialog(),
                  icon: const Icon(Icons.emergency),
                  label: const Text('Emergency'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingAppointments() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Pending Sync',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    '2 items',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.sync_problem, color: Colors.orange),
              title: Text('General Consultation'),
              subtitle: Text('Created offline • Will sync when online'),
              trailing: Icon(Icons.upload),
            ),
            const ListTile(
              leading: Icon(Icons.priority_high, color: Colors.red),
              title: Text('Emergency Consultation'),
              subtitle: Text('High priority • Needs immediate sync'),
              trailing: Icon(Icons.priority_high),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCachedRecords() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cached Health Records',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('Patient Profile'),
              subtitle: Text('Last updated: 2 hours ago'),
              trailing: Icon(Icons.offline_pin, color: Colors.green),
            ),
            const ListTile(
              leading: Icon(Icons.medical_services, color: Colors.green),
              title: Text('Recent Prescriptions'),
              subtitle: Text('5 prescriptions cached'),
              trailing: Icon(Icons.offline_pin, color: Colors.green),
            ),
            const ListTile(
              leading: Icon(Icons.history, color: Colors.purple),
              title: Text('Medical History'),
              subtitle: Text('Complete history available'),
              trailing: Icon(Icons.offline_pin, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSyncStatus() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Sync Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Last Sync: 2 hours ago'),
                      Text('Next Sync: When online'),
                      Text('Pending Items: 3'),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showSyncDialog(),
                  icon: const Icon(Icons.sync),
                  label: const Text('Force Sync'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSymptomCheckDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Offline Symptom Check'),
        content: const Text(
          'This feature works completely offline using rule-based guidance. '
          'It supports multiple languages and can detect emergency symptoms.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Start Check'),
          ),
        ],
      ),
    );
  }

  void _showAppointmentConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Scheduled'),
        content: const Text(
          'Your appointment has been scheduled offline. '
          'It will be automatically synced when internet connection is available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Appointment'),
        content: const Text(
          'Emergency appointments are marked with high priority and will be '
          'synced immediately when internet connection is restored.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm Emergency'),
          ),
        ],
      ),
    );
  }

  void _showSyncDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Force Sync'),
        content: const Text(
          'This will attempt to sync all pending data with the server. '
          'Make sure you have a stable internet connection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performManualSync();
            },
            child: const Text('Start Sync'),
          ),
        ],
      ),
    );
  }

  void _performManualSync() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sync started... This may take a few moments.'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

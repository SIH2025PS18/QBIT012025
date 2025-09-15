import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/emergency_medical_data.dart';
import '../services/emergency_data_service.dart';

class EmergencyAccessMonitor extends StatefulWidget {
  final String patientId;

  const EmergencyAccessMonitor({Key? key, required this.patientId})
    : super(key: key);

  @override
  State<EmergencyAccessMonitor> createState() => _EmergencyAccessMonitorState();
}

class _EmergencyAccessMonitorState extends State<EmergencyAccessMonitor> {
  final EmergencyDataService _dataService = EmergencyDataService();
  List<EmergencyAccessLog> _accessLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccessLogs();
  }

  Future<void> _loadAccessLogs() async {
    try {
      final logs = await _dataService.getAccessLogs(widget.patientId);
      setState(() {
        _accessLogs = logs;
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
        title: const Text('Emergency Access Monitor'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadAccessLogs,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 16),
        Expanded(child: _buildAccessLogsList()),
      ],
    );
  }

  Widget _buildSummaryCard() {
    final recentAccesses = _accessLogs
        .where(
          (log) => log.accessTime.isAfter(
            DateTime.now().subtract(const Duration(days: 30)),
          ),
        )
        .length;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.red.shade700),
                const SizedBox(width: 12),
                const Text(
                  'Access Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    'Total Accesses',
                    _accessLogs.length.toString(),
                    Icons.history,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    'Last 30 Days',
                    recentAccesses.toString(),
                    Icons.access_time,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            if (_accessLogs.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Last access: ${_formatDateTime(_accessLogs.first.accessTime)}',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAccessLogsList() {
    if (_accessLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No Emergency Access Records',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your emergency medical data has not been accessed yet',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to emergency setup
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.qr_code),
              label: const Text('Set Up Emergency Access'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _accessLogs.length,
      itemBuilder: (context, index) {
        final log = _accessLogs[index];
        return _buildAccessLogCard(log);
      },
    );
  }

  Widget _buildAccessLogCard(EmergencyAccessLog log) {
    final isRecent = log.accessTime.isAfter(
      DateTime.now().subtract(const Duration(hours: 24)),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isRecent ? 4 : 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isRecent ? Colors.red.shade100 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.local_hospital,
            color: isRecent ? Colors.red.shade700 : Colors.grey.shade600,
          ),
        ),
        title: Text(
          log.doctorName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(log.hospitalName),
            const SizedBox(height: 4),
            Text(
              'Location: ${log.location}',
              style: const TextStyle(fontSize: 12),
            ),
            Text('Reason: ${log.reason}', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(log.accessTime),
              style: TextStyle(
                fontSize: 12,
                color: isRecent ? Colors.red.shade700 : Colors.grey.shade600,
                fontWeight: isRecent ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRecent) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'RECENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
            IconButton(
              onPressed: () => _showAccessDetails(log),
              icon: const Icon(Icons.info_outline),
              iconSize: 20,
            ),
          ],
        ),
        onTap: () => _showAccessDetails(log),
      ),
    );
  }

  void _showAccessDetails(EmergencyAccessLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Access Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Doctor', log.doctorName),
              _buildDetailRow('Hospital/Clinic', log.hospitalName),
              _buildDetailRow('Location', log.location),
              _buildDetailRow('Date & Time', _formatDateTime(log.accessTime)),
              _buildDetailRow('Access Reason', log.reason),
              _buildDetailRow('Doctor ID', log.doctorId),
              _buildDetailRow('Token ID', log.tokenId.substring(0, 12) + '...'),

              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Colors.blue.shade700,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Security Information',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Only Level 1 (Emergency) data was accessed\n'
                      '• Access was logged and monitored\n'
                      '• Doctor credentials were verified\n'
                      '• No sensitive information was shared',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (log.accessTime.isAfter(
            DateTime.now().subtract(const Duration(hours: 24)),
          ))
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reportUnauthorizedAccess(log);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Report Issue'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _reportUnauthorizedAccess(EmergencyAccessLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Unauthorized Access'),
        content: const Text(
          'If you believe this emergency access was unauthorized or suspicious, '
          'please report it to our security team. We take privacy and security very seriously.\n\n'
          'Our team will investigate and take appropriate action.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitSecurityReport(log);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitSecurityReport(EmergencyAccessLog log) async {
    // In a real implementation, this would send a report to the security team
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Submitted'),
        content: const Text(
          'Your security report has been submitted. Our team will investigate '
                  'this access and contact you within 24 hours if necessary.\n\n'
                  'Reference ID: SR-' +
              'XXXXX',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Notification Service for Emergency Access
class EmergencyAccessNotificationService {
  // Initialize notification service
  static Future<void> initialize() async {
    // In a real implementation, this would set up push notifications
    // using firebase_messaging or similar with proper channel configuration
  }

  // Send notification when emergency data is accessed
  static Future<void> sendAccessNotification({
    required String patientName,
    required String doctorName,
    required String hospitalName,
    required DateTime accessTime,
  }) async {
    // In a real implementation, this would send a push notification
    // For now, we'll show a local notification

    final message =
        'Your emergency medical data was accessed by $doctorName at $hospitalName on ${_formatDate(accessTime)}';

    // This would be replaced with actual notification implementation
    print('EMERGENCY ACCESS NOTIFICATION: $message');
  }

  // Send notification for suspicious access
  static Future<void> sendSecurityAlert({
    required String reason,
    required DateTime accessTime,
  }) async {
    final message = 'Security Alert: $reason at ${_formatDate(accessTime)}';
    print('SECURITY ALERT: $message');
  }

  static String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Widget for displaying real-time notifications
class EmergencyAccessNotificationWidget extends StatelessWidget {
  final EmergencyAccessLog accessLog;
  final VoidCallback? onDismiss;

  const EmergencyAccessNotificationWidget({
    Key? key,
    required this.accessLog,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.red.shade700),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Emergency Data Accessed',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close),
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Dr. ${accessLog.doctorName} at ${accessLog.hospitalName} accessed your emergency medical information.',
          ),
          const SizedBox(height: 4),
          Text(
            'Time: ${_formatDateTime(accessLog.accessTime)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // View details action
                  },
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Report action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Report Issue'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

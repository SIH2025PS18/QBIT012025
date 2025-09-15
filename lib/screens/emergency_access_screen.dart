import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/emergency_medical_data.dart';
import '../services/emergency_qr_service.dart';
import '../providers/emergency_data_provider.dart';
import '../widgets/emergency_data_form.dart';
import '../widgets/qr_display_options.dart';

class EmergencyAccessScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const EmergencyAccessScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  State<EmergencyAccessScreen> createState() => _EmergencyAccessScreenState();
}

class _EmergencyAccessScreenState extends State<EmergencyAccessScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final EmergencyQRService _qrService = EmergencyQRService();

  EmergencyQRToken? _currentToken;
  bool _isGeneratingQR = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadExistingToken();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingToken() async {
    try {
      final tokens = await _qrService.getActiveTokens(widget.patientId);
      if (tokens.isNotEmpty) {
        setState(() {
          _currentToken = tokens.first;
        });
      }
    } catch (e) {
      print('Error loading existing token: $e');
    }
  }

  Future<void> _generateNewQRToken() async {
    setState(() {
      _isGeneratingQR = true;
    });

    try {
      final token = await _qrService.generateEmergencyQRToken(widget.patientId);
      setState(() {
        _currentToken = token;
        _isGeneratingQR = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).emergencyQRGenerated),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isGeneratingQR = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating QR code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _revokeCurrentToken() async {
    if (_currentToken == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Emergency Access'),
        content: const Text(
          'Are you sure you want to revoke this emergency QR code? '
          'This will prevent access to your emergency medical information.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _qrService.revokeToken(_currentToken!.tokenId);
        setState(() {
          _currentToken = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Emergency QR code revoked successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error revoking QR code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Emergency Access'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.medical_information), text: 'Emergency Data'),
            Tab(icon: Icon(Icons.qr_code), text: 'QR Code'),
            Tab(icon: Icon(Icons.display_settings), text: 'Display Options'),
            Tab(icon: Icon(Icons.history), text: 'Access History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEmergencyDataTab(),
          _buildQRCodeTab(),
          _buildDisplayOptionsTab(),
          _buildAccessHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildEmergencyDataTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            icon: Icons.warning_amber,
            title: 'Emergency Medical Information',
            subtitle:
                'This information will be accessible to medical professionals in emergency situations',
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          Consumer<EmergencyDataProvider>(
            builder: (context, provider, child) {
              return EmergencyDataForm(
                patientId: widget.patientId,
                onDataUpdated: () {
                  // Refresh QR code if data is updated
                  if (_currentToken != null) {
                    _generateNewQRToken();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.qr_code,
            title: 'Emergency QR Code',
            subtitle:
                'Secure access code for medical emergencies. Does not contain your personal data.',
            color: Colors.blue,
          ),
          const SizedBox(height: 20),

          if (_currentToken != null) ...[
            // Current QR Code Display
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Active Emergency QR Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _qrService.createQRCodeWidget(_currentToken!, size: 250),
                    const SizedBox(height: 16),
                    _buildTokenInfo(_currentToken!),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _generateNewQRToken,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Regenerate'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _revokeCurrentToken,
                          icon: const Icon(Icons.block),
                          label: const Text('Revoke'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // No QR Code Available
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.qr_code_2,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Emergency QR Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Generate a secure QR code for emergency medical access',
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _isGeneratingQR ? null : _generateNewQRToken,
                      icon: _isGeneratingQR
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.add),
                      label: Text(
                        _isGeneratingQR ? 'Generating...' : 'Generate QR Code',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDisplayOptionsTab() {
    if (_currentToken == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Generate QR Code First',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You need to generate an emergency QR code before setting display options',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return QRDisplayOptionsWidget(
      token: _currentToken!,
      patientName: widget.patientName,
    );
  }

  Widget _buildAccessHistoryTab() {
    return Consumer<EmergencyDataProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.accessLogs.length,
          itemBuilder: (context, index) {
            final log = provider.accessLogs[index];
            return _buildAccessLogCard(log);
          },
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenInfo(EmergencyQRToken token) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildInfoRow('Token ID', token.tokenId.substring(0, 12) + '...'),
          _buildInfoRow('Generated', _formatDateTime(token.generatedAt)),
          _buildInfoRow('Expires', _formatDateTime(token.expiresAt)),
          _buildInfoRow('Status', token.isActive ? 'Active' : 'Inactive'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAccessLogCard(EmergencyAccessLog log) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade100,
          child: Icon(Icons.local_hospital, color: Colors.red.shade700),
        ),
        title: Text(log.doctorName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(log.hospitalName),
            Text(
              'Accessed: ${_formatDateTime(log.accessTime)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: Text(
          log.location,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/supabase_config.dart';
import '../utils/network_utils.dart';
import '../services/supabase_auth_service.dart';

class NetworkTroubleshootScreen extends StatefulWidget {
  const NetworkTroubleshootScreen({super.key});

  @override
  State<NetworkTroubleshootScreen> createState() =>
      _NetworkTroubleshootScreenState();
}

class _NetworkTroubleshootScreenState extends State<NetworkTroubleshootScreen> {
  bool _isRunningDiagnostics = false;
  Map<String, dynamic>? _diagnosticsResult;
  Map<String, dynamic>? _connectionTest;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isRunningDiagnostics = true;
      _diagnosticsResult = null;
      _connectionTest = null;
    });

    try {
      // Run network diagnostics
      final diagnostics = await NetworkUtils.getNetworkDiagnostics(
        SupabaseConfig.url,
      );

      // Test Supabase connection
      final connectionTest = await AuthService.testConnection();

      setState(() {
        _diagnosticsResult = diagnostics;
        _connectionTest = connectionTest;
        _isRunningDiagnostics = false;
      });
    } catch (e) {
      setState(() {
        _diagnosticsResult = {'error': e.toString()};
        _isRunningDiagnostics = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Troubleshoot'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRunningDiagnostics ? null : _runDiagnostics,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildSectionCard(
              'Network Diagnostics',
              Icons.network_check,
              Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This screen helps diagnose connectivity issues with the authentication service.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  if (_isRunningDiagnostics)
                    const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text('Running diagnostics...'),
                        ],
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _runDiagnostics,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Run Diagnostics'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Configuration Info
            _buildSectionCard(
              'Configuration',
              Icons.settings,
              Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Supabase URL', SupabaseConfig.url),
                  _buildInfoRow(
                    'API Key (First 20 chars)',
                    SupabaseConfig.anonKey.substring(0, 20) + '...',
                  ),
                  _buildInfoRow('Platform', Theme.of(context).platform.name),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Diagnostics Results
            if (_diagnosticsResult != null) ...[
              _buildSectionCard(
                'Network Test Results',
                Icons.wifi,
                _getDiagnosticsColor(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_diagnosticsResult!.containsKey('error'))
                      _buildErrorInfo(_diagnosticsResult!['error'])
                    else ...[
                      _buildTestResult(
                        'Internet Connection',
                        _diagnosticsResult!['hasInternet'] ?? false,
                      ),
                      _buildTestResult(
                        'Supabase Reachable',
                        _diagnosticsResult!['canReachSupabase'] ?? false,
                      ),
                      _buildInfoRow(
                        'Test Time',
                        _diagnosticsResult!['timestamp'] ?? 'Unknown',
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Connection Test Results
            if (_connectionTest != null) ...[
              _buildSectionCard(
                'Supabase Connection Test',
                Icons.cloud,
                _getConnectionColor(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTestResult(
                      'Connection Status',
                      _connectionTest!['status'] == 'success',
                    ),
                    if (_connectionTest!['status'] == 'error') ...[
                      const SizedBox(height: 12),
                      _buildErrorInfo(_connectionTest!['error']),
                      if (_connectionTest!.containsKey('errorType'))
                        _buildInfoRow(
                          'Error Type',
                          _connectionTest!['errorType'],
                        ),
                    ] else ...[
                      if (_connectionTest!.containsKey('currentUser'))
                        _buildInfoRow(
                          'Current User',
                          _connectionTest!['currentUser'] ?? 'Not signed in',
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Troubleshooting Tips
            _buildSectionCard(
              'Troubleshooting Tips',
              Icons.lightbulb,
              Colors.orange,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'If you\'re experiencing connectivity issues, try these solutions:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  ...NetworkUtils.getTroubleshootingTips().map(
                    (tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Debug Info
            if (_connectionTest != null &&
                _connectionTest!.containsKey('originalError'))
              _buildSectionCard(
                'Debug Information',
                Icons.bug_report,
                Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Technical details for developers:',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _connectionTest!['originalError'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: 'monospace',
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: _connectionTest!['originalError'],
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Error copied to clipboard',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy, size: 16),
                                label: const Text('Copy Error'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildSectionCard(
    String title,
    IconData icon,
    Color color, {
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResult(String testName, bool passed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            passed ? Icons.check_circle : Icons.error,
            color: passed ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(testName, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            passed ? 'PASS' : 'FAIL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: passed ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorInfo(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 16),
              SizedBox(width: 8),
              Text(
                'Error Details:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            NetworkUtils.getNetworkErrorMessage(error),
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Color _getDiagnosticsColor() {
    if (_diagnosticsResult == null) return Colors.grey;
    if (_diagnosticsResult!.containsKey('error')) return Colors.red;

    final hasInternet = _diagnosticsResult!['hasInternet'] ?? false;
    final canReachSupabase = _diagnosticsResult!['canReachSupabase'] ?? false;

    if (hasInternet && canReachSupabase) return Colors.green;
    if (hasInternet) return Colors.orange;
    return Colors.red;
  }

  Color _getConnectionColor() {
    if (_connectionTest == null) return Colors.grey;
    return _connectionTest!['status'] == 'success' ? Colors.green : Colors.red;
  }
}

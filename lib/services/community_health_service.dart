import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/symptom_analysis.dart';
import 'package:crypto/crypto.dart';

class CommunityHealthService {
  static final CommunityHealthService _instance =
      CommunityHealthService._internal();
  factory CommunityHealthService() => _instance;
  CommunityHealthService._internal();

  static const String _queueKey = 'community_health_queue';
  List<Map<String, dynamic>> _pendingReports = [];

  /// Submit anonymized symptom data for community health monitoring
  Future<void> submitSymptomData({
    required List<String> symptoms,
    required String primaryCondition,
    required String severity,
    required Map<String, dynamic> location,
    required String ageGroup,
    required String gender,
  }) async {
    try {
      // Generate device-based anonymous ID
      final deviceId = await _getDeviceId();

      final reportData = {
        'symptoms': symptoms,
        'primaryCondition': primaryCondition,
        'severity': severity,
        'location': location,
        'ageGroup': ageGroup,
        'gender': gender,
        'deviceId': deviceId,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Try to submit immediately if online
      final success = await _submitToBackend(reportData);

      if (!success) {
        // Queue for later submission if offline
        await _queueForLaterSubmission(reportData);
      }
    } catch (e) {
      print('Error submitting symptom data: $e');
      // Always queue on error for retry
      await _queueForLaterSubmission({
        'symptoms': symptoms,
        'primaryCondition': primaryCondition,
        'severity': severity,
        'location': location,
        'ageGroup': ageGroup,
        'gender': gender,
        'deviceId': await _getDeviceId(),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }
  }

  /// Submit symptom analysis result for community health monitoring
  Future<void> submitSymptomAnalysisResult(
    SymptomAnalysis analysis,
    Map<String, dynamic> userProfile,
  ) async {
    // Extract relevant data for community health
    final symptoms = analysis.symptomsText
        .split(',')
        .map((s) => s.trim())
        .toList();
    final primaryCondition = analysis.conditions.isNotEmpty
        ? analysis.conditions.first.name
        : analysis.disease;
    final severity = _mapSeverityToLevel(analysis.urgencyLevel);

    await submitSymptomData(
      symptoms: symptoms,
      primaryCondition: primaryCondition,
      severity: severity,
      location: userProfile['location'] ?? {},
      ageGroup: _mapAgeToGroup(userProfile['age']),
      gender: userProfile['gender'] ?? 'other',
    );
  }

  /// Get active health alerts for user's location
  Future<List<Map<String, dynamic>>> getHealthAlerts(
    Map<String, dynamic> location,
  ) async {
    try {
      final baseUrl = ApiConfig.baseUrl;
      final queryParams = <String, String>{};

      if (location['pincode'] != null) {
        queryParams['pincode'] = location['pincode'].toString();
      }
      if (location['coordinates'] != null) {
        queryParams['lat'] = location['coordinates']['lat'].toString();
        queryParams['lng'] = location['coordinates']['lng'].toString();
      }

      final uri = Uri.parse(
        '$baseUrl/community-health/alerts',
      ).replace(queryParameters: queryParams);

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['alerts'] ?? []);
      }
    } catch (e) {
      print('Error fetching health alerts: $e');
    }

    return [];
  }

  /// Process queued symptom reports when connection is restored
  Future<void> processQueuedReports() async {
    await _loadQueue();

    if (_pendingReports.isEmpty) return;

    final List<Map<String, dynamic>> successfullySubmitted = [];

    for (final report in _pendingReports) {
      final success = await _submitToBackend(report);
      if (success) {
        successfullySubmitted.add(report);
      }
    }

    // Remove successfully submitted reports from queue
    _pendingReports.removeWhere(
      (report) => successfullySubmitted.contains(report),
    );
    await _saveQueue();

    print(
      'Community Health: Processed ${successfullySubmitted.length} queued reports',
    );
  }

  /// Submit data to backend
  Future<bool> _submitToBackend(Map<String, dynamic> reportData) async {
    try {
      final baseUrl = ApiConfig.baseUrl;
      final response = await http
          .post(
            Uri.parse('$baseUrl/community-health/symptoms'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(reportData),
          )
          .timeout(Duration(seconds: 15));

      if (response.statusCode == 201) {
        final result = json.decode(response.body);
        print(
          'Community Health: Symptom data submitted successfully - ${result['message']}',
        );
        return true;
      } else {
        print('Community Health: Failed to submit - ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Community Health: Network error - $e');
      return false;
    }
  }

  /// Queue report for later submission
  Future<void> _queueForLaterSubmission(Map<String, dynamic> reportData) async {
    await _loadQueue();
    _pendingReports.add(reportData);
    await _saveQueue();
    print('Community Health: Queued symptom report for later submission');
  }

  /// Generate anonymous device ID
  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('community_health_device_id');

    if (deviceId == null) {
      // Generate a unique ID based on app installation
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final randomData = DateTime.now().toString() + timestamp;
      deviceId = sha256
          .convert(utf8.encode(randomData))
          .toString()
          .substring(0, 16);
      await prefs.setString('community_health_device_id', deviceId);
    }

    return deviceId;
  }

  /// Map severity level to standardized format
  String _mapSeverityToLevel(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'emergency':
      case 'severe':
        return 'emergency';
      case 'high':
        return 'high';
      case 'medium':
      case 'moderate':
        return 'moderate';
      case 'low':
      case 'mild':
      default:
        return 'low';
    }
  }

  /// Map age to age group
  String _mapAgeToGroup(dynamic age) {
    if (age == null) return '19-35'; // Default group

    final ageInt = age is String ? int.tryParse(age) ?? 25 : age as int;

    if (ageInt <= 5) return '0-5';
    if (ageInt <= 18) return '6-18';
    if (ageInt <= 35) return '19-35';
    if (ageInt <= 60) return '36-60';
    return '60+';
  }

  /// Load queued reports from local storage
  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueJson = prefs.getString(_queueKey);
      if (queueJson != null) {
        _pendingReports = List<Map<String, dynamic>>.from(
          json.decode(queueJson).map((item) => Map<String, dynamic>.from(item)),
        );
      }
    } catch (e) {
      print('Error loading community health queue: $e');
      _pendingReports = [];
    }
  }

  /// Save queued reports to local storage
  Future<void> _saveQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_queueKey, json.encode(_pendingReports));
    } catch (e) {
      print('Error saving community health queue: $e');
    }
  }

  /// Get queue status for debugging
  Future<Map<String, dynamic>> getQueueStatus() async {
    await _loadQueue();
    return {
      'queuedReports': _pendingReports.length,
      'oldestReport': _pendingReports.isNotEmpty
          ? _pendingReports.first['timestamp']
          : null,
    };
  }

  /// Clear all queued reports (for testing/reset)
  Future<void> clearQueue() async {
    _pendingReports.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_queueKey);
  }
}

/// Widget to display health alerts to users
class HealthAlertBanner extends StatefulWidget {
  final Map<String, dynamic> location;

  const HealthAlertBanner({Key? key, required this.location}) : super(key: key);

  @override
  _HealthAlertBannerState createState() => _HealthAlertBannerState();
}

class _HealthAlertBannerState extends State<HealthAlertBanner> {
  List<Map<String, dynamic>> alerts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    final communityHealthService = CommunityHealthService();
    final fetchedAlerts = await communityHealthService.getHealthAlerts(
      widget.location,
    );

    setState(() {
      alerts = fetchedAlerts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(height: 4, child: LinearProgressIndicator());
    }

    if (alerts.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      children: alerts.map((alert) => _buildAlertCard(alert)).toList(),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final severity = alert['severity'] ?? 'low';
    final message = alert['message'] ?? {};

    Color alertColor = _getSeverityColor(severity);
    IconData alertIcon = _getSeverityIcon(severity);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        color: alertColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: alertColor.withOpacity(0.3)),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(alertIcon, color: alertColor, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['title'] ?? 'Health Alert',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: alertColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      message['message'] ?? '',
                      style: TextStyle(fontSize: 13),
                    ),
                    if (message['precautions'] != null) ...[
                      SizedBox(height: 8),
                      Text(
                        'Precautions:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      ...List<String>.from(message['precautions'])
                          .take(2)
                          .map(
                            (precaution) => Text(
                              '• $precaution',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'moderate':
        return Colors.yellow[700]!;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.emergency;
      case 'high':
        return Icons.warning;
      case 'moderate':
        return Icons.info;
      case 'low':
        return Icons.health_and_safety;
      default:
        return Icons.notifications;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommunityHealthDashboard extends StatefulWidget {
  @override
  _CommunityHealthDashboardState createState() =>
      _CommunityHealthDashboardState();
}

class _CommunityHealthDashboardState extends State<CommunityHealthDashboard> {
  List<Map<String, dynamic>> activeAlerts = [];
  Map<String, dynamic> healthStatistics = {};
  bool isLoading = true;
  String selectedTimeRange = '7';
  String selectedLocation = 'all';

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    setState(() => isLoading = true);

    try {
      // Load health statistics
      final statsResponse = await http.get(
        Uri.parse(
          'http://192.168.1.7:5002/api/community-health/statistics?timeRange=$selectedTimeRange',
        ),
      );

      if (statsResponse.statusCode == 200) {
        healthStatistics = json.decode(statsResponse.body);
      }

      // Load active alerts
      final alertsResponse = await http.get(
        Uri.parse('http://192.168.1.7:5002/api/community-health/alerts'),
      );

      if (alertsResponse.statusCode == 200) {
        final alertsData = json.decode(alertsResponse.body);
        activeAlerts = List<Map<String, dynamic>>.from(
          alertsData['alerts'] ?? [],
        );
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Health Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: loadDashboardData),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildControlsSection(),
                  SizedBox(height: 20),
                  _buildAlertOverview(),
                  SizedBox(height: 20),
                  _buildStatisticsCards(),
                  SizedBox(height: 20),
                  _buildActiveAlerts(),
                  SizedBox(height: 20),
                  _buildTrendCharts(),
                ],
              ),
            ),
    );
  }

  Widget _buildControlsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Time Range'),
                  DropdownButton<String>(
                    value: selectedTimeRange,
                    onChanged: (value) {
                      setState(() => selectedTimeRange = value!);
                      loadDashboardData();
                    },
                    items: [
                      DropdownMenuItem(
                        value: '1',
                        child: Text('Last 24 hours'),
                      ),
                      DropdownMenuItem(value: '3', child: Text('Last 3 days')),
                      DropdownMenuItem(value: '7', child: Text('Last 7 days')),
                      DropdownMenuItem(
                        value: '30',
                        child: Text('Last 30 days'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () => _showOutbreakSimulator(context),
              icon: Icon(Icons.science),
              label: Text('Test Outbreak Detection'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertOverview() {
    final stats = healthStatistics['statistics'] ?? {};
    final totalReports = stats['totalReports'] ?? 0;
    final activeAlertsCount = stats['activeAlerts'] ?? 0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Health Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildMetricCard(
                  'Total Reports',
                  totalReports.toString(),
                  Icons.report,
                  Colors.blue,
                ),
                SizedBox(width: 10),
                _buildMetricCard(
                  'Active Alerts',
                  activeAlertsCount.toString(),
                  Icons.warning,
                  activeAlertsCount > 0 ? Colors.red : Colors.green,
                ),
                SizedBox(width: 10),
                _buildMetricCard(
                  'Conditions',
                  (stats['uniqueConditions'] ?? 0).toString(),
                  Icons.health_and_safety,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildTrendCard(
            'Reports Trend',
            'Last $selectedTimeRange days',
            Icons.trending_up,
            Colors.green,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildTrendCard(
            'Alert Activity',
            '${activeAlerts.length} active',
            Icons.notifications,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Text(subtitle, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 16),
            Container(
              height: 60,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateSampleTrendData(),
                      isCurved: true,
                      color: color,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
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

  Widget _buildActiveAlerts() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Health Alerts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (activeAlerts.isNotEmpty)
                  Chip(
                    label: Text('${activeAlerts.length}'),
                    backgroundColor: Colors.red.withOpacity(0.1),
                  ),
              ],
            ),
            SizedBox(height: 16),
            if (activeAlerts.isEmpty)
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 30),
                    SizedBox(width: 16),
                    Text(
                      'No active health alerts in your monitoring area',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              ...activeAlerts.map((alert) => _buildAlertCard(alert)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    Color severityColor = _getSeverityColor(alert['severity']);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: severityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      alert['severity'].toString().toUpperCase(),
                      style: TextStyle(
                        color: severityColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    alert['area'] ?? '',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                alert['message']?['title'] ?? 'Health Alert',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                alert['message']?['message'] ?? '',
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.medical_services,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Condition: ${alert['condition']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Text(
                    _formatDate(alert['issuedAt']),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendCharts() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const conditions = [
                            'GI',
                            'Resp',
                            'Vector',
                            'Skin',
                            'Neuro',
                          ];
                          if (value.toInt() < conditions.length) {
                            return Text(conditions[value.toInt()]);
                          }
                          return Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _generateSampleBarData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity?.toLowerCase()) {
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

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  List<FlSpot> _generateSampleTrendData() {
    // Generate sample trend data
    return [
      FlSpot(0, 1),
      FlSpot(1, 3),
      FlSpot(2, 2),
      FlSpot(3, 5),
      FlSpot(4, 3),
      FlSpot(5, 4),
      FlSpot(6, 6),
    ];
  }

  List<BarChartGroupData> _generateSampleBarData() {
    return [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 6)]),
      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4)]),
      BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 3)]),
    ];
  }

  void _showOutbreakSimulator(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Outbreak Detection Simulator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Simulate an outbreak scenario for testing the detection system.',
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _simulateOutbreak('gastrointestinal'),
              child: Text('Simulate GI Outbreak'),
            ),
            ElevatedButton(
              onPressed: () => _simulateOutbreak('respiratory'),
              child: Text('Simulate Respiratory Outbreak'),
            ),
            ElevatedButton(
              onPressed: () => _simulateOutbreak('vector_borne'),
              child: Text('Simulate Vector-borne Outbreak'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _simulateOutbreak(String conditionType) async {
    // Simulate multiple symptom reports to trigger outbreak detection
    final conditions = {
      'gastrointestinal': ['diarrhea', 'vomiting', 'stomach pain'],
      'respiratory': ['cough', 'fever', 'cold'],
      'vector_borne': ['dengue', 'fever', 'headache'],
    };

    final symptoms = conditions[conditionType] ?? ['fever'];

    for (int i = 0; i < 8; i++) {
      await _submitSimulatedReport(symptoms[i % symptoms.length]);
      await Future.delayed(Duration(milliseconds: 500));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Outbreak simulation completed. Checking for alerts...'),
      ),
    );

    // Reload data after simulation
    await Future.delayed(Duration(seconds: 2));
    loadDashboardData();
  }

  Future<void> _submitSimulatedReport(String condition) async {
    final reportData = {
      'symptoms': [condition, 'fever'],
      'primaryCondition': condition,
      'severity': 'moderate',
      'location': {
        'state': 'Test State',
        'district': 'Test District',
        'block': 'Test Block',
        'village': 'Test Village',
        'pincode': '123456',
        'coordinates': {'lat': 12.9716, 'lng': 77.5946},
      },
      'ageGroup': '19-35',
      'gender': 'male',
      'deviceId':
          'simulator_${DateTime.now().millisecondsSinceEpoch}_$condition',
    };

    try {
      await http.post(
        Uri.parse('http://192.168.1.7:5002/api/community-health/symptoms'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(reportData),
      );
    } catch (e) {
      print('Error submitting simulated report: $e');
    }
  }
}

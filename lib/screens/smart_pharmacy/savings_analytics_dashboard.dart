import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:fl_chart/fl_chart.dart'; // TODO: Add fl_chart dependency
import '../../providers/smart_pharmacy_provider.dart';

class SavingsAnalyticsDashboard extends StatefulWidget {
  final String patientId;

  const SavingsAnalyticsDashboard({super.key, required this.patientId});

  @override
  State<SavingsAnalyticsDashboard> createState() =>
      _SavingsAnalyticsDashboardState();
}

class _SavingsAnalyticsDashboardState extends State<SavingsAnalyticsDashboard> {
  Map<String, dynamic>? _analytics;
  bool _isLoading = true;
  String _selectedPeriod = '30d';

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    try {
      final provider = Provider.of<SmartPharmacyProvider>(
        context,
        listen: false,
      );
      final analytics = await provider.getPatientSavingsAnalytics(
        patientId: widget.patientId,
        period: _selectedPeriod,
      );

      setState(() {
        _analytics = analytics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load analytics: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Analytics'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (period) {
              setState(() {
                _selectedPeriod = period;
              });
              _loadAnalytics();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '7d', child: Text('Last 7 Days')),
              const PopupMenuItem(value: '30d', child: Text('Last 30 Days')),
              const PopupMenuItem(value: '90d', child: Text('Last 90 Days')),
              const PopupMenuItem(value: '1y', child: Text('Last Year')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getPeriodLabel(_selectedPeriod)),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _analytics == null
          ? _buildErrorView()
          : _buildAnalyticsView(),
    );
  }

  String _getPeriodLabel(String period) {
    switch (period) {
      case '7d':
        return '7 Days';
      case '30d':
        return '30 Days';
      case '90d':
        return '90 Days';
      case '1y':
        return '1 Year';
      default:
        return '30 Days';
    }
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Failed to load analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Please try again later'),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: _loadAnalytics, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildAnalyticsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSavingsSummaryCard(),
          const SizedBox(height: 16),
          _buildSavingsBreakdownCard(),
          const SizedBox(height: 16),
          _buildTrendsChart(),
          const SizedBox(height: 16),
          _buildTopSavingCategoriesCard(),
          const SizedBox(height: 16),
          _buildSchemeUtilizationCard(),
          const SizedBox(height: 16),
          _buildRecommendationsCard(),
        ],
      ),
    );
  }

  Widget _buildSavingsSummaryCard() {
    final totalSavings = _analytics!['totalSavings'] ?? 0.0;
    final prescriptionsAnalyzed = _analytics!['prescriptionsAnalyzed'] ?? 0;
    final averageSavings = _analytics!['averageSavingsPerPrescription'] ?? 0.0;

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Colors.green[400]!, Colors.green[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.savings, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Total Savings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              '₹${totalSavings.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prescriptions Analyzed',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      Text(
                        '$prescriptionsAnalyzed',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Avg. Savings/Prescription',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                      Text(
                        '₹${averageSavings.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsBreakdownCard() {
    final breakdown = _analytics!['savingsBreakdown'] ?? {};
    final genericSavings = breakdown['genericAlternatives'] ?? 0.0;
    final schemeSavings = breakdown['schemeSubsidies'] ?? 0.0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Savings Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildSavingsBreakdownItem(
                    'Generic Alternatives',
                    genericSavings,
                    Icons.swap_horiz,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSavingsBreakdownItem(
                    'Scheme Subsidies',
                    schemeSavings,
                    Icons.account_balance,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsBreakdownItem(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsChart() {
    final monthlyTrend = _analytics!['monthlyTrend'] as List<dynamic>? ?? [];

    if (monthlyTrend.isEmpty) {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Savings Trend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('No data available for the selected period'),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Savings Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 200,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Savings Trend Chart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: monthlyTrend.map((trend) {
                          final savings = (trend['savings'] as num).toDouble();
                          final maxSavings = 600.0; // Max for scaling
                          final height = (savings / maxSavings) * 120;

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '₹${savings.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 20,
                                height: height,
                                decoration: BoxDecoration(
                                  color: Colors.green[600],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trend['month'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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

  Widget _buildTopSavingCategoriesCard() {
    final categories =
        _analytics!['topSavingCategories'] as List<dynamic>? ?? [];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Saving Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (categories.isEmpty)
              Text('No category data available')
            else
              ...categories.map((category) {
                final categoryName = category['category'] ?? 'Unknown';
                final savings =
                    (category['savings'] as num?)?.toDouble() ?? 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value:
                                  savings /
                                  500, // Normalize to max expected savings
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green[600]!,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '₹${savings.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeUtilizationCard() {
    final schemes = _analytics!['schemesUtilized'] as List<dynamic>? ?? [];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance,
                  color: Colors.orange[700],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Scheme Utilization',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (schemes.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text('No government schemes utilized yet'),
                  ],
                ),
              )
            else
              ...schemes.map((scheme) {
                final schemeName = scheme['schemeName'] ?? 'Unknown';
                final utilizationCount = scheme['utilizationCount'] ?? 0;
                final totalSavings =
                    (scheme['totalSavings'] as num?)?.toDouble() ?? 0.0;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schemeName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Used $utilizationCount times',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${totalSavings.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.purple[700],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Smart Recommendations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildRecommendationItem(
              'Visit Jan Aushadhi Centers',
              'Save up to 80% on your regular medicines by visiting nearby government pharmacies.',
              Icons.account_balance,
              Colors.orange,
              () => Navigator.pushNamed(context, '/pharmacy-locator'),
            ),

            const SizedBox(height: 12),

            _buildRecommendationItem(
              'Request Generic Alternatives',
              'Always ask your pharmacist for generic versions of prescribed medicines.',
              Icons.swap_horiz,
              Colors.blue,
              () => _showGenericTips(),
            ),

            const SizedBox(height: 12),

            _buildRecommendationItem(
              'Track Your Savings',
              'Use Smart Pharmacy Engine for every prescription to maximize your savings.',
              Icons.analytics,
              Colors.green,
              () => _showSavingsTips(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  void _showGenericTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generic Medicine Tips'),
        content: const Text(
          'Generic medicines contain the same active ingredients as brand-name drugs but cost significantly less. '
          'Always ask your pharmacist: "Do you have a generic version of this medicine?"',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showSavingsTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Maximize Your Savings'),
        content: const Text(
          '• Always check prescription analysis before buying medicines\n'
          '• Visit Jan Aushadhi centers for government subsidized rates\n'
          '• Compare prices at multiple pharmacies\n'
          '• Keep track of your government scheme eligibility',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

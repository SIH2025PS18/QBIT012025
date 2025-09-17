import 'package:flutter/material.dart';
import '../screens/smart_pharmacy/prescription_analysis_screen.dart';
import '../screens/smart_pharmacy/pharmacy_locator_screen.dart';
import '../screens/smart_pharmacy/savings_analytics_dashboard.dart';

/// Demo integration showing how to add Smart Pharmacy features to existing screens
class SmartPharmacyIntegrationDemo extends StatelessWidget {
  const SmartPharmacyIntegrationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Pharmacy Integration Demo'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('1. Patient Dashboard Integration'),
            _buildPatientDashboardDemo(),

            const SizedBox(height: 24),
            _buildSectionHeader('2. Doctor Prescription Integration'),
            _buildDoctorPrescriptionDemo(),

            const SizedBox(height: 24),
            _buildSectionHeader('3. Pharmacy Search Integration'),
            _buildPharmacySearchDemo(),

            const SizedBox(height: 24),
            _buildSectionHeader('4. Family Health Integration'),
            _buildFamilyHealthDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildPatientDashboardDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add these tiles to your patient dashboard:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildDashboardTile(
                  'Smart Pharmacy',
                  Icons.local_pharmacy,
                  Colors.green,
                  'Find cheapest medicines & government schemes',
                  () {},
                ),
                _buildDashboardTile(
                  'Savings Analytics',
                  Icons.analytics,
                  Colors.purple,
                  'Track your medicine cost savings',
                  () {},
                ),
                _buildDashboardTile(
                  'Prescription Analysis',
                  Icons.description,
                  Colors.blue,
                  'Optimize prescription costs',
                  () {},
                ),
                _buildDashboardTile(
                  'Jan Aushadhi Finder',
                  Icons.account_balance,
                  Colors.orange,
                  'Government pharmacy locator',
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => _navigateToFeature(context, title),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorPrescriptionDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add to doctor\'s prescription screen:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // Mock prescription form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prescribed Medicines:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildMedicineItem(
                    'Paracetamol 500mg',
                    '10 tablets',
                    '₹15.00',
                  ),
                  _buildMedicineItem(
                    'Amoxicillin 250mg',
                    '21 capsules',
                    '₹45.00',
                  ),
                  _buildMedicineItem(
                    'Metformin 500mg',
                    '30 tablets',
                    '₹120.00',
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          label: const Text('Complete Prescription'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Builder(
                          builder: (context) => ElevatedButton.icon(
                            onPressed: () => _showPrescriptionAnalysis(context),
                            icon: const Icon(Icons.savings),
                            label: const Text('Optimize Costs'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                            ),
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
    );
  }

  Widget _buildMedicineItem(String name, String quantity, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Text(quantity, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(width: 16),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPharmacySearchDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add to medicine purchase flow:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[50]!, Colors.purple[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.purple[700],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Find Best Medicine Prices Near You',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Compare prices at regular pharmacies and Jan Aushadhi centers. Save up to 80% on your medicines!',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Builder(
                      builder: (context) => ElevatedButton.icon(
                        onPressed: () => _navigateToPharmacyLocator(context),
                        icon: const Icon(Icons.search),
                        label: const Text('Find Pharmacies'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
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

  Widget _buildFamilyHealthDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add to family health dashboard:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[50]!, Colors.green[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.family_restroom,
                        color: Colors.green[700],
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Family Medicine Savings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildSavingsMetric(
                          'This Month',
                          '₹2,450',
                          'saved',
                        ),
                      ),
                      Expanded(
                        child: _buildSavingsMetric(
                          'This Year',
                          '₹18,200',
                          'saved',
                        ),
                      ),
                      Expanded(
                        child: _buildSavingsMetric(
                          'Avg. Savings',
                          '45%',
                          'per prescription',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Builder(
                      builder: (context) => ElevatedButton.icon(
                        onPressed: () => _navigateToSavingsAnalytics(context),
                        icon: const Icon(Icons.analytics),
                        label: const Text('View Detailed Analytics'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
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

  Widget _buildSavingsMetric(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        Text(unit, style: TextStyle(fontSize: 12, color: Colors.green[600])),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  void _navigateToFeature(BuildContext context, String feature) {
    switch (feature) {
      case 'Smart Pharmacy':
        _navigateToPharmacyLocator(context);
        break;
      case 'Savings Analytics':
        _navigateToSavingsAnalytics(context);
        break;
      case 'Prescription Analysis':
        _showPrescriptionAnalysis(context);
        break;
      case 'Jan Aushadhi Finder':
        _navigateToPharmacyLocator(context);
        break;
    }
  }

  void _navigateToPharmacyLocator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PharmacyLocatorScreen()),
    );
  }

  void _navigateToSavingsAnalytics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const SavingsAnalyticsDashboard(patientId: 'DEMO_PATIENT_001'),
      ),
    );
  }

  void _showPrescriptionAnalysis(BuildContext context) {
    // Sample prescription data for demo
    final samplePrescription = [
      {
        'medicineId': 'paracetamol_500mg',
        'name': 'Paracetamol 500mg',
        'quantity': 10,
        'price': 15.00,
        'composition': 'Paracetamol',
        'strength': '500mg',
      },
      {
        'medicineId': 'amoxicillin_250mg',
        'name': 'Amoxicillin 250mg',
        'quantity': 21,
        'price': 45.00,
        'composition': 'Amoxicillin',
        'strength': '250mg',
      },
      {
        'medicineId': 'metformin_500mg',
        'name': 'Metformin 500mg',
        'quantity': 30,
        'price': 120.00,
        'composition': 'Metformin HCl',
        'strength': '500mg',
      },
    ];

    final samplePatientProfile = {
      'patientId': 'DEMO_PATIENT_001',
      'doctorId': 'DEMO_DOCTOR_001',
      'annualIncome': 150000,
      'hasRationCard': true,
      'hasESICCard': false,
      'area': 'rural',
      'state': 'uttar_pradesh',
      'latitude': 28.7041,
      'longitude': 77.1025,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrescriptionAnalysisScreen(
          prescriptionId: 'DEMO_PRESC_${DateTime.now().millisecondsSinceEpoch}',
          prescribedMedicines: samplePrescription,
          patientProfile: samplePatientProfile,
        ),
      ),
    );
  }
}

/// Extension methods to easily add Smart Pharmacy features to existing widgets
extension SmartPharmacyExtensions on Widget {
  /// Add Smart Pharmacy cost optimization button to any prescription form
  Widget withCostOptimization(
    BuildContext context,
    List<Map<String, dynamic>> medicines,
    Map<String, dynamic> patientProfile,
  ) {
    return Column(
      children: [
        this,
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.savings, color: Colors.green[700], size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Optimize medicine costs with Smart Pharmacy',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrescriptionAnalysisScreen(
                        prescriptionId:
                            'PRESC_${DateTime.now().millisecondsSinceEpoch}',
                        prescribedMedicines: medicines,
                        patientProfile: patientProfile,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Optimize'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Add pharmacy finder button to any medicine-related screen
  Widget withPharmacyFinder(BuildContext context) {
    return Column(
      children: [
        this,
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PharmacyLocatorScreen(),
                ),
              );
            },
            icon: const Icon(Icons.local_pharmacy),
            label: const Text('Find Nearby Pharmacies'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[700],
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

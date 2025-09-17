import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medicine.dart';
import '../../models/smart_pharmacy_models.dart';
import '../../providers/smart_pharmacy_provider.dart';

class PrescriptionAnalysisScreen extends StatefulWidget {
  final String prescriptionId;
  final List<Map<String, dynamic>> prescribedMedicines;
  final Map<String, dynamic> patientProfile;

  const PrescriptionAnalysisScreen({
    super.key,
    required this.prescriptionId,
    required this.prescribedMedicines,
    required this.patientProfile,
  });

  @override
  State<PrescriptionAnalysisScreen> createState() =>
      _PrescriptionAnalysisScreenState();
}

class _PrescriptionAnalysisScreenState
    extends State<PrescriptionAnalysisScreen> {
  PrescriptionAnalysis? _analysis;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _analyzePrescription();
  }

  Future<void> _analyzePrescription() async {
    setState(() => _isLoading = true);

    final provider = Provider.of<SmartPharmacyProvider>(context, listen: false);

    final analysis = await provider.analyzePrescription(
      prescriptionId: widget.prescriptionId,
      patientId: widget.patientProfile['patientId'] ?? 'unknown',
      doctorId: widget.patientProfile['doctorId'] ?? 'unknown',
      prescribedMedicines: widget.prescribedMedicines,
      patientProfile: widget.patientProfile,
    );

    setState(() {
      _analysis = analysis;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Pharmacy Analysis'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _analysis == null
          ? _buildErrorView()
          : _buildAnalysisView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Failed to analyze prescription',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Please try again later'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _analyzePrescription,
            child: const Text('Retry Analysis'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSavingsSummaryCard(),
          const SizedBox(height: 16),
          if (_analysis!.hasSchemeEligibility) ...[
            _buildSchemeEligibilityCard(),
            const SizedBox(height: 16),
          ],
          _buildMedicineAnalysisCards(),
          const SizedBox(height: 16),
          _buildPharmacyRecommendationsCard(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSavingsSummaryCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.savings, color: Colors.green[700], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Potential Savings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Original Cost',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        '₹${_analysis!.originalTotalCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'You Save',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        '₹${_analysis!.totalSavings.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Text(
                        '(${_analysis!.savingsPercentage.toStringAsFixed(1)}% off)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Optimized Cost: ₹${_analysis!.optimizedTotalCost.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800],
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

  Widget _buildSchemeEligibilityCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance, color: Colors.blue[700], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Government Scheme Benefits',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[50]!, Colors.orange[100]!],
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
                      Icon(Icons.verified, color: Colors.orange[700], size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Jan Aushadhi Scheme Eligible',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your prescribed medicines are available at subsidized rates under government schemes.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Additional 30-50% savings possible',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
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

  Widget _buildMedicineAnalysisCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medicine-wise Analysis',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ..._analysis!.originalMedicines.map((prescMed) {
          return _buildMedicineCard(prescMed);
        }).toList(),
      ],
    );
  }

  Widget _buildMedicineCard(PrescribedMedicine prescMed) {
    final hasAlternatives = prescMed.genericAlternatives.isNotEmpty;
    final hasSchemeSupport = prescMed.schemeEligibility.isNotEmpty;
    final bestAlternative = prescMed.bestGenericAlternative;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prescMed.medicine.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${prescMed.medicine.chemicalComposition} • ${prescMed.medicine.strength}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        'Qty: ${prescMed.quantity} • ₹${prescMed.medicine.price.toStringAsFixed(2)} each',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '₹${prescMed.totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            if (hasAlternatives || hasSchemeSupport) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
            ],

            // Generic Alternative
            if (hasAlternatives && bestAlternative != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.swap_horiz,
                          color: Colors.green[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Generic Alternative Available',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        children: [
                          const TextSpan(text: 'Ask for '),
                          TextSpan(
                            text: bestAlternative.genericMedicine.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' instead of '),
                          TextSpan(
                            text: prescMed.medicine.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Save ₹${(bestAlternative.costSavings * prescMed.quantity).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${bestAlternative.savingsPercentage.toStringAsFixed(0)}% off',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            // Scheme Support
            if (hasSchemeSupport) ...[
              if (hasAlternatives) const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance,
                          color: Colors.orange[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Government Scheme Coverage',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ...prescMed.schemeEligibility.map((scheme) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• ${scheme.schemeName}: ${scheme.isFullyCovered ? "Free" : "₹${scheme.subsidyAmount.toStringAsFixed(2)} subsidy"}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],

            if (!hasAlternatives && !hasSchemeSupport) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'No additional savings options available for this medicine',
                        style: TextStyle(fontSize: 14),
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

  Widget _buildPharmacyRecommendationsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_pharmacy, color: Colors.purple[700], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Recommended Pharmacies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (_analysis!.janAushadhiCenters.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.green[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Jan Aushadhi Centers',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._analysis!.janAushadhiCenters.take(3).map((center) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                center,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            ElevatedButton.icon(
              onPressed: () {
                // Navigate to pharmacy locator
                Navigator.pushNamed(context, '/pharmacy-locator');
              },
              icon: const Icon(Icons.map),
              label: const Text('Find Nearby Pharmacies'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _shareAnalysis();
            },
            icon: const Icon(Icons.share),
            label: const Text('Share Analysis with Pharmacist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              _downloadPrescription();
            },
            icon: const Icon(Icons.download),
            label: const Text('Download Optimized Prescription'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  void _shareAnalysis() {
    // Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analysis shared successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _downloadPrescription() {
    // Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prescription downloaded to your device!'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class DigitalHealthLockerScreen extends StatefulWidget {
  const DigitalHealthLockerScreen({super.key});

  @override
  State<DigitalHealthLockerScreen> createState() =>
      _DigitalHealthLockerScreenState();
}

class _DigitalHealthLockerScreenState extends State<DigitalHealthLockerScreen> {
  bool _isOnline = false;
  int _selectedIndex = 0;

  // Mock data for demonstration
  final List<Map<String, dynamic>> _pastConsultations = [
    {
      'id': '1',
      'doctorName': 'Dr. Singh',
      'specialization': 'General Medicine',
      'date': '2023-10-15',
      'summary': 'Routine checkup, blood pressure monitoring',
      'prescription': 'Paracetamol 500mg - 1 tablet twice daily for 5 days',
    },
    {
      'id': '2',
      'doctorName': 'Dr. Kaur',
      'specialization': 'Pediatrics',
      'date': '2023-09-22',
      'summary': 'Child vaccination and growth monitoring',
      'prescription': 'Multivitamin syrup - 5ml once daily for 30 days',
    },
    {
      'id': '3',
      'doctorName': 'Dr. Patel',
      'specialization': 'Cardiology',
      'date': '2023-08-10',
      'summary': 'Heart checkup, ECG and blood tests',
      'prescription':
          'Aspirin 75mg - 1 tablet daily, Atenolol 50mg - 1 tablet daily',
    },
  ];

  final List<Map<String, dynamic>> _prescriptions = [
    {
      'id': '1',
      'doctorName': 'Dr. Singh',
      'date': '2023-10-15',
      'medications': [
        'Paracetamol 500mg - 1 tablet twice daily for 5 days',
        'Vitamin C - 1 tablet once daily for 10 days',
      ],
      'notes': 'Take with food. Complete the full course.',
    },
    {
      'id': '2',
      'doctorName': 'Dr. Kaur',
      'date': '2023-09-22',
      'medications': ['Multivitamin syrup - 5ml once daily for 30 days'],
      'notes': 'Shake well before use. Store in refrigerator.',
    },
  ];

  final List<Map<String, dynamic>> _labReports = [
    {
      'id': '1',
      'title': 'Complete Blood Count',
      'date': '2023-10-15',
      'hospital': 'Nabha Civil Hospital',
      'status': 'Normal',
    },
    {
      'id': '2',
      'title': 'Lipid Profile',
      'date': '2023-08-10',
      'hospital': 'Nabha Civil Hospital',
      'status': 'Requires follow-up',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Digital Health Locker',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          // Network status indicator
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _isOnline ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isOnline ? Icons.wifi : Icons.wifi_off,
                    size: 16,
                    color: _isOnline ? Colors.green[700] : Colors.orange[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _isOnline ? Colors.green[700] : Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab bar
            Container(
              color: Colors.white,
              child: TabBar(
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                tabs: const [
                  Tab(text: 'Consultations'),
                  Tab(text: 'Prescriptions'),
                  Tab(text: 'Lab Reports'),
                ],
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildConsultationsTab(),
                  _buildPrescriptionsTab(),
                  _buildLabReportsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Past Consultations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          if (_pastConsultations.isEmpty) ...[
            _buildEmptyState(
              icon: Icons.video_call,
              title: 'No consultations yet',
              subtitle: 'Your past video consultations will appear here',
            ),
          ] else ...[
            ..._pastConsultations.map((consultation) {
              return _buildConsultationCard(consultation);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildPrescriptionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Digital Prescriptions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          if (_prescriptions.isEmpty) ...[
            _buildEmptyState(
              icon: Icons.description,
              title: 'No prescriptions yet',
              subtitle: 'Your digital prescriptions will appear here',
            ),
          ] else ...[
            ..._prescriptions.map((prescription) {
              return _buildPrescriptionCard(prescription);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildLabReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lab Reports',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          if (_labReports.isEmpty) ...[
            _buildEmptyState(
              icon: Icons.assignment,
              title: 'No lab reports yet',
              subtitle: 'Your lab reports will appear here',
            ),
          ] else ...[
            ..._labReports.map((report) {
              return _buildLabReportCard(report);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildConsultationCard(Map<String, dynamic> consultation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.video_call, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consultation['doctorName'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      consultation['specialization'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                consultation['date'],
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Summary:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            consultation['summary'],
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          const Text(
            'Prescription:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            consultation['prescription'],
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  // View detailed consultation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Viewing consultation details'),
                    ),
                  );
                },
                child: const Text('View Details'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Download as PDF
                  _downloadConsultationAsPdf(consultation);
                },
                child: const Text('Download'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(Map<String, dynamic> prescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prescription header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.description, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prescription from ${prescription['doctorName']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        prescription['date'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Medications list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Medications:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                ...prescription['medications'].map<Widget>((med) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.medication,
                          size: 16,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            med,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                if (prescription['notes'].isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prescription['notes'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // Save prescription
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Prescription saved to device'),
                      ),
                    );
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Share prescription
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Prescription shared')),
                    );
                  },
                  child: const Text(
                    'Share',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Print prescription
                    _printPrescription(prescription);
                  },
                  child: const Text(
                    'Print',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabReportCard(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                  color: report['status'] == 'Normal'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  report['status'] == 'Normal'
                      ? Icons.check_circle
                      : Icons.warning,
                  color: report['status'] == 'Normal'
                      ? Colors.green
                      : Colors.orange,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      report['hospital'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                report['date'],
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: report['status'] == 'Normal'
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: report['status'] == 'Normal'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
            child: Text(
              report['status'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: report['status'] == 'Normal'
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  // View detailed report
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Viewing lab report details')),
                  );
                },
                child: const Text('View Details'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Download report
                  _downloadLabReport(report);
                },
                child: const Text('Download'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _downloadConsultationAsPdf(
    Map<String, dynamic> consultation,
  ) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text(
                'Consultation Summary',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Doctor: ${consultation['doctorName']}'),
              pw.Text('Specialization: ${consultation['specialization']}'),
              pw.Text('Date: ${consultation['date']}'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Summary:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(consultation['summary']),
              pw.SizedBox(height: 20),
              pw.Text(
                'Prescription:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(consultation['prescription']),
            ],
          ),
        ),
      );

      // Save to device
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/consultation_${consultation['id']}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Saved to ${file.path}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save PDF: $e')));
      }
    }
  }

  Future<void> _printPrescription(Map<String, dynamic> prescription) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Prescription',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Doctor: ${prescription['doctorName']}'),
              pw.Text('Date: ${prescription['date']}'),
              pw.SizedBox(height: 30),
              pw.Text(
                'Medications:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              ...prescription['medications']
                  .map(
                    (med) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 10),
                      child: pw.Text('• $med'),
                    ),
                  )
                  .toList(),
              if (prescription['notes'].isNotEmpty) ...[
                pw.SizedBox(height: 20),
                pw.Text(
                  'Notes:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(prescription['notes']),
              ],
            ],
          ),
        ),
      );

      await Printing.layoutPdf(onLayout: (_) => pdf.save());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to print: $e')));
      }
    }
  }

  Future<void> _downloadLabReport(Map<String, dynamic> report) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            children: [
              pw.Text(
                'Lab Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Title: ${report['title']}'),
              pw.Text('Hospital: ${report['hospital']}'),
              pw.Text('Date: ${report['date']}'),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(border: pw.Border.all()),
                child: pw.Text(
                  'Status: ${report['status']}',
                  style: pw.TextStyle(
                    color: report['status'] == 'Normal'
                        ? PdfColors.green
                        : PdfColors.orange,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // Save to device
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/lab_report_${report['id']}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Saved to ${file.path}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save PDF: $e')));
      }
    }
  }
}

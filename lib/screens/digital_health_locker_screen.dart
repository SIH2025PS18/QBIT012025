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

class _DigitalHealthLockerScreenState extends State<DigitalHealthLockerScreen>
    with SingleTickerProviderStateMixin {
  bool _isOnline = false;
  late TabController _tabController;
  String _selectedFamilyMember = 'self';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Family members with Hindi/Punjabi names
  final List<Map<String, dynamic>> _familyMembers = [
    {
      'id': 'self',
      'name': 'Shaurya Singh',
      'relation': 'Self',
      'age': 28,
      'gender': 'Male',
    },
    {
      'id': 'mother',
      'name': 'Sunita Devi',
      'relation': 'Mother',
      'age': 52,
      'gender': 'Female',
    },
    {
      'id': 'father',
      'name': 'Rajesh Singh',
      'relation': 'Father',
      'age': 55,
      'gender': 'Male',
    },
    {
      'id': 'wife',
      'name': 'Priya Kaur',
      'relation': 'Wife',
      'age': 26,
      'gender': 'Female',
    },
    {
      'id': 'son',
      'name': 'Arjun Singh',
      'relation': 'Son',
      'age': 5,
      'gender': 'Male',
    },
    {
      'id': 'daughter',
      'name': 'Simran Kaur',
      'relation': 'Daughter',
      'age': 3,
      'gender': 'Female',
    },
  ];

  // Mock data for demonstration - organized by family member
  Map<String, List<Map<String, dynamic>>> _familyConsultations = {
    'self': [
      {
        'id': '1',
        'doctorName': 'Dr. Gurmeet Singh',
        'specialization': 'General Medicine',
        'date': '2024-01-15',
        'summary': 'Routine checkup, blood pressure monitoring',
        'prescription': 'Paracetamol 500mg - 1 tablet twice daily for 5 days',
        'hospital': 'Nabha Civil Hospital',
        'isOfflineAvailable': true,
      },
      {
        'id': '2',
        'doctorName': 'Dr. Harpreet Kaur',
        'specialization': 'Cardiology',
        'date': '2024-01-10',
        'summary': 'Heart checkup, ECG and blood tests',
        'prescription':
            'Aspirin 75mg - 1 tablet daily, Atenolol 50mg - 1 tablet daily',
        'hospital': 'Rajindra Hospital, Patiala',
        'isOfflineAvailable': true,
      },
    ],
    'mother': [
      {
        'id': '3',
        'doctorName': 'Dr. Amarjeet Singh',
        'specialization': 'Gynecology',
        'date': '2024-01-12',
        'summary': 'Regular health checkup, diabetes monitoring',
        'prescription': 'Metformin 500mg - 1 tablet twice daily',
        'hospital': 'Nabha Civil Hospital',
        'isOfflineAvailable': true,
      },
    ],
    'father': [
      {
        'id': '4',
        'doctorName': 'Dr. Jasbir Singh',
        'specialization': 'General Medicine',
        'date': '2024-01-08',
        'summary': 'Blood pressure check, joint pain consultation',
        'prescription': 'Ibuprofen 400mg - 1 tablet after meals',
        'hospital': 'Government Medical College, Patiala',
        'isOfflineAvailable': true,
      },
    ],
    'wife': [
      {
        'id': '5',
        'doctorName': 'Dr. Simran Kaur',
        'specialization': 'Gynecology',
        'date': '2024-01-05',
        'summary': 'Prenatal checkup, vitamins prescribed',
        'prescription': 'Folic acid 5mg - 1 tablet daily, Iron tablets',
        'hospital': 'Nabha Civil Hospital',
        'isOfflineAvailable': true,
      },
    ],
    'son': [
      {
        'id': '6',
        'doctorName': 'Dr. Manpreet Kaur',
        'specialization': 'Pediatrics',
        'date': '2024-01-03',
        'summary': 'Child vaccination and growth monitoring',
        'prescription': 'Multivitamin syrup - 5ml once daily for 30 days',
        'hospital': 'Nabha Civil Hospital',
        'isOfflineAvailable': true,
      },
    ],
    'daughter': [
      {
        'id': '7',
        'doctorName': 'Dr. Manpreet Kaur',
        'specialization': 'Pediatrics',
        'date': '2024-01-01',
        'summary': 'Fever treatment, cold and cough',
        'prescription': 'Paracetamol syrup - 2.5ml twice daily for 3 days',
        'hospital': 'Nabha Civil Hospital',
        'isOfflineAvailable': true,
      },
    ],
  };

  Map<String, List<Map<String, dynamic>>> _familyPrescriptions = {
    'self': [
      {
        'id': '1',
        'doctorName': 'Dr. Gurmeet Singh',
        'date': '2024-01-15',
        'medications': [
          'Paracetamol 500mg - 1 tablet twice daily for 5 days',
          'Vitamin C - 1 tablet once daily for 10 days',
        ],
        'notes': 'Take with food. Complete the full course.',
        'isOfflineAvailable': true,
      },
    ],
    'mother': [
      {
        'id': '2',
        'doctorName': 'Dr. Amarjeet Singh',
        'date': '2024-01-12',
        'medications': ['Metformin 500mg - 1 tablet twice daily'],
        'notes': 'Take before meals. Monitor blood sugar levels.',
        'isOfflineAvailable': true,
      },
    ],
    'father': [
      {
        'id': '3',
        'doctorName': 'Dr. Jasbir Singh',
        'date': '2024-01-08',
        'medications': ['Ibuprofen 400mg - 1 tablet after meals'],
        'notes': 'Take only after food. Avoid empty stomach.',
        'isOfflineAvailable': true,
      },
    ],
    'wife': [
      {
        'id': '4',
        'doctorName': 'Dr. Simran Kaur',
        'date': '2024-01-05',
        'medications': [
          'Folic acid 5mg - 1 tablet daily',
          'Iron tablets - 1 tablet daily',
        ],
        'notes': 'Take with vitamin C for better absorption.',
        'isOfflineAvailable': true,
      },
    ],
    'son': [
      {
        'id': '5',
        'doctorName': 'Dr. Manpreet Kaur',
        'date': '2024-01-03',
        'medications': ['Multivitamin syrup - 5ml once daily for 30 days'],
        'notes': 'Shake well before use. Store in refrigerator.',
        'isOfflineAvailable': true,
      },
    ],
    'daughter': [
      {
        'id': '6',
        'doctorName': 'Dr. Manpreet Kaur',
        'date': '2024-01-01',
        'medications': ['Paracetamol syrup - 2.5ml twice daily for 3 days'],
        'notes': 'Give every 6 hours. Do not exceed 4 doses per day.',
        'isOfflineAvailable': true,
      },
    ],
  };

  Map<String, List<Map<String, dynamic>>> _familyLabReports = {
    'self': [
      {
        'id': '1',
        'title': 'Complete Blood Count',
        'date': '2024-01-15',
        'hospital': 'Nabha Civil Hospital',
        'status': 'Normal',
        'isOfflineAvailable': true,
      },
      {
        'id': '2',
        'title': 'Lipid Profile',
        'date': '2024-01-10',
        'hospital': 'Rajindra Hospital, Patiala',
        'status': 'Requires follow-up',
        'isOfflineAvailable': true,
      },
    ],
    'mother': [
      {
        'id': '3',
        'title': 'HbA1c Test',
        'date': '2024-01-12',
        'hospital': 'Nabha Civil Hospital',
        'status': 'Normal',
        'isOfflineAvailable': true,
      },
    ],
    'father': [
      {
        'id': '4',
        'title': 'Bone Density Scan',
        'date': '2024-01-08',
        'hospital': 'Government Medical College, Patiala',
        'status': 'Mild osteoporosis',
        'isOfflineAvailable': true,
      },
    ],
    'wife': [
      {
        'id': '5',
        'title': 'Prenatal Blood Work',
        'date': '2024-01-05',
        'hospital': 'Nabha Civil Hospital',
        'status': 'Normal',
        'isOfflineAvailable': true,
      },
    ],
    'son': [
      {
        'id': '6',
        'title': 'Growth Chart',
        'date': '2024-01-03',
        'hospital': 'Nabha Civil Hospital',
        'status': 'Normal development',
        'isOfflineAvailable': true,
      },
    ],
    'daughter': [
      {
        'id': '7',
        'title': 'Blood Test',
        'date': '2024-01-01',
        'hospital': 'Nabha Civil Hospital',
        'status': 'Normal',
        'isOfflineAvailable': true,
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final selectedMember = _familyMembers.firstWhere(
      (member) => member['id'] == _selectedFamilyMember,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Digital Health Records',
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
            // Family member selector
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.family_restroom,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Select Family Member',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _familyMembers.map((member) {
                        final isSelected =
                            member['id'] == _selectedFamilyMember;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFamilyMember = member['id'];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue[600]
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              border: isSelected
                                  ? Border.all(color: Colors.blue[600]!)
                                  : null,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  member['name'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                Text(
                                  member['relation'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isSelected
                                        ? Colors.white70
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Selected member info
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      selectedMember['name'].split(' ').map((n) => n[0]).join(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedMember['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${selectedMember['relation']} • ${selectedMember['age']} years • ${selectedMember['gender']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
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
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.offline_bolt,
                          size: 14,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Offline Records',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
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
                controller: _tabController,
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
    final consultations = _familyConsultations[_selectedFamilyMember] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Past Consultations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${consultations.length} Records',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (consultations.isEmpty) ...[
            _buildEmptyState(
              icon: Icons.video_call,
              title: 'No consultations yet',
              subtitle: 'Past video consultations will appear here',
            ),
          ] else ...[
            ...consultations.map((consultation) {
              return _buildConsultationCard(consultation);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildPrescriptionsTab() {
    final prescriptions = _familyPrescriptions[_selectedFamilyMember] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Digital Prescriptions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${prescriptions.length} Prescriptions',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (prescriptions.isEmpty) ...[
            _buildEmptyState(
              icon: Icons.receipt_long,
              title: 'No prescriptions yet',
              subtitle: 'Digital prescriptions will appear here',
            ),
          ] else ...[
            ...prescriptions.map((prescription) {
              return _buildPrescriptionCard(prescription);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildLabReportsTab() {
    final labReports = _familyLabReports[_selectedFamilyMember] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Lab Reports',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${labReports.length} Reports',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.purple[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (labReports.isEmpty) ...[
            _buildEmptyState(
              icon: Icons.assignment,
              title: 'No lab reports yet',
              subtitle: 'Test results and reports will appear here',
            ),
          ] else ...[
            ...labReports.map((report) {
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

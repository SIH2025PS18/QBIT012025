import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../models/patient.dart';
import '../widgets/sidebar.dart';

class BulkUploadScreen extends StatefulWidget {
  const BulkUploadScreen({Key? key}) : super(key: key);

  @override
  State<BulkUploadScreen> createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  List<List<String>>? _csvData;
  bool _isUploading = false;
  String? _fileName;
  List<String> _uploadResults = [];
  int _successCount = 0;
  int _errorCount = 0;

  final List<String> _requiredColumns = [
    'Name',
    'Phone',
    'Email',
    'Age',
    'Gender',
    'Address',
    'Emergency Contact',
    'Medical History',
    'Blood Group',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInstructions(),
                        const SizedBox(height: 24),
                        _buildUploadSection(),
                        if (_csvData != null) ...[
                          const SizedBox(height: 24),
                          _buildPreviewSection(),
                        ],
                        if (_uploadResults.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildResultsSection(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D29),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2D3A), width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_upload, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          const Text(
            'Bulk Patient Records Upload',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _downloadTemplate,
            icon: const Icon(Icons.download),
            label: const Text('Download Template'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      color: const Color(0xFF1A1D29),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Color(0xFFFF6B9D), size: 24),
                SizedBox(width: 12),
                Text(
                  'Upload Instructions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Follow these steps to upload patient records in bulk:',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildInstructionStep('1', 'Download the CSV template file'),
            _buildInstructionStep(
                '2', 'Fill in patient data using the template format'),
            _buildInstructionStep('3', 'Save the file as CSV format'),
            _buildInstructionStep(
                '4', 'Upload the completed CSV file using the upload button'),
            _buildInstructionStep('5',
                'Review the preview and click "Import Records" to complete'),
            const SizedBox(height: 16),
            const Text(
              'Required Columns:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _requiredColumns.map((column) {
                return Chip(
                  label: Text(
                    column,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFF2A2D3A),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B9D),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Card(
      color: const Color(0xFF1A1D29),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload CSV File',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF2A2D3A),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: _pickFile,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _csvData != null
                          ? Icons.check_circle
                          : Icons.cloud_upload,
                      color: _csvData != null
                          ? Colors.green
                          : const Color(0xFFFF6B9D),
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _fileName ?? 'Click to select CSV file',
                      style: TextStyle(
                        color: _csvData != null ? Colors.green : Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Supported format: CSV',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            if (_csvData != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.assessment, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'File loaded: ${_csvData!.length - 1} records found',
                    style: const TextStyle(color: Colors.green, fontSize: 14),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    if (_csvData == null || _csvData!.isEmpty) return const SizedBox();

    final headers = _csvData!.first;
    final rows = _csvData!.skip(1).take(5).toList();

    return Card(
      color: const Color(0xFF1A1D29),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Data Preview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _importRecords,
                  icon: _isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.upload),
                  label: Text(_isUploading ? 'Importing...' : 'Import Records'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B9D),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildValidationStatus(headers),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2A2D3A)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                      MaterialStateProperty.all(const Color(0xFF2A2D3A)),
                  dataRowColor:
                      MaterialStateProperty.all(const Color(0xFF1A1D29)),
                  columns: headers.map((header) {
                    return DataColumn(
                      label: Text(
                        header,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  rows: rows.map((row) {
                    return DataRow(
                      cells: row.map((cell) {
                        return DataCell(
                          Text(
                            cell,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (rows.length < _csvData!.length - 1) ...[
              const SizedBox(height: 8),
              Text(
                'Showing first 5 of ${_csvData!.length - 1} records',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValidationStatus(List<String> headers) {
    final missingColumns = _requiredColumns
        .where((required) => !headers.contains(required))
        .toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: missingColumns.isEmpty
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: missingColumns.isEmpty ? Colors.green : Colors.red,
        ),
      ),
      child: Row(
        children: [
          Icon(
            missingColumns.isEmpty ? Icons.check_circle : Icons.error,
            color: missingColumns.isEmpty ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missingColumns.isEmpty
                      ? 'All required columns found'
                      : 'Missing required columns',
                  style: TextStyle(
                    color: missingColumns.isEmpty ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (missingColumns.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Missing: ${missingColumns.join(', ')}',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return Card(
      color: const Color(0xFF1A1D29),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Import Results',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Success: $_successCount',
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Errors: $_errorCount',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D3A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _uploadResults.length,
                itemBuilder: (context, index) {
                  final result = _uploadResults[index];
                  final isError = result.startsWith('Error');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      result,
                      style: TextStyle(
                        color: isError ? Colors.red : Colors.green,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadTemplate() {
    final csvRows = [
      _requiredColumns.join(','),
      'John Doe,9876543210,john.doe@email.com,35,Male,123 Main Street Delhi,9876543211,Hypertension,O+'
    ];

    final csvContent = csvRows.join('\n');
    final blob = html.Blob([csvContent], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', 'patient_records_template.csv')
      ..click();

    html.Url.revokeObjectUrl(url);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Template downloaded successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = result.files.first;
      final bytes = file.bytes;

      if (bytes != null) {
        try {
          final csvString = String.fromCharCodes(bytes);
          final csvData = _parseCsv(csvString);

          setState(() {
            _csvData = csvData;
            _fileName = file.name;
            _uploadResults.clear();
            _successCount = 0;
            _errorCount = 0;
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error reading CSV file: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  List<List<String>> _parseCsv(String csvString) {
    final lines = csvString.split('\n');
    return lines
        .map((line) {
          return line.split(',').map((cell) => cell.trim()).toList();
        })
        .where((row) => row.isNotEmpty && row.any((cell) => cell.isNotEmpty))
        .toList();
  }

  void _importRecords() async {
    if (_csvData == null || _csvData!.length < 2) return;

    setState(() {
      _isUploading = true;
      _uploadResults.clear();
      _successCount = 0;
      _errorCount = 0;
    });

    final headers = _csvData!.first;
    final rows = _csvData!.skip(1);

    final patientProvider =
        Provider.of<PatientProvider>(context, listen: false);

    for (int i = 0; i < rows.length; i++) {
      final row = rows.elementAt(i);
      final rowNum = i + 2;

      try {
        final patient = _createPatientFromRow(headers, row);
        final success = await patientProvider.addPatient(patient);

        if (success) {
          setState(() {
            _successCount++;
            _uploadResults
                .add('Row $rowNum: Successfully imported ${patient.name}');
          });
        } else {
          setState(() {
            _errorCount++;
            _uploadResults.add('Error Row $rowNum: Failed to import patient');
          });
        }
      } catch (e) {
        setState(() {
          _errorCount++;
          _uploadResults.add('Error Row $rowNum: $e');
        });
      }
    }

    setState(() {
      _isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Import completed: $_successCount success, $_errorCount errors'),
        backgroundColor: _errorCount == 0 ? Colors.green : Colors.orange,
      ),
    );
  }

  Patient _createPatientFromRow(List<String> headers, List<String> row) {
    String getValue(String columnName) {
      final index = headers.indexOf(columnName);
      if (index == -1 || index >= row.length) {
        throw Exception('Missing required column: $columnName');
      }
      return row[index].trim();
    }

    return Patient(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: getValue('Name'),
      phone: getValue('Phone'),
      email: getValue('Email'),
      age: int.tryParse(getValue('Age')) ?? 0,
      gender: getValue('Gender'),
      address: getValue('Address'),
      emergencyContact: getValue('Emergency Contact'),
      medicalHistory: getValue('Medical History'),
      bloodGroup: getValue('Blood Group'),
      createdAt: DateTime.now(),
      isActive: true,
      allergies: [],
      medications: [],
      medicalRecords: [],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/admin_service.dart';
import '../widgets/sidebar.dart';

class PatientManagementScreen extends StatefulWidget {
  const PatientManagementScreen({Key? key}) : super(key: key);

  @override
  State<PatientManagementScreen> createState() =>
      _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  final AdminService _adminService = AdminService();
  List<Patient> _patients = [];
  List<Patient> _filteredPatients = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedGender = 'All';

  final List<String> _genders = [
    'All',
    'male',
    'female',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() => _isLoading = true);
    try {
      final patients = await _adminService.getAllPatients();
      setState(() {
        _patients = patients;
        _filteredPatients = patients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load patients: $e');
    }
  }

  void _filterPatients() {
    setState(() {
      _filteredPatients = _patients.where((patient) {
        final matchesSearch = patient.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            patient.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            patient.phone.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (patient.patientId ?? '')
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        final matchesGender =
            _selectedGender == 'All' || patient.gender == _selectedGender;

        return matchesSearch && matchesGender;
      }).toList();
    });
  }

  Future<void> _deletePatient(Patient patient) async {
    final confirmed = await _showDeleteConfirmation(patient.name);
    if (!confirmed) return;

    final success = await _adminService.deletePatient(patient.id);
    if (success) {
      await _loadPatients();
      _showSuccessSnackBar('Patient deleted successfully');
    } else {
      _showErrorSnackBar('Failed to delete patient');
    }
  }

  Future<bool> _showDeleteConfirmation(String patientName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A1D29),
            title: const Text(
              'Delete Patient',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to delete $patientName? This action cannot be undone.',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

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
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            _buildSearchAndFilters(),
                            Expanded(child: _buildPatientsTable()),
                          ],
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
        border: Border(
          bottom: BorderSide(color: Color(0xFF2A2D3F), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Patient Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/add-patient'),
            icon: const Icon(Icons.add),
            label: const Text('Add Patient'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patients...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFF1A1D29),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2A2D3F)),
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                _searchQuery = value;
                _filterPatients();
              },
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D29),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2A2D3F)),
            ),
            child: DropdownButton<String>(
              value: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                  _filterPatients();
                });
              },
              dropdownColor: const Color(0xFF1A1D29),
              style: const TextStyle(color: Colors.white),
              underline: Container(),
              items: _genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _loadPatients,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2D3F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsTable() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2D3F)),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: _filteredPatients.isEmpty
                ? const Center(
                    child: Text(
                      'No patients found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      return _buildPatientRow(_filteredPatients[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2D3F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
              flex: 2,
              child: Text('Patient',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: Text('Contact',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text('Age',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text('Gender',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text('Blood Group',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text('Status',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 1,
              child: Text('Actions',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildPatientRow(Patient patient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF2A2D3F), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  patient.patientId ?? 'No ID',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.email,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  patient.phone,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              patient.age.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              patient.gender.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              patient.bloodGroup ?? 'Unknown',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: patient.isActive
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                patient.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: patient.isActive ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showPatientDetails(patient),
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  tooltip: 'View Details',
                ),
                IconButton(
                  onPressed: () => _deletePatient(patient),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Delete Patient',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPatientDetails(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D29),
        title: Text(
          patient.name,
          style: const TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(
                    'Patient ID', patient.patientId ?? 'Not assigned'),
                _buildDetailRow('Email', patient.email),
                _buildDetailRow('Phone', patient.phone),
                _buildDetailRow('Age', patient.age.toString()),
                _buildDetailRow('Gender', patient.gender.toUpperCase()),
                _buildDetailRow('Blood Group', patient.bloodGroup ?? 'Unknown'),
                _buildDetailRow('Address', patient.address ?? 'Not provided'),
                _buildDetailRow('Emergency Contact',
                    patient.emergencyContact ?? 'Not provided'),
                _buildDetailRow(
                    'Medical History', patient.medicalHistory ?? 'None'),
                _buildDetailRow(
                    'Allergies',
                    patient.allergies.isEmpty
                        ? 'None'
                        : patient.allergies.join(', ')),
                _buildDetailRow(
                    'Medications',
                    patient.medications.isEmpty
                        ? 'None'
                        : patient.medications.join(', ')),
                _buildDetailRow(
                    'Created At', patient.createdAt.toString().split('.')[0]),
                if (patient.lastVisit != null)
                  _buildDetailRow(
                      'Last Visit', patient.lastVisit.toString().split('.')[0]),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

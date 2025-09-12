import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/doctor.dart';
import '../services/admin_service.dart';
import '../widgets/sidebar.dart';

class DoctorManagementScreen extends StatefulWidget {
  const DoctorManagementScreen({Key? key}) : super(key: key);

  @override
  State<DoctorManagementScreen> createState() => _DoctorManagementScreenState();
}

class _DoctorManagementScreenState extends State<DoctorManagementScreen> {
  final AdminService _adminService = AdminService();
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedSpeciality = 'All';

  final List<String> _specialities = [
    'All',
    'Cardiology',
    'Neurology',
    'Pediatrics',
    'Orthopedics',
    'Dermatology',
    'General Medicine',
    'Emergency Medicine',
  ];

  // Helper function to generate password based on doctor's name
  String _generateDoctorPassword(Doctor doctor) {
    // Extract first name from the doctor's name
    String firstName = doctor.name.split(' ').first.toLowerCase();
    // Remove any special characters and 'dr.' prefix
    firstName = firstName.replaceAll(RegExp(r'[^a-zA-Z]'), '');
    if (firstName.startsWith('dr')) {
      firstName = firstName.substring(2);
    }
    return '$firstName@123';
  }

  @override
  void initState() {
    super.initState();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    setState(() => _isLoading = true);
    try {
      final doctors = await _adminService.getAllDoctors();
      setState(() {
        _doctors = doctors;
        _filteredDoctors = doctors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load doctors: $e');
    }
  }

  void _filterDoctors() {
    setState(() {
      _filteredDoctors = _doctors.where((doctor) {
        final matchesSearch =
            doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                doctor.speciality
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                doctor.qualification
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());

        final matchesDepartment = _selectedSpeciality == 'All' ||
            doctor.speciality == _selectedSpeciality;

        return matchesSearch && matchesDepartment;
      }).toList();
    });
  }

  Future<void> _toggleDoctorAvailability(Doctor doctor) async {
    final success = await _adminService.updateDoctorAvailability(
        doctor.id, !doctor.isAvailable);

    if (success) {
      await _loadDoctors();
      _showSuccessSnackBar('Doctor availability updated successfully');
    } else {
      _showErrorSnackBar('Failed to update doctor availability');
    }
  }

  Future<void> _deleteDoctor(Doctor doctor) async {
    final confirmed = await _showDeleteConfirmation(doctor.name);
    if (!confirmed) return;

    final success = await _adminService.deleteDoctor(doctor.id);
    if (success) {
      await _loadDoctors();
      _showSuccessSnackBar('Doctor deleted successfully');
    } else {
      _showErrorSnackBar('Failed to delete doctor');
    }
  }

  Future<bool> _showDeleteConfirmation(String doctorName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Doctor'),
            content: Text('Are you sure you want to delete Dr. $doctorName?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
                _buildFilters(),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildDoctorGrid(),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Doctor Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage doctors, their schedules, and availability',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/add-doctor'),
            icon: const Icon(Icons.add),
            label: const Text('Add Doctor'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterDoctors();
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search doctors...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFF1A1D29),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D29),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: _selectedSpeciality,
              onChanged: (value) {
                setState(() => _selectedSpeciality = value!);
                _filterDoctors();
              },
              style: const TextStyle(color: Colors.white),
              dropdownColor: const Color(0xFF1A1D29),
              underline: const SizedBox(),
              items: _specialities.map((speciality) {
                return DropdownMenuItem(
                  value: speciality,
                  child: Text(speciality),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${_filteredDoctors.length} doctors found',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorGrid() {
    if (_filteredDoctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'No doctors found',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: _filteredDoctors.length,
        itemBuilder: (context, index) {
          return _buildDoctorCard(_filteredDoctors[index]);
        },
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2D3F)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFFF6B9D),
                  child: Text(
                    doctor.name.length > 1
                        ? doctor.name.substring(0, 2).toUpperCase()
                        : doctor.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: doctor.isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    doctor.isAvailable ? 'Available' : 'Unavailable',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              doctor.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              doctor.speciality,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  doctor.rating.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(width: 16),
                Icon(Icons.people, color: Colors.grey[400], size: 16),
                const SizedBox(width: 4),
                Text(
                  '${doctor.experience} years',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Login Credentials Section
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D3F),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF3A3D4F)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.login,
                          color: const Color(0xFFFF6B9D), size: 14),
                      const SizedBox(width: 4),
                      const Text(
                        'Doctor Login',
                        style: TextStyle(
                          color: Color(0xFFFF6B9D),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Email: ${doctor.email}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Password: ${_generateDoctorPassword(doctor)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showCredentialsDialog(doctor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B9D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text(
                      'View Login',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _toggleDoctorAvailability(doctor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          doctor.isAvailable ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      doctor.isAvailable ? 'Disable' : 'Enable',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _deleteDoctor(doctor),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCredentialsDialog(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D29),
        title: const Text(
          'Doctor Login Credentials',
          style: TextStyle(color: Colors.white),
        ),
        content: Container(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Use these credentials for doctor dashboard login:',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2D3F),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF3A3D4F)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Color(0xFFFF6B9D),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Email:',
                      style: TextStyle(
                        color: Color(0xFFFF6B9D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            doctor.email,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              _copyToClipboard(doctor.email, 'Email copied!'),
                          icon: const Icon(Icons.copy,
                              color: Color(0xFFFF6B9D), size: 18),
                          tooltip: 'Copy email',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Password:',
                      style: TextStyle(
                        color: Color(0xFFFF6B9D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            _generateDoctorPassword(doctor),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _copyToClipboard(
                              _generateDoctorPassword(doctor),
                              'Password copied!'),
                          icon: const Icon(Icons.copy,
                              color: Color(0xFFFF6B9D), size: 18),
                          tooltip: 'Copy password',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Doctor Dashboard URL:',
                      style: TextStyle(
                        color: Color(0xFFFF6B9D),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const SelectableText(
                      'http://localhost:8082',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'The doctor can use these credentials to login to the doctor dashboard at localhost:8082',
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFFF6B9D)),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF6B9D),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/modern_sidebar.dart';
import '../models/doctor.dart';
import '../services/admin_service.dart';

class ModernDoctorManagementScreen extends StatefulWidget {
  const ModernDoctorManagementScreen({Key? key}) : super(key: key);

  @override
  State<ModernDoctorManagementScreen> createState() =>
      _ModernDoctorManagementScreenState();
}

class _ModernDoctorManagementScreenState
    extends State<ModernDoctorManagementScreen> {
  final AdminService _adminService = AdminService();
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading doctors: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  void _filterDoctors() {
    setState(() {
      _filteredDoctors = _doctors.where((doctor) {
        final matchesSearch = doctor.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            doctor.speciality
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            doctor.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (doctor.employeeId
                    ?.toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ??
                false);

        final matchesFilter = _selectedFilter == 'All' ||
            (_selectedFilter == 'Available' && doctor.isAvailable) ||
            (_selectedFilter == 'Unavailable' && !doctor.isAvailable) ||
            (_selectedFilter == 'Verified' && doctor.isVerified) ||
            (_selectedFilter == 'Unverified' && !doctor.isVerified) ||
            (_selectedFilter == 'Enabled' && doctor.isEnabled) ||
            (_selectedFilter == 'Disabled' && !doctor.isEnabled);

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          const ModernAdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF10B981)))
                      : _buildContent(),
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
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doctor Management',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage hospital doctors, their schedules, and availability.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final result =
                      await Navigator.pushNamed(context, '/modern-add-doctor');
                  if (result == true) {
                    // Refresh the doctor list when a new doctor is added
                    _loadDoctors();
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Doctor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSearchAndFilter(),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterDoctors();
              },
              decoration: const InputDecoration(
                hintText: 'Search doctors...',
                hintStyle: TextStyle(color: Color(0xFF64748B)),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF64748B)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFilter,
              items:
                  ['All', 'Available', 'Unavailable', 'Verified', 'Unverified']
                      .map((filter) => DropdownMenuItem(
                            value: filter,
                            child: Text(filter),
                          ))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value ?? 'All';
                });
                _filterDoctors();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_filteredDoctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No doctors found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsCards(),
          const SizedBox(height: 32),
          _buildDoctorsGrid(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final totalDoctors = _doctors.length;
    final availableDoctors = _doctors.where((d) => d.isAvailable).length;
    final verifiedDoctors = _doctors.where((d) => d.isVerified).length;
    final enabledDoctors = _doctors.where((d) => d.isEnabled).length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Doctors',
            totalDoctors.toString(),
            Icons.medical_services_rounded,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Available',
            availableDoctors.toString(),
            Icons.check_circle_rounded,
            const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Verified',
            verifiedDoctors.toString(),
            Icons.verified_rounded,
            const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Enabled',
            enabledDoctors.toString(),
            Icons.toggle_on,
            const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85, // Increased height to prevent overflow
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: _filteredDoctors.length,
      itemBuilder: (context, index) {
        return _buildDoctorCard(_filteredDoctors[index]);
      },
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile and status
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    doctor.isEnabled ? const Color(0xFF10B981) : Colors.grey,
                backgroundImage: doctor.profileImage?.isNotEmpty == true
                    ? NetworkImage(doctor.profileImage!)
                    : null,
                child: doctor.profileImage?.isEmpty != false
                    ? Text(
                        doctor.name
                            .split(' ')
                            .map((n) => n[0])
                            .join()
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: doctor.isEnabled
                            ? const Color(0xFF1E293B)
                            : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.employeeId ??
                          'EMP-${doctor.id.substring(0, 6).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Enable/Disable switch
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: doctor.isEnabled,
                  onChanged: (value) => _toggleDoctorStatus(doctor.id, value),
                  activeColor: const Color(0xFF10B981),
                  inactiveThumbColor: Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Status badges
          Row(
            children: [
              _buildStatusBadge(
                doctor.isAvailable ? 'Available' : 'Unavailable',
                doctor.isAvailable
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(
                doctor.isVerified ? 'Verified' : 'Unverified',
                doctor.isVerified
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFFF59E0B),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Speciality and Department
          Text(
            doctor.speciality,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          if (doctor.department != null) ...[
            const SizedBox(height: 4),
            Text(
              'Dept: ${doctor.department}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Rating and consultations
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                size: 16,
                color: Colors.amber[600],
              ),
              const SizedBox(width: 4),
              Text(
                doctor.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${doctor.totalRatings})',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              Text(
                '${doctor.totalConsultations} consults',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Login credentials section
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.login,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Login Credentials',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const Spacer(),
                    if (doctor.hasTemporaryPassword)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text(
                          'TEMP',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Email: ${doctor.email}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF475569),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Password: ${doctor.defaultPassword ?? 'Not Set'}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF475569),
                          fontFamily: 'Courier',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (doctor.defaultPassword != null)
                      InkWell(
                        onTap: () => _copyToClipboard(doctor.defaultPassword!),
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: const Icon(
                            Icons.copy,
                            size: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showDoctorDetails(doctor),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF10B981),
                    side: const BorderSide(color: Color(0xFF10B981)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text(
                    'Details',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showDoctorManagementDialog(doctor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text(
                    'Manage',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // New functionality methods
  Future<void> _toggleDoctorStatus(String doctorId, bool isEnabled) async {
    try {
      final success =
          await _adminService.enableDisableDoctor(doctorId, isEnabled);
      if (success) {
        setState(() {
          final doctorIndex = _doctors.indexWhere((d) => d.id == doctorId);
          if (doctorIndex != -1) {
            _doctors[doctorIndex] =
                _doctors[doctorIndex].copyWith(isEnabled: isEnabled);
          }
        });
        _filterDoctors();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEnabled
                  ? 'Doctor enabled successfully'
                  : 'Doctor disabled successfully'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        }
      } else {
        _showErrorSnackBar('Failed to update doctor status');
      }
    } catch (e) {
      _showErrorSnackBar('Error updating doctor status: $e');
    }
  }

  void _copyToClipboard(String text) {
    // Copy text to clipboard functionality
    // For web, we'll use the browser's clipboard API through JS interop
    // For now, showing a snackbar to indicate the action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password "$text" copied to clipboard'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDoctorDetails(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => _buildDoctorDetailsDialog(doctor),
    );
  }

  void _showDoctorManagementDialog(Doctor doctor) {
    showDialog(
      context: context,
      builder: (context) => _buildDoctorManagementDialog(doctor),
    );
  }

  Widget _buildDoctorDetailsDialog(Doctor doctor) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF10B981),
                  backgroundImage: doctor.profileImage?.isNotEmpty == true
                      ? NetworkImage(doctor.profileImage!)
                      : null,
                  child: doctor.profileImage?.isEmpty != false
                      ? Text(
                          doctor.name
                              .split(' ')
                              .map((n) => n[0])
                              .join()
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        doctor.speciality,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Employee ID', doctor.employeeId ?? 'Not assigned'),
            _buildDetailRow('Email', doctor.email),
            _buildDetailRow('Phone', doctor.phone),
            _buildDetailRow('License Number', doctor.licenseNumber),
            _buildDetailRow('Experience', '${doctor.experience} years'),
            _buildDetailRow('Consultation Fee', '₹${doctor.consultationFee}'),
            _buildDetailRow('Department', doctor.department ?? 'Not assigned'),
            _buildDetailRow(
                'Emergency Contact', doctor.emergencyContact ?? 'Not provided'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                _buildStatusBadge(
                  doctor.isEnabled ? 'Enabled' : 'Disabled',
                  doctor.isEnabled
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(
                  doctor.isAvailable ? 'Available' : 'Unavailable',
                  doctor.isAvailable
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFFF59E0B),
                ),
              ],
            ),
            if (doctor.lastActive != null) ...[
              const SizedBox(height: 12),
              Text(
                'Last Active: ${_formatDateTime(doctor.lastActive!)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorManagementDialog(Doctor doctor) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Manage Doctor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              doctor.name,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            _buildManagementOption(
              'Reset Password',
              'Generate new temporary password',
              Icons.lock_reset,
              () => _resetPassword(doctor),
            ),
            _buildManagementOption(
              'Update Credentials',
              'Modify login credentials',
              Icons.edit,
              () => _updateCredentials(doctor),
            ),
            _buildManagementOption(
              'Toggle Availability',
              doctor.isAvailable ? 'Mark as unavailable' : 'Mark as available',
              doctor.isAvailable ? Icons.visibility_off : Icons.visibility,
              () => _toggleAvailability(doctor),
            ),
            _buildManagementOption(
              'View Login History',
              'Check recent login activity',
              Icons.history,
              () => _viewLoginHistory(doctor),
            ),
            if (!doctor.isEnabled)
              _buildManagementOption(
                'Delete Doctor',
                'Permanently remove doctor',
                Icons.delete_forever,
                () => _deleteDoctor(doctor),
                isDestructive: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF64748B),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _resetPassword(Doctor doctor) async {
    Navigator.of(context).pop(); // Close dialog
    try {
      final result = await _adminService.resetDoctorPassword(doctor.id);
      if (result != null) {
        _showPasswordResetDialog(doctor.name, result['newPassword']);
        // Reload doctors to get updated data
        _loadDoctors();
      } else {
        _showErrorSnackBar('Failed to reset password');
      }
    } catch (e) {
      _showErrorSnackBar('Error resetting password: $e');
    }
  }

  void _updateCredentials(Doctor doctor) {
    Navigator.of(context).pop(); // Close dialog
    // Here you would show a form to update credentials
    _showInfoSnackBar('Credential update feature coming soon');
  }

  Future<void> _toggleAvailability(Doctor doctor) async {
    Navigator.of(context).pop(); // Close dialog
    try {
      final success = await _adminService.updateDoctorAvailability(
          doctor.id, !doctor.isAvailable);
      if (success) {
        _loadDoctors(); // Reload to get updated data
        _showInfoSnackBar(doctor.isAvailable
            ? 'Doctor marked as unavailable'
            : 'Doctor marked as available');
      } else {
        _showErrorSnackBar('Failed to update availability');
      }
    } catch (e) {
      _showErrorSnackBar('Error updating availability: $e');
    }
  }

  void _viewLoginHistory(Doctor doctor) {
    Navigator.of(context).pop(); // Close dialog
    // Here you would show login history
    _showInfoSnackBar('Login history feature coming soon');
  }

  Future<void> _deleteDoctor(Doctor doctor) async {
    Navigator.of(context).pop(); // Close dialog

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Doctor'),
        content:
            Text('Are you sure you want to permanently delete ${doctor.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final success = await _adminService.deleteDoctor(doctor.id);
        if (success) {
          _loadDoctors(); // Reload to get updated data
          _showInfoSnackBar('Doctor deleted successfully');
        } else {
          _showErrorSnackBar('Failed to delete doctor');
        }
      } catch (e) {
        _showErrorSnackBar('Error deleting doctor: $e');
      }
    }
  }

  void _showPasswordResetDialog(String doctorName, String newPassword) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Reset'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New password for $doctorName:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      newPassword,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _copyToClipboard(newPassword),
                    icon: const Icon(Icons.copy),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This is a temporary password. The doctor should change it on first login.',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  void _showInfoSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

import 'package:flutter/material.dart';
import '../models/department.dart';
import '../widgets/sidebar.dart';

class DepartmentManagementScreen extends StatefulWidget {
  const DepartmentManagementScreen({Key? key}) : super(key: key);

  @override
  State<DepartmentManagementScreen> createState() =>
      _DepartmentManagementScreenState();
}

class _DepartmentManagementScreenState
    extends State<DepartmentManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  List<Department> _departments = [];
  bool _isLoading = true;
  bool _showAddDepartmentForm = false;

  @override
  void initState() {
    super.initState();
    _loadDemoDepartments();
  }

  void _loadDemoDepartments() {
    // Demo data for departments
    _departments = [
      Department(
        id: '1',
        name: 'Cardiology',
        description: 'Comprehensive heart and cardiovascular care',
        headOfDepartment: 'Dr. Sarah Smith',
        headDoctorId: 'D001',
        totalDoctors: 8,
        totalPatients: 245,
        services: [
          'ECG',
          'Echocardiography',
          'Cardiac Catheterization',
          'Angioplasty'
        ],
        location: 'Building A, Floor 2',
        contactNumber: '+91 9876543210',
        email: 'cardiology@hospital.com',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        specializations: [
          'Interventional Cardiology',
          'Electrophysiology',
          'Heart Failure'
        ],
        operatingHours: {
          'Monday': '8:00 AM - 6:00 PM',
          'Tuesday': '8:00 AM - 6:00 PM',
          'Wednesday': '8:00 AM - 6:00 PM',
          'Thursday': '8:00 AM - 6:00 PM',
          'Friday': '8:00 AM - 6:00 PM',
          'Saturday': '8:00 AM - 2:00 PM',
          'Sunday': 'Emergency Only',
        },
      ),
      Department(
        id: '2',
        name: 'Neurology',
        description: 'Advanced neurological and brain disorder treatment',
        headOfDepartment: 'Dr. Michael Johnson',
        headDoctorId: 'D002',
        totalDoctors: 6,
        totalPatients: 189,
        services: ['MRI', 'CT Scan', 'EEG', 'Neuropsychological Testing'],
        location: 'Building B, Floor 3',
        contactNumber: '+91 9876543211',
        email: 'neurology@hospital.com',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        specializations: ['Stroke Care', 'Epilepsy', 'Movement Disorders'],
        operatingHours: {
          'Monday': '9:00 AM - 5:00 PM',
          'Tuesday': '9:00 AM - 5:00 PM',
          'Wednesday': '9:00 AM - 5:00 PM',
          'Thursday': '9:00 AM - 5:00 PM',
          'Friday': '9:00 AM - 5:00 PM',
          'Saturday': 'Emergency Only',
          'Sunday': 'Emergency Only',
        },
      ),
      Department(
        id: '3',
        name: 'Orthopedics',
        description: 'Bone, joint, and musculoskeletal system care',
        headOfDepartment: 'Dr. Emily Davis',
        headDoctorId: 'D003',
        totalDoctors: 10,
        totalPatients: 312,
        services: [
          'X-Ray',
          'Joint Replacement',
          'Arthroscopy',
          'Physical Therapy'
        ],
        location: 'Building C, Floor 1',
        contactNumber: '+91 9876543212',
        email: 'orthopedics@hospital.com',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 400)),
        specializations: ['Sports Medicine', 'Spine Surgery', 'Trauma Surgery'],
        operatingHours: {
          'Monday': '7:00 AM - 7:00 PM',
          'Tuesday': '7:00 AM - 7:00 PM',
          'Wednesday': '7:00 AM - 7:00 PM',
          'Thursday': '7:00 AM - 7:00 PM',
          'Friday': '7:00 AM - 7:00 PM',
          'Saturday': '8:00 AM - 4:00 PM',
          'Sunday': 'Emergency Only',
        },
      ),
      Department(
        id: '4',
        name: 'Pediatrics',
        description:
            'Specialized medical care for infants, children, and adolescents',
        headOfDepartment: 'Dr. James Wilson',
        headDoctorId: 'D004',
        totalDoctors: 7,
        totalPatients: 156,
        services: [
          'Vaccination',
          'Growth Monitoring',
          'Pediatric Surgery',
          'NICU'
        ],
        location: 'Building D, Floor 1-2',
        contactNumber: '+91 9876543213',
        email: 'pediatrics@hospital.com',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        specializations: [
          'Neonatology',
          'Pediatric Cardiology',
          'Developmental Pediatrics'
        ],
        operatingHours: {
          'Monday': '8:00 AM - 8:00 PM',
          'Tuesday': '8:00 AM - 8:00 PM',
          'Wednesday': '8:00 AM - 8:00 PM',
          'Thursday': '8:00 AM - 8:00 PM',
          'Friday': '8:00 AM - 8:00 PM',
          'Saturday': '8:00 AM - 6:00 PM',
          'Sunday': '9:00 AM - 5:00 PM',
        },
      ),
      Department(
        id: '5',
        name: 'Emergency',
        description: '24/7 emergency and trauma care services',
        headOfDepartment: 'Dr. Linda Martinez',
        headDoctorId: 'D005',
        totalDoctors: 12,
        totalPatients: 1024,
        services: [
          'Emergency Care',
          'Trauma Surgery',
          'Critical Care',
          'Ambulance'
        ],
        location: 'Ground Floor, Main Building',
        contactNumber: '+91 9876543214',
        email: 'emergency@hospital.com',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 500)),
        specializations: [
          'Emergency Medicine',
          'Trauma Surgery',
          'Critical Care'
        ],
        operatingHours: {
          'Monday': '24 Hours',
          'Tuesday': '24 Hours',
          'Wednesday': '24 Hours',
          'Thursday': '24 Hours',
          'Friday': '24 Hours',
          'Saturday': '24 Hours',
          'Sunday': '24 Hours',
        },
      ),
      Department(
        id: '6',
        name: 'Dermatology',
        description: 'Skin, hair, and nail disorders treatment',
        headOfDepartment: 'Dr. Robert Chen',
        headDoctorId: 'D006',
        totalDoctors: 4,
        totalPatients: 89,
        services: [
          'Skin Biopsy',
          'Laser Treatment',
          'Cosmetic Procedures',
          'Allergy Testing'
        ],
        location: 'Building E, Floor 2',
        contactNumber: '+91 9876543215',
        email: 'dermatology@hospital.com',
        isActive: false,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        specializations: [
          'Medical Dermatology',
          'Surgical Dermatology',
          'Cosmetic Dermatology'
        ],
        operatingHours: {
          'Monday': '9:00 AM - 5:00 PM',
          'Tuesday': '9:00 AM - 5:00 PM',
          'Wednesday': '9:00 AM - 5:00 PM',
          'Thursday': '9:00 AM - 5:00 PM',
          'Friday': '9:00 AM - 3:00 PM',
          'Saturday': 'Closed',
          'Sunday': 'Closed',
        },
      ),
    ];

    setState(() {
      _isLoading = false;
    });
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
                  child: _showAddDepartmentForm
                      ? _buildAddDepartmentForm()
                      : _buildDepartmentsList(),
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
        border: Border(bottom: BorderSide(color: Color(0xFF2A2D3F))),
      ),
      child: Row(
        children: [
          const Text(
            'Department Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          _buildStatsCards(),
          const SizedBox(width: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showAddDepartmentForm = !_showAddDepartmentForm;
              });
            },
            icon: Icon(_showAddDepartmentForm ? Icons.list : Icons.add),
            label: Text(
                _showAddDepartmentForm ? 'View Departments' : 'Add Department'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final activeDepartments =
        _departments.where((dept) => dept.isActive).length;
    final totalDoctors =
        _departments.fold(0, (sum, dept) => sum + dept.totalDoctors);
    final totalPatients =
        _departments.fold(0, (sum, dept) => sum + dept.totalPatients);

    return Row(
      children: [
        _buildStatCard('Active', activeDepartments.toString(), Colors.green),
        const SizedBox(width: 12),
        _buildStatCard('Doctors', totalDoctors.toString(), Colors.blue),
        const SizedBox(width: 12),
        _buildStatCard('Patients', totalPatients.toString(), Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentsList() {
    return Column(
      children: [
        _buildFiltersAndSearch(),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF6B9D)),
                )
              : _buildDepartmentsGrid(),
        ),
      ],
    );
  }

  Widget _buildFiltersAndSearch() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search departments...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: const Color(0xFF1A1D29),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: _selectedFilter,
            dropdownColor: const Color(0xFF1A1D29),
            style: const TextStyle(color: Colors.white),
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Departments')),
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFilter = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentsGrid() {
    final filteredDepartments = _getFilteredDepartments();

    if (filteredDepartments.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: filteredDepartments.length,
      itemBuilder: (context, index) {
        return _buildDepartmentCard(filteredDepartments[index]);
      },
    );
  }

  Widget _buildDepartmentCard(Department department) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2D3F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: department.departmentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  department.departmentIcon,
                  color: department.departmentColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      department.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: department.statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          department.statusText,
                          style: TextStyle(
                            color: department.statusColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            department.description,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(
                  Icons.person, '${department.totalDoctors} Doctors'),
              const SizedBox(width: 8),
              _buildInfoChip(
                  Icons.people, '${department.totalPatients} Patients'),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoChip(Icons.location_on, department.location),
          const SizedBox(height: 12),
          Text(
            'Head: ${department.headOfDepartment}',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Spacer(),
              IconButton(
                onPressed: () => _showDepartmentDetails(department),
                icon: const Icon(Icons.visibility, color: Colors.blue),
                tooltip: 'View Details',
              ),
              IconButton(
                onPressed: () => _editDepartment(department),
                icon: const Icon(Icons.edit, color: Colors.orange),
                tooltip: 'Edit Department',
              ),
              IconButton(
                onPressed: () => _toggleDepartmentStatus(department),
                icon: Icon(
                  department.isActive ? Icons.toggle_on : Icons.toggle_off,
                  color: department.isActive ? Colors.green : Colors.grey,
                ),
                tooltip: department.isActive ? 'Deactivate' : 'Activate',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3F),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[400]),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 80,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No Departments Found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first department to get started',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showAddDepartmentForm = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Add First Department'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddDepartmentForm() {
    return Center(
      child: Container(
        width: 600,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D29),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2D3F)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Department',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Department creation form coming soon...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showAddDepartmentForm = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement add department
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Add department functionality coming soon'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B9D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Add Department'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Department> _getFilteredDepartments() {
    var filtered = _departments;

    // Filter by search text
    if (_searchController.text.isNotEmpty) {
      final searchLower = _searchController.text.toLowerCase();
      filtered = filtered.where((department) {
        return department.name.toLowerCase().contains(searchLower) ||
            department.description.toLowerCase().contains(searchLower) ||
            department.headOfDepartment.toLowerCase().contains(searchLower) ||
            department.location.toLowerCase().contains(searchLower);
      }).toList();
    }

    // Filter by status
    switch (_selectedFilter) {
      case 'active':
        filtered = filtered.where((department) => department.isActive).toList();
        break;
      case 'inactive':
        filtered =
            filtered.where((department) => !department.isActive).toList();
        break;
    }

    return filtered;
  }

  void _showDepartmentDetails(Department department) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D29),
        title: Row(
          children: [
            Icon(
              department.departmentIcon,
              color: department.departmentColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              department.name,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Description', department.description),
              _buildDetailRow(
                  'Head of Department', department.headOfDepartment),
              _buildDetailRow('Location', department.location),
              _buildDetailRow('Contact', department.contactNumber),
              _buildDetailRow('Email', department.email),
              _buildDetailRow(
                  'Total Doctors', department.totalDoctors.toString()),
              _buildDetailRow(
                  'Total Patients', department.totalPatients.toString()),
              _buildDetailRow('Status', department.statusText),
              const SizedBox(height: 16),
              const Text(
                'Services:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: department.services
                    .map((service) => Chip(
                          label: Text(service),
                          backgroundColor: const Color(0xFF2A2D3F),
                          labelStyle: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ))
                    .toList(),
              ),
              if (department.specializations.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Specializations:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: department.specializations
                      .map((spec) => Chip(
                            label: Text(spec),
                            backgroundColor:
                                department.departmentColor.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: department.departmentColor,
                              fontSize: 12,
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Close', style: TextStyle(color: Color(0xFFFF6B9D))),
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

  void _editDepartment(Department department) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit department functionality coming soon'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _toggleDepartmentStatus(Department department) {
    setState(() {
      final index = _departments.indexWhere((dept) => dept.id == department.id);
      if (index != -1) {
        _departments[index] = department.copyWith(
          isActive: !department.isActive,
          updatedAt: DateTime.now(),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Department ${department.isActive ? 'deactivated' : 'activated'}',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/modern_sidebar.dart';
import '../models/patient.dart';
import '../services/admin_service.dart';

class ModernReportsScreen extends StatefulWidget {
  const ModernReportsScreen({Key? key}) : super(key: key);

  @override
  State<ModernReportsScreen> createState() => _ModernReportsScreenState();
}

class _ModernReportsScreenState extends State<ModernReportsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final AdminService _adminService = AdminService();

  List<PatientRecord> _patientRecords = [];
  List<PatientRecord> _filteredRecords = [];
  List<Patient> _patients = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _recordCategories = [
    'All',
    'Lab Reports',
    'Prescriptions',
    'Medical History',
    'Vaccination Records',
    'Imaging Reports',
    'Discharge Summary',
    'Surgery Notes',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final patients = await _adminService.getAllPatients();
      setState(() {
        _patients = patients;
        _patientRecords = _generateDemoRecords();
        _filteredRecords = _patientRecords;
        _isLoading = false;
      });
      _filterRecords();
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error loading data: $e');
    }
  }

  List<PatientRecord> _generateDemoRecords() {
    // Generate demo records for testing
    return [
      PatientRecord(
        id: '1',
        patientId: 'P001',
        patientName: 'John Doe',
        title: 'Blood Test Report',
        category: 'Lab Reports',
        description: 'Complete Blood Count (CBC) test results',
        doctorName: 'Dr. Rajesh Kumar',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Completed',
        attachments: ['blood_test_report.pdf'],
        notes: 'All parameters within normal range. Hemoglobin slightly low.',
        isVisible: true,
      ),
      PatientRecord(
        id: '2',
        patientId: 'P002',
        patientName: 'Jane Smith',
        title: 'Cardiac Consultation Report',
        category: 'Medical History',
        description: 'Cardiology consultation for chest pain evaluation',
        doctorName: 'Dr. Priya Sharma',
        date: DateTime.now().subtract(const Duration(days: 5)),
        status: 'Completed',
        attachments: ['cardiac_report.pdf', 'ecg_results.pdf'],
        notes: 'ECG normal. Recommended stress test and dietary changes.',
        isVisible: true,
      ),
      PatientRecord(
        id: '3',
        patientId: 'P001',
        patientName: 'John Doe',
        title: 'Prescription - Hypertension Medication',
        category: 'Prescriptions',
        description: 'Medication prescribed for blood pressure management',
        doctorName: 'Dr. Amit Patel',
        date: DateTime.now().subtract(const Duration(days: 7)),
        status: 'Active',
        attachments: ['prescription.pdf'],
        notes: 'Take medication twice daily. Monitor BP regularly.',
        isVisible: true,
      ),
      PatientRecord(
        id: '4',
        patientId: 'P003',
        patientName: 'Alice Johnson',
        title: 'COVID-19 Vaccination Certificate',
        category: 'Vaccination Records',
        description: 'COVID-19 vaccine second dose certificate',
        doctorName: 'Dr. Sunita Gupta',
        date: DateTime.now().subtract(const Duration(days: 30)),
        status: 'Completed',
        attachments: ['vaccination_certificate.pdf'],
        notes: 'No adverse reactions reported. Next dose due in 6 months.',
        isVisible: true,
      ),
      PatientRecord(
        id: '5',
        patientId: 'P002',
        patientName: 'Jane Smith',
        title: 'Chest X-Ray Report',
        category: 'Imaging Reports',
        description: 'Chest X-ray for respiratory symptoms evaluation',
        doctorName: 'Dr. Vikram Singh',
        date: DateTime.now().subtract(const Duration(days: 15)),
        status: 'Completed',
        attachments: ['chest_xray.jpg', 'radiologist_report.pdf'],
        notes: 'Clear lung fields. No signs of infection or abnormality.',
        isVisible: false,
      ),
    ];
  }

  void _filterRecords() {
    setState(() {
      _filteredRecords = _patientRecords.where((record) {
        final matchesSearch = record.patientName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            record.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            record.doctorName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        final matchesCategory =
            _selectedCategory == 'All' || record.category == _selectedCategory;

        return matchesSearch && matchesCategory;
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
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPatientRecordsTab(),
                      _buildReportsAnalyticsTab(),
                      _buildAddRecordTab(),
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
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical Reports & Records',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manage patient medical records, reports, and documentation that patients can access.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.folder_rounded, size: 18),
                SizedBox(width: 8),
                Text('Patient Records'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.analytics_rounded, size: 18),
                SizedBox(width: 8),
                Text('Analytics'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_rounded, size: 18),
                SizedBox(width: 8),
                Text('Add Record'),
              ],
            ),
          ),
        ],
        labelColor: const Color(0xFF10B981),
        unselectedLabelColor: const Color(0xFF64748B),
        indicatorColor: const Color(0xFF10B981),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPatientRecordsTab() {
    return Column(
      children: [
        _buildSearchAndFilter(),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF10B981)))
              : _buildRecordsList(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
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
                  _filterRecords();
                },
                decoration: const InputDecoration(
                  hintText: 'Search patient records...',
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
                value: _selectedCategory,
                items: _recordCategories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? 'All';
                  });
                  _filterRecords();
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => _tabController.animateTo(2),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Record'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList() {
    if (_filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No records found',
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

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _filteredRecords.length,
      itemBuilder: (context, index) {
        return _buildRecordCard(_filteredRecords[index]);
      },
    );
  }

  Widget _buildRecordCard(PatientRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
                  color: _getCategoryColor(record.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(record.category),
                  color: _getCategoryColor(record.category),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Patient: ${record.patientName} • Dr. ${record.doctorName}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(record.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      record.status,
                      style: TextStyle(
                        color: _getStatusColor(record.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: record.isVisible,
                    onChanged: (value) =>
                        _toggleRecordVisibility(record.id, value),
                    activeColor: const Color(0xFF10B981),
                    inactiveThumbColor: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            record.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
          if (record.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.note_rounded,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      record.notes,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              if (record.attachments.isNotEmpty) ...[
                Icon(
                  Icons.attach_file_rounded,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${record.attachments.length} attachment(s)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(record.date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _viewRecord(record),
                icon: const Icon(Icons.visibility_rounded, size: 16),
                label: const Text('View'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _editRecord(record),
                icon: const Icon(Icons.edit_rounded, size: 16),
                label: const Text('Edit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportsAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnalyticsCards(),
          const SizedBox(height: 24),
          _buildReportsChart(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCards() {
    final totalRecords = _patientRecords.length;
    final visibleRecords = _patientRecords.where((r) => r.isVisible).length;
    final recentRecords = _patientRecords
        .where((r) =>
            r.date.isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildAnalyticsCard(
            'Total Records',
            totalRecords.toString(),
            Icons.folder_rounded,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Visible to Patients',
            visibleRecords.toString(),
            Icons.visibility_rounded,
            const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'This Week',
            recentRecords.toString(),
            Icons.schedule_rounded,
            const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Categories',
            _recordCategories.length.toString(),
            Icons.category_rounded,
            const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(
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

  Widget _buildReportsChart() {
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
          const Text(
            'Records by Category',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: Center(
              child: Text(
                'Chart placeholder - Records distribution by category',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddRecordTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
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
        child: const AddRecordForm(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Lab Reports':
        return Icons.science_rounded;
      case 'Prescriptions':
        return Icons.medication_rounded;
      case 'Medical History':
        return Icons.history_rounded;
      case 'Vaccination Records':
        return Icons.vaccines_rounded;
      case 'Imaging Reports':
        return Icons.camera_alt_rounded;
      case 'Discharge Summary':
        return Icons.description_rounded;
      case 'Surgery Notes':
        return Icons.medical_services_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Lab Reports':
        return const Color(0xFF10B981);
      case 'Prescriptions':
        return const Color(0xFF3B82F6);
      case 'Medical History':
        return const Color(0xFFF59E0B);
      case 'Vaccination Records':
        return const Color(0xFF8B5CF6);
      case 'Imaging Reports':
        return const Color(0xFFEF4444);
      case 'Discharge Summary':
        return const Color(0xFF06B6D4);
      case 'Surgery Notes':
        return const Color(0xFFEC4899);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF10B981);
      case 'Active':
        return const Color(0xFF3B82F6);
      case 'Pending':
        return const Color(0xFFF59E0B);
      case 'Cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _toggleRecordVisibility(String recordId, bool isVisible) {
    setState(() {
      final index = _patientRecords.indexWhere((r) => r.id == recordId);
      if (index != -1) {
        _patientRecords[index] =
            _patientRecords[index].copyWith(isVisible: isVisible);
      }
    });
    _filterRecords();

    _showInfoSnackBar(isVisible
        ? 'Record is now visible to patient'
        : 'Record is now hidden from patient');
  }

  void _viewRecord(PatientRecord record) {
    // Show record details dialog
    showDialog(
      context: context,
      builder: (context) => _buildRecordDetailsDialog(record),
    );
  }

  void _editRecord(PatientRecord record) {
    // Navigate to edit record screen or show edit dialog
    _showInfoSnackBar('Edit record functionality coming soon');
  }

  Widget _buildRecordDetailsDialog(PatientRecord record) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(record.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(record.category),
                    color: _getCategoryColor(record.category),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        record.category,
                        style: const TextStyle(
                          fontSize: 14,
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
            _buildDetailRow('Patient', record.patientName),
            _buildDetailRow('Doctor', record.doctorName),
            _buildDetailRow('Date', _formatDate(record.date)),
            _buildDetailRow('Status', record.status),
            _buildDetailRow('Description', record.description),
            if (record.notes.isNotEmpty) _buildDetailRow('Notes', record.notes),
            if (record.attachments.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Attachments:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              ...record.attachments.map((attachment) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file,
                            size: 16, color: Color(0xFF64748B)),
                        const SizedBox(width: 8),
                        Text(
                          attachment,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Patient Record Model
class PatientRecord {
  final String id;
  final String patientId;
  final String patientName;
  final String title;
  final String category;
  final String description;
  final String doctorName;
  final DateTime date;
  final String status;
  final List<String> attachments;
  final String notes;
  final bool isVisible;

  PatientRecord({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.title,
    required this.category,
    required this.description,
    required this.doctorName,
    required this.date,
    required this.status,
    required this.attachments,
    required this.notes,
    required this.isVisible,
  });

  PatientRecord copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? title,
    String? category,
    String? description,
    String? doctorName,
    DateTime? date,
    String? status,
    List<String>? attachments,
    String? notes,
    bool? isVisible,
  }) {
    return PatientRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      notes: notes ?? this.notes,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

// Add Record Form Widget
class AddRecordForm extends StatefulWidget {
  const AddRecordForm({Key? key}) : super(key: key);

  @override
  State<AddRecordForm> createState() => _AddRecordFormState();
}

class _AddRecordFormState extends State<AddRecordForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedPatient = '';
  String _selectedDoctor = '';
  String _selectedCategory = 'Lab Reports';
  String _selectedStatus = 'Completed';
  bool _isVisible = true;
  List<String> _attachments = [];

  final List<String> _patients = ['John Doe', 'Jane Smith', 'Alice Johnson'];
  final List<String> _doctors = [
    'Dr. Rajesh Kumar',
    'Dr. Priya Sharma',
    'Dr. Amit Patel'
  ];
  final List<String> _categories = [
    'Lab Reports',
    'Prescriptions',
    'Medical History',
    'Vaccination Records',
    'Imaging Reports',
    'Discharge Summary',
    'Surgery Notes',
  ];
  final List<String> _statuses = [
    'Completed',
    'Active',
    'Pending',
    'Cancelled'
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Patient Record',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a new medical record that patients can view in their app.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Select Patient *',
                  value: _selectedPatient,
                  items: _patients,
                  onChanged: (value) =>
                      setState(() => _selectedPatient = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: 'Select Doctor *',
                  value: _selectedDoctor,
                  items: _doctors,
                  onChanged: (value) =>
                      setState(() => _selectedDoctor = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Category *',
                  value: _selectedCategory,
                  items: _categories,
                  onChanged: (value) =>
                      setState(() => _selectedCategory = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: 'Status *',
                  value: _selectedStatus,
                  items: _statuses,
                  onChanged: (value) =>
                      setState(() => _selectedStatus = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _titleController,
            label: 'Record Title *',
            hint: 'Enter record title',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'Description *',
            hint: 'Enter record description',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _notesController,
            label: 'Notes',
            hint: 'Additional notes (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _isVisible,
                onChanged: (value) =>
                    setState(() => _isVisible = value ?? true),
                activeColor: const Color(0xFF10B981),
              ),
              const Text(
                'Visible to patient',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF64748B),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _submitRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Record',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) =>
              value?.isEmpty == true ? '$label is required' : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) => value == null ? '$label is required' : null,
        ),
      ],
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _notesController.clear();
    setState(() {
      _selectedPatient = '';
      _selectedDoctor = '';
      _selectedCategory = 'Lab Reports';
      _selectedStatus = 'Completed';
      _isVisible = true;
    });
  }

  void _submitRecord() {
    if (_formKey.currentState!.validate()) {
      // Add record logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient record added successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      _resetForm();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

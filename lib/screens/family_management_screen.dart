import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/dependent_profile.dart';
import '../providers/family_profile_provider.dart';
import '../widgets/custom_button.dart';

class FamilyManagementScreen extends StatefulWidget {
  const FamilyManagementScreen({super.key});

  @override
  State<FamilyManagementScreen> createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeFamilyProvider();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeFamilyProvider() async {
    setState(() => _isLoading = true);
    try {
      final familyProvider = Provider.of<FamilyProfileProvider>(
        context,
        listen: false,
      );

      if (!familyProvider.isInitialized) {
        await familyProvider.initialize();
      }
      await familyProvider.initializeFamilyProfiles();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing family data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Family Management',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Members'),
            Tab(icon: Icon(Icons.health_and_safety), text: 'Health'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMembersTab(),
                _buildHealthTab(),
                _buildSettingsTab(),
              ],
            ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => _showAddMemberDialog(),
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.person_add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildMembersTab() {
    return Consumer<FamilyProfileProvider>(
      builder: (context, familyProvider, child) {
        if (familyProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (familyProvider.error != null) {
          return _buildErrorWidget(familyProvider.error!);
        }

        final dependents = familyProvider.dependents;

        if (dependents.isEmpty) {
          return _buildEmptyMembersState();
        }

        return RefreshIndicator(
          onRefresh: () => familyProvider.refreshFamilyData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dependents.length,
            itemBuilder: (context, index) {
              final dependent = dependents[index];
              return _buildMemberCard(dependent, familyProvider);
            },
          ),
        );
      },
    );
  }

  Widget _buildMemberCard(
    DependentProfile dependent,
    FamilyProfileProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  child: Text(
                    dependent.name.isNotEmpty
                        ? dependent.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dependent.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dependent.relation,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        '${dependent.age} years, ${dependent.gender}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) =>
                      _handleMemberAction(value, dependent, provider),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'switch',
                      child: Row(
                        children: [
                          Icon(Icons.swap_horiz, size: 20),
                          SizedBox(width: 8),
                          Text('Switch To'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'health',
                      child: Row(
                        children: [
                          Icon(Icons.health_and_safety, size: 20),
                          SizedBox(width: 8),
                          Text('Health Records'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Remove', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (dependent.bloodGroup.isNotEmpty ||
                dependent.allergies.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (dependent.bloodGroup.isNotEmpty) ...[
                      Icon(Icons.bloodtype, size: 16, color: Colors.red[300]),
                      const SizedBox(width: 4),
                      Text(
                        dependent.bloodGroup,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (dependent.allergies.isNotEmpty)
                        const SizedBox(width: 16),
                    ],
                    if (dependent.allergies.isNotEmpty) ...[
                      Icon(Icons.warning, size: 16, color: Colors.orange[300]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${dependent.allergies.length} allergies',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTab() {
    return Consumer<FamilyProfileProvider>(
      builder: (context, familyProvider, child) {
        final overview = familyProvider.familyOverview;

        if (overview == null) {
          return _buildEmptyHealthState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHealthOverviewCard(overview),
              const SizedBox(height: 16),
              _buildHealthMetricsCard(overview),
              const SizedBox(height: 16),
              _buildQuickActionsCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHealthOverviewCard(FamilyHealthOverview overview) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family Health Overview',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMetricItem(
                  'Total Members',
                  overview.totalMembers.toString(),
                  Icons.people,
                  Colors.blue,
                ),
                _buildMetricItem(
                  'Appointments',
                  overview.upcomingAppointments.toString(),
                  Icons.calendar_today,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMetricItem(
                  'Medications',
                  overview.pendingMedications.toString(),
                  Icons.medication,
                  Colors.orange,
                ),
                _buildMetricItem(
                  'Alerts',
                  overview.criticalAlerts.toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetricsCard(FamilyHealthOverview overview) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Last updated: ${DateFormat('MMM dd, yyyy hh:mm a').format(overview.lastUpdated)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            // TODO: Add actual health metrics and charts here
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Health metrics coming soon...',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Add Health Record',
                    Icons.add_circle,
                    Colors.green,
                    () => _showAddHealthRecordDialog(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    'Schedule Checkup',
                    Icons.schedule,
                    Colors.blue,
                    () => _showScheduleCheckupDialog(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Consumer<FamilyProfileProvider>(
      builder: (context, familyProvider, child) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingsCard(
              'Caregiver Mode',
              'Manage access for family members',
              Icons.supervisor_account,
              () => _showCaregiverSettingsDialog(),
            ),
            _buildSettingsCard(
              'Emergency Contacts',
              'Set up emergency contact information',
              Icons.emergency,
              () => _showEmergencyContactsDialog(),
            ),
            _buildSettingsCard(
              'Health Insurance',
              'Manage family health insurance details',
              Icons.health_and_safety,
              () => _showHealthInsuranceDialog(),
            ),
            _buildSettingsCard(
              'Data Sync',
              'Sync family data with cloud',
              Icons.sync,
              () => _handleDataSync(familyProvider),
            ),
            _buildSettingsCard(
              'Export Data',
              'Export family health records',
              Icons.download,
              () => _handleExportData(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildEmptyMembersState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.family_restroom, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Family Members Added',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Add family members to start managing their health together',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add Family Member',
            onPressed: () => _showAddMemberDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHealthState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.health_and_safety, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Health Data Available',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Add family members to view health overview',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Retry',
            onPressed: () => _initializeFamilyProvider(),
          ),
        ],
      ),
    );
  }

  void _handleMemberAction(
    String action,
    DependentProfile dependent,
    FamilyProfileProvider provider,
  ) async {
    switch (action) {
      case 'edit':
        await _showEditMemberDialog(dependent);
        break;
      case 'switch':
        await _switchToMember(dependent, provider);
        break;
      case 'health':
        _showHealthRecordsDialog(dependent);
        break;
      case 'delete':
        await _confirmDeleteMember(dependent, provider);
        break;
    }
  }

  Future<void> _switchToMember(
    DependentProfile dependent,
    FamilyProfileProvider provider,
  ) async {
    try {
      await provider.enterCaregiverMode(dependent);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched to ${dependent.name}\'s profile'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to switch profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _confirmDeleteMember(
    DependentProfile dependent,
    FamilyProfileProvider provider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Family Member'),
        content: Text(
          'Are you sure you want to remove ${dependent.name} from your family? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await provider.removeDependentProfile(dependent.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${dependent.name} removed from family'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove family member: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showAddMemberDialog() {
    showDialog(context: context, builder: (context) => AddFamilyMemberDialog());
  }

  Future<void> _showEditMemberDialog(DependentProfile dependent) async {
    showDialog(
      context: context,
      builder: (context) => EditFamilyMemberDialog(dependent: dependent),
    );
  }

  void _showHealthRecordsDialog(DependentProfile dependent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${dependent.name}\'s Health Records'),
        content: const Text('Health records feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAddHealthRecordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Health Record'),
        content: const Text('Add health record feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showScheduleCheckupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Checkup'),
        content: const Text('Schedule checkup feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCaregiverSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Caregiver Settings'),
        content: const Text('Caregiver settings feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyContactsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Contacts'),
        content: const Text('Emergency contacts feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHealthInsuranceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Insurance'),
        content: const Text('Health insurance feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDataSync(FamilyProfileProvider provider) async {
    try {
      await provider.refreshFamilyData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Family data synced successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleExportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Export data feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Placeholder dialogs that can be enhanced later
class AddFamilyMemberDialog extends StatefulWidget {
  @override
  State<AddFamilyMemberDialog> createState() => _AddFamilyMemberDialogState();
}

class _AddFamilyMemberDialogState extends State<AddFamilyMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _bloodGroupController = TextEditingController();

  String _selectedRelation = 'Child';
  String _selectedGender = 'Male';
  DateTime _selectedDate = DateTime.now().subtract(
    const Duration(days: 365 * 10),
  );

  final List<String> _relations = [
    'Child',
    'Spouse',
    'Parent',
    'Grandparent',
    'Sibling',
    'Other',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Family Member'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRelation,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  border: OutlineInputBorder(),
                ),
                items: _relations.map((relation) {
                  return DropdownMenuItem(
                    value: relation,
                    child: Text(relation),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedRelation = value!);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: _genders.map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedGender = value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _bloodGroupController,
                      decoration: const InputDecoration(
                        labelText: 'Blood Group',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date of Birth'),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _addMember, child: const Text('Add Member')),
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _addMember() async {
    if (_formKey.currentState!.validate()) {
      try {
        final familyProvider = Provider.of<FamilyProfileProvider>(
          context,
          listen: false,
        );

        final dependent = DependentProfile(
          id: '', // Will be generated by database
          primaryUserId: '', // Will be set by provider
          name: _nameController.text.trim(),
          relation: _selectedRelation,
          dateOfBirth: _selectedDate,
          gender: _selectedGender,
          bloodGroup: _bloodGroupController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          allergies: [],
          medications: [],
          medicalHistory: {},
          isPrimaryContact: false,
          hasOwnAccount: false,
          linkedAccountId: null,
          allowIndependentAccess: false,
          caregiverPermissions: [],
          caregiverSettings: {},
          medicalConditions: [],
          emergencyInfo: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await familyProvider.addDependentProfileWithLocalSync(dependent);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${dependent.name} added to family'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add family member: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

class EditFamilyMemberDialog extends StatefulWidget {
  final DependentProfile dependent;

  const EditFamilyMemberDialog({super.key, required this.dependent});

  @override
  State<EditFamilyMemberDialog> createState() => _EditFamilyMemberDialogState();
}

class _EditFamilyMemberDialogState extends State<EditFamilyMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _bloodGroupController;

  late String _selectedRelation;
  late String _selectedGender;
  late DateTime _selectedDate;

  final List<String> _relations = [
    'Child',
    'Spouse',
    'Parent',
    'Grandparent',
    'Sibling',
    'Other',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dependent.name);
    _phoneController = TextEditingController(
      text: widget.dependent.phoneNumber,
    );
    _emailController = TextEditingController(text: widget.dependent.email);
    _bloodGroupController = TextEditingController(
      text: widget.dependent.bloodGroup,
    );
    _selectedRelation = widget.dependent.relation;
    _selectedGender = widget.dependent.gender;
    _selectedDate = widget.dependent.dateOfBirth;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.dependent.name}'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRelation,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  border: OutlineInputBorder(),
                ),
                items: _relations.map((relation) {
                  return DropdownMenuItem(
                    value: relation,
                    child: Text(relation),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedRelation = value!);
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: _genders.map((gender) {
                        return DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedGender = value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _bloodGroupController,
                      decoration: const InputDecoration(
                        labelText: 'Blood Group',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Date of Birth'),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy').format(_selectedDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _updateMember, child: const Text('Update')),
      ],
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _updateMember() async {
    if (_formKey.currentState!.validate()) {
      try {
        final familyProvider = Provider.of<FamilyProfileProvider>(
          context,
          listen: false,
        );

        final updatedDependent = widget.dependent.copyWith(
          name: _nameController.text.trim(),
          relation: _selectedRelation,
          dateOfBirth: _selectedDate,
          gender: _selectedGender,
          bloodGroup: _bloodGroupController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          updatedAt: DateTime.now(),
        );

        await familyProvider.updateDependentProfile(updatedDependent);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${updatedDependent.name} updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update family member: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dependent_profile.dart';
import '../providers/family_profile_provider.dart';
import '../widgets/custom_button.dart';

class FamilyDashboardScreen extends StatefulWidget {
  const FamilyDashboardScreen({super.key});

  @override
  State<FamilyDashboardScreen> createState() => _FamilyDashboardScreenState();
}

class _FamilyDashboardScreenState extends State<FamilyDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFamilyData();
    });
  }

  Future<void> _loadFamilyData() async {
    final familyProvider = Provider.of<FamilyProfileProvider>(
      context,
      listen: false,
    );
    await familyProvider.initializeFamilyProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Family Health Hub',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Consumer<FamilyProfileProvider>(
            builder: (context, familyProvider, child) {
              if (familyProvider.isCaregiverModeActive) {
                return IconButton(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: () async {
                    await familyProvider.exitCaregiverMode();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exited caregiver mode'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  tooltip: 'Exit Caregiver Mode',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<FamilyProfileProvider>(
        builder: (context, familyProvider, child) {
          if (familyProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (familyProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading family data',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    familyProvider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(text: 'Retry', onPressed: _loadFamilyData),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => familyProvider.refreshFamilyData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Caregiver Mode Banner
                  if (familyProvider.isCaregiverModeActive)
                    _buildCaregiverModeBanner(familyProvider),

                  // Family Overview Cards
                  _buildFamilyOverviewCards(familyProvider),

                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildQuickActions(context),

                  const SizedBox(height: 24),

                  // Family Members Section
                  _buildFamilyMembersSection(familyProvider),

                  const SizedBox(height: 24),

                  // Health Alerts Section
                  _buildHealthAlertsSection(familyProvider),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddMemberDialog(context);
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Member'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildCaregiverModeBanner(FamilyProfileProvider familyProvider) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.health_and_safety, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Caregiver Mode Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Managing ${familyProvider.caregiverMode.activeDependentName}\'s health',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () async {
              await familyProvider.exitCaregiverMode();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exited caregiver mode'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyOverviewCards(FamilyProfileProvider familyProvider) {
    final overview = familyProvider.familyOverview;

    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            title: 'Family Members',
            value: '${overview?.totalMembers ?? 1}',
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            title: 'Appointments',
            value: '${overview?.upcomingAppointments ?? 0}',
            icon: Icons.calendar_today,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            title: 'Medications',
            value: '${overview?.pendingMedications ?? 0}',
            icon: Icons.medication,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            title: 'Alerts',
            value: '${overview?.criticalAlerts ?? 0}',
            icon: Icons.warning,
            color:
                overview?.criticalAlerts != null && overview!.criticalAlerts > 0
                ? Colors.red
                : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                title: 'Book Appointment',
                subtitle: 'Schedule for family',
                icon: Icons.calendar_today,
                color: Colors.blue,
                onTap: () {
                  // TODO: Navigate to appointment booking
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                title: 'Medication',
                subtitle: 'Set reminders',
                icon: Icons.medication,
                color: Colors.green,
                onTap: () {
                  // TODO: Navigate to medication management
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                title: 'Health Records',
                subtitle: 'View reports',
                icon: Icons.folder_outlined,
                color: Colors.orange,
                onTap: () {
                  // TODO: Navigate to health records
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMembersSection(FamilyProfileProvider familyProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Family Members',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                _showAddMemberDialog(context);
              },
              child: const Text('Add Member'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (familyProvider.dependents.isEmpty)
          _buildEmptyFamilyState()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: familyProvider.dependents.length,
            itemBuilder: (context, index) {
              final dependent = familyProvider.dependents[index];
              return _buildFamilyMemberCard(dependent, familyProvider);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyFamilyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.family_restroom, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No family members added yet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your family members to manage their health together',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add First Member',
            onPressed: () {
              _showAddMemberDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(
    DependentProfile dependent,
    FamilyProfileProvider familyProvider,
  ) {
    final isActiveProfile =
        familyProvider.isCaregiverModeActive &&
        familyProvider.caregiverMode.activeDependentId == dependent.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isActiveProfile
            ? Border.all(color: Theme.of(context).primaryColor, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: _getRelationColor(dependent.relation),
          child: Text(
            dependent.name.isNotEmpty ? dependent.name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                dependent.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (isActiveProfile)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${dependent.relation} • Age ${dependent.age}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            if (dependent.medicalConditions.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Conditions: ${dependent.medicalConditions.join(', ')}',
                style: TextStyle(color: Colors.red[600], fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isActiveProfile ? Icons.exit_to_app : Icons.person,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                if (isActiveProfile) {
                  await familyProvider.exitCaregiverMode();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exited caregiver mode'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  await familyProvider.enterCaregiverMode(dependent);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Entered caregiver mode for ${dependent.name}',
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              },
              tooltip: isActiveProfile
                  ? 'Exit Caregiver Mode'
                  : 'Enter Caregiver Mode',
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          _showMemberDetail(dependent);
        },
      ),
    );
  }

  Widget _buildHealthAlertsSection(FamilyProfileProvider familyProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Alerts',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.health_and_safety, size: 48, color: Colors.green[400]),
              const SizedBox(height: 16),
              Text(
                'All Good!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.green[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No critical health alerts for your family',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getRelationColor(String relation) {
    switch (relation.toLowerCase()) {
      case 'father':
        return Colors.blue[600]!;
      case 'mother':
        return Colors.pink[400]!;
      case 'spouse':
        return Colors.purple[400]!;
      case 'son':
        return Colors.green[600]!;
      case 'daughter':
        return Colors.orange[400]!;
      case 'brother':
        return Colors.teal[600]!;
      case 'sister':
        return Colors.indigo[400]!;
      default:
        return Colors.grey[600]!;
    }
  }

  void _showAddMemberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Family Member'),
        content: const Text('Family member addition feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMemberDetail(DependentProfile dependent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dependent.name),
        content: Text(
          'Detailed view for ${dependent.name} (${dependent.relation}) coming soon!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

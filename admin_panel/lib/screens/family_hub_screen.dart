import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/family_hub_provider.dart';
import '../models/family_hub.dart';

class FamilyHubScreen extends StatefulWidget {
  const FamilyHubScreen({super.key});

  @override
  State<FamilyHubScreen> createState() => _FamilyHubScreenState();
}

class _FamilyHubScreenState extends State<FamilyHubScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FamilyHubProvider>(context, listen: false).loadAllData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('Family Hub Management'),
        backgroundColor: const Color(0xFF2D2D2D),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.family_restroom), text: 'Family Groups'),
            Tab(icon: Icon(Icons.health_and_safety), text: 'Community Health'),
            Tab(icon: Icon(Icons.analytics), text: 'Health Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FamilyGroupsTab(),
          CommunityHealthTab(),
          HealthAnalyticsTab(),
        ],
      ),
    );
  }
}

class FamilyGroupsTab extends StatelessWidget {
  const FamilyGroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyHubProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingGroups) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.groupsError != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.groupsError!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadFamilyGroups(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildFamilyGroupsHeader(context, provider),
            Expanded(
              child: _buildFamilyGroupsList(context, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFamilyGroupsHeader(
      BuildContext context, FamilyHubProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2D2D2D),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Families',
                  provider.totalFamilyGroups.toString(),
                  Icons.family_restroom,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Members',
                  provider.totalFamilyMembers.toString(),
                  Icons.people,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Children',
                  provider.totalChildren.toString(),
                  Icons.child_care,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Active Families',
                  provider.activeFamilyGroups.toString(),
                  Icons.verified,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3D3D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: provider.selectedVillage,
                    onChanged: (value) => provider.setVillageFilter(value!),
                    dropdownColor: const Color(0xFF3D3D3D),
                    style: const TextStyle(color: Colors.white),
                    underline: Container(),
                    items: provider.availableVillages
                        .map((village) => DropdownMenuItem(
                              value: village,
                              child: Text(
                                  village == 'all' ? 'All Villages' : village),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showCreateFamilyGroupDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Family Group'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3D3D3D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyGroupsList(
      BuildContext context, FamilyHubProvider provider) {
    final groups = provider.filteredFamilyGroups;

    if (groups.isEmpty) {
      return const Center(
        child: Text(
          'No family groups found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return _buildFamilyGroupCard(context, group);
      },
    );
  }

  Widget _buildFamilyGroupCard(BuildContext context, FamilyGroup group) {
    return Card(
      color: const Color(0xFF2D2D2D),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.family_restroom,
                  color: group.isActive ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    group.familyName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  '${group.totalMembers} members',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 16),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditFamilyGroupDialog(context, group);
                        break;
                      case 'delete':
                        _showDeleteConfirmation(context, group);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Primary: ${group.primaryMemberName}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'Phone: ${group.primaryMemberPhone}',
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              'Village: ${group.village}, ${group.pincode}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: group.members
                  .map((member) => Chip(
                        label: Text(
                          '${member.name} (${member.relationship})',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: const Color(0xFF3D3D3D),
                        labelStyle: const TextStyle(color: Colors.white),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateFamilyGroupDialog(BuildContext context) {
    // Implementation for create dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Add Family Group',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Family group creation dialog would be implemented here',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditFamilyGroupDialog(BuildContext context, FamilyGroup group) {
    // Implementation for edit dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Edit Family Group',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Edit ${group.familyName}',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, FamilyGroup group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Delete Family Group',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete ${group.familyName}?',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<FamilyHubProvider>(context, listen: false)
                  .deleteFamilyGroup(group.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class CommunityHealthTab extends StatelessWidget {
  const CommunityHealthTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyHubProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingHealth) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            _buildHealthHeader(context, provider),
            Expanded(
              child: _buildHealthDataList(context, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHealthHeader(BuildContext context, FamilyHubProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF2D2D2D),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Reports',
                  provider.totalHealthReports.toString(),
                  Icons.report,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Active Alerts',
                  provider.activeHealthAlerts.toString(),
                  Icons.warning,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Monitoring',
                  provider.filteredHealthData
                      .where((d) => d.status == 'monitoring')
                      .length
                      .toString(),
                  Icons.monitor_heart,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Resolved',
                  provider.filteredHealthData
                      .where((d) => d.status == 'resolved')
                      .length
                      .toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3D3D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: provider.selectedVillage,
                    onChanged: (value) => provider.setVillageFilter(value!),
                    dropdownColor: const Color(0xFF3D3D3D),
                    style: const TextStyle(color: Colors.white),
                    underline: Container(),
                    items: provider.availableVillages
                        .map((village) => DropdownMenuItem(
                              value: village,
                              child: Text(
                                  village == 'all' ? 'All Villages' : village),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3D3D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: provider.selectedCondition,
                    onChanged: (value) => provider.setConditionFilter(value!),
                    dropdownColor: const Color(0xFF3D3D3D),
                    style: const TextStyle(color: Colors.white),
                    underline: Container(),
                    items: provider.availableConditions
                        .map((condition) => DropdownMenuItem(
                              value: condition,
                              child: Text(condition == 'all'
                                  ? 'All Conditions'
                                  : condition),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showCreateHealthReportDialog(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3D3D3D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthDataList(
      BuildContext context, FamilyHubProvider provider) {
    final data = provider.filteredHealthData;

    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No health data found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final healthData = data[index];
        return _buildHealthDataCard(context, healthData);
      },
    );
  }

  Widget _buildHealthDataCard(BuildContext context, CommunityHealthData data) {
    Color statusColor;
    switch (data.status) {
      case 'active':
        statusColor = Colors.red;
        break;
      case 'monitoring':
        statusColor = Colors.orange;
        break;
      case 'resolved':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    Color severityColor;
    switch (data.severity.toLowerCase()) {
      case 'high':
        severityColor = Colors.red;
        break;
      case 'medium':
        severityColor = Colors.orange;
        break;
      case 'low':
        severityColor = Colors.green;
        break;
      default:
        severityColor = Colors.grey;
    }

    return Card(
      color: const Color(0xFF2D2D2D),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: statusColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.condition,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    data.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Village: ${data.village}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Text(
                  'Age: ${data.ageGroup}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Text(
                  'Gender: ${data.gender}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Severity: ${data.severity}',
                    style: TextStyle(
                      color: severityColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Symptoms: ${data.symptoms.join(", ")}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Reported: ${data.reportDate.day}/${data.reportDate.month}/${data.reportDate.year}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateHealthReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Add Health Report',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Health report creation dialog would be implemented here',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class HealthAnalyticsTab extends StatelessWidget {
  const HealthAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyHubProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildAnalyticsHeader(provider),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildConditionChart(provider),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildVillageChart(provider),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTrendChart(provider),
              const SizedBox(height: 20),
              _buildHealthAlerts(provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsHeader(FamilyHubProvider provider) {
    return Row(
      children: [
        Expanded(
          child: _buildAnalyticsCard(
            'Total Reports',
            provider.totalHealthReports.toString(),
            Icons.analytics,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Active Alerts',
            provider.activeHealthAlerts.toString(),
            Icons.warning,
            Colors.red,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Villages Covered',
            provider.availableVillages.length.toString(),
            Icons.location_on,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnalyticsCard(
            'Conditions Tracked',
            provider.availableConditions.length.toString(),
            Icons.medical_services,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConditionChart(FamilyHubProvider provider) {
    final stats = provider.getConditionStatistics();
    if (stats.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child:
              Text('No data available', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Health Conditions Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: stats.entries.map((entry) {
                  final colors = [
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                    Colors.red
                  ];
                  final index = stats.keys.toList().indexOf(entry.key);
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    title: '${entry.key}\n${entry.value}',
                    color: colors[index % colors.length],
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVillageChart(FamilyHubProvider provider) {
    final stats = provider.getVillageStatistics();
    if (stats.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child:
              Text('No data available', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Reports by Village',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    stats.values.reduce((a, b) => a > b ? a : b).toDouble() + 2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < stats.keys.length) {
                          return Text(
                            stats.keys.elementAt(index),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: stats.entries.map((entry) {
                  final index = stats.keys.toList().indexOf(entry.key);
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.toDouble(),
                        color: Colors.blue,
                        width: 20,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(FamilyHubProvider provider) {
    final trendData = provider.getTrendData();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Health Reports Trend (Last 7 Days)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < trendData.length) {
                          final date = trendData[index]['date'] as DateTime;
                          return Text(
                            '${date.day}/${date.month}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: trendData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value['count'].toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthAlerts(FamilyHubProvider provider) {
    final alerts =
        provider.healthAlerts.where((alert) => alert.isActive).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Health Alerts',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (alerts.isEmpty)
            const Text(
              'No active alerts',
              style: TextStyle(color: Colors.grey),
            )
          else
            ...alerts.map((alert) => _buildAlertCard(alert)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(HealthAlert alert) {
    Color alertColor;
    switch (alert.severity) {
      case 'critical':
        alertColor = Colors.red;
        break;
      case 'high':
        alertColor = Colors.orange;
        break;
      case 'medium':
        alertColor = Colors.yellow;
        break;
      default:
        alertColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3D3D3D),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: alertColor, width: 4),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: alertColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  alert.description,
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Villages: ${alert.affectedVillages.join(", ")}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: alertColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              alert.severity.toUpperCase(),
              style: TextStyle(
                color: alertColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

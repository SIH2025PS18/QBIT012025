import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dependent_profile.dart';
import '../providers/family_profile_provider.dart';

class FamilyMemberSelector extends StatelessWidget {
  final Function(DependentProfile?)? onMemberSelected;
  final bool showPrimaryUser;
  final bool compact;

  const FamilyMemberSelector({
    super.key,
    this.onMemberSelected,
    this.showPrimaryUser = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyProfileProvider>(
      builder: (context, familyProvider, child) {
        if (!familyProvider.isInitialized) {
          return const SizedBox.shrink();
        }

        final dependents = familyProvider.dependents;
        final activeProfile = familyProvider.activeProfile;
        final isCaregiverMode = familyProvider.isCaregiverModeActive;

        if (dependents.isEmpty && !showPrimaryUser) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: compact ? EdgeInsets.zero : const EdgeInsets.all(8),
          elevation: compact ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(compact ? 8 : 12),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 8 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!compact) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Family Members',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      if (isCaregiverMode)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.supervisor_account,
                                size: 12,
                                color: Colors.orange[700],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Caregiver Mode',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Current active profile indicator
                if (isCaregiverMode && activeProfile != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            activeProfile.name.isNotEmpty
                                ? activeProfile.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Currently Managing',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                activeProfile.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.exit_to_app, size: 18),
                          onPressed: () =>
                              _exitCaregiverMode(context, familyProvider),
                          tooltip: 'Exit Caregiver Mode',
                        ),
                      ],
                    ),
                  ),

                // Family member list
                if (showPrimaryUser && !isCaregiverMode)
                  _buildPrimaryUserTile(context, familyProvider),

                if (dependents.isNotEmpty) ...[
                  if (showPrimaryUser && !isCaregiverMode)
                    const SizedBox(height: 8),
                  ...dependents.map(
                    (dependent) => _buildMemberTile(
                      context,
                      dependent,
                      familyProvider,
                      activeProfile,
                    ),
                  ),
                ],

                if (dependents.isEmpty && !showPrimaryUser) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.family_restroom,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No family members added',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _navigateToFamilyManagement(context),
                          child: const Text('Add Family Members'),
                        ),
                      ],
                    ),
                  ),
                ],

                if (!compact && dependents.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _navigateToFamilyManagement(context),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, size: 16),
                          SizedBox(width: 8),
                          Text('Manage Family'),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrimaryUserTile(
    BuildContext context,
    FamilyProfileProvider provider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.green,
          child: const Icon(Icons.person, color: Colors.white, size: 20),
        ),
        title: const Text(
          'You (Primary User)',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: const Text('Your own profile'),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
        onTap: () {
          if (onMemberSelected != null) {
            onMemberSelected!(null); // null represents primary user
          }
        },
      ),
    );
  }

  Widget _buildMemberTile(
    BuildContext context,
    DependentProfile dependent,
    FamilyProfileProvider provider,
    DependentProfile? activeProfile,
  ) {
    final isActive = activeProfile?.id == dependent.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
        borderRadius: BorderRadius.circular(8),
        border: isActive
            ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3))
            : null,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: isActive
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            dependent.name.isNotEmpty ? dependent.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: isActive ? Colors.white : Theme.of(context).primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          dependent.name,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${dependent.relation} • ${dependent.age} years',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 16),
              onSelected: (value) =>
                  _handleMemberAction(context, value, dependent, provider),
              itemBuilder: (context) => [
                if (!isActive)
                  const PopupMenuItem(
                    value: 'switch',
                    child: Row(
                      children: [
                        Icon(Icons.swap_horiz, size: 16),
                        SizedBox(width: 8),
                        Text('Switch To'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 16),
                      SizedBox(width: 8),
                      Text('View Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'health',
                  child: Row(
                    children: [
                      Icon(Icons.health_and_safety, size: 16),
                      SizedBox(width: 8),
                      Text('Health Records'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () async {
          if (isActive) {
            // Already active, maybe show profile or do nothing
            if (onMemberSelected != null) {
              onMemberSelected!(dependent);
            }
          } else {
            // Switch to this member
            await _switchToMember(context, dependent, provider);
          }
        },
      ),
    );
  }

  Future<void> _handleMemberAction(
    BuildContext context,
    String action,
    DependentProfile dependent,
    FamilyProfileProvider provider,
  ) async {
    switch (action) {
      case 'switch':
        await _switchToMember(context, dependent, provider);
        break;
      case 'profile':
        _viewMemberProfile(context, dependent);
        break;
      case 'health':
        _viewHealthRecords(context, dependent);
        break;
    }
  }

  Future<void> _switchToMember(
    BuildContext context,
    DependentProfile dependent,
    FamilyProfileProvider provider,
  ) async {
    try {
      await provider.enterCaregiverMode(dependent);

      if (onMemberSelected != null) {
        onMemberSelected!(dependent);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${dependent.name}\'s profile'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to switch profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exitCaregiverMode(
    BuildContext context,
    FamilyProfileProvider provider,
  ) async {
    try {
      await provider.exitCaregiverMode();

      if (onMemberSelected != null) {
        onMemberSelected!(null); // null represents primary user
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Returned to your profile'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to exit caregiver mode: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _viewMemberProfile(BuildContext context, DependentProfile dependent) {
    // Navigate to member profile screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${dependent.name}\'s Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileItem('Relationship', dependent.relation),
            _buildProfileItem('Age', '${dependent.age} years'),
            _buildProfileItem('Gender', dependent.gender),
            if (dependent.bloodGroup.isNotEmpty)
              _buildProfileItem('Blood Group', dependent.bloodGroup),
            if (dependent.phoneNumber.isNotEmpty)
              _buildProfileItem('Phone', dependent.phoneNumber),
            if (dependent.email.isNotEmpty)
              _buildProfileItem('Email', dependent.email),
            if (dependent.allergies.isNotEmpty)
              _buildProfileItem('Allergies', dependent.allergies.join(', ')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToFamilyManagement(context);
            },
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _viewHealthRecords(BuildContext context, DependentProfile dependent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${dependent.name}\'s Health Records'),
        content: const Text('Health records feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToFamilyManagement(BuildContext context) {
    Navigator.of(context).pushNamed('/family-management');
  }
}

/// Compact version of family member selector for app bars or small spaces
class CompactFamilySelector extends StatelessWidget {
  final Function(DependentProfile?)? onMemberSelected;

  const CompactFamilySelector({super.key, this.onMemberSelected});

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyProfileProvider>(
      builder: (context, familyProvider, child) {
        if (!familyProvider.isInitialized) {
          return const SizedBox.shrink();
        }

        final dependents = familyProvider.dependents;
        final activeProfile = familyProvider.activeProfile;
        final isCaregiverMode = familyProvider.isCaregiverModeActive;

        return PopupMenuButton<DependentProfile?>(
          icon: CircleAvatar(
            radius: 16,
            backgroundColor: isCaregiverMode && activeProfile != null
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
            child: Text(
              isCaregiverMode && activeProfile != null
                  ? (activeProfile.name.isNotEmpty
                        ? activeProfile.name[0].toUpperCase()
                        : '?')
                  : 'M',
              style: TextStyle(
                color: isCaregiverMode && activeProfile != null
                    ? Colors.white
                    : Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          tooltip: isCaregiverMode && activeProfile != null
              ? 'Managing ${activeProfile.name}'
              : 'Switch Family Member',
          onSelected: (member) async {
            if (member == null) {
              // Switch to primary user
              if (isCaregiverMode) {
                await familyProvider.exitCaregiverMode();
              }
            } else {
              // Switch to selected member
              await familyProvider.enterCaregiverMode(member);
            }

            if (onMemberSelected != null) {
              onMemberSelected!(member);
            }
          },
          itemBuilder: (context) => [
            // Primary user option
            PopupMenuItem<DependentProfile?>(
              value: null,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: !isCaregiverMode
                        ? Colors.green
                        : Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: !isCaregiverMode ? Colors.white : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('You (Primary)')),
                  if (!isCaregiverMode)
                    const Icon(Icons.check, color: Colors.green, size: 16),
                ],
              ),
            ),

            // Divider if there are dependents
            if (dependents.isNotEmpty) const PopupMenuDivider(),

            // Dependent options
            ...dependents.map(
              (dependent) => PopupMenuItem<DependentProfile?>(
                value: dependent,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: activeProfile?.id == dependent.id
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      child: Text(
                        dependent.name.isNotEmpty
                            ? dependent.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: activeProfile?.id == dependent.id
                              ? Colors.white
                              : Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dependent.name),
                          Text(
                            dependent.relation,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (activeProfile?.id == dependent.id)
                      Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      ),
                  ],
                ),
              ),
            ),

            // Divider and manage option
            if (dependents.isNotEmpty) ...[
              const PopupMenuDivider(),
              PopupMenuItem<DependentProfile?>(
                value: null,
                onTap: () {
                  // Small delay to let popup close first
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.of(context).pushNamed('/family-management');
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.settings, size: 16),
                    SizedBox(width: 12),
                    Text('Manage Family'),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

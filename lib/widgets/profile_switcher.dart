import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dependent_profile.dart';
import '../providers/family_profile_provider.dart';

/// A widget that displays the current active profile and allows switching between profiles
class ProfileSwitcher extends StatelessWidget {
  final bool showProfilePicture;
  final bool showDropdown;
  final VoidCallback? onProfileTap;

  const ProfileSwitcher({
    super.key,
    this.showProfilePicture = true,
    this.showDropdown = true,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyProfileProvider>(
      builder: (context, familyProvider, child) {
        final activeProfile = familyProvider.activeProfile;
        final isInCaregiverMode = familyProvider.isCaregiverModeActive;

        return GestureDetector(
          onTap: onProfileTap ?? () => _showProfileSwitcher(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isInCaregiverMode ? Colors.blue[50] : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: isInCaregiverMode
                  ? Border.all(color: Colors.blue[300]!, width: 1)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showProfilePicture) ...[
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: isInCaregiverMode
                        ? _getRelationColor(activeProfile?.relation ?? '')
                        : Theme.of(context).primaryColor,
                    child: Text(
                      _getProfileInitial(activeProfile, familyProvider),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getProfileName(activeProfile, familyProvider),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isInCaregiverMode
                              ? Colors.blue[800]
                              : Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (isInCaregiverMode && activeProfile != null)
                        Text(
                          'Caregiver Mode',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                if (showDropdown) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: isInCaregiverMode
                        ? Colors.blue[600]
                        : Colors.grey[600],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getProfileInitial(
    DependentProfile? activeProfile,
    FamilyProfileProvider familyProvider,
  ) {
    if (activeProfile != null) {
      return activeProfile.name.isNotEmpty
          ? activeProfile.name[0].toUpperCase()
          : '?';
    }
    // Return primary user initial - you might want to get this from user provider
    return 'U'; // Placeholder for primary user
  }

  String _getProfileName(
    DependentProfile? activeProfile,
    FamilyProfileProvider familyProvider,
  ) {
    if (activeProfile != null) {
      return activeProfile.name;
    }
    return 'My Profile'; // Primary user profile
  }

  void _showProfileSwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileSwitcherBottomSheet(),
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
}

/// Bottom sheet for switching between profiles
class ProfileSwitcherBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyProfileProvider>(
      builder: (context, familyProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Switch Profile',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    if (familyProvider.isCaregiverModeActive)
                      TextButton(
                        onPressed: () async {
                          await familyProvider.exitCaregiverMode();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Exited caregiver mode'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Text(
                          'Exit Caregiver',
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ),
                  ],
                ),
              ),

              const Divider(),

              // Primary User Profile
              _buildProfileOption(
                context: context,
                name: 'My Profile',
                subtitle: 'Primary Account',
                initial: 'U',
                isActive: !familyProvider.isCaregiverModeActive,
                color: Theme.of(context).primaryColor,
                onTap: () async {
                  if (familyProvider.isCaregiverModeActive) {
                    await familyProvider.exitCaregiverMode();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Switched to your profile'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),

              // Family Members
              if (familyProvider.dependents.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Family Members',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                ...familyProvider.dependents.map((dependent) {
                  final isActive =
                      familyProvider.isCaregiverModeActive &&
                      familyProvider.caregiverMode.activeDependentId ==
                          dependent.id;

                  return _buildProfileOption(
                    context: context,
                    name: dependent.name,
                    subtitle: '${dependent.relation} • Age ${dependent.age}',
                    initial: dependent.name.isNotEmpty
                        ? dependent.name[0].toUpperCase()
                        : '?',
                    isActive: isActive,
                    color: _getRelationColor(dependent.relation),
                    onTap: () async {
                      if (!isActive) {
                        await familyProvider.enterCaregiverMode(dependent);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Switched to ${dependent.name}\'s profile',
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.family_restroom,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No family members added yet',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Navigate to add family member screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Add family member feature coming soon!',
                              ),
                            ),
                          );
                        },
                        child: const Text('Add Family Member'),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required String name,
    required String subtitle,
    required String initial,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : null,
          border: isActive ? Border.all(color: color.withOpacity(0.3)) : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isActive ? color : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
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
      ),
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
}

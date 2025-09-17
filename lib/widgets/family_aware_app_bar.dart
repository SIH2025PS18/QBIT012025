import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dependent_profile.dart';
import '../providers/family_profile_provider.dart';
import 'profile_switcher.dart';

/// Enhanced AppBar that includes profile switching capabilities for family health hub
class FamilyAwareAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final bool showProfileSwitcher;
  final VoidCallback? onProfileSwitcherTap;

  const FamilyAwareAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.showProfileSwitcher = true,
    this.onProfileSwitcherTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      elevation: 0,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        if (showProfileSwitcher) ...[
          Consumer<FamilyProfileProvider>(
            builder: (context, familyProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ProfileSwitcher(
                  showDropdown: true,
                  showProfilePicture: true,
                  onProfileTap: onProfileSwitcherTap,
                ),
              );
            },
          ),
        ],
        if (actions != null) ...actions!,
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Caregiver mode banner widget that shows when in caregiver mode
class CaregiverModeBanner extends StatelessWidget {
  const CaregiverModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyProfileProvider>(
      builder: (context, familyProvider, child) {
        if (!familyProvider.isCaregiverModeActive) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[400]!, Colors.blue[600]!],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.health_and_safety, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Managing ${familyProvider.caregiverMode.activeDependentName}\'s health',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await familyProvider.exitCaregiverMode();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exited caregiver mode'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text(
                  'Exit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Quick profile info widget for displaying current profile info
class CurrentProfileInfo extends StatelessWidget {
  final bool compact;

  const CurrentProfileInfo({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyProfileProvider>(
      builder: (context, familyProvider, child) {
        final activeProfile = familyProvider.activeProfile;
        final isInCaregiverMode = familyProvider.isCaregiverModeActive;

        if (compact) {
          return _buildCompactView(context, activeProfile, isInCaregiverMode);
        } else {
          return _buildExpandedView(context, activeProfile, isInCaregiverMode);
        }
      },
    );
  }

  Widget _buildCompactView(
    BuildContext context,
    DependentProfile? activeProfile,
    bool isInCaregiverMode,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isInCaregiverMode
              ? _getRelationColor(activeProfile?.relation ?? '')
              : Theme.of(context).primaryColor,
          child: Text(
            _getProfileInitial(activeProfile),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _getProfileName(activeProfile),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isInCaregiverMode ? Colors.blue[800] : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedView(
    BuildContext context,
    DependentProfile? activeProfile,
    bool isInCaregiverMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isInCaregiverMode ? Colors.blue[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: isInCaregiverMode
            ? Border.all(color: Colors.blue[200]!)
            : Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isInCaregiverMode
                ? _getRelationColor(activeProfile?.relation ?? '')
                : Theme.of(context).primaryColor,
            child: Text(
              _getProfileInitial(activeProfile),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
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
                  _getProfileName(activeProfile),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isInCaregiverMode
                        ? Colors.blue[800]
                        : Colors.black87,
                  ),
                ),
                if (isInCaregiverMode && activeProfile != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${activeProfile.relation} • Age ${activeProfile.age}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Caregiver Mode Active',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  Text(
                    'Primary Account',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getProfileInitial(DependentProfile? activeProfile) {
    if (activeProfile != null) {
      return activeProfile.name.isNotEmpty
          ? activeProfile.name[0].toUpperCase()
          : '?';
    }
    return 'U'; // Primary user initial
  }

  String _getProfileName(DependentProfile? activeProfile) {
    if (activeProfile != null) {
      return activeProfile.name;
    }
    return 'My Profile'; // Primary user profile
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

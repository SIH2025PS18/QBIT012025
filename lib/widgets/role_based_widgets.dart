import 'package:flutter/material.dart';
import '../constants/user_roles.dart';
import '../services/role_based_auth_service.dart';
import '../middleware/auth_guard.dart';

/// Utility widgets for common role-based UI scenarios

/// Role-based app bar that shows different actions based on user role
class RoleBasedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? commonActions;
  final List<Widget>? patientActions;
  final List<Widget>? doctorActions;
  final List<Widget>? adminActions;
  final List<Widget>? pharmacyActions;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;

  const RoleBasedAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.commonActions,
    this.patientActions,
    this.doctorActions,
    this.adminActions,
    this.pharmacyActions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor,
      actions: [
        if (commonActions != null) ...commonActions!,
        ConditionalAuth(
          patientChild: patientActions != null
              ? Row(children: patientActions!)
              : null,
          doctorChild: doctorActions != null
              ? Row(children: doctorActions!)
              : null,
          adminChild: adminActions != null
              ? Row(children: adminActions!)
              : null,
          pharmacyChild: pharmacyActions != null
              ? Row(children: pharmacyActions!)
              : null,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Role-based bottom navigation bar
class RoleBasedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> commonItems;
  final List<BottomNavigationBarItem>? patientItems;
  final List<BottomNavigationBarItem>? doctorItems;
  final List<BottomNavigationBarItem>? adminItems;
  final List<BottomNavigationBarItem>? pharmacyItems;
  final BottomNavigationBarType? type;

  const RoleBasedBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.commonItems,
    this.patientItems,
    this.doctorItems,
    this.adminItems,
    this.pharmacyItems,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConditionalAuth(
      patientChild: _buildBottomNavBar([...commonItems, ...?patientItems]),
      doctorChild: _buildBottomNavBar([...commonItems, ...?doctorItems]),
      adminChild: _buildBottomNavBar([...commonItems, ...?adminItems]),
      pharmacyChild: _buildBottomNavBar([...commonItems, ...?pharmacyItems]),
      fallbackChild: _buildBottomNavBar(commonItems),
    );
  }

  Widget _buildBottomNavBar(List<BottomNavigationBarItem> items) {
    return BottomNavigationBar(
      currentIndex: currentIndex.clamp(0, items.length - 1),
      onTap: onTap,
      items: items,
      type:
          type ??
          (items.length > 3
              ? BottomNavigationBarType.fixed
              : BottomNavigationBarType.shifting),
    );
  }
}

/// Role-based drawer with different menu items for different roles
class RoleBasedDrawer extends StatelessWidget {
  final Widget? header;
  final List<Widget> commonItems;
  final List<Widget>? patientItems;
  final List<Widget>? doctorItems;
  final List<Widget>? adminItems;
  final List<Widget>? pharmacyItems;
  final Widget? footer;

  const RoleBasedDrawer({
    Key? key,
    this.header,
    required this.commonItems,
    this.patientItems,
    this.doctorItems,
    this.adminItems,
    this.pharmacyItems,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (header != null) header!,
          ...commonItems,
          ConditionalAuth(
            patientChild: patientItems != null
                ? Column(children: patientItems!)
                : null,
            doctorChild: doctorItems != null
                ? Column(children: doctorItems!)
                : null,
            adminChild: adminItems != null
                ? Column(children: adminItems!)
                : null,
            pharmacyChild: pharmacyItems != null
                ? Column(children: pharmacyItems!)
                : null,
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

/// Widget that shows user role information
class UserRoleChip extends StatelessWidget {
  final bool showIcon;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const UserRoleChip({
    Key? key,
    this.showIcon = true,
    this.textStyle,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = RoleBasedAuthService();

    return FutureBuilder<AuthenticatedUser?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const SizedBox.shrink();
        }

        return Chip(
          avatar: showIcon ? _getRoleIcon(user.role) : null,
          label: Text(user.role.displayName, style: textStyle),
          backgroundColor: backgroundColor ?? _getRoleColor(user.role),
        );
      },
    );
  }

  Icon _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return const Icon(Icons.person, size: 16);
      case UserRole.doctor:
        return const Icon(Icons.medical_services, size: 16);
      case UserRole.admin:
        return const Icon(Icons.admin_panel_settings, size: 16);
      case UserRole.pharmacy:
        return const Icon(Icons.local_pharmacy, size: 16);
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return Colors.blue.shade100;
      case UserRole.doctor:
        return Colors.green.shade100;
      case UserRole.admin:
        return Colors.red.shade100;
      case UserRole.pharmacy:
        return Colors.orange.shade100;
    }
  }
}

/// Widget that shows verification status
class VerificationStatusWidget extends StatelessWidget {
  final bool showText;
  final IconData? verifiedIcon;
  final IconData? unverifiedIcon;
  final Color? verifiedColor;
  final Color? unverifiedColor;

  const VerificationStatusWidget({
    Key? key,
    this.showText = true,
    this.verifiedIcon,
    this.unverifiedIcon,
    this.verifiedColor,
    this.unverifiedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = RoleBasedAuthService();

    return FutureBuilder<AuthenticatedUser?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const SizedBox.shrink();
        }

        final isVerified = user.isVerified;
        final icon = isVerified
            ? (verifiedIcon ?? Icons.verified)
            : (unverifiedIcon ?? Icons.pending);
        final color = isVerified
            ? (verifiedColor ?? Colors.green)
            : (unverifiedColor ?? Colors.orange);

        if (showText) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                isVerified ? 'Verified' : 'Pending Verification',
                style: TextStyle(color: color, fontSize: 12),
              ),
            ],
          );
        } else {
          return Icon(icon, color: color, size: 16);
        }
      },
    );
  }
}

/// Button that is only enabled if user has required permissions
class PermissionBasedButton extends StatelessWidget {
  final List<Permission> requiredPermissions;
  final bool requireAll;
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final String? disabledTooltip;

  const PermissionBasedButton({
    Key? key,
    required this.requiredPermissions,
    this.requireAll = false,
    required this.onPressed,
    required this.child,
    this.style,
    this.disabledTooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = RoleBasedAuthService();

    return FutureBuilder<AuthenticatedUser?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ElevatedButton(
            onPressed: null,
            style: style,
            child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final user = snapshot.data;
        final hasPermission =
            user != null &&
            (requireAll
                ? user.hasAllPermissions(requiredPermissions)
                : user.hasAnyPermission(requiredPermissions));

        final button = ElevatedButton(
          onPressed: hasPermission ? onPressed : null,
          style: style,
          child: child,
        );

        if (!hasPermission && disabledTooltip != null) {
          return Tooltip(message: disabledTooltip!, child: button);
        }

        return button;
      },
    );
  }
}

/// FAB that is only shown if user has required permissions
class PermissionBasedFAB extends StatelessWidget {
  final List<Permission> requiredPermissions;
  final bool requireAll;
  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;

  const PermissionBasedFAB({
    Key? key,
    required this.requiredPermissions,
    this.requireAll = false,
    required this.onPressed,
    required this.child,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PermissionGuard(
      requiredPermissions: requiredPermissions,
      requireAll: requireAll,
      fallback: const SizedBox.shrink(),
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        child: child,
      ),
    );
  }
}

/// List tile that is only shown if user has required role
class RoleBasedListTile extends StatelessWidget {
  final List<UserRole> allowedRoles;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool requiresVerification;

  const RoleBasedListTile({
    Key? key,
    required this.allowedRoles,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.requiresVerification = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoleGuard(
      allowedRoles: allowedRoles,
      requiresVerification: requiresVerification,
      fallback: const SizedBox.shrink(),
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

/// Card that shows different content based on user role
class RoleBasedCard extends StatelessWidget {
  final Widget? patientContent;
  final Widget? doctorContent;
  final Widget? adminContent;
  final Widget? pharmacyContent;
  final Widget? defaultContent;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;

  const RoleBasedCard({
    Key? key,
    this.patientContent,
    this.doctorContent,
    this.adminContent,
    this.pharmacyContent,
    this.defaultContent,
    this.margin,
    this.color,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: color,
      elevation: elevation,
      child: ConditionalAuth(
        patientChild: patientContent,
        doctorChild: doctorContent,
        adminChild: adminContent,
        pharmacyChild: pharmacyContent,
        fallbackChild: defaultContent,
      ),
    );
  }
}

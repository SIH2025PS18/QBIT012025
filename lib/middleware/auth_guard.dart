import 'package:flutter/material.dart';
import '../constants/user_roles.dart';
import '../services/role_based_auth_service.dart';

/// Authentication guard for protecting routes and widgets based on authentication status
class AuthGuard extends StatelessWidget {
  final Widget child;
  final Widget? fallback;
  final VoidCallback? onAuthRequired;

  const AuthGuard({
    Key? key,
    required this.child,
    this.fallback,
    this.onAuthRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = RoleBasedAuthService();

    return FutureBuilder<AuthenticatedUser?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;
        if (user == null || !authService.isAuthenticated()) {
          if (onAuthRequired != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onAuthRequired!();
            });
          }
          return fallback ?? const _UnauthenticatedFallback();
        }

        return child;
      },
    );
  }
}

/// Role-based access control guard for protecting content based on user roles
class RoleGuard extends StatelessWidget {
  final Widget child;
  final List<UserRole> allowedRoles;
  final Widget? fallback;
  final bool requiresVerification;
  final VoidCallback? onAccessDenied;

  const RoleGuard({
    Key? key,
    required this.child,
    required this.allowedRoles,
    this.fallback,
    this.requiresVerification = true,
    this.onAccessDenied,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = RoleBasedAuthService();

    return FutureBuilder<AuthenticatedUser?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;
        if (user == null || !authService.isAuthenticated()) {
          return fallback ??
              const _AccessDeniedFallback(message: 'Authentication required');
        }

        // Check if user role is in allowed roles
        if (!allowedRoles.contains(user.role)) {
          if (onAccessDenied != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onAccessDenied!();
            });
          }
          return fallback ??
              _AccessDeniedFallback(
                message:
                    'Access denied. Required role: ${allowedRoles.map((r) => r.displayName).join(', ')}',
              );
        }

        // Check verification status if required
        if (requiresVerification && !user.isVerified) {
          return fallback ??
              const _AccessDeniedFallback(
                message: 'Account verification required',
              );
        }

        return child;
      },
    );
  }
}

/// Permission-based access control guard
class PermissionGuard extends StatelessWidget {
  final Widget child;
  final List<Permission> requiredPermissions;
  final bool
  requireAll; // If true, user must have ALL permissions; if false, ANY permission
  final Widget? fallback;
  final VoidCallback? onAccessDenied;

  const PermissionGuard({
    Key? key,
    required this.child,
    required this.requiredPermissions,
    this.requireAll = false,
    this.fallback,
    this.onAccessDenied,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = RoleBasedAuthService();

    return FutureBuilder<AuthenticatedUser?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;
        if (user == null || !authService.isAuthenticated()) {
          return fallback ??
              const _AccessDeniedFallback(message: 'Authentication required');
        }

        // Check permissions
        bool hasAccess = requireAll
            ? user.hasAllPermissions(requiredPermissions)
            : user.hasAnyPermission(requiredPermissions);

        if (!hasAccess) {
          if (onAccessDenied != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onAccessDenied!();
            });
          }
          return fallback ??
              _AccessDeniedFallback(
                message:
                    'Insufficient permissions. Required: ${requiredPermissions.map((p) => p.value).join(', ')}',
              );
        }

        return child;
      },
    );
  }
}

/// Combined role and permission guard for complex access control scenarios
class RolePermissionGuard extends StatelessWidget {
  final Widget child;
  final List<UserRole>? allowedRoles;
  final List<Permission>? requiredPermissions;
  final bool requireAllPermissions;
  final bool requiresVerification;
  final Widget? fallback;
  final VoidCallback? onAccessDenied;

  const RolePermissionGuard({
    Key? key,
    required this.child,
    this.allowedRoles,
    this.requiredPermissions,
    this.requireAllPermissions = false,
    this.requiresVerification = true,
    this.fallback,
    this.onAccessDenied,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = RoleBasedAuthService();

    return FutureBuilder<AuthenticatedUser?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;
        if (user == null || !authService.isAuthenticated()) {
          return fallback ??
              const _AccessDeniedFallback(message: 'Authentication required');
        }

        // Check verification status if required
        if (requiresVerification && !user.isVerified) {
          return fallback ??
              const _AccessDeniedFallback(
                message: 'Account verification required',
              );
        }

        // Check role access
        if (allowedRoles != null && !allowedRoles!.contains(user.role)) {
          if (onAccessDenied != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onAccessDenied!();
            });
          }
          return fallback ??
              _AccessDeniedFallback(
                message:
                    'Access denied. Required role: ${allowedRoles!.map((r) => r.displayName).join(', ')}',
              );
        }

        // Check permission access
        if (requiredPermissions != null && requiredPermissions!.isNotEmpty) {
          bool hasAccess = requireAllPermissions
              ? user.hasAllPermissions(requiredPermissions!)
              : user.hasAnyPermission(requiredPermissions!);

          if (!hasAccess) {
            if (onAccessDenied != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onAccessDenied!();
              });
            }
            return fallback ??
                _AccessDeniedFallback(
                  message:
                      'Insufficient permissions. Required: ${requiredPermissions!.map((p) => p.value).join(', ')}',
                );
          }
        }

        return child;
      },
    );
  }
}

/// Conditional widget based on authentication and role status
class ConditionalAuth extends StatelessWidget {
  final Widget? authenticatedChild;
  final Widget? unauthenticatedChild;
  final Widget? patientChild;
  final Widget? doctorChild;
  final Widget? adminChild;
  final Widget? pharmacyChild;
  final Widget? unverifiedChild;
  final Widget? fallbackChild;

  const ConditionalAuth({
    Key? key,
    this.authenticatedChild,
    this.unauthenticatedChild,
    this.patientChild,
    this.doctorChild,
    this.adminChild,
    this.pharmacyChild,
    this.unverifiedChild,
    this.fallbackChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = RoleBasedAuthService();

    return FutureBuilder<AuthenticatedUser?>(
      future: authService.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;

        // User not authenticated
        if (user == null || !authService.isAuthenticated()) {
          return unauthenticatedChild ??
              fallbackChild ??
              const SizedBox.shrink();
        }

        // User not verified
        if (!user.isVerified && unverifiedChild != null) {
          return unverifiedChild!;
        }

        // Role-specific widgets
        switch (user.role) {
          case UserRole.patient:
            return patientChild ??
                authenticatedChild ??
                fallbackChild ??
                const SizedBox.shrink();
          case UserRole.doctor:
            return doctorChild ??
                authenticatedChild ??
                fallbackChild ??
                const SizedBox.shrink();
          case UserRole.admin:
            return adminChild ??
                authenticatedChild ??
                fallbackChild ??
                const SizedBox.shrink();
          case UserRole.pharmacy:
            return pharmacyChild ??
                authenticatedChild ??
                fallbackChild ??
                const SizedBox.shrink();
        }
      },
    );
  }
}

/// Utility widget for showing content based on specific permission
class PermissionWidget extends StatelessWidget {
  final Permission permission;
  final Widget child;
  final Widget? fallback;

  const PermissionWidget({
    Key? key,
    required this.permission,
    required this.child,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PermissionGuard(
      requiredPermissions: [permission],
      fallback: fallback ?? const SizedBox.shrink(),
      child: child,
    );
  }
}

// Private fallback widgets

class _UnauthenticatedFallback extends StatelessWidget {
  const _UnauthenticatedFallback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Authentication Required',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Please sign in to access this content',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

class _AccessDeniedFallback extends StatelessWidget {
  final String message;

  const _AccessDeniedFallback({Key? key, required this.message})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.block, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Access Denied',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.red[600]),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

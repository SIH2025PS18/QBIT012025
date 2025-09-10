import 'package:flutter/material.dart';
import '../constants/user_roles.dart';
import '../services/role_based_auth_service.dart';

/// Route guard service for handling navigation-level access control
class RouteGuardService {
  static final RouteGuardService _instance = RouteGuardService._internal();
  factory RouteGuardService() => _instance;
  RouteGuardService._internal();

  final RoleBasedAuthService _authService = RoleBasedAuthService();

  /// Check if current user can access a route based on roles
  Future<bool> canAccessRoute({
    required List<UserRole> allowedRoles,
    bool requiresVerification = true,
  }) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null || !_authService.isAuthenticated()) {
        return false;
      }

      // Check role access
      if (!allowedRoles.contains(user.role)) {
        return false;
      }

      // Check verification status if required
      if (requiresVerification && !user.isVerified) {
        return false;
      }

      return true;
    } catch (e) {
      print('Error checking route access: $e');
      return false;
    }
  }

  /// Check if current user has required permissions for a route
  Future<bool> hasPermissionForRoute({
    required List<Permission> requiredPermissions,
    bool requireAll = false,
  }) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null || !_authService.isAuthenticated()) {
        return false;
      }

      return requireAll
          ? user.hasAllPermissions(requiredPermissions)
          : user.hasAnyPermission(requiredPermissions);
    } catch (e) {
      print('Error checking permission for route: $e');
      return false;
    }
  }

  /// Navigate with role-based access control
  Future<bool> navigateWithRoleCheck({
    required BuildContext context,
    required String routeName,
    List<UserRole>? allowedRoles,
    List<Permission>? requiredPermissions,
    bool requireAllPermissions = false,
    bool requiresVerification = true,
    Map<String, dynamic>? arguments,
    String? fallbackRoute,
    VoidCallback? onAccessDenied,
  }) async {
    try {
      // Check authentication
      if (!_authService.isAuthenticated()) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
        return false;
      }

      final user = await _authService.getCurrentUser();
      if (user == null) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
        return false;
      }

      // Check verification status
      if (requiresVerification && !user.isVerified) {
        if (onAccessDenied != null) {
          onAccessDenied();
        } else {
          _showAccessDeniedDialog(
            context,
            'Account verification required',
            'Please wait for your account to be verified by an administrator.',
          );
        }
        return false;
      }

      // Check role access
      if (allowedRoles != null && !allowedRoles.contains(user.role)) {
        if (onAccessDenied != null) {
          onAccessDenied();
        } else {
          _showAccessDeniedDialog(
            context,
            'Access Denied',
            'You do not have the required role to access this feature. Required: ${allowedRoles.map((r) => r.displayName).join(', ')}',
          );
        }
        return false;
      }

      // Check permission access
      if (requiredPermissions != null && requiredPermissions.isNotEmpty) {
        bool hasAccess = requireAllPermissions
            ? user.hasAllPermissions(requiredPermissions)
            : user.hasAnyPermission(requiredPermissions);

        if (!hasAccess) {
          if (onAccessDenied != null) {
            onAccessDenied();
          } else {
            _showAccessDeniedDialog(
              context,
              'Insufficient Permissions',
              'You do not have the required permissions to access this feature.',
            );
          }
          return false;
        }
      }

      // Navigate to the route
      if (arguments != null) {
        Navigator.of(context).pushNamed(routeName, arguments: arguments);
      } else {
        Navigator.of(context).pushNamed(routeName);
      }

      return true;
    } catch (e) {
      print('Error during navigation with role check: $e');
      if (fallbackRoute != null) {
        Navigator.of(context).pushNamed(fallbackRoute);
      }
      return false;
    }
  }

  /// Replace current route with role-based access control
  Future<bool> pushReplacementWithRoleCheck({
    required BuildContext context,
    required String routeName,
    List<UserRole>? allowedRoles,
    List<Permission>? requiredPermissions,
    bool requireAllPermissions = false,
    bool requiresVerification = true,
    Map<String, dynamic>? arguments,
    String? fallbackRoute,
    VoidCallback? onAccessDenied,
  }) async {
    try {
      // Check authentication
      if (!_authService.isAuthenticated()) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
        return false;
      }

      final user = await _authService.getCurrentUser();
      if (user == null) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
        return false;
      }

      // Check verification status
      if (requiresVerification && !user.isVerified) {
        if (onAccessDenied != null) {
          onAccessDenied();
        } else {
          _showAccessDeniedDialog(
            context,
            'Account verification required',
            'Please wait for your account to be verified by an administrator.',
          );
        }
        return false;
      }

      // Check role access
      if (allowedRoles != null && !allowedRoles.contains(user.role)) {
        if (onAccessDenied != null) {
          onAccessDenied();
        } else {
          _showAccessDeniedDialog(
            context,
            'Access Denied',
            'You do not have the required role to access this feature.',
          );
        }
        return false;
      }

      // Check permission access
      if (requiredPermissions != null && requiredPermissions.isNotEmpty) {
        bool hasAccess = requireAllPermissions
            ? user.hasAllPermissions(requiredPermissions)
            : user.hasAnyPermission(requiredPermissions);

        if (!hasAccess) {
          if (onAccessDenied != null) {
            onAccessDenied();
          } else {
            _showAccessDeniedDialog(
              context,
              'Insufficient Permissions',
              'You do not have the required permissions to access this feature.',
            );
          }
          return false;
        }
      }

      // Replace current route
      if (arguments != null) {
        Navigator.of(
          context,
        ).pushReplacementNamed(routeName, arguments: arguments);
      } else {
        Navigator.of(context).pushReplacementNamed(routeName);
      }

      return true;
    } catch (e) {
      print('Error during route replacement with role check: $e');
      if (fallbackRoute != null) {
        Navigator.of(context).pushReplacementNamed(fallbackRoute);
      }
      return false;
    }
  }

  /// Get appropriate home route based on user role
  String getHomeRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return '/patient-dashboard';
      case UserRole.doctor:
        return '/doctor-dashboard';
      case UserRole.admin:
        return '/admin-dashboard';
      case UserRole.pharmacy:
        return '/pharmacy-dashboard';
    }
  }

  /// Check if user can access admin features
  Future<bool> canAccessAdminFeatures() async {
    return await canAccessRoute(
      allowedRoles: [UserRole.admin],
      requiresVerification: true,
    );
  }

  /// Check if user can access doctor features
  Future<bool> canAccessDoctorFeatures() async {
    return await canAccessRoute(
      allowedRoles: [UserRole.doctor, UserRole.admin],
      requiresVerification: true,
    );
  }

  /// Check if user can access pharmacy features
  Future<bool> canAccessPharmacyFeatures() async {
    return await canAccessRoute(
      allowedRoles: [UserRole.pharmacy, UserRole.admin],
      requiresVerification: true,
    );
  }

  /// Navigate to appropriate dashboard based on user role
  Future<void> navigateToRoleDashboard(BuildContext context) async {
    try {
      final user = await _authService.getCurrentUser();
      if (user == null || !_authService.isAuthenticated()) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
        return;
      }

      final homeRoute = getHomeRouteForRole(user.role);
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(homeRoute, (route) => false);
    } catch (e) {
      print('Error navigating to role dashboard: $e');
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  /// Redirect to login if not authenticated
  void redirectToLoginIfNotAuthenticated(BuildContext context) {
    if (!_authService.isAuthenticated()) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  /// Show access denied dialog
  void _showAccessDeniedDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
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

/// Mixin for pages that require authentication
mixin AuthRequiredMixin<T extends StatefulWidget> on State<T> {
  final RouteGuardService _routeGuard = RouteGuardService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _routeGuard.redirectToLoginIfNotAuthenticated(context);
    });
  }
}

/// Mixin for pages that require specific roles
mixin RoleRequiredMixin<T extends StatefulWidget> on State<T> {
  final RouteGuardService _routeGuard = RouteGuardService();

  /// Override this method to specify required roles
  List<UserRole> get requiredRoles;

  /// Override this method to specify if verification is required
  bool get requiresVerification => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkRoleAccess();
    });
  }

  Future<void> _checkRoleAccess() async {
    final canAccess = await _routeGuard.canAccessRoute(
      allowedRoles: requiredRoles,
      requiresVerification: requiresVerification,
    );

    if (!canAccess) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }
}

/// Mixin for pages that require specific permissions
mixin PermissionRequiredMixin<T extends StatefulWidget> on State<T> {
  final RouteGuardService _routeGuard = RouteGuardService();

  /// Override this method to specify required permissions
  List<Permission> get requiredPermissions;

  /// Override this method to specify if all permissions are required
  bool get requireAllPermissions => false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionAccess();
    });
  }

  Future<void> _checkPermissionAccess() async {
    final canAccess = await _routeGuard.hasPermissionForRoute(
      requiredPermissions: requiredPermissions,
      requireAll: requireAllPermissions,
    );

    if (!canAccess) {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }
}

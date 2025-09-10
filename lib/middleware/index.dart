/// Role-based access control middleware and widgets
///
/// This module provides comprehensive role-based access control (RBAC) functionality
/// for the TeleMed application, including authentication guards, route protection,
/// and role-specific UI components.

// Core guards and middleware
export 'auth_guard.dart';
export 'route_guard.dart';

// Role-based UI widgets
export '../widgets/role_based_widgets.dart';

// Constants and services
export '../constants/user_roles.dart';
export '../services/role_based_auth_service.dart';
export '../services/jwt_service.dart';

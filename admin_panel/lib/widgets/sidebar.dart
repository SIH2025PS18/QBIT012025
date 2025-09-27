import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_theme_provider.dart';

class AdminSidebar extends StatefulWidget {
  const AdminSidebar({Key? key}) : super(key: key);

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  int _selectedIndex = 0;

  final List<SidebarItem> _menuItems = [
    SidebarItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
    ),
    SidebarItem(
      title: 'Doctors',
      icon: Icons.local_hospital,
      route: '/doctors',
      isExpandable: true,
      subItems: [
        SidebarSubItem(title: 'All Doctors', route: '/doctors/all'),
        SidebarSubItem(title: 'Add Doctor', route: '/doctors/add'),
        SidebarSubItem(title: 'Doctor Schedules', route: '/doctors/schedules'),
        SidebarSubItem(title: 'Doctor Dashboard', route: '/doctors/dashboard'),
      ],
    ),
    SidebarItem(
      title: 'Patients',
      icon: Icons.people,
      route: '/patients',
      isExpandable: true,
      subItems: [
        SidebarSubItem(title: 'All Patients', route: '/patients/all'),
        SidebarSubItem(title: 'Patient Records', route: '/patients/records'),
        SidebarSubItem(title: 'Medical History', route: '/patients/history'),
        SidebarSubItem(title: 'Bulk Upload', route: '/patients/bulk-upload'),
      ],
    ),
    SidebarItem(
      title: 'Pharmacies',
      icon: Icons.local_pharmacy,
      route: '/pharmacies',
      isExpandable: true,
      subItems: [
        SidebarSubItem(title: 'All Pharmacies', route: '/pharmacies/all'),
        SidebarSubItem(
            title: 'Government Pharmacies', route: '/pharmacies/government'),
        SidebarSubItem(
            title: 'Verification Queue', route: '/pharmacies/verification'),
      ],
    ),
    SidebarItem(
      title: 'Departments',
      icon: Icons.business,
      route: '/departments',
      isExpandable: true,
      subItems: [
        SidebarSubItem(title: 'All Departments', route: '/departments/all'),
        SidebarSubItem(title: 'Add Department', route: '/departments/add'),
      ],
    ),
    SidebarItem(
      title: 'Appointments',
      icon: Icons.calendar_month,
      route: '/appointments',
      isExpandable: true,
      subItems: [
        SidebarSubItem(title: 'All Appointments', route: '/appointments/all'),
        SidebarSubItem(title: 'Pending', route: '/appointments/pending'),
        SidebarSubItem(title: 'Approved', route: '/appointments/approved'),
        SidebarSubItem(title: 'Cancelled', route: '/appointments/cancelled'),
      ],
    ),
    SidebarItem(
      title: 'Bulk Reports',
      icon: Icons.analytics,
      route: '/bulk-reports',
      isExpandable: true,
      subItems: [
        SidebarSubItem(
            title: 'Patient Reports', route: '/bulk-reports/patients'),
        SidebarSubItem(title: 'Doctor Reports', route: '/bulk-reports/doctors'),
        SidebarSubItem(
            title: 'Appointment Reports', route: '/bulk-reports/appointments'),
        SidebarSubItem(
            title: 'Community Health Reports',
            route: '/bulk-reports/community'),
        SidebarSubItem(
            title: 'Financial Reports', route: '/bulk-reports/financial'),
        SidebarSubItem(
            title: 'Drug Inventory Reports', route: '/bulk-reports/inventory'),
        SidebarSubItem(title: 'Custom Reports', route: '/bulk-reports/custom'),
      ],
    ),
    SidebarItem(
      title: 'Family Hub',
      icon: Icons.family_restroom,
      route: '/family-hub',
      isExpandable: true,
      subItems: [
        SidebarSubItem(title: 'Family Groups', route: '/family-hub/groups'),
        SidebarSubItem(title: 'Community Health', route: '/family-hub/health'),
        SidebarSubItem(
            title: 'Health Analytics', route: '/family-hub/analytics'),
        SidebarSubItem(title: 'Health Alerts', route: '/family-hub/alerts'),
      ],
    ),
    SidebarItem(
      title: 'Settings',
      icon: Icons.settings,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          width: 280,
          height: double.infinity,
          decoration: BoxDecoration(
            color: themeProvider.cardBackgroundColor,
            border: Border(
              right: BorderSide(color: themeProvider.borderColor, width: 1),
            ),
          ),
          child: Column(
            children: [
              // Logo Section
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: themeProvider.accentColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Hospital+',
                      style: TextStyle(
                        color: themeProvider.primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MAIN',
                      style: TextStyle(
                        color: themeProvider.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Menu Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    return _buildMenuItem(_menuItems[index], index);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(SidebarItem item, int index) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        final isSelected = _selectedIndex == index;

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? themeProvider.accentColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(
                        color: themeProvider.accentColor.withOpacity(0.3))
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    // Immediate state update for responsive feel
                    setState(() {
                      _selectedIndex = index;
                      if (item.isExpandable) {
                        item.isExpanded = !item.isExpanded;
                      }
                    });

                    // Handle navigation with minimal delay
                    if (!item.isExpandable) {
                      Future.microtask(() => _handleNavigation(item.route));
                    }
                  },
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected
                          ? themeProvider.accentColor
                          : themeProvider.secondaryTextColor,
                      size: 20,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected
                            ? themeProvider.accentColor
                            : themeProvider.secondaryTextColor,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: item.isExpandable
                        ? Icon(
                            item.isExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: isSelected
                                ? themeProvider.accentColor
                                : themeProvider.secondaryTextColor,
                            size: 20,
                          )
                        : null,
                  ),
                ),
              ),
            ),

            // Sub Items
            if (item.isExpandable && item.isExpanded && item.subItems != null)
              ...item.subItems!.map((subItem) => _buildSubMenuItem(subItem)),
          ],
        );
      },
    );
  }

  Widget _buildSubMenuItem(SidebarSubItem subItem) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          margin: const EdgeInsets.only(left: 20, right: 8, bottom: 2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () =>
                  Future.microtask(() => _handleNavigation(subItem.route)),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 40, right: 16),
                title: Text(
                  subItem.title,
                  style: TextStyle(
                    color: themeProvider.secondaryTextColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleNavigation(String route) {
    try {
      switch (route) {
        case '/dashboard':
          Navigator.pushReplacementNamed(context, '/dashboard');
          break;
        case '/doctors/all':
          Navigator.pushReplacementNamed(context, '/doctors');
          break;
        case '/doctors/add':
          Navigator.pushNamed(context, '/add-doctor');
          break;
        case '/doctors/dashboard':
          Navigator.pushNamed(context, '/doctor-dashboard');
          break;
        case '/patients/all':
          Navigator.pushReplacementNamed(context, '/patients');
          break;
        case '/patients/bulk-upload':
          Navigator.pushNamed(context, '/patients/bulk-upload');
          break;
        case '/pharmacies/all':
          Navigator.pushReplacementNamed(context, '/pharmacies');
          break;
        case '/pharmacies/government':
          Navigator.pushReplacementNamed(context, '/pharmacies');
          break;
        case '/pharmacies/verification':
          Navigator.pushReplacementNamed(context, '/pharmacies');
          break;
        case '/appointments/all':
          Navigator.pushReplacementNamed(context, '/appointments');
          break;
        case '/bulk-reports':
        case '/bulk-reports/patients':
        case '/bulk-reports/doctors':
        case '/bulk-reports/appointments':
        case '/bulk-reports/community':
        case '/bulk-reports/financial':
        case '/bulk-reports/inventory':
        case '/bulk-reports/custom':
          Navigator.pushReplacementNamed(context, '/bulk-reports');
          break;
        case '/departments/all':
          Navigator.pushReplacementNamed(context, '/departments');
          break;
        case '/family-hub':
        case '/family-hub/groups':
        case '/family-hub/health':
        case '/family-hub/analytics':
        case '/family-hub/alerts':
          Navigator.pushReplacementNamed(context, '/family-hub');
          break;
        case '/settings':
          Navigator.pushReplacementNamed(context, '/settings');
          break;
        default:
          print('Navigating to: $route');
          // Try to navigate to the route directly
          Navigator.pushReplacementNamed(context, route);
      }
    } catch (e) {
      print('Navigation failed for route: $route, Error: $e');
      // Show a snackbar or dialog to inform user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to navigate to $route'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class SidebarItem {
  final String title;
  final IconData icon;
  final String route;
  final bool isExpandable;
  final List<SidebarSubItem>? subItems;
  bool isExpanded;

  SidebarItem({
    required this.title,
    required this.icon,
    required this.route,
    this.isExpandable = false,
    this.subItems,
    this.isExpanded = false,
  });
}

class SidebarSubItem {
  final String title;
  final String route;

  SidebarSubItem({
    required this.title,
    required this.route,
  });
}

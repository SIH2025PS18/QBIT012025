import 'package:flutter/material.dart';

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
      title: 'Settings',
      icon: Icons.settings,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D29),
        border: Border(
          right: BorderSide(color: Color(0xFF2A2D3F), width: 1),
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
                    color: const Color(0xFFFF6B9D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_hospital,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Hospital+',
                  style: TextStyle(
                    color: Colors.white,
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
                    color: Colors.grey[600],
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
  }

  Widget _buildMenuItem(SidebarItem item, int index) {
    final isSelected = _selectedIndex == index;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2A2D3F) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: Icon(
              item.icon,
              color: isSelected ? Colors.white : Colors.grey[400],
              size: 20,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            trailing: item.isExpandable
                ? Icon(
                    item.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: isSelected ? Colors.white : Colors.grey[400],
                    size: 20,
                  )
                : null,
            onTap: () {
              setState(() {
                _selectedIndex = index;
                if (item.isExpandable) {
                  item.isExpanded = !item.isExpanded;
                }
              });

              // Handle navigation
              _handleNavigation(item.route);
            },
          ),
        ),

        // Sub Items
        if (item.isExpandable && item.isExpanded && item.subItems != null)
          ...item.subItems!.map((subItem) => _buildSubMenuItem(subItem)),
      ],
    );
  }

  Widget _buildSubMenuItem(SidebarSubItem subItem) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 8, bottom: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 40, right: 16),
        title: Text(
          subItem.title,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 13,
          ),
        ),
        onTap: () => _handleNavigation(subItem.route),
      ),
    );
  }

  void _handleNavigation(String route) {
    switch (route) {
      case '/doctors/all':
        Navigator.pushNamed(context, '/doctors');
        break;
      case '/doctors/add':
        Navigator.pushNamed(context, '/add-doctor');
        break;
      case '/doctors/dashboard':
        Navigator.pushNamed(context, '/doctor-dashboard');
        break;
      case '/patients/all':
        Navigator.pushNamed(context, '/patients');
        break;
      case '/appointments/all':
        Navigator.pushNamed(context, '/appointments');
        break;
      default:
        print('Navigating to: $route');
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

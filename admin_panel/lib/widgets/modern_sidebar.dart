import 'package:flutter/material.dart';

class ModernAdminSidebar extends StatefulWidget {
  const ModernAdminSidebar({Key? key}) : super(key: key);

  @override
  State<ModernAdminSidebar> createState() => _ModernAdminSidebarState();
}

class _ModernAdminSidebarState extends State<ModernAdminSidebar> {
  final Map<String, bool> _expandedItems = {};

  String get _currentRoute {
    final route = ModalRoute.of(context)?.settings.name;
    return route ?? '/dashboard';
  }

  final List<ModernSidebarItem> _menuItems = [
    ModernSidebarItem(
      title: 'MENU',
      isHeader: true,
    ),
    ModernSidebarItem(
      title: 'Dashboard',
      icon: Icons.grid_view_rounded,
      route: '/dashboard',
    ),
    ModernSidebarItem(
      title: 'Patients',
      icon: Icons.people_rounded,
      route: '/patients',
      badge: '12',
    ),
    ModernSidebarItem(
      title: 'Doctors',
      icon: Icons.medical_services_rounded,
      route: '/doctors',
    ),
    ModernSidebarItem(
      title: 'Appointments',
      icon: Icons.calendar_today_rounded,
      route: '/appointments',
      badge: '8',
    ),
    ModernSidebarItem(
      title: 'Analytics',
      icon: Icons.analytics_rounded,
      route: '/analytics',
    ),
    ModernSidebarItem(
      title: 'Departments',
      icon: Icons.business_rounded,
      route: '/departments',
    ),
    ModernSidebarItem(
      title: 'GENERAL',
      isHeader: true,
    ),
    ModernSidebarItem(
      title: 'Reports',
      icon: Icons.description_rounded,
      route: '/modern-reports',
    ),
    ModernSidebarItem(
      title: 'Pharmacies',
      icon: Icons.local_pharmacy_rounded,
      route: '/pharmacies',
    ),
    ModernSidebarItem(
      title: 'Settings',
      icon: Icons.settings_rounded,
      route: '/settings',
    ),
    ModernSidebarItem(
      title: 'Help',
      icon: Icons.help_outline_rounded,
      route: '/help',
    ),
    ModernSidebarItem(
      title: 'Logout',
      icon: Icons.logout_rounded,
      route: '/logout',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMenuItems(),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Sehat Sarthi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _menuItems.length,
      itemBuilder: (context, index) {
        final item = _menuItems[index];

        if (item.isHeader) {
          return _buildHeaderItem(item);
        }

        return _buildMenuItem(item);
      },
    );
  }

  Widget _buildHeaderItem(ModernSidebarItem item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        item.title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem(ModernSidebarItem item) {
    final isSelected = _currentRoute == item.route;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _handleItemTap(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelected ? Colors.white : const Color(0xFF374151),
                    ),
                  ),
                ),
                if (item.badge != null) ...[
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badge!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                ],
                if (item.hasSubmenu) ...[
                  const SizedBox(width: 8),
                  Icon(
                    _expandedItems[item.route] == true
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    size: 16,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.cloud_download_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Download our',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Mobile App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Get easy access anywhere, anytime',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleItemTap(ModernSidebarItem item) {
    if (item.route == '/logout') {
      _handleLogout();
      return;
    }

    // Navigate using Future.microtask to prevent UI blocking
    Future.microtask(() {
      try {
        Navigator.pushReplacementNamed(context, item.route);
      } catch (e) {
        // Handle navigation error gracefully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation to ${item.title} not implemented yet'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    });
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Color(0xFF64748B)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

class ModernSidebarItem {
  final String title;
  final IconData? icon;
  final String route;
  final String? badge;
  final bool isHeader;
  final bool hasSubmenu;
  final List<ModernSidebarSubItem>? subItems;

  ModernSidebarItem({
    required this.title,
    this.icon,
    this.route = '',
    this.badge,
    this.isHeader = false,
    this.hasSubmenu = false,
    this.subItems,
  });
}

class ModernSidebarSubItem {
  final String title;
  final String route;

  ModernSidebarSubItem({
    required this.title,
    required this.route,
  });
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pharmacy_provider.dart';
import '../providers/prescription_provider.dart';
import '../providers/pharmacy_theme_provider.dart';
import '../providers/inventory_provider.dart';
import '../widgets/prescription_request_card.dart';
import '../widgets/pharmacy_stats_widget.dart';
import 'inventory_management_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final prescriptionProvider = Provider.of<PrescriptionProvider>(
      context,
      listen: false,
    );
    await prescriptionProvider.loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Row(
            children: [
              // Fixed Sidebar
              _buildFixedSidebar(themeProvider),

              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    _buildTopBar(themeProvider),
                    Expanded(child: _buildBody()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const PrescriptionRequestsTab();
      case 1:
        return const DashboardOverviewTab();
      case 2:
        return ChangeNotifierProvider(
          create: (_) => InventoryProvider(),
          child: const InventoryManagementScreen(),
        );
      case 3:
        return const OrderHistoryTab();
      default:
        return const PrescriptionRequestsTab();
    }
  }

  Widget _buildFixedSidebar(PharmacyThemeProvider themeProvider) {
    return Container(
      width: 260,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 0)),
        ],
      ),
      child: Column(
        children: [
          // Sidebar Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_pharmacy,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Pharmacy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Main Menu Label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'MAIN MENU',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFF374151),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Color(0xFF9CA3AF),
                    size: 12,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSidebarItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  isSelected: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                _buildSidebarItem(
                  icon: Icons.receipt_long_rounded,
                  title: 'Prescription Requests',
                  isSelected: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                  badge: Consumer<PrescriptionProvider>(
                    builder: (context, provider, child) {
                      final count = provider.totalPendingRequests;
                      return count > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
                _buildSidebarItem(
                  icon: Icons.inventory_2_rounded,
                  title: 'Products',
                  isSelected: _selectedIndex == 2,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                _buildSidebarItem(
                  icon: Icons.category_rounded,
                  title: 'Categories',
                  isSelected: false,
                  onTap: () {},
                ),

                // LEADS Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    children: [
                      Text(
                        'LEADS',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Color(0xFF64748B),
                        size: 16,
                      ),
                    ],
                  ),
                ),

                _buildSidebarItem(
                  icon: Icons.shopping_cart_rounded,
                  title: 'Orders',
                  isSelected: _selectedIndex == 3,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
                _buildSidebarItem(
                  icon: Icons.analytics_rounded,
                  title: 'Sales',
                  isSelected: false,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  icon: Icons.people_rounded,
                  title: 'Customers',
                  isSelected: false,
                  onTap: () {},
                ),

                // COMMS Section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    children: [
                      Text(
                        'COMMS',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: Color(0xFF64748B),
                        size: 16,
                      ),
                    ],
                  ),
                ),

                _buildSidebarItem(
                  icon: Icons.payment_rounded,
                  title: 'Payments',
                  isSelected: false,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  icon: Icons.receipt_long_rounded,
                  title: 'Reports',
                  isSelected: false,
                  onTap: () {},
                ),
                _buildSidebarItem(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Bottom Profile Section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF374151),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Consumer<PharmacyProvider>(
              builder: (context, provider, child) {
                return Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '90%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Complete Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Complete Your Profile to Unlock all Features',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 10,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Verify Identity Button
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Verify Identity',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? badge,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF10B981) : const Color(0xFF9CA3AF),
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF10B981)
                : const Color(0xFF9CA3AF),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
        trailing: badge,
        selected: isSelected,
        selectedTileColor: const Color(0xFF10B981).withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        dense: true,
        onTap: onTap,
      ),
    );
  }

  Widget _buildTopBar(PharmacyThemeProvider themeProvider) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        children: [
          // Search Bar
          Container(
            width: 300,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                  size: 18,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),

          const Spacer(),

          // Right side icons and profile
          Row(
            children: [
              Consumer<PrescriptionProvider>(
                builder: (context, provider, child) {
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _selectedIndex = 0),
                        icon: const Icon(Icons.notifications_outlined),
                        iconSize: 22,
                        color: const Color(0xFF64748B),
                      ),
                      if (provider.totalPendingRequests > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${provider.totalPendingRequests}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(width: 8),

              PopupMenuButton<String>(
                onSelected: _handleMenuAction,
                child: Consumer<PharmacyProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFF10B981),
                          child: Text(
                            'B',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Budiono Siregar',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            Text(
                              'budiono.siregar@gmail.com',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF64748B),
                          size: 18,
                        ),
                      ],
                    );
                  },
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        Icon(Icons.person_outline),
                        SizedBox(width: 8),
                        Text('Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings_outlined),
                        SizedBox(width: 8),
                        Text('Settings'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'help',
                    child: Row(
                      children: [
                        Icon(Icons.help_outline),
                        SizedBox(width: 8),
                        Text('Help'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) async {
    switch (action) {
      case 'profile':
        // TODO: Navigate to profile screen
        break;
      case 'settings':
        // TODO: Navigate to settings screen
        break;
      case 'help':
        // TODO: Show help dialog
        break;
      case 'logout':
        await _handleLogout();
        break;
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final pharmacyProvider = Provider.of<PharmacyProvider>(
        context,
        listen: false,
      );
      await pharmacyProvider.logout();
    }
  }
}

// Tab for prescription requests
class PrescriptionRequestsTab extends StatelessWidget {
  const PrescriptionRequestsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrescriptionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error: ${provider.error}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadRequests(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final pendingRequests = provider.pendingRequests;

        if (pendingRequests.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No pending prescription requests',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'New requests will appear here automatically',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadRequests(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              final request = pendingRequests[index];
              return PrescriptionRequestCard(
                request: request,
                onResponse: (response, notes, cost, medicineAvailability) =>
                    _handleResponse(
                      context,
                      request.id,
                      response,
                      notes,
                      cost,
                      medicineAvailability,
                    ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleResponse(
    BuildContext context,
    String requestId,
    String response,
    String? notes,
    double? cost,
    List<Map<String, dynamic>>? medicineAvailability,
  ) async {
    final provider = Provider.of<PrescriptionProvider>(context, listen: false);

    bool success = false;
    switch (response) {
      case 'all_available':
        success = await provider.respondAllAvailable(
          requestId,
          notes: notes,
          estimatedCost: cost,
        );
        break;
      case 'some_available':
        success = await provider.respondSomeAvailable(
          requestId,
          notes: notes ?? 'Some medicines available',
          estimatedCost: cost,
          medicineAvailability: medicineAvailability,
        );
        break;
      case 'unavailable':
        success = await provider.respondUnavailable(requestId, notes: notes);
        break;
    }

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Response sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send response: ${provider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Tab for dashboard overview
class DashboardOverviewTab extends StatelessWidget {
  const DashboardOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PharmacyStatsWidget(),
          SizedBox(height: 24),
          // Add more dashboard widgets here
        ],
      ),
    );
  }
}

// Tab for order history
class OrderHistoryTab extends StatelessWidget {
  const OrderHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PharmacyProvider>(
      builder: (context, provider, child) {
        final orders = provider.orderHistory;

        if (orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No order history yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('Order #${order['id'] ?? index + 1}'),
                subtitle: Text('₹${order['totalAmount'] ?? 0}'),
                trailing: Chip(
                  label: Text(order['status'] ?? 'Unknown'),
                  backgroundColor: _getStatusColor(order['status']),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green[100]!;
      case 'pending':
        return Colors.orange[100]!;
      case 'cancelled':
        return Colors.red[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}

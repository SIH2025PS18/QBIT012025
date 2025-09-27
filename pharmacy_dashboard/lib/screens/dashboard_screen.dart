import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pharmacy_provider.dart';
import '../providers/prescription_provider.dart';
import '../providers/pharmacy_theme_provider.dart';
import '../widgets/prescription_request_card.dart';
import '../widgets/pharmacy_stats_widget.dart';
import '../widgets/quick_actions_widget.dart';

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
          appBar: _buildAppBar(themeProvider),
          body: _buildBody(),
          drawer: _buildDrawer(themeProvider),
          backgroundColor: themeProvider.primaryBackgroundColor,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(PharmacyThemeProvider themeProvider) {
    return AppBar(
      title: Text(
        'Sehat Sarthi Pharmacy',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: themeProvider.primaryTextColor,
        ),
      ),
      backgroundColor: themeProvider.cardBackgroundColor,
      foregroundColor: themeProvider.primaryTextColor,
      elevation: 1,
      actions: [
        // Theme toggle button
        IconButton(
          onPressed: () => themeProvider.toggleTheme(),
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: themeProvider.primaryTextColor,
          ),
          tooltip: themeProvider.isDarkMode
              ? 'Switch to Light Mode'
              : 'Switch to Dark Mode',
        ),

        // Online status indicator
        Consumer<PharmacyProvider>(
          builder: (context, provider, child) {
            return Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: provider.isOnline ? Colors.green : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    provider.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: provider.isOnline ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Notifications
        Consumer<PrescriptionProvider>(
          builder: (context, provider, child) {
            final urgentCount = provider.criticalRequests;
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0; // Switch to requests tab
                    });
                  },
                ),
                if (urgentCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$urgentCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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

        // Profile menu
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
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
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const PrescriptionRequestsTab();
      case 1:
        return const DashboardOverviewTab();
      case 2:
        return const OrderHistoryTab();
      default:
        return const PrescriptionRequestsTab();
    }
  }

  Widget _buildDrawer(PharmacyThemeProvider themeProvider) {
    return Drawer(
      backgroundColor: themeProvider.cardBackgroundColor,
      child: Column(
        children: [
          // Drawer header
          Consumer<PharmacyProvider>(
            builder: (context, provider, child) {
              final pharmacy = provider.pharmacy;
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: themeProvider.accentColor),
                accountName: Text(
                  pharmacy?.name ?? 'Pharmacy Name',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                accountEmail: Text(
                  pharmacy?.email ?? 'email@pharmacy.com',
                  style: const TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.local_pharmacy,
                    color: themeProvider.accentColor,
                    size: 30,
                  ),
                ),
              );
            },
          ),

          // Menu items
          ListTile(
            leading: Icon(
              Icons.inbox_outlined,
              color: themeProvider.primaryTextColor,
            ),
            title: Text(
              'Prescription Requests',
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
            selected: _selectedIndex == 0,
            selectedTileColor: themeProvider.accentColor.withOpacity(0.1),
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context);
            },
            trailing: Consumer<PrescriptionProvider>(
              builder: (context, provider, child) {
                final count = provider.totalPendingRequests;
                return count > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: themeProvider.accentColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.dashboard_outlined,
              color: themeProvider.primaryTextColor,
            ),
            title: Text(
              'Dashboard',
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
            selected: _selectedIndex == 1,
            selectedTileColor: themeProvider.accentColor.withOpacity(0.1),
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: themeProvider.primaryTextColor),
            title: Text(
              'Order History',
              style: TextStyle(color: themeProvider.primaryTextColor),
            ),
            selected: _selectedIndex == 2,
            selectedTileColor: themeProvider.accentColor.withOpacity(0.1),
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
              Navigator.pop(context);
            },
          ),

          Divider(color: themeProvider.dividerColor),

          // Quick actions
          const QuickActionsWidget(),

          const Spacer(),

          // Online status toggle
          Consumer<PharmacyProvider>(
            builder: (context, provider, child) {
              return SwitchListTile(
                title: Text(
                  'Online Status',
                  style: TextStyle(color: themeProvider.primaryTextColor),
                ),
                subtitle: Text(
                  provider.isOnline
                      ? 'Available for orders'
                      : 'Not accepting orders',
                  style: TextStyle(color: themeProvider.secondaryTextColor),
                ),
                value: provider.isOnline,
                onChanged: (value) {
                  provider.setOnlineStatus(value);
                },
                secondary: Icon(
                  provider.isOnline
                      ? Icons.online_prediction
                      : Icons.offline_bolt,
                  color: provider.isOnline ? Colors.green : Colors.grey,
                ),
              );
            },
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

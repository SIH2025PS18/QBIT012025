import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pharmacy_provider.dart';
import '../providers/prescription_provider.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PharmacyProvider, PrescriptionProvider>(
      builder: (context, pharmacyProvider, prescriptionProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Online status toggle
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      pharmacyProvider.isOnline
                          ? Icons.online_prediction
                          : Icons.offline_bolt,
                      color: pharmacyProvider.isOnline
                          ? Colors.green
                          : Colors.grey,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pharmacy Status',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            pharmacyProvider.isOnline
                                ? 'Currently accepting prescription requests'
                                : 'Offline - Not accepting new requests',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: pharmacyProvider.isOnline,
                      onChanged: (value) {
                        pharmacyProvider.toggleOnlineStatus();
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick action buttons grid
            GridView.count(
              crossAxisCount: _getCrossAxisCount(context),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildActionButton(
                  context,
                  title: 'Respond to All',
                  subtitle:
                      '${prescriptionProvider.totalPendingRequests} pending',
                  icon: Icons.reply_all,
                  color: Colors.blue,
                  onTap: () =>
                      _showBulkResponseDialog(context, prescriptionProvider),
                  enabled: prescriptionProvider.totalPendingRequests > 0,
                ),
                _buildActionButton(
                  context,
                  title: 'Update Inventory',
                  subtitle: 'Medicine stock',
                  icon: Icons.inventory_2_outlined,
                  color: Colors.purple,
                  onTap: () => _showInventoryDialog(context),
                ),
                _buildActionButton(
                  context,
                  title: 'Business Hours',
                  subtitle: 'Set availability',
                  icon: Icons.schedule,
                  color: Colors.orange,
                  onTap: () =>
                      _showBusinessHoursDialog(context, pharmacyProvider),
                ),
                _buildActionButton(
                  context,
                  title: 'Profile Settings',
                  subtitle: 'Pharmacy details',
                  icon: Icons.store,
                  color: Colors.teal,
                  onTap: () =>
                      _showPharmacyProfileDialog(context, pharmacyProvider),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Emergency actions
            if (prescriptionProvider.criticalRequests > 0) ...[
              Card(
                color: Colors.red[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Critical Requests',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${prescriptionProvider.criticalRequests} requests need immediate attention (< 5 minutes remaining)',
                        style: TextStyle(color: Colors.red[600]),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleCriticalRequests(
                            context,
                            prescriptionProvider,
                          ),
                          icon: const Icon(Icons.priority_high),
                          label: const Text('Handle Critical Requests'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Notification settings
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications_outlined),
                        const SizedBox(width: 8),
                        const Text(
                          'Notification Settings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Switch(
                          value: pharmacyProvider.notificationsEnabled,
                          onChanged: (value) {
                            pharmacyProvider.toggleNotifications();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pharmacyProvider.notificationsEnabled
                          ? 'Sound alerts enabled for new requests'
                          : 'Sound alerts disabled',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 800) return 2;
    return 1;
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Card(
      elevation: enabled ? 2 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: enabled
                      ? color.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: enabled ? color : Colors.grey,
                  size: 24,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: enabled ? null : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: enabled ? Colors.grey[600] : Colors.grey[400],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBulkResponseDialog(
    BuildContext context,
    PrescriptionProvider prescriptionProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Response'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Respond to all ${prescriptionProvider.totalPendingRequests} pending requests:',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    prescriptionProvider.respondToAllPending('all_available');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All requests marked as available'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('All Available'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    prescriptionProvider.respondToAllPending('unavailable');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All requests marked as unavailable'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('All Unavailable'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInventoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Inventory'),
        content: const Text('Inventory management feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBusinessHoursDialog(
    BuildContext context,
    PharmacyProvider pharmacyProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Business Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Monday - Friday'),
              subtitle: Text(pharmacyProvider.weekdayHours),
              trailing: const Icon(Icons.edit),
            ),
            ListTile(
              title: const Text('Saturday'),
              subtitle: Text(pharmacyProvider.saturdayHours),
              trailing: const Icon(Icons.edit),
            ),
            ListTile(
              title: const Text('Sunday'),
              subtitle: Text(pharmacyProvider.sundayHours),
              trailing: const Icon(Icons.edit),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPharmacyProfileDialog(
    BuildContext context,
    PharmacyProvider pharmacyProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pharmacy Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${pharmacyProvider.currentPharmacy?.name ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text(
              'Address: ${pharmacyProvider.currentPharmacy?.address ?? 'N/A'}',
            ),
            const SizedBox(height: 8),
            Text('Phone: ${pharmacyProvider.currentPharmacy?.phone ?? 'N/A'}'),
            const SizedBox(height: 8),
            Text(
              'License: ${pharmacyProvider.currentPharmacy?.licenseNumber ?? 'N/A'}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to profile edit screen
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _handleCriticalRequests(
    BuildContext context,
    PrescriptionProvider prescriptionProvider,
  ) {
    // Navigate to filtered view showing only critical requests
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Showing critical requests that need immediate attention',
        ),
        backgroundColor: Colors.red,
      ),
    );

    // TODO: Implement navigation to filtered critical requests view
  }
}

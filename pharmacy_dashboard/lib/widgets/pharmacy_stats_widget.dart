import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pharmacy_provider.dart';
import '../providers/prescription_provider.dart';

class PharmacyStatsWidget extends StatelessWidget {
  const PharmacyStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PharmacyProvider, PrescriptionProvider>(
      builder: (context, pharmacyProvider, prescriptionProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Stats grid
            GridView.count(
              crossAxisCount: _getCrossAxisCount(context),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  context,
                  title: 'Pending Requests',
                  value: '${prescriptionProvider.totalPendingRequests}',
                  icon: Icons.inbox_outlined,
                  color: Colors.orange,
                  subtitle: 'Awaiting response',
                ),
                _buildStatCard(
                  context,
                  title: 'Responded Today',
                  value: '${prescriptionProvider.totalRespondedRequests}',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                  subtitle: 'Total responses',
                ),
                _buildStatCard(
                  context,
                  title: "Today's Revenue",
                  value:
                      '₹${pharmacyProvider.todaysRevenue.toStringAsFixed(0)}',
                  icon: Icons.currency_rupee,
                  color: Colors.blue,
                  subtitle: 'Earned today',
                ),
                _buildStatCard(
                  context,
                  title: 'Online Status',
                  value: pharmacyProvider.isOnline ? 'Online' : 'Offline',
                  icon: pharmacyProvider.isOnline
                      ? Icons.online_prediction
                      : Icons.offline_bolt,
                  color: pharmacyProvider.isOnline ? Colors.green : Colors.grey,
                  subtitle: pharmacyProvider.businessHoursStatus,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quick metrics row
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context,
                    title: 'Avg Response Time',
                    value:
                        '${pharmacyProvider.averageResponseTime.toStringAsFixed(1)} min',
                    icon: Icons.timer_outlined,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    context,
                    title: 'Customer Rating',
                    value:
                        '${pharmacyProvider.customerSatisfaction.toStringAsFixed(1)}★',
                    icon: Icons.star_outline,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent activity summary
            _buildActivitySummary(context, prescriptionProvider),
          ],
        );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildActivitySummary(
    BuildContext context,
    PrescriptionProvider prescriptionProvider,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.timeline, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Activity Summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to detailed analytics
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Recent activity items
            _buildActivityItem(
              icon: Icons.notifications_active,
              title: 'Pending Requests',
              count: prescriptionProvider.totalPendingRequests,
              color: Colors.orange,
              subtitle: 'Awaiting your response',
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              icon: Icons.check_circle,
              title: 'Responded Requests',
              count: prescriptionProvider.totalRespondedRequests,
              color: Colors.green,
              subtitle: 'Successfully handled',
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              icon: Icons.timer_off,
              title: 'Expired Requests',
              count: prescriptionProvider.totalExpiredRequests,
              color: Colors.red,
              subtitle: 'Response time exceeded',
            ),

            if (prescriptionProvider.criticalRequests > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${prescriptionProvider.criticalRequests} critical requests need immediate attention!',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

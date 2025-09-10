import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/connectivity_service.dart';
import '../widgets/offline_capabilities_widget.dart';

class OfflineTestScreen extends StatefulWidget {
  const OfflineTestScreen({Key? key}) : super(key: key);

  @override
  State<OfflineTestScreen> createState() => _OfflineTestScreenState();
}

class _OfflineTestScreenState extends State<OfflineTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏥 Rural Healthcare - Offline Mode'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<ConnectivityService>(
            builder: (context, connectivity, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: connectivity.isConnected
                      ? Colors.green[800]
                      : Colors.orange[700],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      connectivity.isConnected ? Icons.wifi : Icons.wifi_off,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      connectivity.isConnected ? 'ONLINE' : 'OFFLINE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: const OfflineCapabilitiesWidget(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showOfflineInfoDialog(),
        backgroundColor: Colors.green[700],
        icon: const Icon(Icons.info_outline, color: Colors.white),
        label: const Text(
          'About Offline Mode',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showOfflineInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.offline_bolt, color: Colors.green[700]),
            const SizedBox(width: 8),
            const Text('Rural Healthcare Solutions'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This telemedicine app is designed for rural and remote areas with limited internet connectivity.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              Text(
                '🌟 Key Features:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              _FeatureItem(
                icon: '📱',
                title: 'Offline-First Design',
                description: 'All features work without internet connection',
              ),
              _FeatureItem(
                icon: '🌐',
                title: 'Multilingual Support',
                description: 'Healthcare guidance in local languages',
              ),
              _FeatureItem(
                icon: '⚡',
                title: 'Smart Sync',
                description: 'Automatic synchronization when online',
              ),
              _FeatureItem(
                icon: '🏥',
                title: 'Rural-Focused',
                description: 'Designed for areas with poor connectivity',
              ),
              SizedBox(height: 16),
              Text(
                '📊 How It Works:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('1. Data is stored locally in encrypted database'),
              Text('2. Features work completely offline'),
              Text('3. Smart sync when internet is available'),
              Text('4. Priority sync for emergency data'),
              Text('5. Conflict resolution for data consistency'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showTechnicalDetails();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Technical Details'),
          ),
        ],
      ),
    );
  }

  void _showTechnicalDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Technical Implementation'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🔧 Technology Stack:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• SQLite with Drift ORM for local storage'),
              Text('• Encrypted local database'),
              Text('• Background sync with retry logic'),
              Text('• Conflict resolution algorithms'),
              Text('• Connectivity monitoring'),
              SizedBox(height: 16),
              Text(
                '📦 Offline Capabilities:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• Patient profile management'),
              Text('• Appointment scheduling'),
              Text('• Symptom checking with ML-like rules'),
              Text('• Prescription history caching'),
              Text('• Multilingual health guidance'),
              SizedBox(height: 16),
              Text(
                '🔄 Sync Strategy:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• Priority-based sync queue'),
              Text('• Emergency data gets highest priority'),
              Text('• Retry mechanism for failed syncs'),
              Text('• Bandwidth-aware operations'),
              Text('• Last-write-wins conflict resolution'),
            ],
          ),
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
}

class _FeatureItem extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

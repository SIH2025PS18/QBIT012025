import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';

import '../models/video_consultation.dart';
import '../services/video_consultation_service.dart';
import '../services/agora_service.dart';
import '../widgets/consultation_queue_widget.dart';
import '../widgets/consultation_card.dart';
import 'video_call_screen.dart';

/// Doctor Dashboard - Optimized for Web/Desktop use
class DoctorDashboardScreen extends StatefulWidget {
  final String doctorId;

  const DoctorDashboardScreen({
    Key? key,
    required this.doctorId,
  }) : super(key: key);

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _selectedIndex = 0;
  List<VideoConsultation> _queueConsultations = [];
  List<VideoConsultation> _activeConsultations = [];
  List<VideoConsultation> _completedConsultations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final service = context.read<VideoConsultationService>();
    
    try {
      // Load doctor's queue
      final queue = await service.getDoctorQueue(widget.doctorId);
      
      // Load all doctor's consultations
      final allConsultations = await service.getUserConsultations(widget.doctorId);
      
      setState(() {
        _queueConsultations = queue;
        _activeConsultations = allConsultations
            .where((c) => c.status == ConsultationStatus.inProgress)
            .toList();
        _completedConsultations = allConsultations
            .where((c) => c.status == ConsultationStatus.completed)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildWebLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar navigation
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                right: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Doctor Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dr. ${widget.doctorId}', // Replace with actual doctor name
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Navigation items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildNavItem(
                        icon: Icons.queue,
                        title: 'Patient Queue',
                        subtitle: '${_queueConsultations.length} waiting',
                        index: 0,
                      ),
                      _buildNavItem(
                        icon: Icons.videocam,
                        title: 'Active Calls',
                        subtitle: '${_activeConsultations.length} in progress',
                        index: 1,
                      ),
                      _buildNavItem(
                        icon: Icons.history,
                        title: 'Consultation History',
                        subtitle: '${_completedConsultations.length} completed',
                        index: 2,
                      ),
                      const Divider(),
                      _buildNavItem(
                        icon: Icons.settings,
                        title: 'Settings',
                        subtitle: 'Preferences & config',
                        index: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        elevation: 1,
      ),
      body: _buildMainContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${_queueConsultations.length}'),
              child: const Icon(Icons.queue),
            ),
            label: 'Queue',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text('${_activeConsultations.length}'),
              child: const Icon(Icons.videocam),
            ),
            label: 'Active',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        selected: isSelected,
        selectedTileColor: Colors.blue.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        onTap: () => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (_selectedIndex) {
      case 0:
        return _buildQueueTab();
      case 1:
        return _buildActiveCallsTab();
      case 2:
        return _buildHistoryTab();
      case 3:
        return _buildSettingsTab();
      default:
        return _buildQueueTab();
    }
  }

  Widget _buildQueueTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with stats
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Patient Queue',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatCard(
                    title: 'Waiting Patients',
                    value: '${_queueConsultations.length}',
                    icon: Icons.people,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    title: 'Avg. Wait Time',
                    value: '15 min', // Calculate from queue
                    icon: Icons.schedule,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    title: 'Priority Cases',
                    value: '${_queueConsultations.where((c) => c.priority.priorityValue > 3).length}',
                    icon: Icons.priority_high,
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Queue list
        Expanded(
          child: ConsultationQueueWidget(
            consultations: _queueConsultations,
            isDoctor: true,
            onStartConsultation: _startConsultation,
            onCancelConsultation: _cancelConsultation,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveCallsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          child: const Text(
            'Active Consultations',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        Expanded(
          child: _activeConsultations.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.videocam_off, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No active consultations',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _activeConsultations.length,
                  itemBuilder: (context, index) {
                    final consultation = _activeConsultations[index];
                    return ConsultationCard(
                      consultation: consultation,
                      isDoctor: true,
                      onTap: () => _joinActiveCall(consultation),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          child: const Text(
            'Consultation History',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _completedConsultations.length,
            itemBuilder: (context, index) {
              final consultation = _completedConsultations[index];
              return ConsultationCard(
                consultation: consultation,
                isDoctor: true,
                showHistory: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTab() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          Text('Settings panel would go here...'),
          // Add settings options like:
          // - Notification preferences
          // - Video quality settings
          // - Audio settings
          // - Profile management
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startConsultation(VideoConsultation consultation) async {
    try {
      final service = context.read<VideoConsultationService>();
      await service.startConsultation(consultation.id);
      
      // Navigate to video call
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<AgoraService>(
            create: (_) => AgoraService(),
            child: VideoCallScreen(
              consultation: consultation.copyWith(
                status: ConsultationStatus.inProgress,
              ),
              userId: widget.doctorId,
              isDoctor: true,
            ),
          ),
        ),
      );
      
      _loadData(); // Refresh data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting consultation: $e')),
      );
    }
  }

  Future<void> _cancelConsultation(VideoConsultation consultation) async {
    try {
      final service = context.read<VideoConsultationService>();
      await service.cancelConsultation(consultation.id);
      
      _loadData(); // Refresh data
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consultation cancelled')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling consultation: $e')),
      );
    }
  }

  void _joinActiveCall(VideoConsultation consultation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider<AgoraService>(
          create: (_) => AgoraService(),
          child: VideoCallScreen(
            consultation: consultation,
            userId: widget.doctorId,
            isDoctor: true,
          ),
        ),
      ),
    );
  }
}
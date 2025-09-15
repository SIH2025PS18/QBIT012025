import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/video_consultation.dart';
import '../widgets/custom_button.dart';
import '../widgets/queue_position_widget.dart';
import 'video_consultation_screen.dart';

class WaitingRoomScreen extends StatefulWidget {
  final VideoConsultation consultation;
  final QueuePosition queuePosition;

  const WaitingRoomScreen({
    super.key,
    required this.consultation,
    required this.queuePosition,
  });

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  late QueuePosition _queuePosition;
  bool _isReceivingUpdates = true;
  int _updateCounter = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with the provided queue position
    _queuePosition = widget.queuePosition;

    // Simulate position updates
    _startPositionUpdates();
  }

  void _startPositionUpdates() {
    // In a real app, this would listen to real-time updates from the server
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isReceivingUpdates) {
        setState(() {
          _queuePosition = QueuePosition(
            position: 3,
            totalInQueue: 12,
            estimatedWaitTime: const Duration(minutes: 25),
            priority: _queuePosition.priority.priorityValue > 3
                ? QueuePriority.urgent
                : QueuePriority.normal,
          );
          _updateCounter++;
        });

        // Schedule next update
        _startPositionUpdates();
      }
    });
  }

  @override
  void dispose() {
    _isReceivingUpdates = false;
    super.dispose();
  }

  void _startConsultation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VideoConsultationScreen(
          userId: 'patient-123',
          isDoctor: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.waitingRoom,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // In a real app, this would refresh the queue position
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.tapToRefresh)));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                l10n.consultationScheduled,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.waitingRoomMessage,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // Queue position widget
              QueuePositionWidget(
                queuePosition: _queuePosition,
                consultation: widget.consultation,
              ),

              const SizedBox(height: 32),

              // Doctor information
              _buildDoctorInfo(),

              const SizedBox(height: 32),

              // SMS notifications
              _buildSmsNotificationInfo(),

              const SizedBox(height: 32),

              // Actions
              CustomButton(
                text: l10n.cancelConsultation,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                backgroundColor: Colors.red,
                textColor: Colors.white,
                icon: Icons.cancel,
              ),

              const SizedBox(height: 16),

              OutlinedButton(
                onPressed: () {
                  // In a real app, this would minimize the app but keep the queue position
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'You can close the app. We\'ll hold your place.',
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: const Text(
                  'Close App (We\'ll Hold Your Place)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Doctor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(0.1),
                child: const Icon(Icons.medical_services, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.consultation.doctorName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'General Medicine',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '10 years experience',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Next Available: 2:30 PM',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSmsNotificationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.sms, color: Colors.green),
              SizedBox(width: 12),
              Text(
                'SMS Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'You will receive SMS updates:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• When your position changes significantly',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                '• 10 minutes before your turn',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                '• 5 minutes before your turn',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                '• When it\'s your turn for consultation',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Current phone number: +91 98765 43210',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // In a real app, this would allow changing the phone number
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Change phone number feature coming soon'),
                ),
              );
            },
            child: const Text(
              'Change Phone Number',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

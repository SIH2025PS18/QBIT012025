import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../generated/l10n/app_localizations.dart';
import '../models/video_consultation.dart';
import '../services/video_consultation_service.dart';
import '../services/agora_service.dart';
import 'waiting_room_screen.dart';
import 'video_call_screen.dart';
import '../widgets/consultation_queue_widget.dart';
import '../widgets/consultation_card.dart';

/// Video consultation screen with call controls and participant management
class VideoConsultationScreen extends StatefulWidget {
  final String userId;
  final bool isDoctor;

  const VideoConsultationScreen({
    Key? key,
    required this.userId,
    required this.isDoctor,
  }) : super(key: key);

  @override
  State<VideoConsultationScreen> createState() =>
      _VideoConsultationScreenState();
}

class _VideoConsultationScreenState extends State<VideoConsultationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StreamSubscription? _consultationSubscription;
  StreamSubscription? _queueSubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.isDoctor ? 3 : 2,
      vsync: this,
    );
    _setupListeners();
  }

  void _setupListeners() {
    final service = context.read<VideoConsultationService>();

    // Listen for consultation updates
    _consultationSubscription = service.consultationStream.listen((
      consultation,
    ) {
      if (consultation?.status == ConsultationStatus.inProgress) {
        _navigateToVideoCall(consultation!);
      }
    });

    // Listen for queue updates
    _queueSubscription = service.queueStream.listen((queue) {
      // Handle queue updates if needed
    });
  }

  void _navigateToVideoCall(VideoConsultation consultation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          consultation: consultation,
          userId: widget.userId,
          isDoctor: widget.isDoctor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isDoctor ? 'Doctor Dashboard' : 'My Consultations'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            const Tab(text: 'Active', icon: const Icon(Icons.videocam)),
            const Tab(text: 'Queue', icon: const Icon(Icons.queue)),
            if (widget.isDoctor)
              const Tab(text: 'History', icon: const Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveConsultationsTab(),
          _buildQueueTab(),
          if (widget.isDoctor) _buildHistoryTab(),
        ],
      ),
      floatingActionButton: widget.isDoctor ? null : _buildPatientFAB(),
    );
  }

  Widget _buildActiveConsultationsTab() {
    return Consumer<VideoConsultationService>(
      builder: (context, service, child) {
        final activeConsultations = widget.isDoctor
            ? service.activeConsultations
                  .where((c) => c.doctorId == widget.userId)
                  .toList()
            : service.activeConsultations
                  .where((c) => c.patientId == widget.userId)
                  .toList();

        if (activeConsultations.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No active consultations'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activeConsultations.length,
          itemBuilder: (context, index) {
            final consultation = activeConsultations[index];
            return ConsultationCard(
              consultation: consultation,
              isDoctor: widget.isDoctor,
              onTap: () => _navigateToVideoCall(consultation),
            );
          },
        );
      },
    );
  }

  Widget _buildQueueTab() {
    if (widget.isDoctor) {
      return Consumer<VideoConsultationService>(
        builder: (context, service, child) {
          return FutureBuilder<List<VideoConsultation>>(
            future: service.getDoctorQueue(widget.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final queue = snapshot.data ?? [];
              return ConsultationQueueWidget(
                consultations: queue,
                isDoctor: true,
                onStartConsultation: (consultation) async {
                  await service.startConsultation(consultation.id);
                },
                onCancelConsultation: (consultation) async {
                  await service.cancelConsultation(consultation.id);
                },
              );
            },
          );
        },
      );
    } else {
      return Consumer<VideoConsultationService>(
        builder: (context, service, child) {
          if (service.currentQueuePosition == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.queue, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Not in queue'),
                  SizedBox(height: 8),
                  Text('Join a consultation to see your position'),
                ],
              ),
            );
          }

          return WaitingRoomScreen(
            consultation: service.currentConsultation!,
            queuePosition: service.currentQueuePosition!,
          );
        },
      );
    }
  }

  Widget _buildHistoryTab() {
    return Consumer<VideoConsultationService>(
      builder: (context, service, child) {
        return FutureBuilder<List<VideoConsultation>>(
          future: service.getUserConsultations(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final consultations = snapshot.data ?? [];
            final completedConsultations = consultations
                .where((c) => c.status == ConsultationStatus.completed)
                .toList();

            if (completedConsultations.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No consultation history'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completedConsultations.length,
              itemBuilder: (context, index) {
                final consultation = completedConsultations[index];
                return ConsultationCard(
                  consultation: consultation,
                  isDoctor: widget.isDoctor,
                  showHistory: true,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget? _buildPatientFAB() {
    return FloatingActionButton.extended(
      onPressed: _showJoinConsultationDialog,
      label: const Text('Join Queue'),
      icon: const Icon(Icons.add),
    );
  }

  void _showJoinConsultationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Consultation Queue'),
        content: const Text('Do you want to join the consultation queue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // This would typically come from an appointment
              // For demo purposes, create a sample consultation
              await _createSampleConsultation();
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Future<void> _createSampleConsultation() async {
    try {
      final service = context.read<VideoConsultationService>();

      // Create a sample consultation (in real app, this would come from appointments)
      final consultation = await service.createConsultation(
        appointmentId: 'sample-appointment',
        patientId: widget.userId,
        doctorId: 'doctor-1', // This should come from the selected doctor
        patientName: 'Patient Name', // Get from user profile
        doctorName: 'Dr. Smith', // Get from doctor profile
        scheduledAt: DateTime.now(),
      );

      // Join the queue
      await service.joinQueue(consultation.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Joined consultation queue')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _consultationSubscription?.cancel();
    _queueSubscription?.cancel();
    super.dispose();
  }
}

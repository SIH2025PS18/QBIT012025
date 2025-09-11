import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'mobile_video_call_screen.dart';
import '../models/video_consultation.dart';
import 'doctor_queue_screen.dart';

class QueueWaitingScreen extends StatefulWidget {
  final LiveDoctor doctor;

  const QueueWaitingScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<QueueWaitingScreen> createState() => _QueueWaitingScreenState();
}

class _QueueWaitingScreenState extends State<QueueWaitingScreen>
    with TickerProviderStateMixin {
  late Timer _updateTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int _currentPosition = 2;
  int _estimatedWaitTime = 8;
  bool _isDoctorReady = false;

  @override
  void initState() {
    super.initState();

    _currentPosition = widget.doctor.currentPatients + 1;
    _estimatedWaitTime = widget.doctor.estimatedWaitTime;

    // Initialize pulse animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    _startUpdateTimer();
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _updateQueueStatus();
    });
  }

  void _updateQueueStatus() {
    final random = Random();

    setState(() {
      // Simulate queue movement
      if (_currentPosition > 1 && random.nextBool()) {
        _currentPosition--;
        _estimatedWaitTime = max(1, _estimatedWaitTime - random.nextInt(3));
      }

      // Check if it's patient's turn
      if (_currentPosition <= 1 && !_isDoctorReady) {
        _isDoctorReady = true;
        _showDoctorReadyDialog();
      }
    });
  }

  void _showDoctorReadyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.videocam, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Doctor is Ready!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Dr. ${widget.doctor.name} is ready to see you now.'),
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  widget.doctor.avatar,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: _startVideoCall,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Start Video Call'),
          ),
        ],
      ),
    );
  }

  void _startVideoCall() {
    Navigator.pop(context); // Close dialog

    // Create mock consultation for video call
    final now = DateTime.now();
    final consultation = VideoConsultation(
      id: 'consultation_${now.millisecondsSinceEpoch}',
      appointmentId: 'appointment_${now.millisecondsSinceEpoch}',
      patientId: 'patient_123',
      doctorId: widget.doctor.id,
      patientName: 'Patient',
      doctorName: widget.doctor.name,
      status: ConsultationStatus.inProgress,
      scheduledAt: now,
      createdAt: now,
      updatedAt: now,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MobileVideoCallScreen(
          consultation: consultation,
          userId: 'patient_123',
          isDoctor: false,
          doctorName: widget.doctor.name,
        ),
      ),
    );
  }

  void _leaveQueue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Queue'),
        content: const Text('Are you sure you want to leave the queue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to queue screen
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Waiting in Queue'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _leaveQueue,
            child: Text('Leave', style: TextStyle(color: Colors.red[600])),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Doctor info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Doctor avatar
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: Colors.blue[300]!,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.doctor.avatar,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Doctor name and specialization
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.doctor.specialization,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.doctor.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Queue position card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[600]!, Colors.blue[700]!],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your Position',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    _currentPosition.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    _currentPosition == 1 ? 'You\'re next!' : 'in queue',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Wait time info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.orange[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Wait Time',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '~$_estimatedWaitTime minutes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Status updates
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.green[600],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Queue Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isDoctorReady
                        ? 'Doctor is ready to see you!'
                        : _currentPosition == 1
                        ? 'You\'re next in line. The doctor will be with you shortly.'
                        : 'Please wait. The doctor is currently with another patient.',
                    style: TextStyle(fontSize: 13, color: Colors.green[600]),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Leave queue button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _leaveQueue,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.red[400]!),
                  foregroundColor: Colors.red[600],
                ),
                child: const Text(
                  'Leave Queue',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

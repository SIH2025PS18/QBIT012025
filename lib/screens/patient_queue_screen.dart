import 'package:flutter/material.dart';
import '../models/video_consultation.dart';
import '../widgets/custom_button.dart';
import '../widgets/queue_position_widget.dart';
import 'waiting_room_screen.dart';

class PatientQueueScreen extends StatefulWidget {
  const PatientQueueScreen({super.key});

  @override
  State<PatientQueueScreen> createState() => _PatientQueueScreenState();
}

class _PatientQueueScreenState extends State<PatientQueueScreen> {
  QueuePriority? _selectedPriority;
  bool _isJoiningQueue = false;
  QueuePosition? _queuePosition;

  // Mock doctors for demonstration
  final List<Map<String, dynamic>> _doctors = [
    {
      'name': 'Dr. Singh',
      'specialization': 'General Medicine',
      'experience': '10 years',
      'rating': 4.8,
    },
    {
      'name': 'Dr. Kaur',
      'specialization': 'Pediatrics',
      'experience': '8 years',
      'rating': 4.9,
    },
    {
      'name': 'Dr. Patel',
      'specialization': 'Cardiology',
      'experience': '15 years',
      'rating': 4.7,
    },
  ];

  final List<Map<String, dynamic>> _urgencyLevels = [
    {
      'priority': QueuePriority.emergency,
      'title': 'Emergency',
      'description':
          'Life-threatening conditions requiring immediate attention',
      'examples': 'Severe chest pain, difficulty breathing, severe bleeding',
      'color': Colors.red,
    },
    {
      'priority': QueuePriority.urgent,
      'title': 'Urgent',
      'description':
          'Serious conditions needing prompt attention within 2 hours',
      'examples': 'High fever, severe pain, injury requiring treatment',
      'color': Colors.orange,
    },
    {
      'priority': QueuePriority.normal,
      'title': 'Normal',
      'description': 'Routine consultations that can wait',
      'examples': 'Regular checkup, minor symptoms, follow-up visits',
      'color': Colors.blue,
    },
  ];

  Future<void> _joinQueue() async {
    if (_selectedPriority == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select urgency level')),
      );
      return;
    }

    setState(() {
      _isJoiningQueue = true;
    });

    try {
      // Simulate joining queue
      await Future.delayed(const Duration(seconds: 2));

      // Mock queue position
      final mockQueuePosition = QueuePosition(
        position: 3,
        totalInQueue: 12,
        estimatedWaitTime: const Duration(minutes: 25),
        priority: _selectedPriority!,
      );

      if (mounted) {
        setState(() {
          _isJoiningQueue = false;
          _queuePosition = mockQueuePosition;
        });

        // Show confirmation
        _showQueueConfirmation();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isJoiningQueue = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to join queue: $e')));
      }
    }
  }

  void _showQueueConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Queue Confirmation'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'You are number 3 in line',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Estimated wait time: 25 minutes',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Text(
              'You will get an SMS 5 minutes before your turn.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can close the app. We\'ll hold your place.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Create a mock VideoConsultation object
              final mockConsultation = VideoConsultation.create(
                appointmentId: 'appointment-123',
                patientId: 'patient-123',
                doctorId: 'doctor-123',
                patientName: 'John Doe',
                doctorName: 'Dr. Singh',
                scheduledAt: DateTime.now().add(const Duration(minutes: 25)),
              );

              // Navigate to waiting room with required parameters
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WaitingRoomScreen(
                    consultation: mockConsultation,
                    queuePosition: _queuePosition!,
                  ),
                ),
              );
            },
            child: const Text('Go to Waiting Room'),
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Join Consultation Queue',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Select Urgency Level',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose based on your current symptoms',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // Urgency level selection
              ..._urgencyLevels.map((urgency) {
                return _buildUrgencyCard(urgency);
              }).toList(),

              const SizedBox(height: 32),

              // Selected doctor info
              _buildDoctorInfo(),

              const SizedBox(height: 32),

              // Join queue button
              CustomButton(
                text: 'Join Queue',
                onPressed: _joinQueue,
                isLoading: _isJoiningQueue,
                icon: Icons.queue,
              ),

              const SizedBox(height: 16),

              // SMS info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sms, color: Colors.blue),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'You can also join by sending SMS: SEHAT <urgency_code> to 12345',
                        style: TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUrgencyCard(Map<String, dynamic> urgency) {
    final isSelected = _selectedPriority == urgency['priority'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = urgency['priority'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? urgency['color'] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? urgency['color'] : Colors.grey[300]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : urgency['color']!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getPriorityIcon(urgency['priority']),
                    color: isSelected ? Colors.white : urgency['color'],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        urgency['title'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        urgency['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: Colors.white, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Examples: ${urgency['examples']}',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    // For demo, we'll show the first doctor
    final doctor = _doctors[0];

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
            'Selected Doctor',
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
                      doctor['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      doctor['specialization'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${doctor['rating']}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          doctor['experience'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getPriorityIcon(QueuePriority priority) {
    switch (priority) {
      case QueuePriority.emergency:
        return Icons.emergency;
      case QueuePriority.urgent:
        return Icons.priority_high;
      case QueuePriority.high:
        return Icons.keyboard_arrow_up;
      case QueuePriority.normal:
        return Icons.horizontal_rule;
      case QueuePriority.low:
        return Icons.keyboard_arrow_down;
    }
  }
}

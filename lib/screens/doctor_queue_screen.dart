import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

// Model for live doctor queue
class LiveDoctor {
  final String id;
  final String name;
  final String specialization;
  final String avatar;
  final bool isOnline;
  final int currentPatients;
  final int estimatedWaitTime; // in minutes
  final double rating;
  final String status; // 'available', 'busy', 'break'

  LiveDoctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.avatar,
    required this.isOnline,
    required this.currentPatients,
    required this.estimatedWaitTime,
    required this.rating,
    required this.status,
  });
}

class DoctorQueueScreen extends StatefulWidget {
  const DoctorQueueScreen({Key? key}) : super(key: key);

  @override
  State<DoctorQueueScreen> createState() => _DoctorQueueScreenState();
}

class _DoctorQueueScreenState extends State<DoctorQueueScreen>
    with TickerProviderStateMixin {
  late Timer _refreshTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  List<LiveDoctor> _liveDoctors = [];
  bool _isLoading = true;
  String? _joinedQueueDoctorId;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    _loadLiveDoctors();
    _startRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startRefreshTimer() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateDoctorData();
    });
  }

  Future<void> _loadLiveDoctors() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call to get live doctors
    await Future.delayed(const Duration(seconds: 1));

    // Mock data - in real app this would come from backend
    final mockDoctors = [
      LiveDoctor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialization: 'General Medicine',
        avatar: '👩‍⚕️',
        isOnline: true,
        currentPatients: 2,
        estimatedWaitTime: 8,
        rating: 4.9,
        status: 'available',
      ),
      LiveDoctor(
        id: '2',
        name: 'Dr. Michael Chen',
        specialization: 'Pediatrics',
        avatar: '👨‍⚕️',
        isOnline: true,
        currentPatients: 1,
        estimatedWaitTime: 5,
        rating: 4.8,
        status: 'available',
      ),
    ];

    setState(() {
      _liveDoctors = mockDoctors;
      _isLoading = false;
    });
  }

  void _updateDoctorData() {
    // Simulate real-time updates
    final random = Random();

    setState(() {
      for (var i = 0; i < _liveDoctors.length; i++) {
        final doctor = _liveDoctors[i];

        // Random updates to make it feel live
        final newWaitTime = max(
          1,
          doctor.estimatedWaitTime + random.nextInt(3) - 1,
        );
        final newPatients = max(
          0,
          doctor.currentPatients + random.nextInt(3) - 1,
        );

        _liveDoctors[i] = LiveDoctor(
          id: doctor.id,
          name: doctor.name,
          specialization: doctor.specialization,
          avatar: doctor.avatar,
          isOnline: doctor.isOnline,
          currentPatients: newPatients,
          estimatedWaitTime: newWaitTime,
          rating: doctor.rating,
          status: doctor.status,
        );
      }
    });
  }

  void _joinQueue(LiveDoctor doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Join Queue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Join Dr. ${doctor.name}\'s queue?'),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Text('Estimated wait: ${doctor.estimatedWaitTime} minutes'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text('${doctor.currentPatients} patients ahead'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmJoinQueue(doctor);
            },
            child: const Text('Join Queue'),
          ),
        ],
      ),
    );
  }

  void _confirmJoinQueue(LiveDoctor doctor) {
    setState(() {
      _joinedQueueDoctorId = doctor.id;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Joined Dr. ${doctor.name}\'s queue')),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate to waiting screen after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamed(context, '/queue-waiting', arguments: doctor);
    });
  }

  void _leaveQueue() {
    setState(() {
      _joinedQueueDoctorId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Left the queue'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Live Doctor Queue',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading live doctors...'),
                ],
              ),
            )
          : Column(
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.health_and_safety,
                            color: Colors.blue[600],
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_liveDoctors.where((d) => d.isOnline).length} Doctors Available',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join a queue to consult with a doctor immediately',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                // Current queue status (if joined)
                if (_joinedQueueDoctorId != null) _buildQueueStatusCard(),

                // Live doctors list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadLiveDoctors,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _liveDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = _liveDoctors[index];
                        return _buildDoctorCard(doctor);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQueueStatusCard() {
    final doctor = _liveDoctors.firstWhere(
      (d) => d.id == _joinedQueueDoctorId,
      orElse: () => _liveDoctors.first,
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.queue, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                'You\'re in queue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
              const Spacer(),
              TextButton(onPressed: _leaveQueue, child: const Text('Leave')),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Dr. ${doctor.name}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(
            'Position: ${doctor.currentPatients + 1} • Wait: ~${doctor.estimatedWaitTime} min',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(LiveDoctor doctor) {
    final isInQueue = _joinedQueueDoctorId == doctor.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        border: isInQueue ? Border.all(color: Colors.blue, width: 2) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Doctor avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      doctor.avatar,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Doctor info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: doctor.isOnline
                                  ? Colors.green
                                  : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doctor.specialization,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            doctor.rating.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status and wait time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: doctor.status == 'available'
                            ? Colors.green[100]
                            : Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        doctor.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: doctor.status == 'available'
                              ? Colors.green[700]
                              : Colors.orange[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '~${doctor.estimatedWaitTime} min',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Queue info
            Row(
              children: [
                Icon(Icons.people_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${doctor.currentPatients} patients in queue',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),

                // Join queue button
                if (!isInQueue)
                  ElevatedButton(
                    onPressed: doctor.isOnline && _joinedQueueDoctorId == null
                        ? () => _joinQueue(doctor)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Join Queue',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'In Queue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

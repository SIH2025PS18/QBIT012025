import 'package:flutter/material.dart';
import '../services/socket_service.dart';
import '../models/video_consultation.dart';
import '../screens/video_call_screen.dart';

/// Screen that handles incoming video call requests from doctor dashboard
class VideoCallRequestScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const VideoCallRequestScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  State<VideoCallRequestScreen> createState() => _VideoCallRequestScreenState();
}

class _VideoCallRequestScreenState extends State<VideoCallRequestScreen> {
  late SocketService _socketService;
  bool _isWaiting = true;
  bool _isConnected = false;
  String _status = 'Connecting to doctor dashboard...';

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
    _initializeSocket();
  }

  Future<void> _initializeSocket() async {
    try {
      setState(() {
        _status = 'Connecting to doctor dashboard...';
      });

      // Initialize socket connection
      await _socketService.initialize(
        serverUrl: 'https://telemed18.onrender.com', // Unified backend URL
        userId: widget.patientId,
        userRole: 'patient',
        userName: widget.patientName,
      );

      setState(() {
        _isConnected = true;
        _status = 'Connected. Waiting for doctor to start consultation...';
      });

      // Listen for video call requests
      _socketService.videoCallRequests.listen((request) {
        if (request.patientId == widget.patientId) {
          _handleVideoCallRequest(request);
        }
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to connect: $e';
      });
    }
  }

  void _handleVideoCallRequest(VideoCallRequest request) {
    // Show incoming call dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text('Incoming Video Consultation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.video_call, size: 64, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                'Dr. ${request.doctorId} is calling you for video consultation',
              ),
              const SizedBox(height: 8),
              const Text(
                'Do you want to accept the call?',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _declineCall(request);
              },
              child: const Text('Decline'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _acceptCall(request);
              },
              child: const Text('Accept'),
            ),
          ],
        ),
      ),
    );
  }

  void _acceptCall(VideoCallRequest request) {
    // Create video consultation object
    final consultation = VideoConsultation(
      id: request.consultationId,
      appointmentId: 'apt_${request.consultationId}',
      patientId: request.patientId,
      doctorId: request.doctorId,
      patientName: widget.patientName,
      doctorName: 'Dr. ${request.doctorId}',
      status: ConsultationStatus.inProgress,
      scheduledAt: DateTime.now(),
      roomId: request.roomId,
      participants: [],
      isRecorded: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Navigate to video call screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          consultation: consultation,
          userId: widget.patientId,
          isDoctor: false,
        ),
      ),
    ).then((_) {
      // Return to waiting state after call ends
      setState(() {
        _isWaiting = true;
        _status = 'Waiting for doctor to start consultation...';
      });
    });
  }

  void _declineCall(VideoCallRequest request) {
    // Send decline notification to doctor
    _socketService.endWebRTCCall(
      to: request.doctorId,
      from: request.patientId,
      consultationId: request.consultationId,
    );

    setState(() {
      _status = 'Call declined. Waiting for next consultation...';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Consultation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Patient info card
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            widget.patientName.isNotEmpty
                                ? widget.patientName[0].toUpperCase()
                                : 'P',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.patientName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Patient ID: ${widget.patientId}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Status indicator
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (_isWaiting) ...[
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                        ],
                        Row(
                          children: [
                            Icon(
                              _isConnected ? Icons.wifi : Icons.wifi_off,
                              color: _isConnected ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isConnected ? 'Connected' : 'Disconnected',
                              style: TextStyle(
                                color: _isConnected ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _status,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Instructions
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Instructions:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Keep your app open and wait for the doctor',
                        ),
                        const Text(
                          '• Ensure your camera and microphone permissions are enabled',
                        ),
                        const Text(
                          '• Make sure you have a stable internet connection',
                        ),
                        const Text(
                          '• The doctor will start the video consultation from their dashboard',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Refresh connection button
                if (!_isConnected)
                  ElevatedButton.icon(
                    onPressed: _initializeSocket,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry Connection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }
}

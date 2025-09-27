import 'package:flutter/material.dart';
import '../screens/video_call_request_screen.dart';
import '../services/socket_service.dart';

/// Widget that provides easy access to video consultation features
class VideoConsultationWidget extends StatefulWidget {
  final String patientId;
  final String patientName;

  const VideoConsultationWidget({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  State<VideoConsultationWidget> createState() =>
      _VideoConsultationWidgetState();
}

class _VideoConsultationWidgetState extends State<VideoConsultationWidget> {
  final SocketService _socketService = SocketService();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _initializeConnection();
  }

  Future<void> _initializeConnection() async {
    try {
      await _socketService.initialize(
        serverUrl: 'https://telemed18.onrender.com',
        userId: widget.patientId,
        userRole: 'patient',
        userName: widget.patientName,
      );

      // Listen to connection state
      _socketService.addListener(() {
        if (mounted) {
          setState(() {
            _isConnected = _socketService.isConnected;
          });
        }
      });
    } catch (e) {
      debugPrint('Failed to initialize socket connection: $e');
    }
  }

  void _navigateToVideoConsultation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallRequestScreen(
          patientId: widget.patientId,
          patientName: widget.patientName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.video_call,
                  size: 32,
                  color: _isConnected ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Video Consultation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isConnected
                            ? 'Ready for consultation'
                            : 'Connecting to doctor dashboard...',
                        style: TextStyle(
                          color: _isConnected ? Colors.green : Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isConnected ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Features:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Text('Real-time video calls with doctors'),
              ],
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Text('Automatic call notifications'),
              ],
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Text('Digital prescriptions'),
              ],
            ),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                SizedBox(width: 8),
                Text('Call recording (with consent)'),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigateToVideoConsultation,
                icon: const Icon(Icons.video_call),
                label: const Text('Join Video Consultation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Patient ID: ${widget.patientId}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import '../widgets/chat_widget.dart';

class NabhaVideoConsultationScreen extends StatefulWidget {
  const NabhaVideoConsultationScreen({super.key});

  @override
  State<NabhaVideoConsultationScreen> createState() =>
      _NabhaVideoConsultationScreenState();
}

class _NabhaVideoConsultationScreenState
    extends State<NabhaVideoConsultationScreen> {
  bool _showChat = false;
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isSpeakerOn = false;
  Duration _callDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Start call timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCallTimer();
    });
  }

  void _startCallTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _callDuration = Duration(seconds: _callDuration.inSeconds + 1);
        });
        _startCallTimer(); // Recursive call to keep timer running
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video call area (mock for now)
            _buildVideoCallArea(),

            // Chat sidebar
            if (_showChat)
              Positioned(
                right: 0,
                top: 0,
                bottom: 100,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ChatWidget(
                  consultationId: 'consultation-123',
                  currentUserId: 'patient-123',
                  isDoctor: false,
                ),
              ),

            // Call controls
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildCallControls(),
            ),

            // Top call info
            Positioned(top: 0, left: 0, right: 0, child: _buildCallInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCallArea() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[900],
      child: Stack(
        children: [
          // Doctor video (mock)
          Center(
            child: Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Dr. Singh',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'General Medicine',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          // Patient video (small overlay)
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: const Icon(Icons.person, size: 32, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Call duration
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatDuration(_callDuration),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Doctor info
          const Column(
            children: [
              Text(
                'Dr. Singh',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'General Medicine',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),

          // Connection status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.wifi, size: 16, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Connected',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black.withOpacity(0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Mute button
              _buildControlButton(
                icon: _isMuted ? Icons.mic_off : Icons.mic,
                label: 'Mute',
                active: _isMuted,
                onPressed: () {
                  setState(() {
                    _isMuted = !_isMuted;
                  });
                },
              ),

              // Video toggle
              _buildControlButton(
                icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                label: 'Video',
                active: !_isVideoEnabled,
                onPressed: () {
                  setState(() {
                    _isVideoEnabled = !_isVideoEnabled;
                  });
                },
              ),

              // Speaker toggle
              _buildControlButton(
                icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                label: 'Speaker',
                active: _isSpeakerOn,
                onPressed: () {
                  setState(() {
                    _isSpeakerOn = !_isSpeakerOn;
                  });
                },
              ),

              // Chat toggle
              _buildControlButton(
                icon: Icons.chat,
                label: 'Chat',
                active: _showChat,
                onPressed: () {
                  setState(() {
                    _showChat = !_showChat;
                  });
                },
              ),

              // End call
              _buildControlButton(
                icon: Icons.call_end,
                label: 'End',
                backgroundColor: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    bool active = false,
    Color backgroundColor = Colors.grey,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: active ? Colors.blue : backgroundColor,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: active ? Colors.blue : Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    super.dispose();
  }
}

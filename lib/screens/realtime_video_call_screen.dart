import 'package:flutter/material.dart';
import 'dart:async';

import '../models/doctor.dart';
import '../services/agora_service.dart';

/// Real-time video call screen integrated with doctor service
class RealtimeVideoCallScreen extends StatefulWidget {
  final Doctor doctor;
  final String patientId;
  final String patientName;
  final String? symptoms;

  const RealtimeVideoCallScreen({
    Key? key,
    required this.doctor,
    required this.patientId,
    required this.patientName,
    this.symptoms,
  }) : super(key: key);

  @override
  State<RealtimeVideoCallScreen> createState() =>
      _RealtimeVideoCallScreenState();
}

class _RealtimeVideoCallScreenState extends State<RealtimeVideoCallScreen>
    with TickerProviderStateMixin {
  late AgoraService _agoraService;

  // Call state
  bool _isConnecting = true;
  bool _isCallActive = false;
  bool _isVideoEnabled = true;
  bool _isAudioEnabled = true;
  bool _isSpeakerEnabled = true;

  // UI state
  bool _showControls = true;
  Timer? _hideControlsTimer;
  late AnimationController _connectingController;
  late Animation<double> _connectingAnimation;

  // Call data
  String? _channelName;
  String? _agoraToken;

  // Timer
  String _callDuration = "00:00";
  Timer? _durationTimer;
  DateTime? _callStartTime;

  @override
  void initState() {
    super.initState();
    _agoraService = AgoraService();

    // Initialize connecting animation
    _connectingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _connectingAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _connectingController, curve: Curves.easeInOut),
    );

    _startVideoConsultation();
  }

  @override
  void dispose() {
    _connectingController.dispose();
    _durationTimer?.cancel();
    _hideControlsTimer?.cancel();
    _agoraService.leaveChannel();
    super.dispose();
  }

  /// Start the video consultation process
  Future<void> _startVideoConsultation() async {
    try {
      setState(() {
        _isConnecting = true;
      });

      _connectingController.repeat(reverse: true);

      // Create channel name to match doctor dashboard format
      _channelName = 'call_${widget.patientId}_doctor';

      // For demo purposes, we'll use a basic setup
      // In production, you'd get the token from your backend
      _agoraToken = null; // Agora can work without token for testing

      print(
        '🚀 Patient joining video call: ${widget.patientName} → Dr. ${widget.doctor.name}',
      );
      print('📱 Channel: $_channelName');

      // Initialize Agora and join channel
      await _agoraService.initialize();

      await _agoraService.joinChannel(
        token: _agoraToken ?? '', // Provide empty string if null
        channelId: _channelName!,
        uid: widget.patientId.hashCode, // Convert string to int
      );

      // Explicitly enable video and audio after joining
      await _agoraService.enableLocalVideo(true);
      await _agoraService.muteLocalAudio(false);

      debugPrint('✅ Video call initiated - Channel: $_channelName');

      // Simulate successful connection
      _onConnectionEstablished();
    } catch (e) {
      debugPrint('❌ Error starting video consultation: $e');
      _showError('Failed to start video call: $e');
    }
  }

  void _onConnectionEstablished() {
    setState(() {
      _isConnecting = false;
      _isCallActive = true;
      _callStartTime = DateTime.now();
    });

    _connectingController.stop();
    _startCallTimer();
    _startHideControlsTimer();
  }

  void _startCallTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_callStartTime != null) {
        final duration = DateTime.now().difference(_callStartTime!);
        setState(() {
          _callDuration = _formatDuration(duration);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _toggleVideo() {
    setState(() {
      _isVideoEnabled = !_isVideoEnabled;
    });
    _agoraService.enableLocalVideo(_isVideoEnabled);
  }

  void _toggleAudio() {
    setState(() {
      _isAudioEnabled = !_isAudioEnabled;
    });
    _agoraService.muteLocalAudio(!_isAudioEnabled);
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerEnabled = !_isSpeakerEnabled;
    });
    _agoraService.setAudioRoute(_isSpeakerEnabled);
  }

  void _endCall() {
    _agoraService.leaveChannel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
          if (_showControls) {
            _startHideControlsTimer();
          }
        },
        child: Stack(
          children: [
            // Video container
            Container(
              width: double.infinity,
              height: double.infinity,
              child: _isConnecting ? _buildConnectingUI() : _buildVideoUI(),
            ),

            // Top bar
            if (_showControls || _isConnecting) _buildTopBar(),

            // Bottom controls
            if (_showControls && _isCallActive) _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _connectingAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _connectingAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.videocam, size: 50, color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Connecting to Dr. ${widget.doctor.name}...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoUI() {
    return Stack(
      children: [
        // Remote video (doctor's video)
        Container(
          width: double.infinity,
          height: double.infinity,
          child: _agoraService.remoteUsers.isNotEmpty
              ? _agoraService.createRemoteVideoView(
                  _agoraService.remoteUsers.first,
                )
              : Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(Icons.person, size: 100, color: Colors.white54),
                  ),
                ),
        ),

        // Local video (patient's video) - picture in picture
        Positioned(
          top: 100,
          right: 20,
          child: Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _agoraService.createLocalVideoView(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 20,
          right: 20,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: _endCall,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. ${widget.doctor.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.doctor.speciality,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (_isCallActive)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _callDuration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: _isAudioEnabled ? Icons.mic : Icons.mic_off,
              isActive: _isAudioEnabled,
              onTap: _toggleAudio,
            ),
            _buildControlButton(
              icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
              isActive: _isVideoEnabled,
              onTap: _toggleVideo,
            ),
            _buildControlButton(
              icon: _isSpeakerEnabled ? Icons.volume_up : Icons.volume_down,
              isActive: _isSpeakerEnabled,
              onTap: _toggleSpeaker,
            ),
            _buildControlButton(
              icon: Icons.call_end,
              isActive: false,
              onTap: _endCall,
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color:
              backgroundColor ?? (isActive ? Colors.white : Colors.grey[600]),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: backgroundColor != null
              ? Colors.white
              : (isActive ? Colors.black : Colors.white),
          size: 28,
        ),
      ),
    );
  }
}

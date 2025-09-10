import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/video_consultation.dart';
import '../services/video_consultation_service.dart';
import '../services/agora_service.dart';
import '../services/call_recording_service.dart';
import '../widgets/video_controls_widget.dart';
import '../widgets/participant_grid_widget.dart';
import '../widgets/chat_widget.dart';
import '../widgets/recording_consent_dialog.dart';

class VideoCallScreen extends StatefulWidget {
  final VideoConsultation consultation;
  final String userId;
  final bool isDoctor;

  const VideoCallScreen({
    Key? key,
    required this.consultation,
    required this.userId,
    required this.isDoctor,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isSpeakerOn = false;
  bool _showChat = false;
  bool _isRecording = false;
  Timer? _callTimer;
  Duration _callDuration = Duration.zero;
  late AgoraService _agoraService;
  late CallRecordingService _recordingService;
  String _recordingDuration = '00:00';

  @override
  void initState() {
    super.initState();
    _agoraService = AgoraService();
    _recordingService = CallRecordingService();
    _startCallTimer();
    _setupVideoCall();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration = Duration(seconds: _callDuration.inSeconds + 1);
      });
    });
  }

  Future<void> _setupVideoCall() async {
    try {
      // Initialize Agora service
      await _agoraService.initialize();

      // Generate channel name from consultation room ID
      final channelId =
          widget.consultation.roomId ??
          'consultation_${widget.consultation.id}';

      // Use session token or null for testing
      final token = widget.consultation.sessionToken;

      // Join the channel
      await _agoraService.joinChannel(
        channelId: channelId,
        token: token ?? '', // Empty string for testing without token
      );

      // Set initial audio/video states
      await _agoraService.muteLocalAudio(_isMuted);
      await _agoraService.enableLocalVideo(_isVideoEnabled);
      await _agoraService.setAudioRoute(_isSpeakerOn);

      debugPrint('Video call setup completed for room: $channelId');
    } catch (e) {
      debugPrint('Error setting up video call: $e');
      _showErrorDialog('Failed to initialize video call: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video participants grid
            _buildVideoGrid(),

            // Top bar with consultation info
            _buildTopBar(),

            // Bottom controls
            _buildBottomControls(),

            // Chat overlay
            if (_showChat) _buildChatOverlay(),

            // Recording status overlay
            if (_isRecording)
              Positioned(
                top: 100,
                left: 16,
                child: RecordingStatusWidget(
                  isRecording: _isRecording,
                  duration: _recordingDuration,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoGrid() {
    return ParticipantGridWidget(
      consultation: widget.consultation,
      isVideoEnabled: _isVideoEnabled,
      currentUserId: widget.userId,
      agoraService: _agoraService,
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => _showEndCallDialog(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),

              // Consultation info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.isDoctor
                          ? widget.consultation.patientName
                          : widget.consultation.doctorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatDuration(_callDuration),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Connection status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Connected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          ),
        ),
        child: VideoControlsWidget(
          isMuted: _isMuted,
          isVideoEnabled: _isVideoEnabled,
          isSpeakerOn: _isSpeakerOn,
          showChat: _showChat,
          isRecording: _isRecording,
          recordingDuration: _recordingDuration,
          onMuteToggle: () async {
            await _agoraService.toggleMute();
            setState(() => _isMuted = _agoraService.isMuted);
          },
          onVideoToggle: () async {
            await _agoraService.toggleCamera();
            setState(() => _isVideoEnabled = _agoraService.isVideoEnabled);
          },
          onSpeakerToggle: () async {
            await _agoraService.toggleSpeaker();
            setState(() => _isSpeakerOn = _agoraService.isSpeakerOn);
          },
          onChatToggle: () => setState(() => _showChat = !_showChat),
          onEndCall: _showEndCallDialog,
          onSwitchCamera: () => _agoraService.switchCamera(),
          onRecordingToggle: _handleRecordingToggle,
        ),
      ),
    );
  }

  Widget _buildChatOverlay() {
    return Positioned(
      right: 0,
      top: 80,
      bottom: 120,
      width: MediaQuery.of(context).size.width * 0.35,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: ChatWidget(
          consultationId: widget.consultation.id,
          currentUserId: widget.userId,
          isDoctor: widget.isDoctor,
        ),
      ),
    );
  }

  Future<void> _handleRecordingToggle() async {
    if (!_isRecording) {
      await _startRecording();
    } else {
      await _stopRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      // Only doctors can initiate recording
      if (!widget.isDoctor) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Only doctors can start recording')),
        );
        return;
      }

      // Show consent dialog
      final consent = await RecordingConsentDialog.show(
        context: context,
        patientName: widget.consultation.patientName,
        doctorName: widget.consultation.doctorName,
      );

      if (consent != true) return;

      // Start recording
      final recordingId = await _recordingService.startRecording(
        consultationId: widget.consultation.id,
        patientId: widget.consultation.patientId,
        doctorId: widget.consultation.doctorId,
        requiresConsent: true,
      );

      if (recordingId == null) {
        throw Exception('Failed to create recording');
      }

      // Start Agora recording
      await _agoraService.startRecording(recordingId: recordingId);

      setState(() {
        _isRecording = true;
      });

      // Start recording timer
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!_isRecording) {
          timer.cancel();
          return;
        }

        if (_recordingService.recordingStartTime != null) {
          final elapsed = DateTime.now().difference(
            _recordingService.recordingStartTime!,
          );
          setState(() {
            _recordingDuration = _formatDuration(elapsed);
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to start recording: $e')));
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _recordingService.stopRecording();
      await _agoraService.stopRecording();

      setState(() {
        _isRecording = false;
        _recordingDuration = '00:00';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to stop recording: $e')));
    }
  }

  void _showEndCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Consultation'),
        content: const Text('Are you sure you want to end this consultation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _endConsultation();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'End Call',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _endConsultation() async {
    try {
      // Stop recording if active
      if (_isRecording) {
        await _stopRecording();
      }

      // Leave Agora channel
      await _agoraService.leaveChannel();

      // Show completion dialog for doctors
      if (widget.isDoctor) {
        await _showCompletionDialog();
      } else {
        // For patients, just end the consultation
        final service = context.read<VideoConsultationService>();
        await service.endConsultation(widget.consultation.id);
        _navigateBack();
      }
    } catch (e) {
      _showErrorDialog('Error ending consultation: $e');
    }
  }

  Future<void> _showCompletionDialog() async {
    final service = context.read<VideoConsultationService>();
    String prescription = '';
    String feedback = '';

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Complete Consultation'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Prescription (Optional)',
                  hintText: 'Enter prescription details...',
                ),
                maxLines: 3,
                onChanged: (value) => prescription = value,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Add consultation notes...',
                ),
                maxLines: 3,
                onChanged: (value) => feedback = value,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await service.endConsultation(
                widget.consultation.id,
                prescription: prescription.isNotEmpty ? prescription : null,
                feedback: feedback.isNotEmpty ? feedback : null,
              );
              _navigateBack();
            },
            child: const Text('Complete Consultation'),
          ),
        ],
      ),
    );
  }

  void _navigateBack() {
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateBack();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  @override
  void dispose() {
    _callTimer?.cancel();

    // Stop recording if active
    if (_isRecording) {
      _recordingService.stopRecording();
      _agoraService.stopRecording();
    }

    _agoraService.dispose();
    super.dispose();
  }
}

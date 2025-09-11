import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/video_consultation.dart';
import '../services/video_call_manager.dart';
import '../services/video_consultation_service.dart';
import '../services/connectivity_service.dart';
import '../widgets/video_controls_widget.dart';
import '../widgets/participant_grid_widget.dart';
import '../widgets/chat_widget.dart';
import '../widgets/recording_consent_dialog.dart';
import '../widgets/recording_status_widget.dart';

/// Unified video call screen with all features integrated
class UnifiedVideoCallScreen extends StatefulWidget {
  final VideoConsultation consultation;
  final String userId;
  final bool isDoctor;

  const UnifiedVideoCallScreen({
    Key? key,
    required this.consultation,
    required this.userId,
    required this.isDoctor,
  }) : super(key: key);

  @override
  State<UnifiedVideoCallScreen> createState() => _UnifiedVideoCallScreenState();
}

class _UnifiedVideoCallScreenState extends State<UnifiedVideoCallScreen>
    with WidgetsBindingObserver {
  late VideoCallManager _videoCallManager;
  bool _isInitialized = false;
  StreamSubscription? _stateSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeVideoCall();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stateSubscription?.cancel();
    _videoCallManager.endConsultation();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.paused:
        // App went to background - mute audio
        _videoCallManager.toggleMute();
        break;
      case AppLifecycleState.resumed:
        // App came to foreground - unmute if it was muted due to background
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        _videoCallManager.endConsultation();
        break;
      default:
        break;
    }
  }

  Future<void> _initializeVideoCall() async {
    try {
      _videoCallManager = VideoCallManager();

      // Get consultation service from provider (if available)
      // For now, create a new instance
      final consultationService = VideoConsultationService(
        ConnectivityService(),
      );

      await _videoCallManager.initialize(
        userId: widget.userId,
        isDoctor: widget.isDoctor,
        consultationService: consultationService,
      );

      // Listen for state changes
      _videoCallManager.addListener(_onVideoCallStateChanged);

      // Start the consultation
      await _videoCallManager.startConsultation(widget.consultation);

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      _showErrorDialog('Failed to initialize video call: $e');
    }
  }

  void _onVideoCallStateChanged() {
    if (!mounted) return;

    final state = _videoCallManager.state;

    switch (state) {
      case VideoCallState.error:
        final error = _videoCallManager.lastError;
        if (error != null) {
          _showErrorSnackBar(error);
        }
        break;
      case VideoCallState.ended:
        // Call ended, navigate back
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      case VideoCallState.reconnecting:
        _showReconnectingDialog();
        break;
      default:
        break;
    }

    setState(() {}); // Trigger rebuild for state changes
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return _buildLoadingScreen();
    }

    return ChangeNotifierProvider.value(
      value: _videoCallManager,
      child: Consumer<VideoCallManager>(
        builder: (context, manager, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Stack(
                children: [
                  // Video participants grid
                  _buildVideoGrid(manager),

                  // Top bar with consultation info
                  _buildTopBar(manager),

                  // Bottom controls
                  _buildBottomControls(manager),

                  // Chat overlay
                  if (manager.showChat) _buildChatOverlay(),

                  // Recording status overlay
                  if (manager.isRecording)
                    Positioned(
                      top: 100,
                      left: 16,
                      child: RecordingStatusWidget(
                        isRecording: manager.isRecording,
                        duration: manager.recordingDuration,
                      ),
                    ),

                  // Connection status overlay
                  _buildConnectionStatusOverlay(manager),

                  // Network quality indicator
                  _buildNetworkQualityIndicator(manager),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'Connecting to consultation...',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isDoctor
                  ? 'Preparing consultation room'
                  : 'Joining video consultation',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoGrid(VideoCallManager manager) {
    return ParticipantGridWidget(
      agoraService: manager.agoraService,
      remoteUsers: manager.remoteUsers,
      showLocalVideo: manager.isVideoEnabled,
      currentUserId: widget.userId,
      consultation: widget.consultation,
    );
  }

  Widget _buildTopBar(VideoCallManager manager) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
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
                onPressed: () => _showEndCallDialog(manager),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDuration(manager.callDuration),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    if (widget.consultation.priority != QueuePriority.normal)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(
                            widget.consultation.priority,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.consultation.priority.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Connection status
              _buildConnectionStatus(manager),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(VideoCallManager manager) {
    Color statusColor;
    String statusText;

    switch (manager.state) {
      case VideoCallState.connected:
        statusColor = Colors.green;
        statusText = 'Connected';
        break;
      case VideoCallState.connecting:
        statusColor = Colors.orange;
        statusText = 'Connecting';
        break;
      case VideoCallState.reconnecting:
        statusColor = Colors.orange;
        statusText = 'Reconnecting';
        break;
      case VideoCallState.error:
        statusColor = Colors.red;
        statusText = 'Error';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(VideoCallManager manager) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          ),
        ),
        child: VideoControlsWidget(
          isMuted: manager.isMuted,
          isVideoEnabled: manager.isVideoEnabled,
          isSpeakerOn: manager.isSpeakerOn,
          showChat: manager.showChat,
          isRecording: manager.isRecording,
          recordingDuration: manager.recordingDuration,
          onMuteToggle: manager.toggleMute,
          onVideoToggle: manager.toggleVideo,
          onSpeakerToggle: manager.toggleSpeaker,
          onSwitchCamera: manager.switchCamera,
          onChatToggle: manager.toggleChat,
          onRecordingToggle: () => _handleRecordingToggle(manager),
          onEndCall: () => _showEndCallDialog(manager),
          isDoctor: widget.isDoctor,
        ),
      ),
    );
  }

  Widget _buildChatOverlay() {
    return Positioned(
      right: 0,
      top: 100,
      bottom: 140,
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

  Widget _buildConnectionStatusOverlay(VideoCallManager manager) {
    if (manager.state != VideoCallState.reconnecting) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text(
                  'Reconnecting...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Trying to restore connection',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkQualityIndicator(VideoCallManager manager) {
    return Positioned(
      top: 110,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.signal_wifi_4_bar, color: Colors.green, size: 16),
            const SizedBox(width: 4),
            Text(
              'Good',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRecordingToggle(VideoCallManager manager) async {
    if (!manager.isRecording) {
      await _startRecording(manager);
    } else {
      await _stopRecording(manager);
    }
  }

  Future<void> _startRecording(VideoCallManager manager) async {
    try {
      // Only doctors can initiate recording
      if (!widget.isDoctor) {
        _showErrorSnackBar('Only doctors can start recording');
        return;
      }

      // Show consent dialog
      final consent = await RecordingConsentDialog.show(
        context: context,
        patientName: widget.consultation.patientName,
        doctorName: widget.consultation.doctorName,
      );

      if (consent != true) return;

      await manager.startRecording();
      _showSuccessSnackBar('Recording started');
    } catch (e) {
      _showErrorSnackBar('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording(VideoCallManager manager) async {
    try {
      await manager.stopRecording();
      _showSuccessSnackBar('Recording saved');
    } catch (e) {
      _showErrorSnackBar('Failed to stop recording: $e');
    }
  }

  void _showEndCallDialog(VideoCallManager manager) {
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
              await _endConsultation(manager);
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

  Future<void> _endConsultation(VideoCallManager manager) async {
    try {
      if (widget.isDoctor) {
        await _showCompletionDialog(manager);
      } else {
        await manager.endConsultation();
        _navigateBack();
      }
    } catch (e) {
      _showErrorDialog('Error ending consultation: $e');
    }
  }

  Future<void> _showCompletionDialog(VideoCallManager manager) async {
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
              await manager.endConsultation(
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

  void _showReconnectingDialog() {
    // The reconnecting overlay is already shown in the UI
    // This could show additional UI if needed
  }

  void _navigateBack() {
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

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

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
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

  Color _getPriorityColor(QueuePriority priority) {
    switch (priority) {
      case QueuePriority.emergency:
        return Colors.red;
      case QueuePriority.urgent:
        return Colors.orange;
      case QueuePriority.high:
        return Colors.yellow;
      case QueuePriority.normal:
        return Colors.blue;
      case QueuePriority.low:
        return Colors.grey;
    }
  }
}

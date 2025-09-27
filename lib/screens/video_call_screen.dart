import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/video_consultation.dart';
import '../services/video_consultation_service.dart';
import '../services/agora_service.dart';
import '../services/call_recording_service.dart';
import '../services/socket_service.dart';
import '../services/video_call_manager.dart';
import '../services/connectivity_service.dart';
import '../widgets/video_controls_widget.dart';
import '../widgets/participant_grid_widget.dart';
import '../widgets/chat_widget.dart' hide PrescriptionData;
import '../widgets/recording_consent_dialog.dart';
import '../widgets/recording_status_widget.dart';
import '../utils/channel_utils.dart';

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

class _VideoCallScreenState extends State<VideoCallScreen>
    with WidgetsBindingObserver {
  // Enhanced state management using VideoCallManager
  late VideoCallManager _videoCallManager;
  bool _isInitialized = false;
  StreamSubscription? _stateSubscription;

  // Legacy direct service support for backward compatibility
  late AgoraService _agoraService;
  late CallRecordingService _recordingService;
  late SocketService _socketService;
  StreamSubscription? _videoCallSubscription;
  StreamSubscription? _prescriptionSubscription;
  StreamSubscription? _chatSubscription;
  StreamSubscription? _recordingSubscription;
  String? _consultationId;

  // Enhanced state tracking
  bool _useVideoCallManager = true;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Try to use VideoCallManager first, fallback to direct services if needed
    _initializeVideoCall();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stateSubscription?.cancel();
    _fallbackTimer?.cancel();

    if (_useVideoCallManager && _isInitialized) {
      _videoCallManager.endConsultation();
    } else {
      _disposeLegacyServices();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.paused:
        // App went to background - mute audio for privacy
        if (_useVideoCallManager && _isInitialized) {
          _videoCallManager.toggleMute();
        } else {
          _agoraService.muteLocalAudio(true);
        }
        break;
      case AppLifecycleState.resumed:
        // App came to foreground - could restore audio if needed
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        if (_useVideoCallManager && _isInitialized) {
          _videoCallManager.endConsultation();
        }
        break;
      default:
        break;
    }
  }

  /// Initialize video call - tries VideoCallManager first, fallbacks to direct services
  Future<void> _initializeVideoCall() async {
    try {
      // Try to use VideoCallManager for enhanced functionality
      await _tryVideoCallManager();
    } catch (e) {
      debugPrint(
        'VideoCallManager failed, falling back to direct services: $e',
      );
      _useVideoCallManager = false;
      await _initializeLegacyServices();
    }
  }

  /// Try to initialize with VideoCallManager
  Future<void> _tryVideoCallManager() async {
    _videoCallManager = VideoCallManager();

    // Get or create consultation service
    VideoConsultationService? consultationService;
    try {
      consultationService = context.read<VideoConsultationService>();
    } catch (e) {
      // Create new instance if not available in provider
      consultationService = VideoConsultationService(ConnectivityService());
    }

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
      _useVideoCallManager = true;
    });

    debugPrint('VideoCallManager initialization successful');
  }

  /// Initialize legacy services as fallback
  Future<void> _initializeLegacyServices() async {
    _agoraService = AgoraService();
    _recordingService = CallRecordingService();
    _socketService = SocketService();
    _consultationId =
        'consultation_${widget.consultation.id}_${DateTime.now().millisecondsSinceEpoch}';

    await _setupSocketConnection();
    await _setupVideoCall();

    setState(() {
      _isInitialized = true;
    });

    debugPrint('Legacy services initialization successful');
  }

  /// Handle VideoCallManager state changes
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
        _navigateBack();
        break;
      case VideoCallState.reconnecting:
        _showReconnectingSnackBar();
        break;
      default:
        break;
    }

    setState(() {}); // Trigger rebuild for state changes
  }

  Future<void> _setupSocketConnection() async {
    try {
      // Initialize socket service
      await _socketService.initialize(
        serverUrl: 'https://telemed18.onrender.com', // Local backend URL
        userId: widget.userId,
        userRole: widget.isDoctor ? 'doctor' : 'patient',
        userName: widget.isDoctor
            ? 'Dr. ${widget.userId}'
            : 'Patient ${widget.userId}',
      );

      // Join consultation room
      _socketService.joinConsultation(
        consultationId: _consultationId!,
        userId: widget.userId,
        role: widget.isDoctor ? 'doctor' : 'patient',
      );

      // Set up event listeners
      _setupSocketListeners();

      // Notify patient ready if this is a patient
      if (!widget.isDoctor) {
        _socketService.notifyPatientReady(
          patientId: widget.userId,
          consultationId: _consultationId!,
        );
      }

      debugPrint('Socket connection setup completed');
    } catch (e) {
      debugPrint('Error setting up socket connection: $e');
    }
  }

  void _setupSocketListeners() {
    // Listen for incoming calls
    _videoCallSubscription = _socketService.videoCallRequests.listen(
      (request) {
        if (!widget.isDoctor && request.patientId == widget.userId) {
          debugPrint('Received incoming call from doctor: ${request.doctorId}');
          // Auto-accept call from doctor dashboard for demo
          _acceptVideoCall(request);
        }
      },
      onError: (error) {
        debugPrint('Error receiving video call request: $error');
        _showSnackBar('Connection error: $error', Colors.red);
      },
    );

    // Listen for prescriptions
    _prescriptionSubscription = _socketService.prescriptions.listen(
      (prescription) {
        if (prescription.patientId == widget.userId) {
          _showPrescriptionDialog(prescription);
        }
      },
      onError: (error) {
        debugPrint('Error receiving prescription: $error');
        _showSnackBar('Error receiving prescription: $error', Colors.red);
      },
    );

    // Listen for chat messages
    _chatSubscription = _socketService.chatMessages.listen(
      (message) {
        if (message.consultationId == _consultationId) {
          debugPrint('Received chat message: ${message.message}');
          // Handle chat message in UI
        }
      },
      onError: (error) {
        debugPrint('Error receiving chat message: $error');
        _showSnackBar('Error receiving chat message: $error', Colors.red);
      },
    );

    _recordingSubscription = _socketService.recordingEvents.listen(
      (event) {
        if (event.consultationId == _consultationId) {
          setState(() {});

          if (event.type == 'started') {
            _showSuccessSnackBar('Call recording started');
          } else {
            _showSuccessSnackBar('Call recording stopped');
          }
        }
      },
      onError: (error) {
        debugPrint('Error receiving recording event: $error');
        _showErrorSnackBar('Error with recording: $error');
      },
    );
  }

  Future<void> _acceptVideoCall(VideoCallRequest request) async {
    try {
      // Setup video call with doctor
      await _setupVideoCall();
      _showSnackBar('Joining video consultation...', Colors.blue);
    } catch (e) {
      debugPrint('Error accepting video call: $e');
      _showSnackBar('Failed to join video call: $e', Colors.red);
    }
  }

  Future<void> _initiateCall() async {
    try {
      // Request Agora token from backend
      final response = await fetchTokenFromBackend();

      if (response != null) {
        // Notify doctor dashboard about incoming call via socket
        _socketService.emit('initiate_call', {
          'from': widget.userId,
          'to': widget.consultation.doctorId,
          'doctorId': widget.consultation.doctorId,
          'patientId': widget.userId,
          'tokenData': response,
        });

        _showSnackBar('Calling doctor...', Colors.blue);
      }
    } catch (e) {
      debugPrint('Error initiating call: $e');
      _showSnackBar('Failed to initiate call: $e', Colors.red);
    }
  }

  Future<Map<String, dynamic>?> fetchTokenFromBackend() async {
    try {
      // In a real implementation, you would call your backend API
      // For now, we'll return mock data
      return {
        'token': '',
        'channel': 'test_channel',
        'uid': 0,
        'appId': 'test_app_id',
      };
    } catch (e) {
      debugPrint('Error fetching token: $e');
      _showSnackBar('Error fetching token: $e', Colors.red);
      return null;
    }
  }

  void _showPrescriptionDialog(PrescriptionData prescription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prescription Received'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: Dr. ${prescription.doctorId}'),
            const SizedBox(height: 8),
            const Text(
              'Medications:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...prescription.medications.map((med) => Text('• $med')),
            const SizedBox(height: 8),
            if (prescription.notes.isNotEmpty) ...[
              const Text(
                'Notes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(prescription.notes),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _setupVideoCall() async {
    try {
      // Initialize Agora service
      await _agoraService.initialize();

      // Generate channel name using consistent utility
      final roomId = widget.consultation.roomId ?? _consultationId!;
      final channelId = ChannelUtils.generateConsultationChannelId(roomId);

      // Use session token or null for testing
      final token = widget.consultation.sessionToken;

      // Join the channel
      await _agoraService.joinChannel(
        channelName: channelId,
        token: token ?? '', // Empty string for testing without token
      );

      // Set initial audio/video states
      await _agoraService.muteLocalAudio(false);
      await _agoraService.enableLocalVideo(true);
      await _agoraService.setAudioRoute(false);

      debugPrint('Video call setup completed for room: $channelId');
    } catch (e) {
      debugPrint('Error setting up video call: $e');
      _showErrorDialog('Failed to initialize video call: $e');
    }
  }

  void _showErrorDialog(String message) {
    if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return _buildLoadingScreen();
    }

    if (_useVideoCallManager) {
      return ChangeNotifierProvider.value(
        value: _videoCallManager,
        child: Consumer<VideoCallManager>(
          builder: (context, manager, child) {
            return _buildVideoCallScreen(manager: manager);
          },
        ),
      );
    } else {
      return _buildVideoCallScreen();
    }
  }

  /// Build loading screen
  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Connecting to consultation...',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isDoctor
                  ? 'Preparing consultation room'
                  : 'Joining video consultation',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the main video call screen
  Widget _buildVideoCallScreen({VideoCallManager? manager}) {
    return Scaffold(
      backgroundColor: Colors.black, // Keep black for video calls
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
            if (_getShowChat(manager)) _buildChatOverlay(),

            // Recording status overlay
            if (_getIsRecording(manager))
              Positioned(
                top: 100,
                left: 16,
                child: _useVideoCallManager && manager != null
                    ? RecordingStatusWidget(
                        isRecording: manager.isRecording,
                        duration: manager.recordingDuration,
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 8,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'REC ${_getLegacyRecordingDuration()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

            // Connection status overlay (for VideoCallManager)
            if (_useVideoCallManager && manager != null)
              _buildConnectionStatusOverlay(manager),

            // Network quality indicator (for VideoCallManager)
            if (_useVideoCallManager && manager != null)
              _buildNetworkQualityIndicator(manager),
          ],
        ),
      ),
    );
  }

  /// Build video grid - supports both VideoCallManager and direct services
  Widget _buildVideoGrid(VideoCallManager? manager) {
    if (_useVideoCallManager && manager != null) {
      return ParticipantGridWidget(
        agoraService: manager.agoraService,
        remoteUsers: manager.remoteUsers,
        showLocalVideo: manager.isVideoEnabled,
        currentUserId: widget.userId,
        consultation: widget.consultation,
      );
    } else {
      return ParticipantGridWidget(
        agoraService: _agoraService,
        remoteUsers: _agoraService.remoteUsers,
        showLocalVideo: _getIsVideoEnabled(manager),
        currentUserId: widget.userId,
        consultation: widget.consultation,
      );
    }
  }

  /// Build top bar - enhanced version with better connection status
  Widget _buildTopBar(VideoCallManager? manager) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: _useVideoCallManager ? 100 : 80,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _useVideoCallManager ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDuration(_getCallDuration(manager)),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: _useVideoCallManager ? 14 : 12,
                      ),
                    ),
                    // Priority indicator for VideoCallManager
                    if (_useVideoCallManager &&
                        widget.consultation.priority != QueuePriority.normal)
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

  /// Build connection status indicator
  Widget _buildConnectionStatus(VideoCallManager? manager) {
    if (_useVideoCallManager && manager != null) {
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
    } else {
      // Legacy simple connection status
      return Container(
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
      );
    }
  }

  /// Build bottom controls - supports both VideoCallManager and direct services
  Widget _buildBottomControls(VideoCallManager? manager) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: _useVideoCallManager ? 140 : 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.9), Colors.transparent],
          ),
        ),
        child: VideoControlsWidget(
          isMuted: _getIsMuted(manager),
          isVideoEnabled: _getIsVideoEnabled(manager),
          isSpeakerOn: _getIsSpeakerOn(manager),
          showChat: _getShowChat(manager),
          isRecording: _getIsRecording(manager),
          recordingDuration: _getRecordingDuration(manager),
          onMuteToggle: () => _handleMuteToggle(manager),
          onVideoToggle: () => _handleVideoToggle(manager),
          onSpeakerToggle: () => _handleSpeakerToggle(manager),
          onSwitchCamera: () => _handleSwitchCamera(manager),
          onChatToggle: () => _handleChatToggle(manager),
          onRecordingToggle: () => _handleRecordingToggle(manager),
          onEndCall: () => _showEndCallDialog(manager),
          isDoctor: widget.isDoctor,
        ),
      ),
    );
  }

  /// Build chat overlay
  Widget _buildChatOverlay() {
    return Positioned(
      right: 0,
      top: _useVideoCallManager ? 100 : 80,
      bottom: _useVideoCallManager ? 140 : 120,
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

  /// Build connection status overlay (for reconnecting)
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

  /// Build network quality indicator
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

  // Helper methods to get state from either VideoCallManager or legacy services
  bool _getIsMuted(VideoCallManager? manager) {
    return _useVideoCallManager && manager != null
        ? manager.isMuted
        : _agoraService.isMuted;
  }

  bool _getIsVideoEnabled(VideoCallManager? manager) {
    return _useVideoCallManager && manager != null
        ? manager.isVideoEnabled
        : _agoraService.isVideoEnabled;
  }

  bool _getIsSpeakerOn(VideoCallManager? manager) {
    return _useVideoCallManager && manager != null
        ? manager.isSpeakerOn
        : _agoraService.isSpeakerOn;
  }

  bool _getShowChat(VideoCallManager? manager) {
    return _useVideoCallManager && manager != null
        ? manager.showChat
        : false; // Legacy doesn't have this state
  }

  bool _getIsRecording(VideoCallManager? manager) {
    return _useVideoCallManager && manager != null
        ? manager.isRecording
        : _recordingService.isRecording;
  }

  String _getRecordingDuration(VideoCallManager? manager) {
    return _useVideoCallManager && manager != null
        ? manager.recordingDuration
        : _getLegacyRecordingDuration();
  }

  Duration _getCallDuration(VideoCallManager? manager) {
    return _useVideoCallManager && manager != null
        ? manager.callDuration
        : Duration.zero; // Legacy doesn't track this well
  }

  String _getLegacyRecordingDuration() {
    if (_recordingService.recordingStartTime != null) {
      final elapsed = DateTime.now().difference(
        _recordingService.recordingStartTime!,
      );
      return _formatDuration(elapsed);
    }
    return '00:00';
  }

  // Control handlers that work with both VideoCallManager and legacy services
  Future<void> _handleMuteToggle(VideoCallManager? manager) async {
    if (_useVideoCallManager && manager != null) {
      await manager.toggleMute();
    } else {
      await _agoraService.toggleMute();
      setState(() {});
    }
  }

  Future<void> _handleVideoToggle(VideoCallManager? manager) async {
    if (_useVideoCallManager && manager != null) {
      await manager.toggleVideo();
    } else {
      await _agoraService.toggleCamera();
      setState(() {});
    }
  }

  Future<void> _handleSpeakerToggle(VideoCallManager? manager) async {
    if (_useVideoCallManager && manager != null) {
      await manager.toggleSpeaker();
    } else {
      await _agoraService.toggleSpeaker();
      setState(() {});
    }
  }

  Future<void> _handleSwitchCamera(VideoCallManager? manager) async {
    if (_useVideoCallManager && manager != null) {
      await manager.switchCamera();
    } else {
      await _agoraService.switchCamera();
    }
  }

  void _handleChatToggle(VideoCallManager? manager) {
    if (_useVideoCallManager && manager != null) {
      manager.toggleChat();
    } else {
      // Legacy chat toggle - not implemented in original
      setState(() {});
    }
  }

  Future<void> _handleRecordingToggle(VideoCallManager? manager) async {
    if (_useVideoCallManager && manager != null) {
      if (!manager.isRecording) {
        await _startRecordingWithManager(manager);
      } else {
        await _stopRecordingWithManager(manager);
      }
    } else {
      await _handleLegacyRecordingToggle();
    }
  }

  // Enhanced recording with VideoCallManager
  Future<void> _startRecordingWithManager(VideoCallManager manager) async {
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

  Future<void> _stopRecordingWithManager(VideoCallManager manager) async {
    try {
      await manager.stopRecording();
      _showSuccessSnackBar('Recording saved');
    } catch (e) {
      _showErrorSnackBar('Failed to stop recording: $e');
    }
  }

  // Legacy recording toggle
  Future<void> _handleLegacyRecordingToggle() async {
    if (!_recordingService.isRecording) {
      await _startLegacyRecording();
    } else {
      await _stopLegacyRecording();
    }
  }

  Future<void> _startLegacyRecording() async {
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

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to start recording: $e')));
    }
  }

  Future<void> _stopLegacyRecording() async {
    try {
      await _recordingService.stopRecording();
      await _agoraService.stopRecording();

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to stop recording: $e')));
    }
  }

  void _showEndCallDialog(VideoCallManager? manager) {
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

  Future<void> _endConsultation(VideoCallManager? manager) async {
    try {
      if (_useVideoCallManager && manager != null) {
        if (widget.isDoctor) {
          await _showCompletionDialog(manager);
        } else {
          await manager.endConsultation();
          _navigateBack();
        }
      } else {
        await _endLegacyConsultation();
      }
    } catch (e) {
      _showErrorDialog('Error ending consultation: $e');
    }
  }

  Future<void> _endLegacyConsultation() async {
    try {
      // Stop recording if active
      if (_recordingService.isRecording) {
        await _stopLegacyRecording();
      }

      // Leave Agora channel
      await _agoraService.leaveChannel();

      // Show completion dialog for doctors
      if (widget.isDoctor) {
        await _showLegacyCompletionDialog();
      } else {
        // For patients, just end the consultation
        try {
          final service = context.read<VideoConsultationService>();
          await service.endConsultation(widget.consultation.id);
        } catch (e) {
          // If service not available, just navigate back
          debugPrint('VideoConsultationService not available: $e');
        }
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

  Future<void> _showLegacyCompletionDialog() async {
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
              try {
                final service = context.read<VideoConsultationService>();
                await service.endConsultation(
                  widget.consultation.id,
                  prescription: prescription.isNotEmpty ? prescription : null,
                  feedback: feedback.isNotEmpty ? feedback : null,
                );
              } catch (e) {
                debugPrint('VideoConsultationService not available: $e');
              }
              _navigateBack();
            },
            child: const Text('Complete Consultation'),
          ),
        ],
      ),
    );
  }

  // Utility and error handling methods
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

  void _showReconnectingSnackBar() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reconnecting to consultation...'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
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

  void _navigateBack() {
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
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

  void _disposeLegacyServices() {
    // Cancel socket subscriptions
    _videoCallSubscription?.cancel();
    _prescriptionSubscription?.cancel();
    _chatSubscription?.cancel();
    _recordingSubscription?.cancel();

    // Stop recording if active
    if (_recordingService.isRecording) {
      _recordingService.stopRecording();
      _agoraService.stopRecording();
    }

    // Disconnect socket service
    _socketService.disconnect();
    _agoraService.dispose();
  }
}

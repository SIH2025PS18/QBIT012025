import 'package:flutter/foundation.dart';
import 'dart:async';

import '../models/video_consultation.dart';
import '../services/agora_service.dart';
import '../services/socket_service.dart';
import '../services/call_recording_service.dart';
import '../services/video_consultation_service.dart';

/// Manages the complete video call lifecycle and coordinates all components
class VideoCallManager extends ChangeNotifier {
  static final VideoCallManager _instance = VideoCallManager._internal();
  factory VideoCallManager() => _instance;
  VideoCallManager._internal();

  // Services
  late AgoraService _agoraService;
  late SocketService _socketService;
  late CallRecordingService _recordingService;
  late VideoConsultationService _consultationService;

  // State
  VideoConsultation? _currentConsultation;
  String? _currentUserId;
  bool _isDoctor = false;
  bool _isInitialized = false;
  VideoCallState _state = VideoCallState.idle;

  // Call state
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isSpeakerOn = false;
  bool _showChat = false;
  bool _isRecording = false;
  String _recordingDuration = '00:00';
  Duration _callDuration = Duration.zero;
  Timer? _callTimer;
  Timer? _recordingTimer;

  // Error handling
  String? _lastError;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;

  // Getters
  VideoConsultation? get currentConsultation => _currentConsultation;
  String? get currentUserId => _currentUserId;
  bool get isDoctor => _isDoctor;
  bool get isInitialized => _isInitialized;
  VideoCallState get state => _state;
  bool get isMuted => _isMuted;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get showChat => _showChat;
  bool get isRecording => _isRecording;
  String get recordingDuration => _recordingDuration;
  Duration get callDuration => _callDuration;
  String? get lastError => _lastError;
  AgoraService get agoraService => _agoraService;
  List<int> get remoteUsers => _agoraService.remoteUsers;

  /// Initialize the video call manager
  Future<void> initialize({
    required String userId,
    required bool isDoctor,
    required VideoConsultationService consultationService,
  }) async {
    if (_isInitialized) return;

    try {
      _currentUserId = userId;
      _isDoctor = isDoctor;
      _consultationService = consultationService;

      // Initialize services
      _agoraService = AgoraService();
      _socketService = SocketService();
      _recordingService = CallRecordingService();

      // Initialize Agora
      await _agoraService.initialize();

      // Initialize Socket service
      await _socketService.initialize(
        userId: userId,
        userRole: isDoctor ? 'doctor' : 'patient',
        userName: isDoctor ? 'Dr. $userId' : 'Patient $userId',
      );

      // Set up listeners
      _setupListeners();

      _isInitialized = true;
      _setState(VideoCallState.initialized);

      debugPrint(
        'VideoCallManager initialized for $userId (${isDoctor ? 'doctor' : 'patient'})',
      );
    } catch (e) {
      _setError('Failed to initialize video call manager: $e');
      rethrow;
    }
  }

  /// Set up event listeners for all services
  void _setupListeners() {
    // Listen for Agora service changes
    _agoraService.addListener(_onAgoraStateChanged);

    // Listen for socket events (video call requests, etc.)
    _socketService.videoCallRequests.listen(_onVideoCallRequest);
    _socketService.recordingEvents.listen(_onRecordingEvent);
  }

  /// Start a video consultation
  Future<void> startConsultation(VideoConsultation consultation) async {
    if (!_isInitialized) {
      throw Exception('VideoCallManager not initialized');
    }

    try {
      _setState(VideoCallState.connecting);
      _currentConsultation = consultation;

      // Start the consultation in the service
      await _consultationService.startConsultation(consultation.id);

      // Join the video channel
      final channelId =
          consultation.roomId ?? 'consultation_${consultation.id}';
      final token = consultation.sessionToken ?? '';

      await _agoraService.joinChannel(channelId: channelId, token: token);

      // Join socket room
      _socketService.joinConsultation(
        consultationId: consultation.id,
        userId: _currentUserId!,
        role: _isDoctor ? 'doctor' : 'patient',
      );

      // Start call timer
      _startCallTimer();

      _setState(VideoCallState.connected);
      notifyListeners();

      debugPrint('Video consultation started: ${consultation.id}');
    } catch (e) {
      _setError('Failed to start consultation: $e');
      _setState(VideoCallState.error);
      rethrow;
    }
  }

  /// End the current consultation
  Future<void> endConsultation({String? prescription, String? feedback}) async {
    if (_currentConsultation == null) return;

    try {
      _setState(VideoCallState.ending);

      // Stop recording if active
      if (_isRecording) {
        await stopRecording();
      }

      // Stop timers
      _callTimer?.cancel();
      _recordingTimer?.cancel();

      // Leave Agora channel
      await _agoraService.leaveChannel();

      // End consultation in service
      await _consultationService.endConsultation(
        _currentConsultation!.id,
        prescription: prescription,
        feedback: feedback,
      );

      // Reset state
      _currentConsultation = null;
      _callDuration = Duration.zero;
      _isMuted = false;
      _isVideoEnabled = true;
      _isSpeakerOn = false;
      _showChat = false;
      _isRecording = false;
      _recordingDuration = '00:00';

      _setState(VideoCallState.ended);
      notifyListeners();

      debugPrint('Video consultation ended');
    } catch (e) {
      _setError('Failed to end consultation: $e');
    }
  }

  /// Toggle microphone mute
  Future<void> toggleMute() async {
    if (!_isInitialized) return;

    try {
      await _agoraService.toggleMute();
      _isMuted = _agoraService.isMuted;
      notifyListeners();
    } catch (e) {
      _setError('Failed to toggle mute: $e');
    }
  }

  /// Toggle camera on/off
  Future<void> toggleVideo() async {
    if (!_isInitialized) return;

    try {
      await _agoraService.toggleCamera();
      _isVideoEnabled = _agoraService.isVideoEnabled;
      notifyListeners();
    } catch (e) {
      _setError('Failed to toggle video: $e');
    }
  }

  /// Toggle speaker on/off
  Future<void> toggleSpeaker() async {
    if (!_isInitialized) return;

    try {
      await _agoraService.toggleSpeaker();
      _isSpeakerOn = _agoraService.isSpeakerOn;
      notifyListeners();
    } catch (e) {
      _setError('Failed to toggle speaker: $e');
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (!_isInitialized) return;

    try {
      await _agoraService.switchCamera();
    } catch (e) {
      _setError('Failed to switch camera: $e');
    }
  }

  /// Toggle chat visibility
  void toggleChat() {
    _showChat = !_showChat;
    notifyListeners();
  }

  /// Start call recording
  Future<void> startRecording() async {
    if (!_isInitialized || _currentConsultation == null) return;
    if (!_isDoctor) {
      throw Exception('Only doctors can start recording');
    }

    try {
      final recordingId = await _recordingService.startRecording(
        consultationId: _currentConsultation!.id,
        patientId: _currentConsultation!.patientId,
        doctorId: _currentConsultation!.doctorId,
        requiresConsent: true,
      );

      if (recordingId != null) {
        await _agoraService.startRecording(recordingId: recordingId);
        _isRecording = true;
        _startRecordingTimer();

        // Notify via socket
        _socketService.notifyRecordingStarted(
          consultationId: _currentConsultation!.id,
          recordingId: recordingId,
        );

        notifyListeners();
        debugPrint('Recording started: $recordingId');
      }
    } catch (e) {
      _setError('Failed to start recording: $e');
      rethrow;
    }
  }

  /// Stop call recording
  Future<void> stopRecording() async {
    if (!_isRecording) return;

    try {
      await _recordingService.stopRecording();
      await _agoraService.stopRecording();

      _isRecording = false;
      _recordingDuration = '00:00';
      _recordingTimer?.cancel();

      // Notify via socket
      if (_currentConsultation != null) {
        _socketService.notifyRecordingStopped(
          consultationId: _currentConsultation!.id,
          recordingId: _recordingService.currentRecording?.id ?? '',
        );
      }

      notifyListeners();
      debugPrint('Recording stopped');
    } catch (e) {
      _setError('Failed to stop recording: $e');
    }
  }

  /// Handle incoming video call request
  void _onVideoCallRequest(VideoCallRequest request) {
    if (!_isDoctor && request.patientId == _currentUserId) {
      debugPrint('Received incoming call from doctor: ${request.doctorId}');
      // Auto-accept or show UI to accept call
      _acceptIncomingCall(request);
    }
  }

  /// Accept incoming video call
  Future<void> _acceptIncomingCall(VideoCallRequest request) async {
    try {
      // Create consultation object from request
      final consultation = VideoConsultation.create(
        appointmentId: request.consultationId,
        patientId: request.patientId,
        doctorId: request.doctorId,
        patientName: 'Patient',
        doctorName: 'Doctor',
        scheduledAt: DateTime.now(),
      ).copyWith(roomId: request.roomId);

      await startConsultation(consultation);
    } catch (e) {
      _setError('Failed to accept incoming call: $e');
    }
  }

  /// Handle recording events from socket
  void _onRecordingEvent(RecordingEvent event) {
    if (event.consultationId == _currentConsultation?.id) {
      _isRecording = event.type == 'started';
      if (!_isRecording) {
        _recordingDuration = '00:00';
        _recordingTimer?.cancel();
      } else if (_recordingTimer?.isActive != true) {
        _startRecordingTimer();
      }
      notifyListeners();
    }
  }

  /// Handle Agora service state changes
  void _onAgoraStateChanged() {
    if (_agoraService.isReconnecting && _state != VideoCallState.reconnecting) {
      _setState(VideoCallState.reconnecting);
    } else if (!_agoraService.isReconnecting &&
        _state == VideoCallState.reconnecting) {
      _setState(VideoCallState.connected);
    }
    notifyListeners();
  }

  /// Start call duration timer
  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDuration = Duration(seconds: _callDuration.inSeconds + 1);
      notifyListeners();
    });
  }

  /// Start recording duration timer
  void _startRecordingTimer() {
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isRecording && _recordingService.recordingStartTime != null) {
        final elapsed = DateTime.now().difference(
          _recordingService.recordingStartTime!,
        );
        _recordingDuration = _formatDuration(elapsed);
        notifyListeners();
      }
    });
  }

  /// Format duration as MM:SS or HH:MM:SS
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

  /// Set current state
  void _setState(VideoCallState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Set error state
  void _setError(String error) {
    _lastError = error;
    debugPrint('VideoCallManager error: $error');
    notifyListeners();
  }

  /// Clean up resources
  @override
  void dispose() {
    _callTimer?.cancel();
    _recordingTimer?.cancel();
    _agoraService.removeListener(_onAgoraStateChanged);
    _agoraService.dispose();
    _socketService.dispose();
    super.dispose();
  }
}

/// Video call states
enum VideoCallState {
  idle,
  initialized,
  connecting,
  connected,
  reconnecting,
  ending,
  ended,
  error,
}

import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';

import '../config/agora_config.dart';

/// Video layout options for multi-participant calls
enum VideoLayout {
  grid, // Grid layout for multiple participants
  speaker, // Speaker view with thumbnails
}

/// User connection state
enum UserConnectionState {
  connecting,
  connected,
  reconnecting,
  disconnected,
  failed,
}

/// Network quality information
class NetworkQuality {
  final int uid;
  final QualityType txQuality;
  final QualityType rxQuality;

  NetworkQuality({
    required this.uid,
    required this.txQuality,
    required this.rxQuality,
  });

  bool get isGood =>
      (txQuality == QualityType.qualityExcellent ||
          txQuality == QualityType.qualityGood) &&
      (rxQuality == QualityType.qualityExcellent ||
          rxQuality == QualityType.qualityGood);

  String get description {
    if (txQuality == QualityType.qualityExcellent &&
        rxQuality == QualityType.qualityExcellent) {
      return 'Excellent';
    } else if (isGood) {
      return 'Good';
    } else if (txQuality == QualityType.qualityPoor ||
        rxQuality == QualityType.qualityPoor) {
      return 'Poor';
    } else {
      return 'Fair';
    }
  }
}

/// Service for managing Agora video calls
class AgoraService extends ChangeNotifier {
  RtcEngine? _engine;
  bool _isInitialized = false;
  bool _isJoined = false;
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isSpeakerOn = false;
  String? _currentChannelId;
  int? _currentUid;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 3;
  Timer? _reconnectTimer;
  bool _isReconnecting = false;

  // Recording state
  bool _isRecording = false;
  String? _recordingId;

  // Remote users with enhanced state tracking
  List<int> _remoteUsers = [];
  Map<int, UserConnectionState> _userStates = {};
  Map<int, NetworkQuality> _networkQualities = {};

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isJoined => _isJoined;
  bool get isMuted => _isMuted;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get isRecording => _isRecording;
  bool get isReconnecting => _isReconnecting;
  String? get recordingId => _recordingId;
  List<int> get remoteUsers => List.unmodifiable(_remoteUsers);
  Map<int, NetworkQuality> get networkQualities =>
      Map.unmodifiable(_networkQualities);
  RtcEngine? get engine => _engine;

  /// Initialize Agora RTC Engine
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permissions
      await _requestPermissions();

      // Create and initialize engine
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(
        const RtcEngineContext(
          appId: AgoraConfig.appId,
          channelProfile: AgoraConfig.channelProfile,
        ),
      );

      // Set up event handlers
      _setupEventHandlers();

      // Configure video
      await _configureVideo();

      // Configure audio
      await _configureAudio();

      _isInitialized = true;
      notifyListeners();

      debugPrint('Agora RTC Engine initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Agora RTC Engine: $e');
      rethrow;
    }
  }

  /// Request camera and microphone permissions
  Future<void> _requestPermissions() async {
    // For web, permissions are handled by the browser when accessing camera/microphone
    if (kIsWeb) {
      debugPrint('🌐 Running on web - permissions will be handled by browser');
      return;
    }

    // For mobile platforms, use permission_handler
    final statuses = await [Permission.microphone, Permission.camera].request();

    if (statuses[Permission.camera] != PermissionStatus.granted) {
      debugPrint('❌ Camera permission not granted');
      throw Exception('Camera permission is required for video calls');
    }

    if (statuses[Permission.microphone] != PermissionStatus.granted) {
      debugPrint('❌ Microphone permission not granted');
      throw Exception('Microphone permission is required for video calls');
    }

    debugPrint('✅ Camera and microphone permissions granted');
  }

  /// Set up event handlers for Agora events
  void _setupEventHandlers() {
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        // User joined channel
        onUserJoined: (connection, uid, elapsed) {
          debugPrint(
            '🎉 Remote user joined channel: $uid (total users: ${_remoteUsers.length + 1})',
          );
          _remoteUsers.add(uid);
          _userStates[uid] = UserConnectionState.connected;
          notifyListeners();
        },

        // User left channel
        onUserOffline: (connection, uid, reason) {
          debugPrint(
            '👋 Remote user left channel: $uid, reason: $reason (remaining users: ${_remoteUsers.length - 1})',
          );
          _remoteUsers.remove(uid);
          _userStates.remove(uid);
          _networkQualities.remove(uid);
          notifyListeners();
        },

        // Local user joined channel
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint('Local user joined channel: ${connection.channelId}');
          _isJoined = true;
          _currentChannelId = connection.channelId;
          _currentUid = connection.localUid;
          _reconnectAttempts = 0;
          _isReconnecting = false;
          _reconnectTimer?.cancel();
          notifyListeners();
        },

        // Local user left channel
        onLeaveChannel: (connection, stats) {
          debugPrint('Local user left channel');
          _isJoined = false;
          _currentChannelId = null;
          _currentUid = null;
          _remoteUsers.clear();
          _userStates.clear();
          _networkQualities.clear();
          notifyListeners();
        },

        // Remote video state changed
        onRemoteVideoStateChanged: (connection, uid, state, reason, elapsed) {
          debugPrint(
            'Remote video state changed: $uid, state: $state, reason: $reason',
          );
          _handleRemoteVideoStateChange(uid, state, reason);
          notifyListeners();
        },

        // Remote audio state changed
        onRemoteAudioStateChanged: (connection, uid, state, reason, elapsed) {
          debugPrint(
            'Remote audio state changed: $uid, state: $state, reason: $reason',
          );
          _handleRemoteAudioStateChange(uid, state, reason);
          notifyListeners();
        },

        // Connection state changed
        onConnectionStateChanged: (connection, state, reason) {
          debugPrint('Connection state changed: $state, reason: $reason');
          _handleConnectionStateChange(state, reason);
        },

        // Network quality indicators
        onNetworkQuality: (connection, uid, txQuality, rxQuality) {
          _networkQualities[uid] = NetworkQuality(
            uid: uid,
            txQuality: txQuality,
            rxQuality: rxQuality,
          );
          notifyListeners();
        },

        // Audio volume indication
        onAudioVolumeIndication:
            (connection, speakers, speakerNumber, totalVolume) {
          // Handle audio volume levels for UI feedback
        },

        // Error occurred
        onError: (err, msg) {
          debugPrint('Agora Error: $err, message: $msg');
          _handleError(err, msg);
        },

        // Connection interrupted
        onConnectionInterrupted: (connection) {
          debugPrint('Connection interrupted');
          _handleConnectionInterrupted();
        },

        // Connection lost
        onConnectionLost: (connection) {
          debugPrint('Connection lost');
          _handleConnectionLost();
        },

        // Rejoin channel success
        onRejoinChannelSuccess: (connection, elapsed) {
          debugPrint('Rejoined channel successfully');
          _isReconnecting = false;
          _reconnectAttempts = 0;
          notifyListeners();
        },
      ),
    );
  }

  /// Configure video settings
  Future<void> _configureVideo() async {
    await _engine!.enableVideo();

    // Use web-optimized settings for better compatibility
    if (kIsWeb) {
      await _engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 640, height: 480),
          frameRate: 15,
          bitrate: 500,
        ),
      );
    } else {
      await _engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: AgoraConfig.videoDimensions,
          frameRate: AgoraConfig.videoFrameRate,
          bitrate: AgoraConfig.videoBitrate,
        ),
      );
    }
  }

  /// Configure audio settings
  Future<void> _configureAudio() async {
    await _engine!.enableAudio();
    await _engine!.setAudioProfile(
      profile: AgoraConfig.audioProfile,
      scenario: AgoraConfig.audioScenario,
    );
  }

  /// Join a video channel with retry logic
  Future<void> joinChannel({
    required String channelId,
    required String token,
    int uid = AgoraConfig.defaultUid,
    int maxRetries = 3,
  }) async {
    if (!_isInitialized) {
      throw Exception('Agora engine not initialized');
    }

    debugPrint('🎥 Attempting to join Agora channel: $channelId (uid: $uid)');
    debugPrint('🌐 Platform: ${kIsWeb ? "Web" : "Mobile"}');

    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        await _engine!.joinChannel(
          token: token,
          channelId: channelId,
          uid: uid,
          options: const ChannelMediaOptions(
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            channelProfile: AgoraConfig.channelProfile,
            publishCameraTrack: true,
            publishMicrophoneTrack: true,
            autoSubscribeVideo: true,
            autoSubscribeAudio: true,
          ),
        );
        debugPrint('✅ Successfully joined Agora channel: $channelId');
        return; // Success, exit retry loop
      } catch (e) {
        attempts++;
        debugPrint('Join channel attempt $attempts failed: $e');

        if (attempts >= maxRetries) {
          debugPrint('Max join attempts reached, throwing error');
          rethrow;
        }

        // Wait before retry
        await Future.delayed(Duration(seconds: attempts * 2));
      }
    }
  }

  /// Leave the current channel
  Future<void> leaveChannel() async {
    if (_engine != null && _isJoined) {
      await _engine!.leaveChannel();
    }
  }

  /// Toggle microphone mute/unmute
  Future<void> toggleMute() async {
    if (_engine != null) {
      _isMuted = !_isMuted;
      await _engine!.muteLocalAudioStream(_isMuted);
      notifyListeners();
    }
  }

  /// Toggle camera on/off
  Future<void> toggleCamera() async {
    if (_engine != null) {
      _isVideoEnabled = !_isVideoEnabled;
      await _engine!.muteLocalVideoStream(!_isVideoEnabled);
      notifyListeners();
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_engine != null) {
      await _engine!.switchCamera();
    }
  }

  /// Toggle speaker on/off
  Future<void> toggleSpeaker() async {
    if (_engine != null) {
      _isSpeakerOn = !_isSpeakerOn;
      await _engine!.setEnableSpeakerphone(_isSpeakerOn);
      notifyListeners();
    }
  }

  /// Set audio route to speaker
  Future<void> setAudioRoute(bool speakerOn) async {
    if (_engine != null) {
      _isSpeakerOn = speakerOn;
      await _engine!.setEnableSpeakerphone(speakerOn);
      notifyListeners();
    }
  }

  /// Mute/unmute local audio
  Future<void> muteLocalAudio(bool mute) async {
    if (_engine != null) {
      _isMuted = mute;
      await _engine!.muteLocalAudioStream(mute);
      notifyListeners();
    }
  }

  /// Enable/disable local video
  Future<void> enableLocalVideo(bool enable) async {
    if (_engine != null) {
      _isVideoEnabled = enable;
      await _engine!.muteLocalVideoStream(!enable);
      debugPrint('📹 Local video ${enable ? "enabled" : "disabled"}');
      notifyListeners();
    }
  }

  /// Get video canvas for local preview
  Widget createLocalVideoView() {
    debugPrint(
        '🎬 Creating local video view (initialized: $_isInitialized, engine: ${_engine != null})');

    if (!_isInitialized || _engine == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Camera Initializing...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(
          uid: 0,
          renderMode: RenderModeType.renderModeHidden,
          mirrorMode: VideoMirrorModeType.videoMirrorModeAuto,
        ),
      ),
    );
  }

  /// Get video canvas for remote user
  Widget createRemoteVideoView(int uid) {
    debugPrint(
        '🎥 Creating remote video view for user: $uid (initialized: $_isInitialized, engine: ${_engine != null})');

    if (!_isInitialized || _engine == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Text('User $uid', style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(
          uid: uid,
          renderMode: RenderModeType.renderModeHidden,
        ),
        connection: RtcConnection(channelId: _currentChannelId ?? ''),
      ),
    );
  }

  /// Start echo test (for testing audio)
  Future<void> startEchoTest() async {
    if (_engine != null) {
      // Agora echo test - check current API documentation for correct parameters
      // This is optional functionality - remove if not needed
      debugPrint(
        'Echo test feature - check Agora documentation for current API',
      );
    }
  }

  /// Stop echo test
  Future<void> stopEchoTest() async {
    if (_engine != null) {
      // Agora stop echo test - check current API documentation
      debugPrint(
        'Stop echo test feature - check Agora documentation for current API',
      );
    }
  }

  /// Enable/disable audio volume indication
  Future<void> enableAudioVolumeIndication({
    int interval = 200,
    int smooth = 3,
    bool reportVad = false,
  }) async {
    if (_engine != null) {
      await _engine!.enableAudioVolumeIndication(
        interval: interval,
        smooth: smooth,
        reportVad: reportVad,
      );
    }
  }

  /// Start call recording
  Future<bool> startRecording({
    required String recordingId,
    String? storageConfig,
  }) async {
    if (_engine == null || !_isJoined) {
      debugPrint(
        'Cannot start recording: Engine not initialized or not joined channel',
      );
      return false;
    }

    try {
      _recordingId = recordingId;
      _isRecording = true;
      notifyListeners();

      // Note: Cloud recording requires Agora Cloud Recording service
      // This is a placeholder for local recording or cloud recording setup
      debugPrint('Recording started with ID: $recordingId');

      return true;
    } catch (e) {
      debugPrint('Failed to start recording: $e');
      _isRecording = false;
      _recordingId = null;
      notifyListeners();
      return false;
    }
  }

  /// Stop call recording
  Future<bool> stopRecording() async {
    if (_engine == null || !_isRecording) {
      debugPrint('Cannot stop recording: Not currently recording');
      return false;
    }

    try {
      _isRecording = false;
      final recordingId = _recordingId;
      _recordingId = null;
      notifyListeners();

      debugPrint('Recording stopped with ID: $recordingId');

      return true;
    } catch (e) {
      debugPrint('Failed to stop recording: $e');
      return false;
    }
  }

  /// Enable dual stream mode for better multi-participant support
  Future<void> enableDualStreamMode() async {
    if (_engine != null) {
      try {
        await _engine!.enableDualStreamMode(enabled: true);
        debugPrint(
          'Dual stream mode enabled for better multi-participant support',
        );
      } catch (e) {
        debugPrint('Failed to enable dual stream mode: $e');
      }
    }
  }

  /// Set remote video stream type (high/low quality) for bandwidth optimization
  Future<void> setRemoteVideoStreamType(
    int uid,
    VideoStreamType streamType,
  ) async {
    if (_engine != null) {
      try {
        await _engine!.setRemoteVideoStreamType(
          uid: uid,
          streamType: streamType,
        );
        debugPrint('Set video stream type for user $uid: $streamType');
      } catch (e) {
        debugPrint('Failed to set remote video stream type: $e');
      }
    }
  }

  /// Optimize for multi-participant calls
  Future<void> optimizeForMultiParticipant() async {
    if (_engine != null) {
      try {
        // Enable dual stream mode
        await enableDualStreamMode();

        // Configure for multiple participants
        await _engine!.setParameters('{"che.audio.live_for_comm":true}');

        // Set low latency mode
        await _engine!.setParameters('{"rtc.enable_nasa2":true}');

        debugPrint('Optimized for multi-participant calls');
      } catch (e) {
        debugPrint('Failed to optimize for multi-participant: $e');
      }
    }
  }

  /// Set video layout for multiple participants
  Future<void> setVideoLayout(VideoLayout layout) async {
    if (_engine != null) {
      try {
        // Configure video layout parameters
        switch (layout) {
          case VideoLayout.grid:
            await _engine!.setParameters(
              '{"che.video.lowBitRateStreamParameter":{"width":160,"height":120,"frameRate":15,"bitRate":65}}',
            );
            break;
          case VideoLayout.speaker:
            await _engine!.setParameters(
              '{"che.video.lowBitRateStreamParameter":{"width":320,"height":240,"frameRate":15,"bitRate":140}}',
            );
            break;
        }
        debugPrint('Video layout set to: $layout');
      } catch (e) {
        debugPrint('Failed to set video layout: $e');
      }
    }
  }

  /// Clean up and dispose resources
  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  /// Clean up Agora resources
  Future<void> _cleanup() async {
    _reconnectTimer?.cancel();

    if (_engine != null) {
      if (_isJoined) {
        await _engine!.leaveChannel();
      }
      await _engine!.release();
      _engine = null;
      _isInitialized = false;
      _isJoined = false;
      _remoteUsers.clear();
      _userStates.clear();
      _networkQualities.clear();
    }
  }

  // Error handling and reconnection methods
  void _handleError(ErrorCodeType error, String message) {
    switch (error) {
      case ErrorCodeType.errTokenExpired:
      case ErrorCodeType.errInvalidToken:
        _handleTokenError();
        break;
      default:
        debugPrint('Agora error: $error - $message');
        _handleNetworkError();
    }
  }

  void _handleConnectionStateChange(
    ConnectionStateType state,
    ConnectionChangedReasonType reason,
  ) {
    switch (state) {
      case ConnectionStateType.connectionStateDisconnected:
        if (reason ==
            ConnectionChangedReasonType.connectionChangedInterrupted) {
          _handleConnectionLost();
        }
        break;
      case ConnectionStateType.connectionStateReconnecting:
        _isReconnecting = true;
        notifyListeners();
        break;
      case ConnectionStateType.connectionStateConnected:
        _isReconnecting = false;
        _reconnectAttempts = 0;
        notifyListeners();
        break;
      case ConnectionStateType.connectionStateFailed:
        _handleConnectionFailed();
        break;
      default:
        break;
    }
  }

  void _handleRemoteVideoStateChange(
    int uid,
    RemoteVideoState state,
    RemoteVideoStateReason reason,
  ) {
    switch (state) {
      case RemoteVideoState.remoteVideoStateStopped:
        debugPrint('Remote video stopped for user $uid: $reason');
        break;
      case RemoteVideoState.remoteVideoStateStarting:
        debugPrint('Remote video starting for user $uid');
        break;
      case RemoteVideoState.remoteVideoStateDecoding:
        debugPrint('Remote video decoding for user $uid');
        break;
      case RemoteVideoState.remoteVideoStateFrozen:
        debugPrint('Remote video frozen for user $uid: $reason');
        break;
      case RemoteVideoState.remoteVideoStateFailed:
        debugPrint('Remote video failed for user $uid: $reason');
        break;
      default:
        break;
    }
  }

  void _handleRemoteAudioStateChange(
    int uid,
    RemoteAudioState state,
    RemoteAudioStateReason reason,
  ) {
    switch (state) {
      case RemoteAudioState.remoteAudioStateStopped:
        debugPrint('Remote audio stopped for user $uid: $reason');
        break;
      case RemoteAudioState.remoteAudioStateStarting:
        debugPrint('Remote audio starting for user $uid');
        break;
      case RemoteAudioState.remoteAudioStateDecoding:
        debugPrint('Remote audio decoding for user $uid');
        break;
      case RemoteAudioState.remoteAudioStateFrozen:
        debugPrint('Remote audio frozen for user $uid: $reason');
        break;
      case RemoteAudioState.remoteAudioStateFailed:
        debugPrint('Remote audio failed for user $uid: $reason');
        break;
      default:
        break;
    }
  }

  void _handleNetworkError() {
    debugPrint('Network error detected, attempting to reconnect...');
    _attemptReconnection();
  }

  void _handleTokenError() {
    debugPrint('Token error detected, need to refresh token');
    // In a real app, you would request a new token from your server
  }

  void _handleConnectionInterrupted() {
    debugPrint('Connection interrupted, will attempt to reconnect');
    _isReconnecting = true;
    notifyListeners();
  }

  void _handleConnectionLost() {
    debugPrint('Connection lost, attempting to reconnect...');
    _attemptReconnection();
  }

  void _handleConnectionFailed() {
    debugPrint('Connection failed completely');
    _isReconnecting = false;
    notifyListeners();
  }

  void _attemptReconnection() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('Max reconnection attempts reached');
      _isReconnecting = false;
      notifyListeners();
      return;
    }

    _reconnectAttempts++;
    _isReconnecting = true;
    notifyListeners();

    final delay = Duration(seconds: _reconnectAttempts * 2);
    _reconnectTimer = Timer(delay, () async {
      if (_currentChannelId != null) {
        try {
          debugPrint('Reconnection attempt $_reconnectAttempts');
          await leaveChannel();
          await Future.delayed(const Duration(seconds: 1));
          await joinChannel(
            channelId: _currentChannelId!,
            token: '', // You would get a fresh token here
          );
        } catch (e) {
          debugPrint('Reconnection attempt $_reconnectAttempts failed: $e');
          if (_reconnectAttempts < _maxReconnectAttempts) {
            _attemptReconnection();
          } else {
            _isReconnecting = false;
            notifyListeners();
          }
        }
      }
    });
  }

  /// Get connection quality for a user
  NetworkQuality? getNetworkQuality(int uid) {
    return _networkQualities[uid];
  }

  /// Get connection state for a user
  UserConnectionState? getUserConnectionState(int uid) {
    return _userStates[uid];
  }
}

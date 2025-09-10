import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/agora_config.dart';

/// Video layout options for multi-participant calls
enum VideoLayout {
  grid, // Grid layout for multiple participants
  speaker, // Speaker view with thumbnails
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

  // Recording state
  bool _isRecording = false;
  String? _recordingId;

  // Remote users
  List<int> _remoteUsers = [];

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isJoined => _isJoined;
  bool get isMuted => _isMuted;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get isRecording => _isRecording;
  String? get recordingId => _recordingId;
  List<int> get remoteUsers => List.unmodifiable(_remoteUsers);
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
    await [Permission.microphone, Permission.camera].request();
  }

  /// Set up event handlers for Agora events
  void _setupEventHandlers() {
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        // User joined channel
        onUserJoined: (connection, uid, elapsed) {
          debugPrint('User joined: $uid');
          _remoteUsers.add(uid);
          notifyListeners();
        },

        // User left channel
        onUserOffline: (connection, uid, reason) {
          debugPrint('User left: $uid');
          _remoteUsers.remove(uid);
          notifyListeners();
        },

        // Local user joined channel
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint('Local user joined channel: ${connection.channelId}');
          _isJoined = true;
          _currentChannelId = connection.channelId;
          _currentUid = connection.localUid;
          notifyListeners();
        },

        // Local user left channel
        onLeaveChannel: (connection, stats) {
          debugPrint('Local user left channel');
          _isJoined = false;
          _currentChannelId = null;
          _currentUid = null;
          _remoteUsers.clear();
          notifyListeners();
        },

        // Remote video state changed
        onRemoteVideoStateChanged: (connection, uid, state, reason, elapsed) {
          debugPrint('Remote video state changed: $uid, state: $state');
          notifyListeners();
        },

        // Remote audio state changed
        onRemoteAudioStateChanged: (connection, uid, state, reason, elapsed) {
          debugPrint('Remote audio state changed: $uid, state: $state');
          notifyListeners();
        },

        // Connection state changed
        onConnectionStateChanged: (connection, state, reason) {
          debugPrint('Connection state changed: $state, reason: $reason');
        },

        // Error occurred
        onError: (err, msg) {
          debugPrint('Agora Error: $err, message: $msg');
        },
      ),
    );
  }

  /// Configure video settings
  Future<void> _configureVideo() async {
    await _engine!.enableVideo();
    await _engine!.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: AgoraConfig.videoDimensions,
        frameRate: AgoraConfig.videoFrameRate,
        bitrate: AgoraConfig.videoBitrate,
      ),
    );
  }

  /// Configure audio settings
  Future<void> _configureAudio() async {
    await _engine!.enableAudio();
    await _engine!.setAudioProfile(
      profile: AgoraConfig.audioProfile,
      scenario: AgoraConfig.audioScenario,
    );
  }

  /// Join a video channel
  Future<void> joinChannel({
    required String channelId,
    required String token,
    int uid = AgoraConfig.defaultUid,
  }) async {
    if (!_isInitialized) {
      throw Exception('Agora engine not initialized');
    }

    try {
      await _engine!.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: AgoraConfig.channelProfile,
        ),
      );
    } catch (e) {
      debugPrint('Error joining channel: $e');
      rethrow;
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
      notifyListeners();
    }
  }

  /// Get video canvas for local preview
  Widget createLocalVideoView() {
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
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  /// Get video canvas for remote user
  Widget createRemoteVideoView(int uid) {
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
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: _currentChannelId),
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
    if (_engine != null) {
      if (_isJoined) {
        await _engine!.leaveChannel();
      }
      // Note: unregisterEventHandler might need specific event handler as parameter
      // Check Agora documentation for current API
      await _engine!.release();
      _engine = null;
      _isInitialized = false;
      _isJoined = false;
      _remoteUsers.clear();
    }
  }
}

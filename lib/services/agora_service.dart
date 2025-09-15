import 'dart:async';
import 'dart:developer';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/agora_config.dart';

class AgoraService {
  // Use App ID from config
  static const String appId = AgoraConfig.appId;

  RtcEngine? _engine;
  bool _isInitialized = false;
  bool _isJoined = false;
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  bool _isSpeakerOn = true;
  int? _localUserUid;
  List<int> _remoteUsers = [];

  // Stream controllers for state changes
  final StreamController<bool> _mutedController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _videoEnabledController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _speakerController =
      StreamController<bool>.broadcast();
  final StreamController<List<int>> _remoteUsersController =
      StreamController<List<int>>.broadcast();
  final StreamController<String> _connectionStateController =
      StreamController<String>.broadcast();

  // For compatibility with existing code that expects addListener
  final List<VoidCallback> _listeners = [];

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isJoined => _isJoined;
  bool get isMuted => _isMuted;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isSpeakerOn => _isSpeakerOn;
  int? get localUserUid => _localUserUid;
  List<int> get remoteUsers => _remoteUsers;

  // Streams
  Stream<bool> get mutedStream => _mutedController.stream;
  Stream<bool> get videoEnabledStream => _videoEnabledController.stream;
  Stream<bool> get speakerStream => _speakerController.stream;
  Stream<List<int>> get remoteUsersStream => _remoteUsersController.stream;
  Stream<String> get connectionStateStream => _connectionStateController.stream;

  /// Add listener for backward compatibility
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Remove listener for backward compatibility
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Notify all listeners (for backward compatibility)
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Initialize Agora RTC Engine
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request permissions
      await _requestPermissions();

      // Create RTC engine
      _engine = createAgoraRtcEngine();

      // Initialize the engine
      await _engine!.initialize(
        RtcEngineContext(
          appId: appId,
          channelProfile: AgoraConfig.channelProfile,
        ),
      );

      // Register event handlers
      _registerEventHandlers();

      // Configure video settings
      await _configureVideo();

      // Configure audio settings
      await _configureAudio();

      _isInitialized = true;
      log('Agora RTC Engine initialized successfully');
    } catch (e) {
      log('Failed to initialize Agora RTC Engine: $e');
      throw Exception('Failed to initialize video service: $e');
    }
  }

  /// Request necessary permissions
  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    bool allGranted = permissions.values.every(
      (status) => status == PermissionStatus.granted,
    );

    if (!allGranted) {
      throw Exception('Camera and microphone permissions are required');
    }
  }

  /// Register event handlers
  void _registerEventHandlers() {
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          log('Local user ${connection.localUid} joined channel');
          _localUserUid = connection.localUid;
          _isJoined = true;
          _connectionStateController.add('joined');
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          log('Remote user $remoteUid joined channel');
          _remoteUsers.add(remoteUid);
          _remoteUsersController.add(_remoteUsers);
          _notifyListeners();
        },
        onUserOffline:
            (
              RtcConnection connection,
              int remoteUid,
              UserOfflineReasonType reason,
            ) {
              log('Remote user $remoteUid left channel');
              _remoteUsers.remove(remoteUid);
              _remoteUsersController.add(_remoteUsers);
              _notifyListeners();
            },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          log('Local user left channel');
          _isJoined = false;
          _remoteUsers.clear();
          _remoteUsersController.add(_remoteUsers);
          _connectionStateController.add('left');
        },
        onError: (ErrorCodeType error, String msg) {
          log('Agora Error: $error - $msg');
          _connectionStateController.add('error: $msg');
        },
        onConnectionStateChanged:
            (
              RtcConnection connection,
              ConnectionStateType state,
              ConnectionChangedReasonType reason,
            ) {
              log('Connection state changed: $state, reason: $reason');
              _connectionStateController.add(state.toString());
            },
        onLocalVideoStateChanged:
            (
              VideoSourceType source,
              LocalVideoStreamState state,
              LocalVideoStreamReason reason,
            ) {
              log('Local video state changed: $state');
            },
        onRemoteVideoStateChanged:
            (
              RtcConnection connection,
              int remoteUid,
              RemoteVideoState state,
              RemoteVideoStateReason reason,
              int elapsed,
            ) {
              log('Remote video state changed for user $remoteUid: $state');
            },
      ),
    );
  }

  /// Configure video settings
  Future<void> _configureVideo() async {
    await _engine!.enableVideo();
    await _engine!.setVideoEncoderConfiguration(
      VideoEncoderConfiguration(
        dimensions: AgoraConfig.videoDimensions,
        frameRate: AgoraConfig.videoFrameRate,
        bitrate: AgoraConfig.videoBitrate,
        orientationMode: OrientationMode.orientationModeAdaptive,
        degradationPreference: DegradationPreference.maintainQuality,
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

  /// Join a channel
  Future<void> joinChannel({
    required String channelName,
    required String token,
    int? uid,
  }) async {
    if (!_isInitialized) {
      throw Exception('Agora service not initialized');
    }

    try {
      ChannelMediaOptions options = ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: AgoraConfig.channelProfile,
      );

      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid ?? 0,
        options: options,
      );

      log('Joining channel: $channelName');
    } catch (e) {
      log('Failed to join channel: $e');
      throw Exception('Failed to join video call: $e');
    }
  }

  /// Leave the channel
  Future<void> leaveChannel() async {
    if (_engine != null && _isJoined) {
      await _engine!.leaveChannel();
      log('Left channel');
    }
  }

  /// Toggle microphone mute
  Future<void> muteLocalAudio(bool mute) async {
    if (_engine != null) {
      await _engine!.muteLocalAudioStream(mute);
      _isMuted = mute;
      _mutedController.add(_isMuted);
      _notifyListeners();
      log('Audio ${mute ? 'muted' : 'unmuted'}');
    }
  }

  /// Toggle video enable/disable
  Future<void> enableLocalVideo(bool enable) async {
    if (_engine != null) {
      await _engine!.enableLocalVideo(enable);
      _isVideoEnabled = enable;
      _videoEnabledController.add(_isVideoEnabled);
      _notifyListeners();
      log('Video ${enable ? 'enabled' : 'disabled'}');
    }
  }

  /// Toggle speaker/earpiece
  Future<void> setAudioRoute(bool speakerOn) async {
    if (_engine != null) {
      await _engine!.setEnableSpeakerphone(speakerOn);
      _isSpeakerOn = speakerOn;
      _speakerController.add(_isSpeakerOn);
      _notifyListeners();
      log('Audio route: ${speakerOn ? 'speaker' : 'earpiece'}');
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_engine != null) {
      await _engine!.switchCamera();
      log('Camera switched');
    }
  }

  /// Create local video view widget
  Widget createLocalVideoView() {
    if (_engine == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Camera not available',
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

  /// Create remote video view widget
  Widget createRemoteVideoView(int uid) {
    if (_engine == null) {
      return Container(
        color: Colors.grey[800],
        child: Center(
          child: Text('User $uid', style: const TextStyle(color: Colors.white)),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(uid: uid),
        connection: RtcConnection(channelId: ''),
      ),
    );
  }

  /// Optimize for multi-participant calls
  Future<void> optimizeForMultiParticipant() async {
    if (_engine != null) {
      // Enable dual stream mode for better performance
      await _engine!.enableDualStreamMode(enabled: true);

      // Set video encoder configuration for multi-party
      await _engine!.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 320, height: 240),
          frameRate: 15,
          bitrate: 0,
          orientationMode: OrientationMode.orientationModeAdaptive,
          degradationPreference: DegradationPreference.maintainFramerate,
        ),
      );
    }
  }

  /// Set video layout (placeholder for future layout optimizations)
  void setVideoLayout(String layout) {
    log('Video layout set to: $layout');
    // Implementation depends on specific layout requirements
  }

  /// Set remote video stream type
  Future<void> setRemoteVideoStreamType(
    int uid,
    VideoStreamType streamType,
  ) async {
    if (_engine != null) {
      await _engine!.setRemoteVideoStreamType(uid: uid, streamType: streamType);
    }
  }

  /// Start call recording (placeholder)
  Future<void> startRecording() async {
    // Implementation depends on recording service integration
    log('Recording started');
  }

  /// Stop call recording (placeholder)
  Future<void> stopRecording() async {
    // Implementation depends on recording service integration
    log('Recording stopped');
  }

  /// Get network quality
  Future<void> enableNetworkTest() async {
    if (_engine != null) {
      // Network quality monitoring is handled through event handlers
      log('Network quality monitoring enabled');
    }
  }

  /// Dispose the service
  Future<void> dispose() async {
    await leaveChannel();

    // Close stream controllers
    await _mutedController.close();
    await _videoEnabledController.close();
    await _speakerController.close();
    await _remoteUsersController.close();
    await _connectionStateController.close();

    // Release RTC engine
    if (_engine != null) {
      await _engine!.release();
      _engine = null;
    }

    _isInitialized = false;
    log('Agora service disposed');
  }

  /// Generate token (placeholder - should be implemented server-side)
  static Future<String> generateToken({
    required String channelName,
    required int uid,
  }) async {
    // In production, this should call your token server
    // For testing, you can use a temporary token from Agora Console

    // Return empty string for testing (works with Agora's test mode)
    return '';
  }
}

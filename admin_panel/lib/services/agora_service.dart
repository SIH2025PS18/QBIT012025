import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraVideoService {
  static const String appId =
      '98d3fa37dec44dc1950b071e3482cfae'; // Replace with your Agora App ID
  late RtcEngine _engine;
  bool _isInitialized = false;
  bool _isInChannel = false;

  // Callbacks
  Function(int uid, bool isJoined)? onUserJoined;
  Function(int uid)? onUserLeft;
  Function(ConnectionStateType state)? onConnectionStateChanged;
  Function(ErrorCodeType error)? onError;
  Function()? onJoinChannelSuccess;
  Function()? onLeaveChannel;

  static final AgoraVideoService _instance = AgoraVideoService._internal();
  factory AgoraVideoService() => _instance;
  AgoraVideoService._internal();

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Request permissions
      await _requestPermissions();

      // Create Agora engine
      _engine = createAgoraRtcEngine();

      // Initialize engine
      await _engine.initialize(RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      // Set up event handlers
      _engine.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('Successfully joined channel: ${connection.channelId}');
          _isInChannel = true;
          onJoinChannelSuccess?.call();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('User joined: $remoteUid');
          onUserJoined?.call(remoteUid, true);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print('User left: $remoteUid, reason: $reason');
          onUserLeft?.call(remoteUid);
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          print('Left channel: ${connection.channelId}');
          _isInChannel = false;
          onLeaveChannel?.call();
        },
        onConnectionStateChanged: (RtcConnection connection,
            ConnectionStateType state, ConnectionChangedReasonType reason) {
          print('Connection state changed: $state, reason: $reason');
          onConnectionStateChanged?.call(state);
        },
        onError: (ErrorCodeType err, String msg) {
          print('Agora error: $err, message: $msg');
          onError?.call(err);
        },
      ));

      // Enable video
      await _engine.enableVideo();
      await _engine.enableAudio();

      // Set client role to broadcaster (for doctors) or audience (for patients)
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      _isInitialized = true;
      return true;
    } catch (e) {
      print('Failed to initialize Agora: $e');
      return false;
    }
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  Future<bool> joinChannel({
    required String channelName,
    required String token,
    required int uid,
    bool isDoctor = true,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Set client role
      await _engine.setClientRole(
        role: isDoctor
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience,
      );

      if (!isDoctor) {
        // Enable audience to publish for bidirectional communication
        await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      }

      // Join channel
      await _engine.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(),
      );

      return true;
    } catch (e) {
      print('Failed to join channel: $e');
      return false;
    }
  }

  Future<void> leaveChannel() async {
    if (_isInChannel) {
      await _engine.leaveChannel();
      _isInChannel = false;
    }
  }

  Future<void> toggleCamera() async {
    await _engine
        .enableLocalVideo(!await _engine.isCameraAutoFocusFaceModeSupported());
  }

  Future<void> toggleMicrophone() async {
    // Get current microphone state and toggle it
    await _engine.muteLocalAudioStream(
        false); // This should be toggled based on current state
  }

  // Toggle video (new method)
  Future<void> toggleVideo(bool enabled) async {
    await _engine.enableLocalVideo(enabled);
  }

  // Toggle audio (new method)
  Future<void> toggleAudio(bool enabled) async {
    await _engine.enableLocalAudio(enabled);
  }

  Future<void> switchCamera() async {
    await _engine.switchCamera();
  }

  Future<void> enableSpeakerphone(bool enabled) async {
    await _engine.setEnableSpeakerphone(enabled);
  }

  Widget createLocalVideoView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget createRemoteVideoView(int uid) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: uid),
        connection: const RtcConnection(channelId: ''),
      ),
    );
  }

  Future<void> startScreenShare() async {
    await _engine.startScreenCapture(const ScreenCaptureParameters2());
  }

  Future<void> stopScreenShare() async {
    await _engine.stopScreenCapture();
  }

  Future<void> dispose() async {
    if (_isInChannel) {
      await leaveChannel();
    }

    if (_isInitialized) {
      await _engine.release();
      _isInitialized = false;
    }
  }

  bool get isInitialized => _isInitialized;
  bool get isInChannel => _isInChannel;
  RtcEngine get engine => _engine;

  // Set callbacks
  void setEventHandlers({
    Function(int uid, bool isJoined)? onUserJoined,
    Function(int uid)? onUserLeft,
    Function(ConnectionStateType state)? onConnectionStateChanged,
    Function(ErrorCodeType error)? onError,
    Function()? onJoinChannelSuccess,
    Function()? onLeaveChannel,
  }) {
    this.onUserJoined = onUserJoined;
    this.onUserLeft = onUserLeft;
    this.onConnectionStateChanged = onConnectionStateChanged;
    this.onError = onError;
    this.onJoinChannelSuccess = onJoinChannelSuccess;
    this.onLeaveChannel = onLeaveChannel;
  }

  void clearEventHandlers() {
    onUserJoined = null;
    onUserLeft = null;
    onConnectionStateChanged = null;
    onError = null;
    onJoinChannelSuccess = null;
    onLeaveChannel = null;
  }
}

// Token generator service (for development/testing)
class AgoraTokenService {
  static const String baseUrl = 'https://telemed18.onrender.com/api';

  static Future<String?> generateToken({
    required String channelName,
    required int uid,
    required String role, // 'publisher' or 'subscriber'
  }) async {
    try {
      // This should call your backend to generate Agora token
      // For now, returning a placeholder
      return 'YOUR_AGORA_TOKEN';
    } catch (e) {
      print('Failed to generate token: $e');
      return null;
    }
  }
}

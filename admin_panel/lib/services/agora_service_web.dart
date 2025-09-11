import 'package:flutter/foundation.dart';

class AgoraVideoService {
  static const String appId = '98d3fa37dec44dc1950b071e3482cfae';
  bool _isInitialized = false;
  bool _isInChannel = false;

  // Callbacks
  Function(int uid, bool isJoined)? onUserJoined;
  Function(int uid)? onUserLeft;
  Function()? onJoinChannelSuccess;
  Function()? onLeaveChannel;

  static final AgoraVideoService _instance = AgoraVideoService._internal();
  factory AgoraVideoService() => _instance;
  AgoraVideoService._internal();

  Future<bool> initialize() async {
    if (kIsWeb) {
      // For web, we'll use a mock implementation for now
      print('Web platform detected - using mock video service');
      _isInitialized = true;
      return true;
    }

    // TODO: Implement native mobile Agora integration
    _isInitialized = true;
    return true;
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

    if (kIsWeb) {
      // Mock join for web
      print('Mock: Joining channel $channelName with uid $uid');
      _isInChannel = true;

      // Simulate successful join after delay
      Future.delayed(const Duration(seconds: 1), () {
        onJoinChannelSuccess?.call();
      });

      // Simulate remote user joining after delay
      Future.delayed(const Duration(seconds: 2), () {
        onUserJoined?.call(2000, true);
      });

      return true;
    }

    // TODO: Implement native mobile channel joining
    return false;
  }

  Future<void> leaveChannel() async {
    if (_isInChannel) {
      print('Mock: Leaving channel');
      _isInChannel = false;
      onLeaveChannel?.call();
    }
  }

  Future<void> toggleVideo(bool enabled) async {
    print('Mock: Toggle video: $enabled');
  }

  Future<void> toggleAudio(bool enabled) async {
    print('Mock: Toggle audio: $enabled');
  }

  Future<void> switchCamera() async {
    print('Mock: Switch camera');
  }

  Future<void> enableSpeakerphone(bool enabled) async {
    print('Mock: Enable speakerphone: $enabled');
  }

  Future<void> dispose() async {
    if (_isInChannel) {
      await leaveChannel();
    }
    _isInitialized = false;
    clearEventHandlers();
  }

  bool get isInitialized => _isInitialized;
  bool get isInChannel => _isInChannel;

  // Mock engine for web compatibility
  dynamic get engine =>
      kIsWeb ? null : throw UnimplementedError('Native engine not implemented');

  void setEventHandlers({
    Function(int uid, bool isJoined)? onUserJoined,
    Function(int uid)? onUserLeft,
    Function()? onJoinChannelSuccess,
    Function()? onLeaveChannel,
  }) {
    this.onUserJoined = onUserJoined;
    this.onUserLeft = onUserLeft;
    this.onJoinChannelSuccess = onJoinChannelSuccess;
    this.onLeaveChannel = onLeaveChannel;
  }

  void clearEventHandlers() {
    onUserJoined = null;
    onUserLeft = null;
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
    required String role,
  }) async {
    try {
      // Return mock token for development
      return 'mock_agora_token_${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      print('Failed to generate token: $e');
      return null;
    }
  }
}

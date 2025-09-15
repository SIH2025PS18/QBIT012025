import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:async';
import 'dart:ui_web' as ui_web;

/// Simplified WebRTC implementation for web platform
class AgoraService extends ChangeNotifier {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  bool _isJoined = false;
  bool _isInitialized = false;
  bool _isVideoEnabled = true;
  bool _isAudioEnabled = true;
  bool _isMuted = false;
  List<int> _remoteUsers = [];
  html.MediaStream? _localStream;
  String? _currentChannelId;

  // Getters
  bool get isJoined => _isJoined;
  bool get isInitialized => _isInitialized;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isAudioEnabled => _isAudioEnabled;
  bool get isMuted => _isMuted;
  List<int> get remoteUsers => _remoteUsers;
  String? get currentChannelId => _currentChannelId;
  html.MediaStream? get localStream => _localStream;

  /// Initialize the Agora service
  Future<void> initialize({String? appId}) async {
    try {
      if (_isInitialized) return;

      debugPrint('Initializing AgoraService for web...');
      _isInitialized = true;
      notifyListeners();

      debugPrint('AgoraService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing AgoraService: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  /// Join a channel
  Future<void> joinChannel({
    required String channelId,
    required int uid,
    String? token,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      debugPrint('Joining channel: $channelId with uid: $uid');
      _currentChannelId = channelId;

      // Initialize media devices
      await _initializeMediaDevices();

      _isJoined = true;
      notifyListeners();

      debugPrint('Successfully joined channel: $channelId');

      // Simulate remote user joining after 3 seconds for demo
      Timer(const Duration(seconds: 3), () {
        if (_isJoined) {
          addRemoteUser(12345);
        }
      });
    } catch (e) {
      debugPrint('Error joining channel: $e');
      rethrow;
    }
  }

  /// Initialize media devices (camera and microphone)
  Future<void> _initializeMediaDevices() async {
    try {
      debugPrint('Initializing media devices...');

      final constraints = {
        'video': _isVideoEnabled ? {'width': 640, 'height': 480} : false,
        'audio': _isAudioEnabled,
      };

      _localStream =
          await html.window.navigator.mediaDevices!.getUserMedia(constraints);

      debugPrint('Media devices initialized successfully');
    } catch (e) {
      debugPrint('Error initializing media devices: $e');
      rethrow;
    }
  }

  /// Leave the current channel
  Future<void> leaveChannel() async {
    try {
      debugPrint('Leaving channel...');

      // Stop local stream
      if (_localStream != null) {
        _localStream!.getTracks().forEach((track) => track.stop());
        _localStream = null;
      }

      _isJoined = false;
      _currentChannelId = null;
      _remoteUsers.clear();

      notifyListeners();
      debugPrint('Left channel successfully');
    } catch (e) {
      debugPrint('Error leaving channel: $e');
      rethrow;
    }
  }

  /// Enable/disable local video
  Future<void> enableLocalVideo(bool enabled) async {
    try {
      _isVideoEnabled = enabled;

      if (_localStream != null) {
        final videoTracks = _localStream!.getVideoTracks();
        for (final track in videoTracks) {
          track.enabled = enabled;
        }
      }

      notifyListeners();
      debugPrint('Local video ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      debugPrint('Error toggling local video: $e');
    }
  }

  /// Enable/disable local audio
  Future<void> enableLocalAudio(bool enabled) async {
    try {
      _isAudioEnabled = enabled;
      _isMuted = !enabled;

      if (_localStream != null) {
        final audioTracks = _localStream!.getAudioTracks();
        for (final track in audioTracks) {
          track.enabled = enabled;
        }
      }

      notifyListeners();
      debugPrint('Local audio ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      debugPrint('Error toggling local audio: $e');
    }
  }

  /// Mute/unmute local audio
  Future<void> muteLocalAudioStream(bool muted) async {
    await enableLocalAudio(!muted);
  }

  /// Create a video view widget for local stream
  Widget createLocalVideoView() {
    if (_localStream == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.videocam_off, color: Colors.white, size: 50),
        ),
      );
    }

    final viewId = 'local-video-${DateTime.now().millisecondsSinceEpoch}';

    // Register the video element
    ui_web.platformViewRegistry.registerViewFactory(viewId, (int id) {
      final videoElement = html.VideoElement()
        ..srcObject = _localStream
        ..autoplay = true
        ..muted = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      return videoElement;
    });

    return HtmlElementView(viewType: viewId);
  }

  /// Create a video view widget for remote stream
  Widget createRemoteVideoView({int? uid}) {
    // For web demo, return a placeholder since we don't have actual remote streams
    return Container(
      color: const Color(0xFF2A2D37),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF6366F1),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Remote User',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Simulate adding a remote user (for demo purposes)
  void addRemoteUser(int uid) {
    if (!_remoteUsers.contains(uid)) {
      _remoteUsers.add(uid);
      notifyListeners();
      debugPrint('Remote user added: $uid');
    }
  }

  /// Simulate removing a remote user (for demo purposes)
  void removeRemoteUser(int uid) {
    _remoteUsers.remove(uid);
    notifyListeners();
    debugPrint('Remote user removed: $uid');
  }

  /// Dispose resources
  @override
  void dispose() {
    leaveChannel();
    super.dispose();
  }

  /// Get available video devices
  Future<List<html.MediaDeviceInfo>> getVideoDevices() async {
    try {
      final devices =
          await html.window.navigator.mediaDevices!.enumerateDevices();
      return devices
          .where((device) => device.kind == 'videoinput')
          .cast<html.MediaDeviceInfo>()
          .toList();
    } catch (e) {
      debugPrint('Error getting video devices: $e');
      return [];
    }
  }

  /// Get available audio devices
  Future<List<html.MediaDeviceInfo>> getAudioDevices() async {
    try {
      final devices =
          await html.window.navigator.mediaDevices!.enumerateDevices();
      return devices
          .where((device) => device.kind == 'audioinput')
          .cast<html.MediaDeviceInfo>()
          .toList();
    } catch (e) {
      debugPrint('Error getting audio devices: $e');
      return [];
    }
  }

  /// Switch camera (for mobile, not applicable on web)
  Future<void> switchCamera() async {
    debugPrint('Camera switching not implemented for web platform');
  }

  /// Enable/disable speaker (for mobile, not applicable on web)
  Future<void> setEnableSpeakerphone(bool enabled) async {
    debugPrint('Speaker control not implemented for web platform');
  }
}

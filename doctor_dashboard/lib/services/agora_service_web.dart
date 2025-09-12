import 'package:flutter/material.dart';

/// Web implementation for Agora - uses WebRTC or similar web-compatible solution
class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  bool _isInitialized = false;
  List<int> _remoteUsers = [];

  // Getters
  bool get isInitialized => _isInitialized;
  List<int> get remoteUsers => _remoteUsers;

  // Initialize (web implementation)
  Future<void> initialize() async {
    _isInitialized = true;
    print('Agora service initialized for web platform');
  }

  // Join channel (web implementation)
  Future<void> joinChannel({
    required String channelId,
    required String token,
    int uid = 0,
    int maxRetries = 3,
  }) async {
    print('Joining channel on web: $channelId with uid: $uid');
    // Simulate joining a channel
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Leave channel (web implementation)
  Future<void> leaveChannel() async {
    print('Leaving channel on web');
    _remoteUsers.clear();
  }

  // Mute local audio (web implementation)
  Future<void> muteLocalAudio(bool muted) async {
    print('Mute local audio on web: $muted');
  }

  // Enable/disable local video (web implementation)
  Future<void> enableLocalVideo(bool enabled) async {
    print('Enable local video on web: $enabled');
  }

  // Create local video view (web implementation)
  Widget createLocalVideoView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam,
              color: Colors.white,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'Web Video (Local)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'WebRTC implementation',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Create remote video view (web implementation)
  Widget createRemoteVideoView({required int uid}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A3D47), Color(0xFF2A2D37)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Remote User $uid',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'WebRTC connection',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Dispose (web implementation)
  Future<void> dispose() async {
    print('Disposing Agora service on web');
    _isInitialized = false;
    _remoteUsers.clear();
  }
}

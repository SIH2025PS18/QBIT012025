import 'package:flutter/material.dart';

/// Stub implementation of AgoraService for web platform
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

  bool get isJoined => _isJoined;
  bool get isInitialized => _isInitialized;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isAudioEnabled => _isAudioEnabled;
  bool get isMuted => _isMuted;
  List<int> get remoteUsers => _remoteUsers;

  Future<void> initialize([String? appId]) async {
    print('Agora Stub: Initializing with app ID: $appId');
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> joinChannel({
    required String channelId,
    required String token,
    int uid = 0,
  }) async {
    print('Agora Stub: Joining channel $channelId with UID $uid');
    _isJoined = true;
    notifyListeners();
  }

  Future<void> leaveChannel() async {
    print('Agora Stub: Leaving channel');
    _isJoined = false;
    _remoteUsers.clear();
    notifyListeners();
  }

  void toggleVideo() {
    print('Agora Stub: Toggling video');
    _isVideoEnabled = !_isVideoEnabled;
    notifyListeners();
  }

  void toggleAudio() {
    print('Agora Stub: Toggling audio');
    _isAudioEnabled = !_isAudioEnabled;
    notifyListeners();
  }

  void toggleMute() {
    print('Agora Stub: Toggling mute');
    _isMuted = !_isMuted;
    notifyListeners();
  }

  Future<void> muteLocalAudio(bool muted) async {
    print('Agora Stub: Muting local audio: $muted');
    _isMuted = muted;
    notifyListeners();
  }

  Future<void> enableLocalVideo(bool enabled) async {
    print('Agora Stub: Enabling local video: $enabled');
    _isVideoEnabled = enabled;
    notifyListeners();
  }

  Widget createLocalVideoView() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              'Local Video\n(Web Preview)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createRemoteVideoView(int uid) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade300, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              'Remote User\nUID: $uid\n(Web Preview)',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('Agora Stub: Disposing');
    super.dispose();
  }
}

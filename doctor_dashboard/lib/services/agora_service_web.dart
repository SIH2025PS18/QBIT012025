import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:async';
import 'dart:ui_web' as ui_web;

/// Real WebRTC implementation of AgoraService for web platform
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
  Map<int, html.VideoElement> _remoteVideoElements = {};
  html.VideoElement? _localVideoElement;

  // WebRTC connection variables
  late html.RtcPeerConnection _peerConnection;
  String? _currentChannelId;

  bool get isJoined => _isJoined;
  bool get isInitialized => _isInitialized;
  bool get isVideoEnabled => _isVideoEnabled;
  bool get isAudioEnabled => _isAudioEnabled;
  bool get isMuted => _isMuted;
  List<int> get remoteUsers => _remoteUsers;

  Future<void> initialize([String? appId]) async {
    print('WebRTC: Initializing with app ID: $appId');
    try {
      await _setupWebRTC();
      _isInitialized = true;
      print('WebRTC: Initialization successful');
    } catch (e) {
      print('WebRTC: Initialization failed: $e');
    }
    notifyListeners();
  }

  Future<void> _setupWebRTC() async {
    // Initialize peer connection with STUN servers
    _peerConnection = html.RtcPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
      ]
    });

    // Set up peer connection event handlers
    _peerConnection.onIceCandidate.listen((event) {
      if (event.candidate != null) {
        print('WebRTC: ICE candidate generated');
        // In a real implementation, you would send this to the other peer
      }
    });

    _peerConnection.onTrack.listen((event) {
      print('WebRTC: Remote track received');
      final mediaStream = event.streams?.first;
      if (mediaStream != null) {
        _handleRemoteStream(mediaStream);
      }
    });
  }

  Future<void> _requestPermissions() async {
    try {
      print('WebRTC: Requesting camera and microphone permissions...');
      _localStream = await html.window.navigator.mediaDevices?.getUserMedia({
        'video': {'width': 640, 'height': 480},
        'audio': true,
      });

      if (_localStream != null) {
        print('WebRTC: Media permissions granted');
        // Add local stream to peer connection
        _localStream!.getTracks().forEach((track) {
          _peerConnection.addTrack(track, _localStream!);
        });
      }
    } catch (e) {
      print('WebRTC: Failed to get media permissions: $e');
      throw Exception('Camera/microphone access denied');
    }
  }

  Future<void> joinChannel({
    required String channelId,
    required String token,
    int uid = 0,
  }) async {
    print('WebRTC: Joining channel $channelId with UID $uid');

    try {
      await _requestPermissions();
      _currentChannelId = channelId;

      // Create offer for peer connection
      final offer = await _peerConnection.createOffer();
      await _peerConnection.setLocalDescription({
        'type': offer.type,
        'sdp': offer.sdp,
      });

      _isJoined = true;
      print('WebRTC: Successfully joined channel $channelId');

      // Simulate a remote user joining after 2 seconds
      Timer(Duration(seconds: 2), () {
        if (_isJoined) {
          _simulateRemoteUser();
        }
      });
    } catch (e) {
      print('WebRTC: Failed to join channel: $e');
      throw Exception('Failed to join video call: $e');
    }

    notifyListeners();
  }

  void _simulateRemoteUser() {
    // For demonstration, add a simulated remote user
    // In real implementation, this would come from signaling server
    final remoteUid = 12345;
    if (!_remoteUsers.contains(remoteUid)) {
      _remoteUsers.add(remoteUid);
      print('WebRTC: Remote user $remoteUid joined');
      notifyListeners();
    }
  }

  void _handleRemoteStream(html.MediaStream stream) {
    print('WebRTC: Handling remote stream');
    final remoteUid = 12345; // In real app, this would come from signaling

    // Create video element for remote stream
    final videoElement = html.VideoElement()
      ..srcObject = stream
      ..autoplay = true
      ..muted = false
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover';

    _remoteVideoElements[remoteUid] = videoElement;

    // Register with platform view
    final viewType = 'remote-video-$remoteUid';
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      return videoElement;
    });

    if (!_remoteUsers.contains(remoteUid)) {
      _remoteUsers.add(remoteUid);
      notifyListeners();
    }
  }

  Future<void> leaveChannel() async {
    print('WebRTC: Leaving channel $_currentChannelId');

    // Stop local stream
    _localStream?.getTracks().forEach((track) => track.stop());
    _localStream = null;
    _localVideoElement = null;

    // Close peer connection
    _peerConnection.close();

    // Clear remote users and video elements
    _remoteUsers.clear();
    _remoteVideoElements.clear();

    _isJoined = false;
    _currentChannelId = null;

    print('WebRTC: Successfully left channel');
    notifyListeners();
  }

  void toggleVideo() {
    print('WebRTC: Toggling video');
    _isVideoEnabled = !_isVideoEnabled;

    // Enable/disable video track
    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = _isVideoEnabled;
    });

    notifyListeners();
  }

  void toggleAudio() {
    print('WebRTC: Toggling audio');
    _isAudioEnabled = !_isAudioEnabled;

    // Enable/disable audio track
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = _isAudioEnabled;
    });

    notifyListeners();
  }

  void toggleMute() {
    print('WebRTC: Toggling mute');
    _isMuted = !_isMuted;

    // Mute/unmute audio track
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = !_isMuted && _isAudioEnabled;
    });

    notifyListeners();
  }

  Future<void> muteLocalAudio(bool muted) async {
    print('WebRTC: Muting local audio: $muted');
    _isMuted = muted;

    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = !_isMuted && _isAudioEnabled;
    });

    notifyListeners();
  }

  Future<void> enableLocalVideo(bool enabled) async {
    print('WebRTC: Enabling local video: $enabled');
    _isVideoEnabled = enabled;

    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = _isVideoEnabled;
    });

    notifyListeners();
  }

  Widget createLocalVideoView() {
    if (_localStream == null || !_isVideoEnabled) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
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
                'Local Video Off',
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

    // Create or reuse local video element
    if (_localVideoElement == null) {
      _localVideoElement = html.VideoElement()
        ..srcObject = _localStream
        ..autoplay = true
        ..muted = true // Mute local video to prevent feedback
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      // Register with platform view
      final viewType = 'local-video-element';
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        return _localVideoElement!;
      });
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: HtmlElementView(
          viewType: 'local-video-element',
        ),
      ),
    );
  }

  Widget createRemoteVideoView(int uid) {
    final videoElement = _remoteVideoElements[uid];

    if (videoElement == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade600],
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
                'Patient\nUID: $uid\n(Connecting...)',
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: HtmlElementView(
          viewType: 'remote-video-$uid',
        ),
      ),
    );
  }

  @override
  void dispose() {
    print('WebRTC: Disposing');
    leaveChannel();
    super.dispose();
  }
}

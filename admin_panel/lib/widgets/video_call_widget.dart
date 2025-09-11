import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../models/video_call.dart';
import '../services/agora_service.dart';

class VideoCallWidget extends StatefulWidget {
  final VideoCallSession session;
  final bool isDoctor;
  final VoidCallback onCallEnded;

  const VideoCallWidget({
    super.key,
    required this.session,
    required this.isDoctor,
    required this.onCallEnded,
  });

  @override
  State<VideoCallWidget> createState() => _VideoCallWidgetState();
}

class _VideoCallWidgetState extends State<VideoCallWidget> {
  final AgoraVideoService _agoraService = AgoraVideoService();

  bool _localVideoEnabled = true;
  bool _localAudioEnabled = true;
  bool _remoteVideoVisible = false;
  int? _remoteUid;
  bool _isCallConnected = false;

  @override
  void initState() {
    super.initState();
    _initializeCall();
  }

  @override
  void dispose() {
    _agoraService.leaveChannel();
    super.dispose();
  }

  Future<void> _initializeCall() async {
    try {
      await _agoraService.initialize();

      // Set up event handlers
      _agoraService.setEventHandlers(
        onJoinChannelSuccess: () {
          setState(() => _isCallConnected = true);
        },
        onUserJoined: (uid, isJoined) {
          setState(() {
            _remoteUid = uid;
            _remoteVideoVisible = true;
          });
        },
        onUserLeft: (uid) {
          if (uid == _remoteUid) {
            setState(() {
              _remoteUid = null;
              _remoteVideoVisible = false;
            });
          }
        },
        onLeaveChannel: () {
          setState(() => _isCallConnected = false);
          widget.onCallEnded();
        },
      );

      // Join channel
      final uid = widget.isDoctor ? 1001 : 2001;
      await _agoraService.joinChannel(
        channelName: widget.session.channelName,
        token: widget.session.token,
        uid: uid,
        isDoctor: widget.isDoctor,
      );
    } catch (e) {
      print('Error initializing video call: $e');
    }
  }

  void _toggleVideo() {
    setState(() => _localVideoEnabled = !_localVideoEnabled);
    _agoraService.toggleVideo(_localVideoEnabled);
  }

  void _toggleAudio() {
    setState(() => _localAudioEnabled = !_localAudioEnabled);
    _agoraService.toggleAudio(_localAudioEnabled);
  }

  void _endCall() {
    _agoraService.leaveChannel();
    widget.onCallEnded();
  }

  Widget _buildLocalVideo() {
    return Container(
      width: 120,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: _localVideoEnabled
            ? AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _agoraService.engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              )
            : Container(
                color: Colors.black87,
                child: const Icon(
                  Icons.videocam_off,
                  color: Colors.white,
                  size: 40,
                ),
              ),
      ),
    );
  }

  Widget _buildRemoteVideo() {
    if (!_remoteVideoVisible || _remoteUid == null) {
      return Container(
        color: Colors.black87,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                color: Colors.white,
                size: 80,
              ),
              SizedBox(height: 16),
              Text(
                'Waiting for the other participant...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _agoraService.engine,
        canvas: VideoCanvas(uid: _remoteUid),
        connection: RtcConnection(channelId: widget.session.channelName),
      ),
    );
  }

  Widget _buildCallControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Toggle Audio
          GestureDetector(
            onTap: _toggleAudio,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _localAudioEnabled
                    ? Colors.white.withOpacity(0.2)
                    : Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _localAudioEnabled ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),

          // End Call
          GestureDetector(
            onTap: _endCall,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),

          // Toggle Video
          GestureDetector(
            onTap: _toggleVideo,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _localVideoEnabled
                    ? Colors.white.withOpacity(0.2)
                    : Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _localVideoEnabled ? Icons.videocam : Icons.videocam_off,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _isCallConnected ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isCallConnected ? Icons.circle : Icons.access_time,
                  color: Colors.white,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  _isCallConnected ? 'Connected' : 'Connecting...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            widget.isDoctor ? 'Doctor View' : 'Patient View',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Remote video (full screen)
          Positioned.fill(
            child: _buildRemoteVideo(),
          ),

          // Call info at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildCallInfo(),
          ),

          // Local video (floating)
          Positioned(
            top: 80,
            right: 16,
            child: _buildLocalVideo(),
          ),

          // Call controls at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCallControls(),
          ),
        ],
      ),
    );
  }
}

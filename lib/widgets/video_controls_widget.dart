import 'package:flutter/material.dart';

/// Widget for video call controls (mute, video, speaker, etc.)
class VideoControlsWidget extends StatelessWidget {
  final bool isMuted;
  final bool isVideoEnabled;
  final bool isSpeakerOn;
  final bool showChat;
  final bool isRecording;
  final String recordingDuration;
  final VoidCallback onMuteToggle;
  final VoidCallback onVideoToggle;
  final VoidCallback onSpeakerToggle;
  final VoidCallback onSwitchCamera;
  final VoidCallback onChatToggle;
  final VoidCallback onRecordingToggle;
  final VoidCallback onEndCall;
  final bool isDoctor;
  final bool showChatButton;
  final bool showRecordingButton;

  const VideoControlsWidget({
    Key? key,
    required this.isMuted,
    required this.isVideoEnabled,
    required this.isSpeakerOn,
    required this.showChat,
    required this.isRecording,
    required this.recordingDuration,
    required this.onMuteToggle,
    required this.onVideoToggle,
    required this.onSpeakerToggle,
    required this.onSwitchCamera,
    required this.onChatToggle,
    required this.onRecordingToggle,
    required this.onEndCall,
    required this.isDoctor,
    this.showChatButton = true,
    this.showRecordingButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recording indicator
          if (isRecording)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, color: Colors.white, size: 8),
                  const SizedBox(width: 8),
                  Text(
                    'REC $recordingDuration',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Mute/Unmute
              _buildControlButton(
                icon: isMuted ? Icons.mic_off : Icons.mic,
                label: isMuted ? 'Unmute' : 'Mute',
                onPressed: onMuteToggle,
                backgroundColor: isMuted
                    ? Colors.red
                    : Colors.white.withOpacity(0.2),
                iconColor: isMuted ? Colors.white : Colors.white,
              ),

              // Video on/off
              _buildControlButton(
                icon: isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                label: isVideoEnabled ? 'Stop Video' : 'Start Video',
                onPressed: onVideoToggle,
                backgroundColor: !isVideoEnabled
                    ? Colors.red
                    : Colors.white.withOpacity(0.2),
                iconColor: Colors.white,
              ),

              // Speaker on/off
              _buildControlButton(
                icon: isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                label: isSpeakerOn ? 'Speaker' : 'Earpiece',
                onPressed: onSpeakerToggle,
                backgroundColor: Colors.white.withOpacity(0.2),
                iconColor: Colors.white,
              ),

              // Switch camera
              _buildControlButton(
                icon: Icons.switch_camera,
                label: 'Switch',
                onPressed: onSwitchCamera,
                backgroundColor: Colors.white.withOpacity(0.2),
                iconColor: Colors.white,
              ),

              // Chat (if enabled)
              if (showChatButton)
                _buildControlButton(
                  icon: Icons.chat,
                  label: 'Chat',
                  onPressed: onChatToggle,
                  backgroundColor: showChat
                      ? Colors.blue
                      : Colors.white.withOpacity(0.2),
                  iconColor: Colors.white,
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Secondary controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Recording button (only for doctors)
              if (showRecordingButton && isDoctor)
                _buildControlButton(
                  icon: isRecording ? Icons.stop : Icons.fiber_manual_record,
                  label: isRecording ? 'Stop Recording' : 'Start Recording',
                  onPressed: onRecordingToggle,
                  backgroundColor: isRecording ? Colors.red : Colors.green,
                  iconColor: Colors.white,
                  isLarge: true,
                ),

              // End call button
              _buildControlButton(
                icon: Icons.call_end,
                label: 'End Call',
                onPressed: onEndCall,
                backgroundColor: Colors.red,
                iconColor: Colors.white,
                isLarge: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color iconColor,
    bool isLarge = false,
  }) {
    final size = isLarge ? 60.0 : 50.0;
    final iconSize = isLarge ? 28.0 : 24.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

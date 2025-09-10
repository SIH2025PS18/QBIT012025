import 'package:flutter/material.dart';

class VideoControlsWidget extends StatelessWidget {
  final bool isMuted;
  final bool isVideoEnabled;
  final bool isSpeakerOn;
  final bool showChat;
  final bool isRecording;
  final bool canRecord;
  final String? recordingDuration;
  final VoidCallback onMuteToggle;
  final VoidCallback onVideoToggle;
  final VoidCallback onSpeakerToggle;
  final VoidCallback onChatToggle;
  final VoidCallback onEndCall;
  final VoidCallback onSwitchCamera;
  final VoidCallback? onRecordingToggle;

  const VideoControlsWidget({
    Key? key,
    required this.isMuted,
    required this.isVideoEnabled,
    required this.isSpeakerOn,
    required this.showChat,
    this.isRecording = false,
    this.canRecord = false,
    this.recordingDuration,
    required this.onMuteToggle,
    required this.onVideoToggle,
    required this.onSpeakerToggle,
    required this.onChatToggle,
    required this.onEndCall,
    required this.onSwitchCamera,
    this.onRecordingToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recording status indicator
          if (isRecording && recordingDuration != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'REC $recordingDuration',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
                isActive: !isMuted,
                backgroundColor: isMuted ? Colors.red : Colors.grey[800]!,
                onTap: onMuteToggle,
              ),

              // Video On/Off
              _buildControlButton(
                icon: isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                isActive: isVideoEnabled,
                backgroundColor: !isVideoEnabled
                    ? Colors.red
                    : Colors.grey[800]!,
                onTap: onVideoToggle,
              ),

              // Switch Camera
              _buildControlButton(
                icon: Icons.switch_camera,
                isActive: true,
                backgroundColor: Colors.grey[800]!,
                onTap: onSwitchCamera,
              ),

              // Recording toggle (only if doctor can record)
              if (canRecord && onRecordingToggle != null)
                _buildControlButton(
                  icon: isRecording ? Icons.stop : Icons.fiber_manual_record,
                  isActive: isRecording,
                  backgroundColor: isRecording ? Colors.red : Colors.grey[800]!,
                  onTap: onRecordingToggle!,
                ),

              // Speaker On/Off
              _buildControlButton(
                icon: isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                isActive: isSpeakerOn,
                backgroundColor: Colors.grey[800]!,
                onTap: onSpeakerToggle,
              ),

              // Chat Toggle
              _buildControlButton(
                icon: Icons.chat,
                isActive: showChat,
                backgroundColor: showChat ? Colors.blue : Colors.grey[800]!,
                onTap: onChatToggle,
              ),

              // End Call
              _buildControlButton(
                icon: Icons.call_end,
                isActive: false,
                backgroundColor: Colors.red,
                onTap: onEndCall,
                isEndCall: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required Color backgroundColor,
    required VoidCallback onTap,
    bool isEndCall = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isEndCall ? 70 : 56,
        height: isEndCall ? 36 : 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(isEndCall ? 18 : 28),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: isEndCall ? 20 : 24),
      ),
    );
  }
}

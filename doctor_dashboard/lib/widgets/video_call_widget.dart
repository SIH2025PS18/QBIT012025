import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/video_call_provider.dart';

class VideoCallWidget extends StatefulWidget {
  final Patient patient;

  const VideoCallWidget({super.key, required this.patient});

  @override
  State<VideoCallWidget> createState() => _VideoCallWidgetState();
}

class _VideoCallWidgetState extends State<VideoCallWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1B23),
      child: Stack(
        children: [
          // Main video area (patient's video)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D37),
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildMainVideoView(),
              ),
            ),
          ),

          // Doctor's video (small overlay)
          Positioned(top: 32, right: 32, child: _buildDoctorVideoOverlay()),

          // Video call controls at bottom
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: _buildVideoControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainVideoView() {
    return Stack(
      children: [
        // Main patient video background
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3A3D47), Color(0xFF2A2D37)],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Color(0xFF6366F1),
                  child: Icon(Icons.person, size: 80, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  'Patient Video',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Connected',
                  style: TextStyle(color: Colors.green, fontSize: 14),
                ),
              ],
            ),
          ),
        ),

        // Connection status overlay
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 6),
                Text(
                  'Connected',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorVideoOverlay() {
    return Consumer<VideoCallProvider>(
      builder: (context, videoProvider, child) {
        return Container(
          width: 180,
          height: 240,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D37),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF6366F1), width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                // Doctor's video
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                    ),
                  ),
                  child: videoProvider.isVideoEnabled
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'You',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          color: Colors.black87,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.videocam_off,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Camera Off',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoControls() {
    return Consumer<VideoCallProvider>(
      builder: (context, videoProvider, child) {
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2D37).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: const Color(0xFF3A3D47), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mute/Unmute Audio
                _buildControlButton(
                  icon: videoProvider.isAudioEnabled
                      ? Icons.mic
                      : Icons.mic_off,
                  isActive: videoProvider.isAudioEnabled,
                  onPressed: () => videoProvider.toggleAudio(),
                  tooltip: videoProvider.isAudioEnabled ? 'Mute' : 'Unmute',
                ),

                const SizedBox(width: 16),

                // Video On/Off
                _buildControlButton(
                  icon: videoProvider.isVideoEnabled
                      ? Icons.videocam
                      : Icons.videocam_off,
                  isActive: videoProvider.isVideoEnabled,
                  onPressed: () => videoProvider.toggleVideo(),
                  tooltip: videoProvider.isVideoEnabled
                      ? 'Turn off camera'
                      : 'Turn on camera',
                ),

                const SizedBox(width: 16),

                // Screen Share
                _buildControlButton(
                  icon: Icons.screen_share,
                  isActive: false,
                  onPressed: () {
                    // Screen share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Screen sharing started'),
                        backgroundColor: Color(0xFF6366F1),
                      ),
                    );
                  },
                  tooltip: 'Share screen',
                ),

                const SizedBox(width: 16),

                // More options
                _buildControlButton(
                  icon: Icons.more_horiz,
                  isActive: false,
                  onPressed: () {
                    _showMoreOptions(context);
                  },
                  tooltip: 'More options',
                ),

                const SizedBox(width: 24),

                // End Call (Red button like in image)
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      videoProvider.endCall();
                    },
                    icon: const Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 24,
                    ),
                    tooltip: 'End call',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF6366F1).withValues(alpha: 0.2)
              : const Color(0xFF3A3D47),
          shape: BoxShape.circle,
          border: isActive
              ? Border.all(color: const Color(0xFF6366F1), width: 1)
              : null,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isActive ? const Color(0xFF6366F1) : Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2D37),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.volume_up, color: Color(0xFF6366F1)),
              title: const Text(
                'Speaker',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: context.read<VideoCallProvider>().isSpeakerEnabled,
                onChanged: (value) {
                  context.read<VideoCallProvider>().toggleSpeaker();
                  Navigator.pop(context);
                },
                activeColor: const Color(0xFF6366F1),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.flip_camera_ios,
                color: Color(0xFF6366F1),
              ),
              title: const Text(
                'Switch Camera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Camera switched'),
                    backgroundColor: Color(0xFF6366F1),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF6366F1)),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/video_call_provider.dart';
import '../providers/doctor_theme_provider.dart';

class VideoCallWidget extends StatefulWidget {
  final Patient patient;

  const VideoCallWidget({super.key, required this.patient});

  @override
  State<VideoCallWidget> createState() => _VideoCallWidgetState();
}

class _VideoCallWidgetState extends State<VideoCallWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          color: themeProvider.primaryBackgroundColor,
          child: Stack(
            children: [
              // Main video area (patient's video)
              // Refresh analyzer
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: themeProvider.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildMainVideoView(themeProvider),
                  ),
                ),
              ),

              // Doctor's video (small overlay)
              Positioned(
                  top: 32,
                  right: 32,
                  child: _buildDoctorVideoOverlay(themeProvider)),

              // Video call controls at bottom
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: _buildVideoControls(themeProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainVideoView(DoctorThemeProvider themeProvider) {
    return Consumer<VideoCallProvider>(
      builder: (context, videoProvider, child) {
        return Stack(
          children: [
            // Main patient video background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: themeProvider.isDarkMode
                      ? [const Color(0xFF3A3D47), const Color(0xFF2A2D37)]
                      : [Colors.grey[200]!, Colors.grey[100]!],
                ),
              ),
              child: videoProvider.remoteUsers.isNotEmpty
                  ? videoProvider.webrtcService.createRemoteVideoView()
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: themeProvider.accentColor,
                            child: const Icon(Icons.person,
                                size: 80, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Waiting for patient...',
                            style: TextStyle(
                              color: themeProvider.primaryTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDoctorVideoOverlay(DoctorThemeProvider themeProvider) {
    return Consumer<VideoCallProvider>(
      builder: (context, videoProvider, child) {
        return Container(
          width: 180,
          height: 240,
          decoration: BoxDecoration(
            color: themeProvider.cardBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: themeProvider.accentColor, width: 2),
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
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: videoProvider.webrtcService
                              .createLocalVideoView(),
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

  Widget _buildVideoControls(DoctorThemeProvider themeProvider) {
    return Consumer<VideoCallProvider>(
      builder: (context, videoProvider, child) {
        return Center(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: themeProvider.cardBackgroundColor.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: themeProvider.borderColor, width: 1),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mute/Unmute Audio
                _buildControlButton(
                  icon:
                      videoProvider.isAudioEnabled ? Icons.mic : Icons.mic_off,
                  isActive: videoProvider.isAudioEnabled,
                  onPressed: () => videoProvider.toggleAudio(),
                  tooltip: videoProvider.isAudioEnabled ? 'Mute' : 'Unmute',
                  themeProvider: themeProvider,
                ),

                const SizedBox(width: 12),

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
                  themeProvider: themeProvider,
                ),

                const SizedBox(width: 12),

                // Screen Share
                _buildControlButton(
                  icon: Icons.screen_share,
                  isActive: false,
                  onPressed: () {
                    // Screen share functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Screen sharing started'),
                        backgroundColor: themeProvider.accentColor,
                      ),
                    );
                  },
                  tooltip: 'Share screen',
                  themeProvider: themeProvider,
                ),

                const SizedBox(width: 12),

                // More options
                _buildControlButton(
                  icon: Icons.more_horiz,
                  isActive: false,
                  onPressed: () {
                    _showMoreOptions(context, themeProvider);
                  },
                  tooltip: 'More options',
                  themeProvider: themeProvider,
                ),

                const SizedBox(width: 20),

                // End Call (Red button like in image)
                Container(
                  width: 48,
                  height: 48,
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
                      size: 20,
                    ),
                    tooltip: 'End call',
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    required String tooltip,
    required DoctorThemeProvider themeProvider,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive
              ? themeProvider.accentColor.withValues(alpha: 0.2)
              : themeProvider.cardBackgroundColor,
          shape: BoxShape.circle,
          border: isActive
              ? Border.all(color: themeProvider.accentColor, width: 1)
              : null,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isActive
                ? themeProvider.accentColor
                : themeProvider.secondaryTextColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  void _showMoreOptions(
      BuildContext context, DoctorThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeProvider.cardBackgroundColor,
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

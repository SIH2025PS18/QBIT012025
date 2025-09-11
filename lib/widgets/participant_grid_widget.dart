import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' hide VideoLayout;

import '../services/agora_service.dart';
import '../models/video_consultation.dart';

/// Widget that displays video participants in a grid layout
class ParticipantGridWidget extends StatefulWidget {
  final AgoraService agoraService;
  final List<int> remoteUsers;
  final bool showLocalVideo;
  final String? currentUserId;
  final VideoConsultation? consultation;

  const ParticipantGridWidget({
    Key? key,
    required this.agoraService,
    required this.remoteUsers,
    this.showLocalVideo = true,
    this.currentUserId,
    this.consultation,
  }) : super(key: key);

  @override
  State<ParticipantGridWidget> createState() => _ParticipantGridWidgetState();
}

class _ParticipantGridWidgetState extends State<ParticipantGridWidget> {
  VideoLayout _currentLayout = VideoLayout.grid;
  Map<int, VideoStreamType> _userStreamTypes = {};

  @override
  void initState() {
    super.initState();
    // Optimize for multi-participant calls
    widget.agoraService.optimizeForMultiParticipant();
  }

  @override
  Widget build(BuildContext context) {
    final allParticipants = <Widget>[];

    // Add local video if enabled
    if (widget.showLocalVideo) {
      allParticipants.add(_buildLocalVideoView());
    }

    // Add remote videos
    for (final uid in widget.remoteUsers) {
      allParticipants.add(_buildRemoteVideoView(uid));
    }

    if (allParticipants.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Layout toggle buttons
        _buildLayoutControls(),

        // Video grid
        Expanded(child: _buildVideoLayout(allParticipants)),
      ],
    );
  }

  Widget _buildLayoutControls() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLayoutButton(
            icon: Icons.grid_view,
            label: 'Grid',
            isSelected: _currentLayout == VideoLayout.grid,
            onPressed: () => _setLayout(VideoLayout.grid),
          ),
          const SizedBox(width: 8),
          _buildLayoutButton(
            icon: Icons.person,
            label: 'Speaker',
            isSelected: _currentLayout == VideoLayout.speaker,
            onPressed: () => _setLayout(VideoLayout.speaker),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoLayout(List<Widget> participants) {
    switch (_currentLayout) {
      case VideoLayout.grid:
        return _buildGridLayout(participants);
      case VideoLayout.speaker:
        return _buildSpeakerLayout(participants);
      default:
        return _buildGridLayout(participants);
    }
  }

  Widget _buildGridLayout(List<Widget> participants) {
    final participantCount = participants.length;

    if (participantCount == 1) {
      return participants[0];
    } else if (participantCount == 2) {
      return Column(
        children: [
          Expanded(child: participants[0]),
          Expanded(child: participants[1]),
        ],
      );
    } else if (participantCount <= 4) {
      return GridView.count(crossAxisCount: 2, children: participants);
    } else {
      return GridView.count(crossAxisCount: 3, children: participants);
    }
  }

  Widget _buildSpeakerLayout(List<Widget> participants) {
    if (participants.length <= 1) {
      return participants.isNotEmpty ? participants[0] : _buildEmptyState();
    }

    return Column(
      children: [
        // Main speaker view (first participant)
        Expanded(flex: 3, child: participants[0]),

        // Thumbnail views for other participants
        if (participants.length > 1)
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: participants.length - 1,
              itemBuilder: (context, index) {
                return Container(
                  width: 90,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: participants[index + 1],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildLocalVideoView() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: widget.agoraService.createLocalVideoView(),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.agoraService.isMuted ? Icons.mic_off : Icons.mic,
                    color: widget.agoraService.isMuted
                        ? Colors.red
                        : Colors.white,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'You',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemoteVideoView(int uid) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: widget.agoraService.createRemoteVideoView(uid),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: Colors.white, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    'User $uid',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Video quality indicator
          Positioned(top: 8, right: 8, child: _buildQualityIndicator(uid)),

          // Connection status indicator
          Positioned(top: 8, left: 8, child: _buildConnectionIndicator(uid)),
        ],
      ),
    );
  }

  Widget _buildQualityIndicator(int uid) {
    final streamType = _userStreamTypes[uid] ?? VideoStreamType.videoStreamHigh;
    final isHighQuality = streamType == VideoStreamType.videoStreamHigh;

    return GestureDetector(
      onTap: () => _toggleVideoQuality(uid),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isHighQuality ? Icons.hd : Icons.sd,
              color: isHighQuality ? Colors.green : Colors.orange,
              size: 12,
            ),
            const SizedBox(width: 2),
            Text(
              isHighQuality ? 'HD' : 'SD',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionIndicator(int uid) {
    // In a real implementation, you'd track connection quality
    // For now, we'll show a static good connection
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 2),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 2),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No participants',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Waiting for others to join...',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _setLayout(VideoLayout layout) {
    setState(() {
      _currentLayout = layout;
    });

    // Apply layout optimization to Agora service
    widget.agoraService.setVideoLayout(layout);
  }

  void _toggleVideoQuality(int uid) {
    // Toggle between high and low quality for bandwidth optimization
    final currentStreamType =
        _userStreamTypes[uid] ?? VideoStreamType.videoStreamHigh;
    final newStreamType = currentStreamType == VideoStreamType.videoStreamHigh
        ? VideoStreamType.videoStreamLow
        : VideoStreamType.videoStreamHigh;

    setState(() {
      _userStreamTypes[uid] = newStreamType;
    });

    widget.agoraService.setRemoteVideoStreamType(uid, newStreamType);
  }
}

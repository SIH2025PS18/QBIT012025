import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '../models/video_consultation.dart';
import '../services/agora_service.dart';

class AgoraVideoGridWidget extends StatelessWidget {
  final AgoraService agoraService;
  final VideoConsultation consultation;
  final String currentUserId;

  const AgoraVideoGridWidget({
    Key? key,
    required this.agoraService,
    required this.consultation,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: _buildVideoLayout(),
    );
  }

  Widget _buildVideoLayout() {
    final remoteUsers = agoraService.remoteUsers;

    if (remoteUsers.isEmpty) {
      // Only local user - full screen local video
      return _buildSingleUserView();
    } else if (remoteUsers.length == 1) {
      // One remote user - split screen with local video as small overlay
      return _buildTwoUserView(remoteUsers.first);
    } else {
      // Multiple users - grid layout
      return _buildMultiUserGrid(remoteUsers);
    }
  }

  Widget _buildSingleUserView() {
    return Stack(
      children: [
        // Full screen local video
        SizedBox.expand(
          child: agoraService.createLocalVideoView(),
        ),
        
        // Waiting message
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 12),
                Text(
                  'Waiting for other participants...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTwoUserView(int remoteUid) {
    return Stack(
      children: [
        // Remote user - full screen
        SizedBox.expand(
          child: agoraService.createRemoteVideoView(remoteUid),
        ),
        
        // Local user - small overlay
        Positioned(
          top: 50,
          right: 16,
          width: 120,
          height: 160,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: agoraService.createLocalVideoView(),
            ),
          ),
        ),
        
        // User info overlays
        _buildUserInfoOverlay(remoteUid, isLocal: false),
        _buildLocalUserInfoOverlay(),
      ],
    );
  }

  Widget _buildMultiUserGrid(List<int> remoteUsers) {
    final allUsers = [0, ...remoteUsers]; // 0 represents local user
    final itemCount = allUsers.length;
    
    int crossAxisCount;
    if (itemCount <= 2) {
      crossAxisCount = 1;
    } else if (itemCount <= 4) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 3;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 16 / 9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final uid = allUsers[index];
        return _buildVideoTile(uid, isLocal: uid == 0);
      },
    );
  }

  Widget _buildVideoTile(int uid, {required bool isLocal}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: isLocal 
            ? Border.all(color: Colors.blue, width: 2)
            : Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: Stack(
        children: [
          // Video view
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: SizedBox.expand(
              child: isLocal
                  ? agoraService.createLocalVideoView()
                  : agoraService.createRemoteVideoView(uid),
            ),
          ),
          
          // User info
          _buildUserInfoOverlay(uid, isLocal: isLocal),
        ],
      ),
    );
  }

  Widget _buildUserInfoOverlay(int uid, {required bool isLocal}) {
    String userName;
    bool isMuted;
    bool isVideoEnabled;

    if (isLocal) {
      userName = 'You';
      isMuted = agoraService.isMuted;
      isVideoEnabled = agoraService.isVideoEnabled;
    } else {
      // For remote users, you might need to track their states
      // For now, using placeholder values
      userName = uid == int.parse(consultation.doctorId.hashCode.toString().substring(0, 6)) 
          ? consultation.doctorName 
          : consultation.patientName;
      isMuted = false; // You'd track this from remote user state
      isVideoEnabled = true; // You'd track this from remote user state
    }

    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Microphone status
            Icon(
              isMuted ? Icons.mic_off : Icons.mic,
              size: 14,
              color: isMuted ? Colors.red : Colors.green,
            ),
            
            const SizedBox(width: 6),
            
            // User name
            Expanded(
              child: Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Video status
            if (!isVideoEnabled)
              const Icon(
                Icons.videocam_off,
                size: 14,
                color: Colors.red,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalUserInfoOverlay() {
    return Positioned(
      top: 180, // Below the local video overlay
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              agoraService.isMuted ? Icons.mic_off : Icons.mic,
              size: 12,
              color: agoraService.isMuted ? Colors.red : Colors.green,
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
    );
  }
}
import 'package:flutter/material.dart';

class ParticipantPreviewWidget extends StatelessWidget {
  final bool isVideoEnabled;
  final bool isMuted;
  final String participantName;
  final String? avatarUrl;

  const ParticipantPreviewWidget({
    Key? key,
    required this.isVideoEnabled,
    required this.isMuted,
    required this.participantName,
    this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[800],
      ),
      child: Stack(
        children: [
          // Video preview or avatar
          Center(
            child: isVideoEnabled
                ? _buildVideoPreview()
                : _buildAvatarView(),
          ),
          
          // Controls overlay
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Participant name
                  Expanded(
                    child: Text(
                      participantName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // Status indicators
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Microphone status
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isMuted ? Colors.red : Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isMuted ? Icons.mic_off : Icons.mic,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Video status
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isVideoEnabled ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    // This would show the actual camera preview
    // For demo purposes, showing a placeholder with camera icon
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.3),
            Colors.green.withOpacity(0.3),
          ],
        ),
      ),
      child: const Stack(
        children: [
          // Placeholder for actual video feed
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.videocam,
                  size: 48,
                  color: Colors.white70,
                ),
                SizedBox(height: 8),
                Text(
                  'Camera Preview',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[700],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 48,
            backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                ? NetworkImage(avatarUrl!)
                : null,
            backgroundColor: Colors.grey[600],
            child: avatarUrl == null || avatarUrl!.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.white,
                  )
                : null,
          ),
          
          const SizedBox(height: 16),
          
          // Name
          Text(
            participantName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Video disabled message
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.videocam_off,
                  size: 16,
                  color: Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  'Video Off',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/video_consultation.dart';
import '../services/agora_service.dart';

class ParticipantGridWidget extends StatelessWidget {
  final VideoConsultation consultation;
  final bool isVideoEnabled;
  final String currentUserId;
  final AgoraService? agoraService;
  final Function(ConsultationParticipant)? onParticipantTap;

  const ParticipantGridWidget({
    Key? key,
    required this.consultation,
    required this.isVideoEnabled,
    required this.currentUserId,
    this.agoraService,
    this.onParticipantTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final participants = consultation.participants;

    // If no participants, show placeholder
    if (participants.isEmpty) {
      return _buildPlaceholderGrid();
    }

    // Single participant - full screen
    if (participants.length == 1) {
      return _buildSingleParticipant(participants.first);
    }

    // Multiple participants - smart grid layout
    return _buildSmartGrid(participants);
  }

  Widget _buildSmartGrid(List<ConsultationParticipant> participants) {
    final participantCount = participants.length;

    // 2 participants - side by side
    if (participantCount == 2) {
      return Row(
        children: participants
            .map((p) => Expanded(child: _buildParticipantTile(p, true)))
            .toList(),
      );
    }

    // 3-4 participants - 2x2 grid
    if (participantCount <= 4) {
      return _build2x2Grid(participants);
    }

    // 5-6 participants - 2x3 grid
    if (participantCount <= 6) {
      return _build2x3Grid(participants);
    }

    // 7-9 participants - 3x3 grid
    if (participantCount <= 9) {
      return _build3x3Grid(participants);
    }

    // More than 9 - scrollable grid with speaker view
    return _buildScrollableGrid(participants);
  }

  Widget _build2x2Grid(List<ConsultationParticipant> participants) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              if (participants.isNotEmpty)
                Expanded(child: _buildParticipantTile(participants[0], true)),
              if (participants.length > 1)
                Expanded(child: _buildParticipantTile(participants[1], true)),
            ],
          ),
        ),
        if (participants.length > 2)
          Expanded(
            child: Row(
              children: [
                if (participants.length > 2)
                  Expanded(child: _buildParticipantTile(participants[2], true)),
                if (participants.length > 3)
                  Expanded(child: _buildParticipantTile(participants[3], true)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _build2x3Grid(List<ConsultationParticipant> participants) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: participants
                .take(3)
                .map((p) => Expanded(child: _buildParticipantTile(p, false)))
                .toList(),
          ),
        ),
        Expanded(
          child: Row(
            children: participants
                .skip(3)
                .take(3)
                .map((p) => Expanded(child: _buildParticipantTile(p, false)))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _build3x3Grid(List<ConsultationParticipant> participants) {
    return Column(
      children: List.generate(3, (row) {
        final startIndex = row * 3;
        final rowParticipants = participants.skip(startIndex).take(3).toList();

        return Expanded(
          child: Row(
            children: rowParticipants
                .map((p) => Expanded(child: _buildParticipantTile(p, false)))
                .toList(),
          ),
        );
      }),
    );
  }

  Widget _buildScrollableGrid(List<ConsultationParticipant> participants) {
    // Show main speaker and scrollable thumbnails
    final mainParticipant = participants.first;
    final otherParticipants = participants.skip(1).toList();

    return Column(
      children: [
        // Main speaker view (75% of height)
        Expanded(flex: 3, child: _buildParticipantTile(mainParticipant, true)),

        // Scrollable thumbnail strip (25% of height)
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.black54,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: otherParticipants.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 120,
                  child: _buildParticipantTile(otherParticipants[index], false),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantTile(
    ConsultationParticipant participant,
    bool isLarge,
  ) {
    return GestureDetector(
      onTap: () => onParticipantTap?.call(participant),
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          border: Border.all(
            color: participant.isConnected ? Colors.green : Colors.red,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Video or avatar
            Center(
              child: participant.isVideoEnabled && participant.isConnected
                  ? _buildVideoView(participant)
                  : _buildAvatarView(participant),
            ),

            // Connection status indicator
            if (!participant.isConnected)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, color: Colors.white, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Reconnecting...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

            // Participant info overlay
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!participant.isMuted)
                      Icon(
                        Icons.mic,
                        size: isLarge ? 16 : 12,
                        color: Colors.white,
                      )
                    else
                      Icon(
                        Icons.mic_off,
                        size: isLarge ? 16 : 12,
                        color: Colors.red,
                      ),
                    const SizedBox(width: 4),
                    Text(
                      participant.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLarge ? 12 : 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Role indicator
            if (participant.role == ParticipantRole.doctor)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Dr.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isLarge ? 10 : 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderGrid() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 60, color: Colors.white54),
            ),
            const SizedBox(height: 16),
            const Text(
              'Waiting for participants...',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleParticipant(ConsultationParticipant participant) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // Video or avatar
          Center(
            child: participant.isVideoEnabled
                ? _buildVideoView(participant)
                : _buildAvatarView(participant),
          ),

          // Participant info overlay
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!participant.isMuted)
                    const Icon(Icons.mic, size: 16, color: Colors.green)
                  else
                    const Icon(Icons.mic_off, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    participant.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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

  Widget _buildVideoView(ConsultationParticipant participant) {
    if (agoraService != null) {
      // Get the participant's UID for Agora video view
      // This would need to be mapped from participant ID to Agora UID
      final uid = int.tryParse(participant.userId) ?? 0;

      if (uid == 0) {
        // Local user video
        return agoraService!.createLocalVideoView();
      } else {
        // Remote user video
        return agoraService!.createRemoteVideoView(uid);
      }
    }

    // Fallback placeholder
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.3),
            Colors.purple.withOpacity(0.3),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.videocam, size: 40, color: Colors.white70),
      ),
    );
  }

  Widget _buildAvatarView(ConsultationParticipant participant) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[800],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: participant.avatarUrl != null
                ? NetworkImage(participant.avatarUrl!)
                : null,
            backgroundColor: Colors.grey[600],
            child: participant.avatarUrl == null
                ? const Icon(Icons.person, size: 40, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            participant.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

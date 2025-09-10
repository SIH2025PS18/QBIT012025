import 'package:flutter/material.dart';
import '../models/video_consultation.dart';

class ConsultationCard extends StatelessWidget {
  final VideoConsultation consultation;
  final bool isDoctor;
  final VoidCallback? onTap;
  final bool showHistory;

  const ConsultationCard({
    Key? key,
    required this.consultation,
    required this.isDoctor,
    this.onTap,
    this.showHistory = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: _getAvatarImage(),
                    backgroundColor: Colors.grey[300],
                    child: _getAvatarImage() == null
                        ? Icon(
                            Icons.person,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  // Name and info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDoctor
                              ? consultation.patientName
                              : consultation.doctorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getSubtitle(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status indicator
                  _buildStatusChip(),
                ],
              ),
              if (showHistory) ...[
                const SizedBox(height: 12),
                _buildHistoryDetails(),
              ] else ...[
                const SizedBox(height: 12),
                _buildActiveDetails(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _getAvatarImage() {
    final avatarUrl =
        isDoctor ? consultation.patientAvatarUrl : consultation.doctorAvatarUrl;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      return NetworkImage(avatarUrl);
    }
    return null;
  }

  String _getSubtitle() {
    if (showHistory) {
      return _formatDateTime(consultation.endedAt ?? consultation.updatedAt);
    } else {
      return _formatDateTime(consultation.scheduledAt);
    }
  }

  Widget _buildStatusChip() {
    final status = consultation.status;
    Color color;
    String text;

    switch (status) {
      case ConsultationStatus.scheduled:
        color = Colors.blue;
        text = 'Scheduled';
        break;
      case ConsultationStatus.inQueue:
        color = Colors.orange;
        text = 'In Queue';
        break;
      case ConsultationStatus.waitingRoom:
        color = Colors.yellow[700]!;
        text = 'Waiting';
        break;
      case ConsultationStatus.inProgress:
        color = Colors.green;
        text = 'Active';
        break;
      case ConsultationStatus.completed:
        color = Colors.grey;
        text = 'Completed';
        break;
      case ConsultationStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
      case ConsultationStatus.noShow:
        color = Colors.red[800]!;
        text = 'No Show';
        break;
      case ConsultationStatus.reconnecting:
        color = Colors.amber;
        text = 'Reconnecting';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActiveDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (consultation.queuePosition != null)
          Row(
            children: [
              Icon(Icons.queue, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Position: #${consultation.queuePosition!.position}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                'Est. ${_formatDuration(consultation.queuePosition!.estimatedWaitTime)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        if (consultation.status == ConsultationStatus.inProgress) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                'Started: ${_formatTime(consultation.startedAt!)}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildHistoryDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (consultation.duration != null)
          Row(
            children: [
              Icon(Icons.timer, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Duration: ${_formatDuration(consultation.duration!)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        if (consultation.rating != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                'Rating: ${_getRatingText(consultation.rating!)}/5',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
        if (consultation.prescription != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.medication, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              const Text(
                'Prescription available',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  String _getRatingText(ConsultationRating rating) {
    switch (rating) {
      case ConsultationRating.poor:
        return '1';
      case ConsultationRating.fair:
        return '2';
      case ConsultationRating.good:
        return '4';
      case ConsultationRating.excellent:
        return '5';
    }
  }
}

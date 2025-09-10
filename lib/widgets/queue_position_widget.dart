import 'package:flutter/material.dart';
import '../models/video_consultation.dart';

class QueuePositionWidget extends StatelessWidget {
  final QueuePosition queuePosition;
  final VideoConsultation consultation;

  const QueuePositionWidget({
    Key? key,
    required this.queuePosition,
    required this.consultation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getPriorityColor(queuePosition.priority).withOpacity(0.1),
              _getPriorityColor(queuePosition.priority).withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            // Queue position number
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getPriorityColor(queuePosition.priority),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _getPriorityColor(queuePosition.priority)
                        .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${queuePosition.position}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Position text
            Text(
              queuePosition.position == 1 
                  ? 'You\'re next!'
                  : 'Your position in queue',
              style: TextStyle(
                fontSize: queuePosition.position == 1 ? 18 : 16,
                fontWeight: queuePosition.position == 1 
                    ? FontWeight.bold 
                    : FontWeight.w500,
                color: queuePosition.position == 1 
                    ? _getPriorityColor(queuePosition.priority)
                    : Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Queue stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  icon: Icons.people,
                  label: 'Total in Queue',
                  value: '${queuePosition.totalInQueue}',
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                _buildStatItem(
                  icon: Icons.schedule,
                  label: 'Est. Wait Time',
                  value: _formatDuration(queuePosition.estimatedWaitTime),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Priority indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getPriorityColor(queuePosition.priority)
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getPriorityColor(queuePosition.priority),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getPriorityIcon(queuePosition.priority),
                    size: 16,
                    color: _getPriorityColor(queuePosition.priority),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${queuePosition.priority.displayName} Priority',
                    style: TextStyle(
                      color: _getPriorityColor(queuePosition.priority),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            if (queuePosition.position <= 3) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.notifications_active,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        queuePosition.position == 1
                            ? 'Get ready! Your consultation will start soon.'
                            : 'Please stay nearby. Your turn is coming up!',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getPriorityColor(QueuePriority priority) {
    switch (priority) {
      case QueuePriority.emergency:
        return Colors.red;
      case QueuePriority.urgent:
        return Colors.orange;
      case QueuePriority.high:
        return Colors.amber;
      case QueuePriority.normal:
        return Colors.blue;
      case QueuePriority.low:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(QueuePriority priority) {
    switch (priority) {
      case QueuePriority.emergency:
        return Icons.emergency;
      case QueuePriority.urgent:
        return Icons.priority_high;
      case QueuePriority.high:
        return Icons.keyboard_arrow_up;
      case QueuePriority.normal:
        return Icons.horizontal_rule;
      case QueuePriority.low:
        return Icons.keyboard_arrow_down;
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return 'Soon';
    }
  }
}
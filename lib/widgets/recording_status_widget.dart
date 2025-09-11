import 'package:flutter/material.dart';

/// Widget to display recording status with duration
class RecordingStatusWidget extends StatefulWidget {
  final bool isRecording;
  final String duration;
  final bool showStopButton;
  final VoidCallback? onStop;

  const RecordingStatusWidget({
    Key? key,
    required this.isRecording,
    required this.duration,
    this.showStopButton = false,
    this.onStop,
  }) : super(key: key);

  @override
  State<RecordingStatusWidget> createState() => _RecordingStatusWidgetState();
}

class _RecordingStatusWidgetState extends State<RecordingStatusWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isRecording) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(RecordingStatusWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isRecording) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing record dot
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 8),

          // Recording text and duration
          Text(
            'REC ${widget.duration}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Stop button (optional)
          if (widget.showStopButton && widget.onStop != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: widget.onStop,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.stop, color: Colors.white, size: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Larger recording status widget for more prominent display
class RecordingStatusBanner extends StatelessWidget {
  final bool isRecording;
  final String duration;
  final String? fileName;
  final VoidCallback? onStop;
  final VoidCallback? onPause;
  final bool isPaused;

  const RecordingStatusBanner({
    Key? key,
    required this.isRecording,
    required this.duration,
    this.fileName,
    this.onStop,
    this.onPause,
    this.isPaused = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isRecording) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade600, Colors.red.shade500],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Recording indicator
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isPaused ? Colors.yellow : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 12),

              // Recording info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPaused ? 'Recording Paused' : 'Recording in Progress',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (fileName != null)
                      Text(
                        fileName!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),

              // Duration
              Text(
                duration,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),

          // Control buttons
          if (onPause != null || onStop != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onPause != null)
                  _buildActionButton(
                    icon: isPaused ? Icons.play_arrow : Icons.pause,
                    label: isPaused ? 'Resume' : 'Pause',
                    onPressed: onPause!,
                  ),

                if (onPause != null && onStop != null)
                  const SizedBox(width: 16),

                if (onStop != null)
                  _buildActionButton(
                    icon: Icons.stop,
                    label: 'Stop',
                    onPressed: onStop!,
                    isDestructive: true,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.shade700
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

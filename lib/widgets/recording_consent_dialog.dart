import 'package:flutter/material.dart';

/// Dialog for obtaining consent for call recording
class RecordingConsentDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final String patientName;
  final String doctorName;

  const RecordingConsentDialog({
    Key? key,
    required this.onAccept,
    required this.onDecline,
    required this.patientName,
    required this.doctorName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.fiber_manual_record, color: Colors.red),
          ),
          const SizedBox(width: 12),
          const Text('Recording Consent'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dr. $doctorName would like to record this consultation for medical and quality purposes.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recording Information:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Recording will include audio and video',
                  style: TextStyle(fontSize: 13),
                ),
                const Text(
                  '• Used for medical documentation',
                  style: TextStyle(fontSize: 13),
                ),
                const Text(
                  '• Stored securely and confidentially',
                  style: TextStyle(fontSize: 13),
                ),
                const Text(
                  '• You can request deletion anytime',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Do you consent to this consultation being recorded?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.all(16),
      actions: [
        TextButton(
          onPressed: onDecline,
          style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
          child: const Text('Decline'),
        ),
        ElevatedButton(
          onPressed: onAccept,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Accept & Start Recording'),
        ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String patientName,
    required String doctorName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => RecordingConsentDialog(
        patientName: patientName,
        doctorName: doctorName,
        onAccept: () => Navigator.of(context).pop(true),
        onDecline: () => Navigator.of(context).pop(false),
      ),
    );
  }
}

/// Widget to show recording status
class RecordingStatusWidget extends StatelessWidget {
  final bool isRecording;
  final String duration;
  final VoidCallback? onStop;

  const RecordingStatusWidget({
    Key? key,
    required this.isRecording,
    required this.duration,
    this.onStop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isRecording) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'REC $duration',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onStop != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onStop,
              child: const Icon(Icons.stop, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }
}

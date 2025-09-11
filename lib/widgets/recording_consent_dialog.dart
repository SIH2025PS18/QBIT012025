import 'package:flutter/material.dart';

/// Dialog for getting patient consent before recording consultation
class RecordingConsentDialog extends StatefulWidget {
  final String patientName;
  final String doctorName;

  const RecordingConsentDialog({
    Key? key,
    required this.patientName,
    required this.doctorName,
  }) : super(key: key);

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
      ),
    );
  }

  @override
  State<RecordingConsentDialog> createState() => _RecordingConsentDialogState();
}

class _RecordingConsentDialogState extends State<RecordingConsentDialog> {
  bool _consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.videocam, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          const Text('Recording Consent'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dr. ${widget.doctorName} would like to record this consultation for medical and quality purposes.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recording Details:',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Patient:', widget.patientName),
                _buildInfoRow('Doctor:', 'Dr. ${widget.doctorName}'),
                _buildInfoRow(
                  'Purpose:',
                  'Medical consultation and quality assurance',
                ),
                _buildInfoRow('Storage:', 'Secure encrypted storage'),
                _buildInfoRow('Access:', 'Limited to healthcare team'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _consentGiven,
                onChanged: (value) {
                  setState(() {
                    _consentGiven = value ?? false;
                  });
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _consentGiven = !_consentGiven;
                    });
                  },
                  child: Text(
                    'I consent to this consultation being recorded.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'You can request deletion of this recording at any time by contacting your healthcare provider.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Decline'),
        ),
        ElevatedButton(
          onPressed: _consentGiven
              ? () => Navigator.of(context).pop(true)
              : null,
          child: const Text('Allow Recording'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

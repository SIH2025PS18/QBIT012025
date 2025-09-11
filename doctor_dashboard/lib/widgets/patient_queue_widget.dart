import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/doctor_provider.dart';
import '../providers/video_call_provider.dart';
import '../models/models.dart';

class PatientQueueWidget extends StatelessWidget {
  const PatientQueueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1B23),
        border: Border(right: BorderSide(color: Color(0xFF3A3D47), width: 1)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Queue list
          Expanded(child: _buildQueueList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2D37),
        border: Border(bottom: BorderSide(color: Color(0xFF3A3D47), width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: Color(0xFF6366F1), size: 24),
              const SizedBox(width: 12),
              const Text(
                'Patient Queue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Consumer<DoctorProvider>(
                builder: (context, provider, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${provider.waitingPatientsCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Patients waiting for consultation',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueList() {
    return Consumer<DoctorProvider>(
      builder: (context, doctorProvider, child) {
        final patients = doctorProvider.patientQueue;

        if (patients.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: patients.length,
          itemBuilder: (context, index) {
            final patient = patients[index];
            return _buildPatientCard(context, patient, index + 1);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No patients in queue',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Patients will appear here when they join',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(
    BuildContext context,
    Patient patient,
    int position,
  ) {
    final isNext = position == 1;
    final timeUntilAppointment = patient.appointmentTime.difference(
      DateTime.now(),
    );
    final isOverdue = timeUntilAppointment.isNegative;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isNext
            ? const Color(0xFF6366F1).withValues(alpha: 0.1)
            : const Color(0xFF2A2D37),
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Position and status indicator
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isNext
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF3A3D47),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      position.toString(),
                      style: TextStyle(
                        color: isNext ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${patient.age} years • ${patient.gender}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? Colors.red.withValues(alpha: 0.2)
                        : isNext
                        ? const Color(0xFF10B981).withValues(alpha: 0.2)
                        : const Color(0xFF3A3D47),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isOverdue
                        ? 'Overdue'
                        : isNext
                        ? 'Next'
                        : 'Waiting',
                    style: TextStyle(
                      color: isOverdue
                          ? Colors.red
                          : isNext
                          ? const Color(0xFF10B981)
                          : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Patient details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3D47).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatAppointmentTime(patient.appointmentTime),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.medical_information,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          patient.symptoms,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                if (isNext) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _startCall(context, patient),
                      icon: const Icon(Icons.video_call, size: 16),
                      label: const Text('Start Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewPatientDetails(context, patient),
                    icon: const Icon(Icons.person, size: 16),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: const BorderSide(color: Color(0xFF3A3D47)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: () => _showPatientOptions(context, patient),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatAppointmentTime(DateTime appointmentTime) {
    final now = DateTime.now();
    final difference = appointmentTime.difference(now);

    if (difference.isNegative) {
      final overdue = difference.abs();
      if (overdue.inHours > 0) {
        return 'Overdue by ${overdue.inHours}h ${overdue.inMinutes % 60}m';
      } else {
        return 'Overdue by ${overdue.inMinutes}m';
      }
    } else {
      if (difference.inHours > 0) {
        return 'In ${difference.inHours}h ${difference.inMinutes % 60}m';
      } else {
        return 'In ${difference.inMinutes}m';
      }
    }
  }

  void _startCall(BuildContext context, Patient patient) {
    final videoCallProvider = context.read<VideoCallProvider>();
    final doctorProvider = context.read<DoctorProvider>();

    // Start the video call
    videoCallProvider.startCall(patient);

    // Remove patient from queue
    doctorProvider.removePatientFromQueue(patient.id);

    // Increment today's calls count
    doctorProvider.incrementTodaysCallsCount();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting video call with ${patient.name}'),
        backgroundColor: const Color(0xFF6366F1),
      ),
    );
  }

  void _viewPatientDetails(BuildContext context, Patient patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2D37),
          title: Row(
            children: [
              Text(patient.name, style: const TextStyle(color: Colors.white)),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.grey),
              ),
            ],
          ),
          content: Container(
            width: 500,
            height: 600,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Info Section
                  _buildDetailSection('Basic Information', [
                    _buildDetailRow('Age', '${patient.age} years'),
                    _buildDetailRow('Gender', patient.gender),
                    _buildDetailRow('Phone', patient.phone),
                    _buildDetailRow('Email', patient.email),
                    _buildDetailRow('Current Symptoms', patient.symptoms),
                  ]),

                  const SizedBox(height: 20),

                  // Medical History Section
                  _buildDetailSection('Medical History', [
                    if (patient.medicalHistory.isNotEmpty)
                      ...patient.medicalHistory
                          .map(
                            (history) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3D47),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                history,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList()
                    else
                      const Text(
                        'No medical history available',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ]),

                  const SizedBox(height: 20),

                  // Attachments Section
                  _buildDetailSection('Patient Records & Attachments', [
                    if (patient.attachments.isNotEmpty)
                      ...patient.attachments
                          .map(
                            (attachment) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(
                                  _getFileIcon(attachment),
                                  color: const Color(0xFF6366F1),
                                ),
                                title: Text(
                                  _getFileName(attachment),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  _getFileType(attachment),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: IconButton(
                                  onPressed: () =>
                                      _viewAttachment(context, attachment),
                                  icon: const Icon(
                                    Icons.visibility,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                                tileColor: const Color(0xFF3A3D47),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          )
                          .toList()
                    else
                      const Text(
                        'No attachments available',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ]),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startCall(context, patient);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
              ),
              child: const Text('Start Consultation'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6366F1),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  IconData _getFileIcon(String attachment) {
    final extension = attachment.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.attach_file;
    }
  }

  String _getFileName(String attachment) {
    return attachment.split('/').last;
  }

  String _getFileType(String attachment) {
    final extension = attachment.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'PDF Document';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return 'Image';
      case 'doc':
      case 'docx':
        return 'Word Document';
      default:
        return 'File';
    }
  }

  void _viewAttachment(BuildContext context, String attachmentUrl) {
    // For now, show a dialog with the attachment URL
    // In production, this would open the file viewer
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2D37),
        title: const Text(
          'View Attachment',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Attachment URL:', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            SelectableText(
              attachmentUrl,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPatientOptions(BuildContext context, Patient patient) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2D37),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                patient.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              _buildOptionTile(
                icon: Icons.schedule,
                title: 'Reschedule',
                onTap: () {
                  Navigator.pop(context);
                  // Handle reschedule
                },
              ),

              _buildOptionTile(
                icon: Icons.message,
                title: 'Send Message',
                onTap: () {
                  Navigator.pop(context);
                  // Handle send message
                },
              ),

              _buildOptionTile(
                icon: Icons.cancel,
                title: 'Cancel Appointment',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  _cancelAppointment(context, patient);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : const Color(0xFF6366F1),
      ),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.red : Colors.white),
      ),
      onTap: onTap,
    );
  }

  void _cancelAppointment(BuildContext context, Patient patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2D37),
          title: const Text(
            'Cancel Appointment',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to cancel the appointment with ${patient.name}?',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<DoctorProvider>().removePatientFromQueue(
                  patient.id,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Appointment with ${patient.name} cancelled'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

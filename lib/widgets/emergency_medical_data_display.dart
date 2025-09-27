import 'package:flutter/material.dart';
import '../models/emergency_medical_data.dart';

class EmergencyMedicalDataDisplay extends StatelessWidget {
  final EmergencyMedicalData medicalData;
  final bool isEmergencyMode;

  const EmergencyMedicalDataDisplay({
    Key? key,
    required this.medicalData,
    this.isEmergencyMode = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEmergencyMode ? Colors.red[50] : Colors.white,
        border: Border.all(
          color: isEmergencyMode ? Colors.red : Colors.grey[300]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.medical_services,
                color: isEmergencyMode ? Colors.red : Colors.blue,
                size: 28,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEmergencyMode
                      ? 'EMERGENCY MEDICAL DATA'
                      : 'Medical Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isEmergencyMode ? Colors.red[800] : Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Medical Alerts (if any)
          if (medicalData.medicalAlerts != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange[800], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'MEDICAL ALERTS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    medicalData.medicalAlerts!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Critical Information Cards
          Row(
            children: [
              // Blood Type
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.water_drop,
                  title: 'Blood Type',
                  value: medicalData.bloodType,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              // Patient ID
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.person,
                  title: 'Patient ID',
                  value: medicalData.patientId.substring(0, 8) + '...',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Emergency Contact
          _buildSectionCard(
            icon: Icons.contact_phone,
            title: 'Emergency Contact',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicalData.emergencyContact.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  medicalData.emergencyContact.relationship,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      medicalData.emergencyContact.phoneNumber,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
                if (medicalData.emergencyContact.email != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.email, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        medicalData.emergencyContact.email!,
                        style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Allergies
          if (medicalData.allergies.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.error,
              title: 'Allergies',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: medicalData.allergies.map((allergy) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      border: Border.all(color: Colors.red[300]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      allergy,
                      style: TextStyle(
                        color: Colors.red[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Chronic Conditions
          if (medicalData.chronicConditions.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.health_and_safety,
              title: 'Chronic Conditions',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: medicalData.chronicConditions.map((condition) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.orange[600],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            condition,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Critical Medications
          if (medicalData.criticalMedications.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildSectionCard(
              icon: Icons.medication,
              title: 'Critical Medications',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: medicalData.criticalMedications.map((medication) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            medication,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Last Updated
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Last Updated: ${_formatDate(medicalData.lastUpdated)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

// Emergency QR Scanner Result Dialog
class EmergencyQRResultDialog extends StatelessWidget {
  final EmergencyMedicalData? medicalData;
  final String? errorMessage;

  const EmergencyQRResultDialog({Key? key, this.medicalData, this.errorMessage})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: medicalData != null ? Colors.green[50] : Colors.red[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    medicalData != null ? Icons.check_circle : Icons.error,
                    color: medicalData != null ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      medicalData != null
                          ? 'QR Code Scanned Successfully'
                          : 'Scan Failed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: medicalData != null
                            ? Colors.green[800]
                            : Colors.red[800],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: medicalData != null
                    ? EmergencyMedicalDataDisplay(medicalData: medicalData!)
                    : Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to retrieve medical data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorMessage ??
                                'The QR code is invalid or expired.',
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ),

            // Footer actions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (medicalData != null) ...[
                    TextButton.icon(
                      onPressed: () {
                        // Implement call emergency contact
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Call Contact'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

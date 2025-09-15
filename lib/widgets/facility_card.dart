import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/medical_facility.dart';
import 'dart:math' as Math;

class FacilityCard extends StatelessWidget {
  final MedicalFacility facility;
  final Position? currentPosition;
  final VoidCallback onTap;

  const FacilityCard({
    Key? key,
    required this.facility,
    this.currentPosition,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name, type, and status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildTypeChip(),
                            const SizedBox(width: 8),
                            _buildStatusIndicator(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (currentPosition != null) _buildDistanceInfo(),
                      const SizedBox(height: 4),
                      _buildRatingInfo(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Address
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      facility.address,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Specialties
              if (facility.specialties.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: facility.specialties.take(3).map((specialty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        specialty,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],

              // Critical Status Indicators
              _buildCriticalStatus(),

              const SizedBox(height: 12),

              // Bottom row with quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Operating hours
                  _buildOperatingHours(),
                  // Quick action buttons
                  Row(
                    children: [
                      _buildQuickActionButton(
                        Icons.phone,
                        'Call',
                        Colors.green,
                        () => _makeCall(facility.phoneNumber),
                      ),
                      const SizedBox(width: 8),
                      _buildQuickActionButton(
                        Icons.directions,
                        'Directions',
                        Colors.blue,
                        () => _openDirections(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip() {
    IconData icon;
    Color color;

    switch (facility.type) {
      case 'hospital':
        icon = Icons.local_hospital;
        color = Colors.red;
        break;
      case 'clinic':
        icon = Icons.medical_services;
        color = Colors.blue;
        break;
      case 'lab':
        icon = Icons.science;
        color = Colors.purple;
        break;
      case 'diagnostic_center':
        icon = Icons.biotech;
        color = Colors.orange;
        break;
      default:
        icon = Icons.medical_services;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            facility.type.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final isOpen = facility.operatingHours.isOpenNow();
    final isOperational = facility.status.isOperational;
    final acceptingPatients = facility.status.acceptingPatients;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isOperational && acceptingPatients && isOpen) {
      statusColor = Colors.green;
      statusText = 'OPEN';
      statusIcon = Icons.check_circle;
    } else if (isOperational && !isOpen) {
      statusColor = Colors.orange;
      statusText = 'CLOSED';
      statusIcon = Icons.access_time;
    } else if (!acceptingPatients) {
      statusColor = Colors.red;
      statusText = 'NOT ACCEPTING';
      statusIcon = Icons.block;
    } else {
      statusColor = Colors.grey;
      statusText = 'UNKNOWN';
      statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 12, color: statusColor),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceInfo() {
    if (currentPosition == null) return const SizedBox.shrink();

    final distance = facility.getDistanceFrom(
      currentPosition!.latitude,
      currentPosition!.longitude,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        distance,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildRatingInfo() {
    if (facility.rating == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, size: 14, color: Colors.amber),
        const SizedBox(width: 2),
        Text(
          facility.rating!.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        if (facility.reviewCount != null)
          Text(
            ' (${facility.reviewCount})',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
      ],
    );
  }

  Widget _buildCriticalStatus() {
    final criticalItems = <Widget>[];

    // ICU Status
    if (facility.equipment.icuStatus.totalBeds > 0) {
      criticalItems.add(
        _buildStatusItem(
          'ICU',
          '${facility.equipment.icuStatus.availableBeds}/${facility.equipment.icuStatus.totalBeds}',
          facility.equipment.icuStatus.isAvailable ? Colors.green : Colors.red,
          Icons.airline_seat_flat,
        ),
      );
    }

    // Ventilator Status
    if (facility.equipment.ventilatorStatus.totalVentilators > 0) {
      criticalItems.add(
        _buildStatusItem(
          'Ventilators',
          '${facility.equipment.ventilatorStatus.availableVentilators}/${facility.equipment.ventilatorStatus.totalVentilators}',
          facility.equipment.ventilatorStatus.isAvailable
              ? Colors.green
              : Colors.red,
          Icons.air,
        ),
      );
    }

    // Oxygen Status
    if (facility.equipment.oxygenStatus.isAvailable) {
      criticalItems.add(
        _buildStatusItem(
          'Oxygen',
          '${facility.equipment.oxygenStatus.percentage}%',
          _getOxygenColor(facility.equipment.oxygenStatus.level),
          Icons.opacity,
        ),
      );
    }

    // Blood Bank
    if (facility.bloodBank?.isOperational ?? false) {
      criticalItems.add(
        _buildStatusItem(
          'Blood Bank',
          'Available',
          Colors.green,
          Icons.bloodtype,
        ),
      );
    }

    if (criticalItems.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(spacing: 12, runSpacing: 8, children: criticalItems),
    );
  }

  Widget _buildStatusItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getOxygenColor(String level) {
    switch (level) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.lightGreen;
      case 'moderate':
        return Colors.orange;
      case 'low':
        return Colors.deepOrange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildOperatingHours() {
    final isOpen = facility.operatingHours.isOpenNow();
    return Text(
      facility.operatingHours.is24Hours
          ? '24/7'
          : isOpen
          ? 'Open now'
          : 'Closed',
      style: TextStyle(
        fontSize: 12,
        color: isOpen ? Colors.green : Colors.red,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildQuickActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _makeCall(String phoneNumber) {
    // Implementation for making a call
    print('Calling: $phoneNumber');
  }

  void _openDirections() {
    // Implementation for opening directions
    print('Opening directions to: ${facility.name}');
  }
}

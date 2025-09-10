import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final String status; // 'scheduled', 'completed', 'cancelled', 'in_progress'
  final String? notes;
  final double consultationFee;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.notes,
    required this.consultationFee,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert appointment to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'doctor_specialization': doctorSpecialization,
      'appointment_date': appointmentDate.toIso8601String().split('T')[0],
      'appointment_time':
          '${appointmentTime.hour.toString().padLeft(2, '0')}:${appointmentTime.minute.toString().padLeft(2, '0')}',
      'status': status,
      'notes': notes,
      'consultation_fee': consultationFee,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create appointment from Map
  factory Appointment.fromMap(Map<String, dynamic> map) {
    // Parse time string to TimeOfDay
    final timeString = map['appointment_time'] as String;
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return Appointment(
      id: map['id'] as String,
      patientId: map['patient_id'] as String,
      doctorId: map['doctor_id'] as String,
      doctorName: map['doctor_name'] as String,
      doctorSpecialization: map['doctor_specialization'] as String,
      appointmentDate: DateTime.parse(map['appointment_date'] as String),
      appointmentTime: TimeOfDay(hour: hour, minute: minute),
      status: map['status'] as String,
      notes: map['notes'] as String?,
      consultationFee: (map['consultation_fee'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  // Create copy with updated fields
  Appointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialization,
    DateTime? appointmentDate,
    TimeOfDay? appointmentTime,
    String? status,
    String? notes,
    double? consultationFee,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      consultationFee: consultationFee ?? this.consultationFee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Getters for UI display
  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${appointmentDate.day} ${months[appointmentDate.month - 1]} ${appointmentDate.year}';
  }

  String get formattedTime {
    final hour = appointmentTime.hour;
    final minute = appointmentTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'Scheduled';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'in_progress':
        return 'In Progress';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return const Color(0xFF4CAF50);
      case 'completed':
        return const Color(0xFF2196F3);
      case 'cancelled':
        return const Color(0xFFF44336);
      case 'in_progress':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF757575);
    }
  }

  bool get canBeCancelled {
    return status.toLowerCase() == 'scheduled' &&
        appointmentDate.isAfter(DateTime.now());
  }

  bool get isUpcoming {
    return status.toLowerCase() == 'scheduled' &&
        appointmentDate.isAfter(
          DateTime.now().subtract(const Duration(days: 1)),
        );
  }
}

import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String department;
  final DateTime appointmentDate;
  final String timeSlot;
  final String status; // pending, confirmed, completed, cancelled
  final String? reason;
  final String? notes;
  final bool isEmergency;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? patientPhone;
  final String? patientEmail;

  // Add convenience getters for modern UI
  DateTime get dateTime => appointmentDate;
  String get type => department;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.department,
    required this.appointmentDate,
    required this.timeSlot,
    required this.status,
    this.reason,
    this.notes,
    this.isEmergency = false,
    required this.createdAt,
    this.updatedAt,
    this.patientPhone,
    this.patientEmail,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] ?? json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      department: json['department'] ?? '',
      appointmentDate: json['appointmentDate'] != null
          ? DateTime.parse(json['appointmentDate'])
          : DateTime.now(),
      timeSlot: json['timeSlot'] ?? '',
      status: json['status'] ?? 'pending',
      reason: json['reason'],
      notes: json['notes'],
      isEmergency: json['isEmergency'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      patientPhone: json['patientPhone'],
      patientEmail: json['patientEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'department': department,
      'appointmentDate': appointmentDate.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status,
      'reason': reason,
      'notes': notes,
      'isEmergency': isEmergency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'patientPhone': patientPhone,
      'patientEmail': patientEmail,
    };
  }

  Appointment copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? department,
    DateTime? appointmentDate,
    String? timeSlot,
    String? status,
    String? reason,
    String? notes,
    bool? isEmergency,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? patientPhone,
    String? patientEmail,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      department: department ?? this.department,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      isEmergency: isEmergency ?? this.isEmergency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      patientPhone: patientPhone ?? this.patientPhone,
      patientEmail: patientEmail ?? this.patientEmail,
    );
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF4CAF50); // Green
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      case 'completed':
        return const Color(0xFF2196F3); // Blue
      case 'cancelled':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  String get formattedDate {
    return '${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}';
  }

  String get formattedTime {
    return timeSlot;
  }

  bool get isToday {
    final now = DateTime.now();
    return appointmentDate.year == now.year &&
        appointmentDate.month == now.month &&
        appointmentDate.day == now.day;
  }

  bool get isUpcoming {
    return appointmentDate.isAfter(DateTime.now());
  }

  bool get isPast {
    return appointmentDate.isBefore(DateTime.now());
  }
}

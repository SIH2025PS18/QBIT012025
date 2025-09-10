import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'socket_service.dart';

/// Service for managing appointment bookings and syncing with doctor dashboard
class AppointmentBookingService extends ChangeNotifier {
  static final AppointmentBookingService _instance =
      AppointmentBookingService._internal();
  factory AppointmentBookingService() => _instance;
  AppointmentBookingService._internal();

  final SocketService _socketService = SocketService();
  final String _baseUrl = 'http://localhost:4000'; // Change for production

  List<Appointment> _appointments = [];
  List<Appointment> get appointments => List.unmodifiable(_appointments);

  /// Book a new appointment
  Future<bool> bookAppointment({
    required String patientId,
    required String patientName,
    required String patientAge,
    required String patientGender,
    required String symptoms,
    required String preferredTime,
    required String doctorId,
    String? medicalHistory,
    String priority = 'normal',
  }) async {
    try {
      final appointment = Appointment(
        id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
        patientId: patientId,
        doctorId: doctorId,
        patientName: patientName,
        patientAge: patientAge,
        patientGender: patientGender,
        symptoms: symptoms,
        medicalHistory: medicalHistory ?? '',
        preferredTime: preferredTime,
        priority: priority,
        status: 'waiting',
        createdAt: DateTime.now(),
      );

      // Send to backend
      final response = await http.post(
        Uri.parse('$_baseUrl/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(appointment.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _appointments.add(appointment);
        notifyListeners();

        // Notify doctor dashboard via socket
        _socketService.emit('new_appointment', appointment.toJson());

        // Add to patient queue
        _socketService.emit('patient_joined_queue', {
          'id': patientId,
          'name': patientName,
          'age': patientAge,
          'status': 'waiting',
          'priority': priority,
          'symptoms': symptoms,
          'appointmentId': appointment.id,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });

        debugPrint('Appointment booked successfully: ${appointment.id}');
        return true;
      } else {
        debugPrint('Failed to book appointment: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error booking appointment: $e');
      return false;
    }
  }

  /// Cancel an appointment
  Future<bool> cancelAppointment(String appointmentId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/appointments/$appointmentId'),
      );

      if (response.statusCode == 200) {
        _appointments.removeWhere((apt) => apt.id == appointmentId);
        notifyListeners();

        // Notify doctor dashboard
        _socketService.emit('appointment_cancelled', {
          'appointmentId': appointmentId,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error cancelling appointment: $e');
      return false;
    }
  }

  /// Get patient's appointments
  Future<List<Appointment>> getPatientAppointments(String patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/appointments/patient/$patientId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final appointments = data
            .map((json) => Appointment.fromJson(json))
            .toList();
        _appointments = appointments;
        notifyListeners();
        return appointments;
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
      return [];
    }
  }

  /// Update appointment status
  Future<void> updateAppointmentStatus(
    String appointmentId,
    String status,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/appointments/$appointmentId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        final index = _appointments.indexWhere(
          (apt) => apt.id == appointmentId,
        );
        if (index != -1) {
          _appointments[index] = _appointments[index].copyWith(status: status);
          notifyListeners();
        }

        // Notify doctor dashboard
        _socketService.emit('appointment_status_updated', {
          'appointmentId': appointmentId,
          'status': status,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } catch (e) {
      debugPrint('Error updating appointment status: $e');
    }
  }

  /// Join consultation queue (called when appointment time arrives)
  Future<void> joinConsultationQueue(String appointmentId) async {
    final appointment = _appointments.firstWhere(
      (apt) => apt.id == appointmentId,
      orElse: () => throw Exception('Appointment not found'),
    );

    // Update status to in_queue
    await updateAppointmentStatus(appointmentId, 'in_queue');

    // Notify doctor dashboard that patient is ready
    _socketService.emit('patient_ready_for_consultation', {
      'appointmentId': appointmentId,
      'patientId': appointment.patientId,
      'patientName': appointment.patientName,
      'symptoms': appointment.symptoms,
      'priority': appointment.priority,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    debugPrint('Patient joined consultation queue: $appointmentId');
  }
}

/// Appointment data model
class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String symptoms;
  final String medicalHistory;
  final String preferredTime;
  final String priority;
  final String status;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.symptoms,
    required this.medicalHistory,
    required this.preferredTime,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientAge: json['patientAge'] ?? '',
      patientGender: json['patientGender'] ?? '',
      symptoms: json['symptoms'] ?? '',
      medicalHistory: json['medicalHistory'] ?? '',
      preferredTime: json['preferredTime'] ?? '',
      priority: json['priority'] ?? 'normal',
      status: json['status'] ?? 'waiting',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientGender': patientGender,
      'symptoms': symptoms,
      'medicalHistory': medicalHistory,
      'preferredTime': preferredTime,
      'priority': priority,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  Appointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? patientName,
    String? patientAge,
    String? patientGender,
    String? symptoms,
    String? medicalHistory,
    String? preferredTime,
    String? priority,
    String? status,
    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientGender: patientGender ?? this.patientGender,
      symptoms: symptoms ?? this.symptoms,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      preferredTime: preferredTime ?? this.preferredTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get priorityDisplayName {
    switch (priority) {
      case 'critical':
        return 'Critical';
      case 'urgent':
        return 'Urgent';
      case 'normal':
        return 'Normal';
      default:
        return 'Normal';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case 'waiting':
        return 'Waiting';
      case 'in_queue':
        return 'In Queue';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}

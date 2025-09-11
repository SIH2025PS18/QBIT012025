import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/appointment.dart';
import '../models/doctor.dart';
import '../services/auth_service.dart';

class AppointmentService {
  static const String _baseUrl = 'https://telemed18.onrender.com/api';
  static final AuthService _authService = AuthService();

  /// Book a new appointment
  static Future<Appointment?> bookAppointment({
    required String doctorId,
    required String doctorName,
    required String doctorSpecialization,
    required DateTime appointmentDate,
    required TimeOfDay appointmentTime,
    required double consultationFee,
    String? notes,
  }) async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        _showToast('Please log in to book appointment', isError: true);
        return null;
      }

      final appointmentId = 'apt_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      final appointmentData = {
        'id': appointmentId,
        'patientId': currentUser.id,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'doctorSpecialization': doctorSpecialization,
        'appointmentDate': appointmentDate.toIso8601String(),
        'appointmentTime':
            '${appointmentTime.hour}:${appointmentTime.minute.toString().padLeft(2, '0')}',
        'status': 'scheduled',
        'notes': notes,
        'consultationFee': consultationFee,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(appointmentData),
      );

      if (response.statusCode == 201) {
        _showToast('Appointment booked successfully!', isError: false);
        final data = jsonDecode(response.body);
        return Appointment.fromMap(data);
      } else {
        throw Exception('Failed to book appointment: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error booking appointment: $e');
      _showToast('Failed to book appointment', isError: true);
      return null;
    }
  }

  /// Get appointments for current user
  static Future<List<Appointment>> getUserAppointments({
    String? status,
    bool upcomingOnly = false,
  }) async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        return [];
      }

      String url = '$_baseUrl/appointments?patientId=${currentUser.id}';
      if (status != null && status.isNotEmpty) {
        url += '&status=$status';
      }
      if (upcomingOnly) {
        final today = DateTime.now().toIso8601String().split('T')[0];
        url += '&from=$today';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map<Appointment>((item) => Appointment.fromMap(item))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
      _showToast('Error loading appointments', isError: true);
      return [];
    }
  }

  /// Get upcoming appointments (next 7 days)
  static Future<List<Appointment>> getUpcomingAppointments() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        return [];
      }

      final today = DateTime.now();
      final nextWeek = today.add(const Duration(days: 7));

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/appointments?patientId=${currentUser.id}&status=scheduled&from=${today.toIso8601String().split('T')[0]}&to=${nextWeek.toIso8601String().split('T')[0]}',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map<Appointment>((item) => Appointment.fromMap(item))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching upcoming appointments: $e');
      return [];
    }
  }

  /// Cancel an appointment
  static Future<bool> cancelAppointment(String appointmentId) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/appointments/$appointmentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': 'cancelled',
          'updatedAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        _showToast('Appointment cancelled successfully', isError: false);
        return true;
      } else {
        throw Exception('Failed to cancel appointment: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error cancelling appointment: $e');
      _showToast('Failed to cancel appointment', isError: true);
      return false;
    }
  }

  /// Update appointment status
  static Future<bool> updateAppointmentStatus(
    String appointmentId,
    String newStatus,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/appointments/$appointmentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': newStatus,
          'updatedAt': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating appointment status: $e');
      return false;
    }
  }

  /// Get available time slots for a specific date and doctor
  static Future<List<TimeOfDay>> getAvailableTimeSlots(
    String doctorId,
    DateTime date,
  ) async {
    try {
      // Default available time slots (9 AM to 5 PM)
      final allSlots = <TimeOfDay>[
        const TimeOfDay(hour: 9, minute: 0),
        const TimeOfDay(hour: 9, minute: 30),
        const TimeOfDay(hour: 10, minute: 0),
        const TimeOfDay(hour: 10, minute: 30),
        const TimeOfDay(hour: 11, minute: 0),
        const TimeOfDay(hour: 11, minute: 30),
        const TimeOfDay(hour: 14, minute: 0), // 2 PM (after lunch)
        const TimeOfDay(hour: 14, minute: 30),
        const TimeOfDay(hour: 15, minute: 0),
        const TimeOfDay(hour: 15, minute: 30),
        const TimeOfDay(hour: 16, minute: 0),
        const TimeOfDay(hour: 16, minute: 30),
        const TimeOfDay(hour: 17, minute: 0),
      ];

      // Get existing appointments for this doctor on this date
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/appointments?doctorId=$doctorId&date=${date.toIso8601String().split('T')[0]}&exclude=cancelled',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> existingAppointments = jsonDecode(response.body);

        // Convert booked times to TimeOfDay objects
        final bookedTimes = existingAppointments.map((apt) {
          final timeString = apt['appointmentTime'] as String;
          final timeParts = timeString.split(':');
          return TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          );
        }).toList();

        // Filter out booked slots
        final availableSlots = allSlots.where((slot) {
          return !bookedTimes.any(
            (booked) =>
                booked.hour == slot.hour && booked.minute == slot.minute,
          );
        }).toList();

        // If it's today, filter out past times
        if (date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day) {
          final now = TimeOfDay.now();
          return availableSlots.where((slot) {
            final slotMinutes = slot.hour * 60 + slot.minute;
            final currentMinutes =
                now.hour * 60 + now.minute + 30; // 30 min buffer
            return slotMinutes > currentMinutes;
          }).toList();
        }

        return availableSlots;
      }
      return allSlots; // Return all slots if request failed
    } catch (e) {
      debugPrint('Error fetching available time slots: $e');
      return [];
    }
  }

  /// Check if a specific time slot is available
  static Future<bool> isTimeSlotAvailable(
    String doctorId,
    DateTime date,
    TimeOfDay time,
  ) async {
    try {
      final timeString =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

      final response = await http.get(
        Uri.parse(
          '$_baseUrl/appointments?doctorId=$doctorId&date=${date.toIso8601String().split('T')[0]}&time=$timeString&exclude=cancelled',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> existingAppointments = jsonDecode(response.body);
        return existingAppointments.isEmpty;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking time slot availability: $e');
      return false;
    }
  }

  /// Get appointment statistics for user
  static Future<Map<String, int>> getAppointmentStats() async {
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        return {'total': 0, 'completed': 0, 'upcoming': 0, 'cancelled': 0};
      }

      final appointments = await getUserAppointments();
      final now = DateTime.now();

      return {
        'total': appointments.length,
        'completed': appointments
            .where((apt) => apt.status == 'completed')
            .length,
        'upcoming': appointments
            .where(
              (apt) =>
                  apt.status == 'scheduled' && apt.appointmentDate.isAfter(now),
            )
            .length,
        'cancelled': appointments
            .where((apt) => apt.status == 'cancelled')
            .length,
      };
    } catch (e) {
      debugPrint('Error fetching appointment stats: $e');
      return {'total': 0, 'completed': 0, 'upcoming': 0, 'cancelled': 0};
    }
  }

  /// Show toast message
  static void _showToast(String message, {required bool isError}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError
          ? const Color(0xFFE53E3E)
          : const Color(0xFF38A169),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 16.0,
    );
  }
}

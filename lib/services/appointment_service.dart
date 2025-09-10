import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import 'supabase_auth_service.dart';

class AppointmentService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'appointments';

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
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        _showToast('Please log in to book appointment', isError: true);
        return null;
      }

      final appointmentId = 'apt_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      final appointment = Appointment(
        id: appointmentId,
        patientId: currentUser.id,
        doctorId: doctorId,
        doctorName: doctorName,
        doctorSpecialization: doctorSpecialization,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
        status: 'scheduled',
        notes: notes,
        consultationFee: consultationFee,
        createdAt: now,
        updatedAt: now,
      );

      final response = await _supabase
          .from(_tableName)
          .insert(appointment.toMap())
          .select()
          .single();

      _showToast('Appointment booked successfully!', isError: false);
      return Appointment.fromMap(response);
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
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        return [];
      }

      var query = _supabase
          .from(_tableName)
          .select()
          .eq('patient_id', currentUser.id);

      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }

      if (upcomingOnly) {
        final today = DateTime.now().toIso8601String().split('T')[0];
        query = query.gte('appointment_date', today);
      }

      final response = await query.order('appointment_date', ascending: true);

      return response
          .map<Appointment>((data) => Appointment.fromMap(data))
          .toList();
    } catch (e) {
      debugPrint('Error fetching appointments: $e');
      _showToast('Error loading appointments', isError: true);
      return [];
    }
  }

  /// Get upcoming appointments (next 7 days)
  static Future<List<Appointment>> getUpcomingAppointments() async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        return [];
      }

      final today = DateTime.now();
      final nextWeek = today.add(const Duration(days: 7));

      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('patient_id', currentUser.id)
          .eq('status', 'scheduled')
          .gte('appointment_date', today.toIso8601String().split('T')[0])
          .lte('appointment_date', nextWeek.toIso8601String().split('T')[0])
          .order('appointment_date', ascending: true)
          .order('appointment_time', ascending: true);

      return response
          .map<Appointment>((data) => Appointment.fromMap(data))
          .toList();
    } catch (e) {
      debugPrint('Error fetching upcoming appointments: $e');
      return [];
    }
  }

  /// Cancel an appointment
  static Future<bool> cancelAppointment(String appointmentId) async {
    try {
      await _supabase
          .from(_tableName)
          .update({
            'status': 'cancelled',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', appointmentId);

      _showToast('Appointment cancelled successfully', isError: false);
      return true;
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
      await _supabase
          .from(_tableName)
          .update({
            'status': newStatus,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', appointmentId);

      return true;
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
      final existingAppointments = await _supabase
          .from(_tableName)
          .select('appointment_time')
          .eq('doctor_id', doctorId)
          .eq('appointment_date', date.toIso8601String().split('T')[0])
          .neq('status', 'cancelled');

      // Convert booked times to TimeOfDay objects
      final bookedTimes = existingAppointments.map((apt) {
        final timeString = apt['appointment_time'] as String;
        final timeParts = timeString.split(':');
        return TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }).toList();

      // Filter out booked slots
      final availableSlots = allSlots.where((slot) {
        return !bookedTimes.any(
          (booked) => booked.hour == slot.hour && booked.minute == slot.minute,
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

      final existingAppointment = await _supabase
          .from(_tableName)
          .select('id')
          .eq('doctor_id', doctorId)
          .eq('appointment_date', date.toIso8601String().split('T')[0])
          .eq('appointment_time', timeString)
          .neq('status', 'cancelled')
          .maybeSingle();

      return existingAppointment == null;
    } catch (e) {
      debugPrint('Error checking time slot availability: $e');
      return false;
    }
  }

  /// Get appointment statistics for user
  static Future<Map<String, int>> getAppointmentStats() async {
    try {
      final currentUser = AuthService.currentUser;
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

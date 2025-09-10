import '../models/appointment.dart';
import '../repositories/offline_appointment_repository.dart' hide Appointment;

/// Export the appointment repository interface and implementation
export '../repositories/offline_appointment_repository.dart' hide Appointment;

/// Abstract repository interface for appointment operations
abstract class AppointmentRepository {
  /// Get all appointments for the current user
  Future<List<Appointment>> getUserAppointments();

  /// Get appointment by ID
  Future<Appointment?> getAppointmentById(String appointmentId);

  /// Create a new appointment
  Future<Appointment> createAppointment(Appointment appointment);

  /// Update an existing appointment
  Future<Appointment> updateAppointment(Appointment appointment);

  /// Cancel an appointment
  Future<void> cancelAppointment(String appointmentId);

  /// Get appointments by status
  Future<List<Appointment>> getAppointmentsByStatus(String status);

  /// Get upcoming appointments
  Future<List<Appointment>> getUpcomingAppointments();

  /// Get past appointments
  Future<List<Appointment>> getPastAppointments();

  /// Get appointments for a specific date range
  Future<List<Appointment>> getAppointmentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Check appointment availability for a doctor at specific time
  Future<bool> isSlotAvailable(
    String doctorId,
    DateTime appointmentDate,
    String appointmentTime,
  );

  /// Get available time slots for a doctor on a specific date
  Future<List<String>> getAvailableSlots(String doctorId, DateTime date);
}

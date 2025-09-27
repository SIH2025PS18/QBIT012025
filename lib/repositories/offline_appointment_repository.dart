import 'dart:convert';
import 'package:uuid/uuid.dart';

import '../database/local_database.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import '../services/auth_service.dart';

/// Model for appointment data
class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String? doctorName;
  final String? doctorSpecialization;
  final DateTime appointmentDate;
  final DateTime appointmentTime;
  final String status;
  final String? notes;
  final String? patientSymptoms;
  final double consultationFee;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    this.doctorName,
    this.doctorSpecialization,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.notes,
    this.patientSymptoms,
    required this.consultationFee,
    required this.createdAt,
    required this.updatedAt,
  });

  Appointment copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialization,
    DateTime? appointmentDate,
    DateTime? appointmentTime,
    String? status,
    String? notes,
    String? patientSymptoms,
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
      patientSymptoms: patientSymptoms ?? this.patientSymptoms,
      consultationFee: consultationFee ?? this.consultationFee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Repository interface for appointments
abstract class AppointmentRepository {
  Future<List<Appointment>> getPatientAppointments(String patientId);
  Future<List<Appointment>> getUpcomingAppointments(String patientId);
  Future<Appointment?> getAppointment(String appointmentId);
  Future<Appointment> createAppointment(Appointment appointment);
  Future<Appointment> updateAppointment(Appointment appointment);
  Future<void> cancelAppointment(String appointmentId);
}

/// Offline-first repository for appointments
class OfflineAppointmentRepository implements AppointmentRepository {
  final LocalDatabase _localDb = LocalDatabase();
  final ConnectivityService _connectivity = ConnectivityService();
  final SyncService _sync = SyncService();
  final Uuid _uuid = const Uuid();

  @override
  Future<List<Appointment>> getPatientAppointments(String patientId) async {
    try {
      final localAppointments = await _localDb.getAppointmentsForPatient(
        patientId,
      );

      // Convert to app models
      final appointments = localAppointments
          .map(_mapLocalToModelAppointment)
          .toList();

      // Trigger sync if connected and we have few appointments
      if (_connectivity.isConnected && appointments.length < 5) {
        _sync.syncNow();
      }

      return appointments;
    } catch (e) {
      // Return cached data even if there's an error
      try {
        final localAppointments = await _localDb.getAppointmentsForPatient(
          patientId,
        );
        return localAppointments.map(_mapLocalToModelAppointment).toList();
      } catch (cacheError) {
        return [];
      }
    }
  }

  @override
  Future<List<Appointment>> getUpcomingAppointments(String patientId) async {
    try {
      // Since there's no specific method for upcoming appointments,
      // we'll get all appointments and filter them
      final localAppointments = await _localDb.getAppointmentsForPatient(
        patientId,
      );

      // Filter for upcoming appointments (status = 'scheduled' or 'confirmed')
      final upcomingAppointments = localAppointments
          .where(
            (appointment) =>
                appointment.status == 'scheduled' ||
                appointment.status == 'confirmed' ||
                appointment.status == 'waiting',
          )
          .toList();

      // Sort by appointment date
      upcomingAppointments.sort(
        (a, b) => a.appointmentDate.compareTo(b.appointmentDate),
      );

      // Convert to app models
      final appointments = upcomingAppointments
          .map(_mapLocalToModelAppointment)
          .toList();

      // Trigger sync if connected
      if (_connectivity.isConnected) {
        _sync.syncNow();
      }

      return appointments;
    } catch (e) {
      // Return cached data even if there's an error
      try {
        final localAppointments = await _localDb.getAppointmentsForPatient(
          patientId,
        );

        // Filter for upcoming appointments (status = 'scheduled' or 'confirmed')
        final upcomingAppointments = localAppointments
            .where(
              (appointment) =>
                  appointment.status == 'scheduled' ||
                  appointment.status == 'confirmed' ||
                  appointment.status == 'waiting',
            )
            .toList();

        // Sort by appointment date
        upcomingAppointments.sort(
          (a, b) => a.appointmentDate.compareTo(b.appointmentDate),
        );

        return upcomingAppointments.map(_mapLocalToModelAppointment).toList();
      } catch (cacheError) {
        return [];
      }
    }
  }

  @override
  Future<Appointment?> getAppointment(String appointmentId) async {
    try {
      final localAppointment = await _localDb.getAppointment(appointmentId);

      if (localAppointment != null) {
        return _mapLocalToModelAppointment(localAppointment);
      }

      return null;
    } catch (e) {
      // Return cached data even if there's an error
      try {
        final localAppointment = await _localDb.getAppointment(appointmentId);
        if (localAppointment != null) {
          return _mapLocalToModelAppointment(localAppointment);
        }
      } catch (cacheError) {
        return null;
      }
      return null;
    }
  }

  @override
  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final user = await AuthService().getCurrentUser();
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Generate ID if not provided
      final appointmentId = appointment.id.isEmpty
          ? _uuid.v4()
          : appointment.id;
      final appointmentWithId = appointment.copyWith(
        id: appointmentId,
        patientId: user.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final localAppointment = _mapModelToLocalAppointment(appointmentWithId);

      // Save to local database
      await _localDb.upsertAppointment(localAppointment);

      // Add sync operation
      final syncOperation = SyncOperation(
        id: 0, // Will be auto-generated
        tableNameColumn: 'appointments',
        recordId: appointmentId,
        operation: 'create',
        data: jsonEncode(_mapLocalToData(localAppointment)),
        isCompleted: false,
        retryCount: 0,
        createdAt: DateTime.now(),
        lastRetryAt: null,
        errorMessage: null,
      );
      await _localDb.addSyncOperation(syncOperation);

      // Trigger sync if connected
      if (_connectivity.isConnected) {
        _sync.syncNow();
      }

      return appointmentWithId;
    } catch (e) {
      // Even if online sync fails, appointment is still available offline
      final user = await AuthService().getCurrentUser();
      if (user == null) {
        throw Exception('No authenticated user');
      }

      // Generate ID if not provided
      final appointmentId = appointment.id.isEmpty
          ? _uuid.v4()
          : appointment.id;
      final appointmentWithId = appointment.copyWith(
        id: appointmentId,
        patientId: user.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final localAppointment = _mapModelToLocalAppointment(appointmentWithId);

      // Save to local database
      await _localDb.upsertAppointment(localAppointment);

      return appointmentWithId;
    }
  }

  @override
  Future<Appointment> updateAppointment(Appointment appointment) async {
    try {
      final updatedAppointment = appointment.copyWith(
        updatedAt: DateTime.now(),
      );

      final localAppointment = _mapModelToLocalAppointment(updatedAppointment);

      // Save to local database
      await _localDb.upsertAppointment(localAppointment);

      // Add sync operation
      final syncOperation = SyncOperation(
        id: 0, // Will be auto-generated
        tableNameColumn: 'appointments',
        recordId: appointment.id,
        operation: 'update',
        data: jsonEncode(_mapLocalToData(localAppointment)),
        isCompleted: false,
        retryCount: 0,
        createdAt: DateTime.now(),
        lastRetryAt: null,
        errorMessage: null,
      );
      await _localDb.addSyncOperation(syncOperation);

      // Trigger sync if connected
      if (_connectivity.isConnected) {
        _sync.syncNow();
      }

      return updatedAppointment;
    } catch (e) {
      // Even if online sync fails, updated appointment is still available offline
      final updatedAppointment = appointment.copyWith(
        updatedAt: DateTime.now(),
      );

      final localAppointment = _mapModelToLocalAppointment(updatedAppointment);

      // Save to local database
      await _localDb.upsertAppointment(localAppointment);

      return updatedAppointment;
    }
  }

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      // Update appointment status to cancelled
      final localAppointment = await _localDb.getAppointment(appointmentId);
      if (localAppointment == null) {
        throw Exception('Appointment not found');
      }

      final cancelledAppointment = localAppointment.copyWith(
        status: 'cancelled',
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      // Save to local database
      await _localDb.upsertAppointment(cancelledAppointment);

      // Add sync operation
      final syncOperation = SyncOperation(
        id: 0, // Will be auto-generated
        tableNameColumn: 'appointments',
        recordId: appointmentId,
        operation: 'update',
        data: jsonEncode(_mapLocalToData(cancelledAppointment)),
        isCompleted: false,
        retryCount: 0,
        createdAt: DateTime.now(),
        lastRetryAt: null,
        errorMessage: null,
      );
      await _localDb.addSyncOperation(syncOperation);

      // Trigger sync if connected
      if (_connectivity.isConnected) {
        _sync.syncNow();
      }
    } catch (e) {
      // Even if online sync fails, appointment is marked as cancelled offline
      try {
        final localAppointment = await _localDb.getAppointment(appointmentId);
        if (localAppointment != null) {
          final cancelledAppointment = localAppointment.copyWith(
            status: 'cancelled',
            updatedAt: DateTime.now(),
            isSynced: false,
          );

          // Save to local database
          await _localDb.upsertAppointment(cancelledAppointment);
        }
      } catch (cacheError) {
        // Silently fail
      }
    }
  }

  /// Map local database model to app model
  Appointment _mapLocalToModelAppointment(LocalAppointment local) {
    return Appointment(
      id: local.id,
      patientId: local.patientId,
      doctorId: local.doctorId,
      doctorName: local.doctorName,
      doctorSpecialization: local.doctorSpecialization,
      appointmentDate: local.appointmentDate,
      appointmentTime: local.appointmentTime,
      status: local.status,
      notes: local.notes,
      patientSymptoms: local.patientSymptoms,
      consultationFee: local.consultationFee,
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
    );
  }

  /// Map app model to local database model
  LocalAppointment _mapModelToLocalAppointment(Appointment appointment) {
    return LocalAppointment(
      id: appointment.id,
      patientId: appointment.patientId,
      doctorId: appointment.doctorId,
      doctorName: appointment.doctorName,
      doctorSpecialization: appointment.doctorSpecialization,
      appointmentDate: appointment.appointmentDate,
      appointmentTime: appointment.appointmentTime,
      status: appointment.status,
      notes: appointment.notes,
      patientSymptoms: appointment.patientSymptoms,
      consultationFee: appointment.consultationFee,
      createdAt: appointment.createdAt,
      updatedAt: appointment.updatedAt,
      isSynced: false,
      lastSyncAt: null,
      pendingDelete: false,
      syncVersion: '1',
    );
  }

  /// Map local appointment to MongoDB backend data format
  Map<String, dynamic> _mapLocalToData(LocalAppointment local) {
    return {
      'id': local.id,
      'patientId': local.patientId,
      'doctorId': local.doctorId,
      'doctorName': local.doctorName,
      'doctorSpecialization': local.doctorSpecialization,
      'appointmentDate': local.appointmentDate.toIso8601String(),
      'appointmentTime': local.appointmentTime.toIso8601String(),
      'status': local.status,
      'notes': local.notes,
      'patientSymptoms': local.patientSymptoms,
      'consultationFee': local.consultationFee,
      'createdAt': local.createdAt.toIso8601String(),
      'updatedAt': local.updatedAt.toIso8601String(),
    };
  }

  /// Get sync status for appointments
  Future<List<Appointment>> getUnsyncedAppointments() async {
    try {
      final localAppointments = await _localDb.getUnsyncedAppointments();
      return localAppointments.map(_mapLocalToModelAppointment).toList();
    } catch (e) {
      throw Exception('Failed to get unsynced appointments: $e');
    }
  }

  /// Force sync appointments
  Future<void> forceSyncAppointments() async {
    final user = await AuthService().getCurrentUser();
    if (user == null) return;

    final unsyncedAppointments = await _localDb.getUnsyncedAppointments();
    for (final appointment in unsyncedAppointments) {
      await _sync.forceSyncRecord('appointments', appointment.id);
    }
  }

  /// Ensure appointment data is cached for offline access
  Future<void> ensureAppointmentsCached(String patientId) async {
    try {
      // Try to get appointments from local database
      final localAppointments = await _localDb.getAppointmentsForPatient(
        patientId,
      );

      // If not found and connected, sync from server
      if (localAppointments.isEmpty && _connectivity.isConnected) {
        await _sync.syncNow();
      }
    } catch (e) {
      // Silently fail, we don't want to interrupt the user experience
    }
  }
}

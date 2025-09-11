// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../database/offline_database.dart';
// import '../services/connectivity_service.dart';
// import '../services/sync_service.dart';
// import '../services/auth_service.dart';
// import '../core/service_locator.dart';

// class OfflineAppointmentService extends ChangeNotifier {
//   static final OfflineAppointmentService _instance =
//       OfflineAppointmentService._internal();
//   factory OfflineAppointmentService() => _instance;
//   OfflineAppointmentService._internal();

//   late final OfflineDatabase _db;
//   final ConnectivityService _connectivity = ConnectivityService();
//   final SyncService _syncService = SyncService();

//   List<dynamic> _appointments = [];
//   bool _isLoading = false;
//   String? _error;

//   List<dynamic> get appointments => _appointments;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get hasOfflineAppointments =>
//       _appointments.any((apt) => apt.isSynced == false);

//   // Initialize the service with dependencies
//   Future<void> initialize() async {
//     // Get database from service locator
//     _db = await serviceLocator.getAsync<OfflineDatabase>();
//     await _loadOfflineAppointments();
//   }

//   // Create appointment (works offline)
//   Future<String?> bookAppointment({
//     required String patientId,
//     required String patientName,
//     required String patientAge,
//     required String patientGender,
//     required String symptoms,
//     String? medicalHistory,
//     required String preferredTime,
//     String priority = 'normal',
//     Map<String, dynamic>? additionalData,
//   }) async {
//     try {
//       _setLoading(true);
//       _clearError();

//       // Create appointment in offline database
//       final appointmentId = await _db.createOfflineAppointment(
//         patientId: patientId,
//         patientName: patientName,
//         patientAge: patientAge,
//         patientGender: patientGender,
//         symptoms: symptoms,
//         medicalHistory: medicalHistory,
//         preferredTime: preferredTime,
//         priority: priority,
//       );

//       // Save additional metadata
//       if (additionalData != null) {
//         await _saveAppointmentMetadata(appointmentId, additionalData);
//       }

//       // Show offline notification
//       await _showOfflineNotification(
//         'Appointment scheduled offline',
//         'Your appointment will be synced when internet is available',
//       );

//       // Try to sync immediately if online
//       if (_connectivity.isConnected) {
//         _syncService.syncNow();
//       }

//       await _loadOfflineAppointments();

//       debugPrint('Appointment booked offline: $appointmentId');
//       return appointmentId;
//     } catch (e) {
//       _setError('Failed to book appointment: $e');
//       debugPrint('Error booking appointment: $e');
//       return null;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Get patient appointments (offline-first)
//   Future<List<dynamic>> getPatientAppointments(String patientId) async {
//     try {
//       _setLoading(true);
//       _clearError();

//       // Always load from offline database first
//       final offlineAppointments = await _db.getPatientAppointments(patientId);

//       // Try to sync if online
//       if (_connectivity.isConnected) {
//         try {
//           await _syncService.syncNow();
//           // Reload from database after sync
//           final updatedAppointments = await _db.getPatientAppointments(
//             patientId,
//           );
//           _appointments = updatedAppointments;
//         } catch (e) {
//           debugPrint('Sync failed, using offline data: $e');
//           _appointments = offlineAppointments;
//         }
//       } else {
//         _appointments = offlineAppointments;
//       }

//       return _appointments;
//     } catch (e) {
//       _setError('Failed to load appointments: $e');
//       debugPrint('Error loading appointments: $e');
//       return [];
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Cancel appointment (works offline)
//   Future<bool> cancelAppointment(String appointmentId, {String? reason}) async {
//     try {
//       _setLoading(true);
//       _clearError();

//       // Mark as cancelled in offline database
//       // This would be implemented in the database class
//       // For now, we'll simulate by updating status

//       // If online, try to cancel on server immediately
//       if (_connectivity.isConnected) {
//         // Implementation would call server API
//         debugPrint(
//           'Attempting to cancel appointment on server: $appointmentId',
//         );
//       } else {
//         // Queue for sync when online
//         await _queueAppointmentCancellation(appointmentId, reason);

//         await _showOfflineNotification(
//           'Appointment cancelled offline',
//           'Cancellation will be synced when internet is available',
//         );
//       }

//       await _loadOfflineAppointments();
//       return true;
//     } catch (e) {
//       _setError('Failed to cancel appointment: $e');
//       debugPrint('Error cancelling appointment: $e');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Reschedule appointment (works offline)
//   Future<bool> rescheduleAppointment(
//     String appointmentId,
//     String newPreferredTime, {
//     String? reason,
//   }) async {
//     try {
//       _setLoading(true);
//       _clearError();

//       // Update in offline database
//       // Implementation would update the appointment record

//       await _showOfflineNotification(
//         'Appointment rescheduled offline',
//         'Changes will be synced when internet is available',
//       );

//       if (_connectivity.isConnected) {
//         _syncService.syncNow();
//       }

//       await _loadOfflineAppointments();
//       return true;
//     } catch (e) {
//       _setError('Failed to reschedule appointment: $e');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Get appointment by ID
//   Future<OfflineAppointment?> getAppointmentById(String appointmentId) async {
//     try {
//       // Query from offline database
//       final appointments = await _db.getPatientAppointments('');
//       return appointments.where((apt) => apt.id == appointmentId).firstOrNull;
//     } catch (e) {
//       debugPrint('Error getting appointment by ID: $e');
//       return null;
//     }
//   }

//   // Get offline queue status
//   Future<Map<String, dynamic>> getOfflineQueueStatus() async {
//     try {
//       final pendingAppointments = await _db.getPendingSyncAppointments();
//       final stats = await _db.getDatabaseStats();

//       return {
//         'pending_appointments': pendingAppointments.length,
//         'total_appointments': stats['appointments'] ?? 0,
//         'is_connected': _connectivity.isConnected,
//         'last_sync': _syncService.lastSyncTime?.toIso8601String(),
//         'sync_errors': _syncService.lastSyncError != null,
//       };
//     } catch (e) {
//       debugPrint('Error getting offline queue status: $e');
//       return {
//         'pending_appointments': 0,
//         'total_appointments': 0,
//         'is_connected': false,
//         'error': e.toString(),
//       };
//     }
//   }

//   // Emergency appointment booking
//   Future<String?> bookEmergencyAppointment({
//     required String patientId,
//     required String patientName,
//     required String patientAge,
//     required String patientGender,
//     required String emergencySymptoms,
//     required String urgencyLevel, // 'high', 'critical'
//     String? contactNumber,
//   }) async {
//     try {
//       final appointmentId = await bookAppointment(
//         patientId: patientId,
//         patientName: 'Patient', // Use actual patient name from user profile
//         patientAge: '30', // Use actual patient age from user profile
//         patientGender: 'Male', // Use actual patient gender from user profile
//         symptoms: emergencySymptoms,
//         preferredTime: 'EMERGENCY - ${DateTime.now().toString()}',
//         priority: 'emergency',
//         additionalData: {
//           'urgency_level': urgencyLevel,
//           'contact_number': contactNumber,
//           'is_emergency': true,
//           'created_offline': !_connectivity.isConnected,
//         },
//       );

//       if (appointmentId != null) {
//         // Mark for high-priority sync
//         await _markForPrioritySync(appointmentId);

//         // Show emergency notification
//         await _showOfflineNotification(
//           'Emergency appointment scheduled',
//           'High priority - will be synced immediately when online',
//         );

//         // Try immediate sync if online
//         if (_connectivity.isConnected) {
//           await _syncService.syncNow();
//         }
//       }

//       return appointmentId;
//     } catch (e) {
//       debugPrint('Error booking emergency appointment: $e');
//       return null;
//     }
//   }

//   // Get appointments by status
//   Future<List<dynamic>> getAppointmentsByStatus(String status) async {
//     try {
//       final allAppointments = await _db.getPatientAppointments('');
//       return allAppointments.where((apt) => apt.status == status).toList();
//     } catch (e) {
//       debugPrint('Error getting appointments by status: $e');
//       return [];
//     }
//   }

//   // Search appointments
//   Future<List<dynamic>> searchAppointments(String query) async {
//     try {
//       final allAppointments = await _db.getPatientAppointments('');
//       final lowerQuery = query.toLowerCase();

//       return allAppointments.where((apt) {
//         return apt.patientName.toLowerCase().contains(lowerQuery) ||
//             apt.symptoms.toLowerCase().contains(lowerQuery) ||
//             apt.status.toLowerCase().contains(lowerQuery);
//       }).toList();
//     } catch (e) {
//       debugPrint('Error searching appointments: $e');
//       return [];
//     }
//   }

//   // Get appointment statistics
//   Future<Map<String, dynamic>> getAppointmentStats() async {
//     try {
//       final allAppointments = await _db.getPatientAppointments('');

//       final stats = <String, dynamic>{
//         'total': allAppointments.length,
//         'pending': allAppointments.where((a) => a.status == 'waiting').length,
//         'completed': allAppointments
//             .where((a) => a.status == 'completed')
//             .length,
//         'cancelled': allAppointments
//             .where((a) => a.status == 'cancelled')
//             .length,
//         'emergency': allAppointments
//             .where((a) => a.priority == 'emergency')
//             .length,
//         'offline_created': allAppointments.where((a) => !a.isSynced).length,
//       };

//       return stats;
//     } catch (e) {
//       debugPrint('Error getting appointment stats: $e');
//       return {};
//     }
//   }

//   // Private helper methods
//   Future<void> _loadOfflineAppointments() async {
//     try {
//       // Load appointments for current patient
//       // Get actual patient ID from auth service instead of hardcoded value
//       final userData = await AuthService.getUserData();
//       if (userData != null && userData['id'] != null) {
//         final patientId = userData['id'];
//         _appointments = await _db.getPatientAppointments(patientId);
//         notifyListeners();
//       } else {
//         debugPrint('No user data found, cannot load appointments');
//       }
//     } catch (e) {
//       debugPrint('Error loading offline appointments: $e');
//     }
//   }

//   Future<void> _saveAppointmentMetadata(
//     String appointmentId,
//     Map<String, dynamic> metadata,
//   ) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(
//         'appointment_metadata_$appointmentId',
//         jsonEncode(metadata),
//       );
//     } catch (e) {
//       debugPrint('Error saving appointment metadata: $e');
//     }
//   }

//   Future<void> _queueAppointmentCancellation(
//     String appointmentId,
//     String? reason,
//   ) async {
//     try {
//       // This would be queued in the sync service
//       debugPrint(
//         'Queued appointment cancellation: $appointmentId for reason: $reason',
//       );
//     } catch (e) {
//       debugPrint('Error queuing appointment cancellation: $e');
//     }
//   }

//   Future<void> _markForPrioritySync(String appointmentId) async {
//     try {
//       // Mark appointment for high-priority sync by forcing sync on this record
//       await _syncService.forceSyncRecord('appointments', appointmentId);
//     } catch (e) {
//       debugPrint('Error marking for priority sync: $e');
//     }
//   }

//   Future<void> _showOfflineNotification(String title, String message) async {
//     try {
//       // This would show a notification to the user
//       debugPrint('Offline Notification: $title - $message');

//       // You could use a package like flutter_local_notifications here
//       // For now, we'll just log it
//     } catch (e) {
//       debugPrint('Error showing offline notification: $e');
//     }
//   }

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String error) {
//     _error = error;
//     notifyListeners();
//   }

//   void _clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   // Cleanup and maintenance
//   Future<void> cleanupOldAppointments() async {
//     try {
//       // This would clean up old, completed appointments
//       // Implementation would be in the database class
//       await _db.clearOldData();
//       await _loadOfflineAppointments();
//     } catch (e) {
//       debugPrint('Error cleaning up old appointments: $e');
//     }
//   }

//   // Export appointments for backup
//   Future<String?> exportAppointments() async {
//     try {
//       // Get actual patient ID instead of empty string
//       final userData = await AuthService.getUserData();
//       if (userData != null && userData['id'] != null) {
//         final patientId = userData['id'];
//         final allAppointments = await _db.getPatientAppointments(patientId);
//         final exportData = {
//           'appointments': allAppointments,
//           'exported_at': DateTime.now().toIso8601String(),
//           'version': '1.0',
//         };

//         return jsonEncode(exportData);
//       }
//       return null;
//     } catch (e) {
//       debugPrint('Error exporting appointments: $e');
//       return null;
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }

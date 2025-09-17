import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dependent_profile.dart';
import '../providers/family_profile_provider.dart';

/// Simplified caregiver notification service without external dependencies
/// Manages caregiver-specific reminders and alerts
class CaregiverNotificationService {
  static final CaregiverNotificationService _instance =
      CaregiverNotificationService._internal();
  factory CaregiverNotificationService() => _instance;
  CaregiverNotificationService._internal();

  FamilyProfileProvider? _familyProvider;
  bool _initialized = false;
  final List<CaregiverReminder> _activeReminders = [];
  final List<CaregiverAlert> _activeAlerts = [];

  /// Initialize the notification service
  Future<void> initialize(FamilyProfileProvider familyProvider) async {
    if (_initialized) return;

    _familyProvider = familyProvider;
    await _loadSavedReminders();
    _initialized = true;

    print('✅ Caregiver Notification Service initialized');
  }

  /// Add medication reminder for a dependent
  Future<void> addMedicationReminder({
    required String dependentId,
    required String dependentName,
    required String medicationName,
    required TimeOfDay scheduledTime,
    required String dosage,
    bool recurring = true,
    List<int> weekdays = const [1, 2, 3, 4, 5, 6, 7], // All days
  }) async {
    final reminder = CaregiverReminder(
      id: _generateId(),
      type: ReminderType.medication,
      dependentId: dependentId,
      dependentName: dependentName,
      title: '💊 Medication Reminder',
      message: 'Give $medicationName ($dosage) to $dependentName',
      scheduledTime: scheduledTime,
      recurring: recurring,
      weekdays: weekdays,
      isActive: true,
      metadata: {'medicationName': medicationName, 'dosage': dosage},
    );

    _activeReminders.add(reminder);
    await _saveReminders();

    print('📅 Added medication reminder for $dependentName - $medicationName');
  }

  /// Add appointment reminder for a dependent
  Future<void> addAppointmentReminder({
    required String dependentId,
    required String dependentName,
    required String doctorName,
    required DateTime appointmentDateTime,
    required String location,
    Duration reminderBefore = const Duration(hours: 1),
  }) async {
    final reminderTime = appointmentDateTime.subtract(reminderBefore);

    final reminder = CaregiverReminder(
      id: _generateId(),
      type: ReminderType.appointment,
      dependentId: dependentId,
      dependentName: dependentName,
      title: '🏥 Appointment Reminder',
      message:
          '$dependentName has an appointment with Dr. $doctorName in ${_formatDuration(reminderBefore)}',
      scheduledTime: TimeOfDay.fromDateTime(reminderTime),
      scheduledDate: reminderTime,
      recurring: false,
      isActive: true,
      metadata: {
        'doctorName': doctorName,
        'location': location,
        'appointmentDateTime': appointmentDateTime.toIso8601String(),
      },
    );

    _activeReminders.add(reminder);
    await _saveReminders();

    print(
      '📅 Added appointment reminder for $dependentName with Dr. $doctorName',
    );
  }

  /// Add health check reminder
  Future<void> addHealthCheckReminder({
    required String dependentId,
    required String dependentName,
    required String checkType,
    required TimeOfDay scheduledTime,
    String? instructions,
    bool recurring = true,
  }) async {
    final reminder = CaregiverReminder(
      id: _generateId(),
      type: ReminderType.healthCheck,
      dependentId: dependentId,
      dependentName: dependentName,
      title: '🩺 Health Check Reminder',
      message:
          'Time for $dependentName\'s $checkType${instructions != null ? ' - $instructions' : ''}',
      scheduledTime: scheduledTime,
      recurring: recurring,
      isActive: true,
      metadata: {'checkType': checkType, 'instructions': instructions},
    );

    _activeReminders.add(reminder);
    await _saveReminders();

    print('📅 Added health check reminder for $dependentName - $checkType');
  }

  /// Add emergency alert
  Future<void> addEmergencyAlert({
    required String dependentId,
    required String dependentName,
    required String alertMessage,
    AlertSeverity severity = AlertSeverity.high,
    String? actionRequired,
  }) async {
    final alert = CaregiverAlert(
      id: _generateId(),
      dependentId: dependentId,
      dependentName: dependentName,
      title: '🚨 Health Alert',
      message: '$dependentName: $alertMessage',
      severity: severity,
      timestamp: DateTime.now(),
      isRead: false,
      actionRequired: actionRequired,
      metadata: {'alertMessage': alertMessage},
    );

    _activeAlerts.add(alert);
    await _saveAlerts();

    print('🚨 Added emergency alert for $dependentName');
  }

  /// Schedule smart reminders based on dependent's profile
  Future<void> scheduleSmartReminders(DependentProfile dependent) async {
    if (!_initialized) return;

    // Clear existing reminders for this dependent
    await clearDependentReminders(dependent.id);

    // Add medication reminders
    for (final medication in dependent.medications) {
      await _addSmartMedicationReminder(dependent, medication);
    }

    // Add condition-specific reminders
    for (final condition in dependent.medicalConditions) {
      await _addConditionSpecificReminders(dependent, condition);
    }

    // Add age-appropriate reminders
    await _addAgeSpecificReminders(dependent);

    print('🤖 Scheduled smart reminders for ${dependent.name}');
  }

  /// Get today's reminders
  List<CaregiverReminder> getTodaysReminders() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _activeReminders.where((reminder) {
        if (!reminder.isActive) return false;

        if (reminder.scheduledDate != null) {
          // One-time reminder
          final reminderDate = DateTime(
            reminder.scheduledDate!.year,
            reminder.scheduledDate!.month,
            reminder.scheduledDate!.day,
          );
          return reminderDate.isAtSameMomentAs(today);
        } else if (reminder.recurring) {
          // Recurring reminder
          return reminder.weekdays.contains(now.weekday);
        }

        return false;
      }).toList()
      ..sort((a, b) => a.scheduledTime.hour.compareTo(b.scheduledTime.hour));
  }

  /// Get upcoming reminders
  List<CaregiverReminder> getUpcomingReminders({int days = 7}) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    return _activeReminders.where((reminder) {
      if (!reminder.isActive) return false;

      if (reminder.scheduledDate != null) {
        return reminder.scheduledDate!.isAfter(now) &&
            reminder.scheduledDate!.isBefore(endDate);
      } else if (reminder.recurring) {
        return true; // Recurring reminders are always upcoming
      }

      return false;
    }).toList();
  }

  /// Get active alerts
  List<CaregiverAlert> getActiveAlerts() {
    return _activeAlerts.where((alert) => !alert.isRead).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Mark alert as read
  Future<void> markAlertAsRead(String alertId) async {
    final alertIndex = _activeAlerts.indexWhere((alert) => alert.id == alertId);
    if (alertIndex != -1) {
      _activeAlerts[alertIndex] = _activeAlerts[alertIndex].copyWith(
        isRead: true,
      );
      await _saveAlerts();
    }
  }

  /// Clear all reminders for a dependent
  Future<void> clearDependentReminders(String dependentId) async {
    _activeReminders.removeWhere(
      (reminder) => reminder.dependentId == dependentId,
    );
    await _saveReminders();

    print('❌ Cleared all reminders for dependent: $dependentId');
  }

  /// Clear all alerts for a dependent
  Future<void> clearDependentAlerts(String dependentId) async {
    _activeAlerts.removeWhere((alert) => alert.dependentId == dependentId);
    await _saveAlerts();

    print('❌ Cleared all alerts for dependent: $dependentId');
  }

  /// Add smart medication reminder based on medication type
  Future<void> _addSmartMedicationReminder(
    DependentProfile dependent,
    String medication,
  ) async {
    TimeOfDay reminderTime;
    String dosageInstructions;

    // AI logic for optimal medication timing
    if (medication.toLowerCase().contains('thyroid')) {
      reminderTime = const TimeOfDay(hour: 6, minute: 0);
      dosageInstructions = 'Take on empty stomach, 30 min before breakfast';
    } else if (medication.toLowerCase().contains('diabetes') ||
        medication.toLowerCase().contains('metformin')) {
      reminderTime = const TimeOfDay(hour: 8, minute: 0);
      dosageInstructions = 'Take with breakfast';
    } else if (medication.toLowerCase().contains('blood pressure') ||
        medication.toLowerCase().contains('bp')) {
      reminderTime = const TimeOfDay(hour: 7, minute: 0);
      dosageInstructions = 'Take at the same time daily';
    } else {
      reminderTime = const TimeOfDay(hour: 9, minute: 0);
      dosageInstructions = 'Take as prescribed';
    }

    await addMedicationReminder(
      dependentId: dependent.id,
      dependentName: dependent.name,
      medicationName: medication,
      scheduledTime: reminderTime,
      dosage: dosageInstructions,
      recurring: true,
    );
  }

  /// Add condition-specific reminders
  Future<void> _addConditionSpecificReminders(
    DependentProfile dependent,
    String condition,
  ) async {
    if (condition.toLowerCase().contains('diabetes')) {
      await addHealthCheckReminder(
        dependentId: dependent.id,
        dependentName: dependent.name,
        checkType: 'Blood Sugar Check',
        scheduledTime: const TimeOfDay(hour: 7, minute: 30),
        instructions: 'Check fasting blood sugar before breakfast',
        recurring: true,
      );
    } else if (condition.toLowerCase().contains('hypertension') ||
        condition.toLowerCase().contains('blood pressure')) {
      await addHealthCheckReminder(
        dependentId: dependent.id,
        dependentName: dependent.name,
        checkType: 'Blood Pressure Check',
        scheduledTime: const TimeOfDay(hour: 9, minute: 0),
        instructions: 'Check blood pressure and record readings',
        recurring: true,
      );
    } else if (condition.toLowerCase().contains('heart')) {
      await addHealthCheckReminder(
        dependentId: dependent.id,
        dependentName: dependent.name,
        checkType: 'Heart Rate Check',
        scheduledTime: const TimeOfDay(hour: 8, minute: 0),
        instructions: 'Monitor heart rate and any symptoms',
        recurring: true,
      );
    }
  }

  /// Add age-specific reminders
  Future<void> _addAgeSpecificReminders(DependentProfile dependent) async {
    final age = dependent.age;

    if (age >= 65) {
      // Elderly care reminders
      await addHealthCheckReminder(
        dependentId: dependent.id,
        dependentName: dependent.name,
        checkType: 'Daily Wellness Check',
        scheduledTime: const TimeOfDay(hour: 10, minute: 0),
        instructions: 'Check overall wellbeing, ask about pain or discomfort',
        recurring: true,
      );
    } else if (age <= 12) {
      // Child care reminders
      await addHealthCheckReminder(
        dependentId: dependent.id,
        dependentName: dependent.name,
        checkType: 'Child Wellness Check',
        scheduledTime: const TimeOfDay(hour: 19, minute: 0),
        instructions: 'Check temperature, appetite, and overall activity',
        recurring: true,
      );
    }
  }

  /// Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Format duration for display
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
  }

  /// Save reminders to local storage
  Future<void> _saveReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final remindersJson = _activeReminders.map((r) => r.toJson()).toList();
      await prefs.setString('caregiver_reminders', jsonEncode(remindersJson));
    } catch (e) {
      print('Error saving reminders: $e');
    }
  }

  /// Save alerts to local storage
  Future<void> _saveAlerts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final alertsJson = _activeAlerts.map((a) => a.toJson()).toList();
      await prefs.setString('caregiver_alerts', jsonEncode(alertsJson));
    } catch (e) {
      print('Error saving alerts: $e');
    }
  }

  /// Load saved reminders from local storage
  Future<void> _loadSavedReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final remindersString = prefs.getString('caregiver_reminders');
      final alertsString = prefs.getString('caregiver_alerts');

      if (remindersString != null) {
        final remindersJson = jsonDecode(remindersString) as List;
        _activeReminders.clear();
        _activeReminders.addAll(
          remindersJson
              .map((json) => CaregiverReminder.fromJson(json))
              .toList(),
        );
      }

      if (alertsString != null) {
        final alertsJson = jsonDecode(alertsString) as List;
        _activeAlerts.clear();
        _activeAlerts.addAll(
          alertsJson.map((json) => CaregiverAlert.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      print('Error loading saved reminders: $e');
    }
  }
}

/// Caregiver reminder model
class CaregiverReminder {
  final String id;
  final ReminderType type;
  final String dependentId;
  final String dependentName;
  final String title;
  final String message;
  final TimeOfDay scheduledTime;
  final DateTime? scheduledDate;
  final bool recurring;
  final List<int> weekdays;
  final bool isActive;
  final Map<String, dynamic> metadata;

  CaregiverReminder({
    required this.id,
    required this.type,
    required this.dependentId,
    required this.dependentName,
    required this.title,
    required this.message,
    required this.scheduledTime,
    this.scheduledDate,
    this.recurring = false,
    this.weekdays = const [1, 2, 3, 4, 5, 6, 7],
    this.isActive = true,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'dependentId': dependentId,
      'dependentName': dependentName,
      'title': title,
      'message': message,
      'scheduledTimeHour': scheduledTime.hour,
      'scheduledTimeMinute': scheduledTime.minute,
      'scheduledDate': scheduledDate?.toIso8601String(),
      'recurring': recurring,
      'weekdays': weekdays,
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  factory CaregiverReminder.fromJson(Map<String, dynamic> json) {
    return CaregiverReminder(
      id: json['id'],
      type: ReminderType.values[json['type']],
      dependentId: json['dependentId'],
      dependentName: json['dependentName'],
      title: json['title'],
      message: json['message'],
      scheduledTime: TimeOfDay(
        hour: json['scheduledTimeHour'],
        minute: json['scheduledTimeMinute'],
      ),
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'])
          : null,
      recurring: json['recurring'] ?? false,
      weekdays: List<int>.from(json['weekdays'] ?? [1, 2, 3, 4, 5, 6, 7]),
      isActive: json['isActive'] ?? true,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// Caregiver alert model
class CaregiverAlert {
  final String id;
  final String dependentId;
  final String dependentName;
  final String title;
  final String message;
  final AlertSeverity severity;
  final DateTime timestamp;
  final bool isRead;
  final String? actionRequired;
  final Map<String, dynamic> metadata;

  CaregiverAlert({
    required this.id,
    required this.dependentId,
    required this.dependentName,
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.isRead = false,
    this.actionRequired,
    this.metadata = const {},
  });

  CaregiverAlert copyWith({
    String? id,
    String? dependentId,
    String? dependentName,
    String? title,
    String? message,
    AlertSeverity? severity,
    DateTime? timestamp,
    bool? isRead,
    String? actionRequired,
    Map<String, dynamic>? metadata,
  }) {
    return CaregiverAlert(
      id: id ?? this.id,
      dependentId: dependentId ?? this.dependentId,
      dependentName: dependentName ?? this.dependentName,
      title: title ?? this.title,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionRequired: actionRequired ?? this.actionRequired,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dependentId': dependentId,
      'dependentName': dependentName,
      'title': title,
      'message': message,
      'severity': severity.index,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'actionRequired': actionRequired,
      'metadata': metadata,
    };
  }

  factory CaregiverAlert.fromJson(Map<String, dynamic> json) {
    return CaregiverAlert(
      id: json['id'],
      dependentId: json['dependentId'],
      dependentName: json['dependentName'],
      title: json['title'],
      message: json['message'],
      severity: AlertSeverity.values[json['severity']],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      actionRequired: json['actionRequired'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

/// Reminder types
enum ReminderType { medication, appointment, healthCheck, general }

/// Alert severity levels
enum AlertSeverity { low, medium, high, critical }

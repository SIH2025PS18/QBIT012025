import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for handling Supabase Edge Functions
class SupabaseFunctionsService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Send SMS notification via Edge Function
  static Future<Map<String, dynamic>> sendSMSNotification({
    required String phoneNumber,
    required String message,
    required String type, // 'appointment_reminder', 'prescription_ready', etc.
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'send-sms',
        body: {
          'phone_number': phoneNumber,
          'message': message,
          'type': type,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to send SMS: $e');
    }
  }

  /// Send email notification via Edge Function
  static Future<Map<String, dynamic>> sendEmailNotification({
    required String email,
    required String subject,
    required String htmlContent,
    required String type,
    Map<String, dynamic>? templateData,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'send-email',
        body: {
          'email': email,
          'subject': subject,
          'html_content': htmlContent,
          'type': type,
          'template_data': templateData,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to send email: $e');
    }
  }

  /// Generate prescription PDF via Edge Function
  static Future<Map<String, dynamic>> generatePrescriptionPDF({
    required String appointmentId,
    required Map<String, dynamic> prescriptionData,
    required Map<String, dynamic> doctorInfo,
    required Map<String, dynamic> patientInfo,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'generate-prescription',
        body: {
          'appointment_id': appointmentId,
          'prescription_data': prescriptionData,
          'doctor_info': doctorInfo,
          'patient_info': patientInfo,
          'generated_at': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to generate prescription PDF: $e');
    }
  }

  /// Analyze symptoms using AI via Edge Function
  static Future<Map<String, dynamic>> analyzeSymptoms({
    required List<String> symptoms,
    required String age,
    required String gender,
    String? medicalHistory,
    String? currentMedications,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'analyze-symptoms',
        body: {
          'symptoms': symptoms,
          'patient_data': {
            'age': age,
            'gender': gender,
            'medical_history': medicalHistory,
            'current_medications': currentMedications,
          },
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to analyze symptoms: $e');
    }
  }

  /// Send appointment reminders via Edge Function
  static Future<Map<String, dynamic>> sendAppointmentReminder({
    required String appointmentId,
    required String reminderType, // '24h', '1h', '15m'
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'appointment-reminder',
        body: {
          'appointment_id': appointmentId,
          'reminder_type': reminderType,
          'sent_at': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to send appointment reminder: $e');
    }
  }

  /// Process payment via Edge Function
  static Future<Map<String, dynamic>> processPayment({
    required String paymentMethod,
    required double amount,
    required String currency,
    required String appointmentId,
    Map<String, dynamic>? paymentDetails,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'process-payment',
        body: {
          'payment_method': paymentMethod,
          'amount': amount,
          'currency': currency,
          'appointment_id': appointmentId,
          'payment_details': paymentDetails,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  /// Generate health report via Edge Function
  static Future<Map<String, dynamic>> generateHealthReport({
    required String patientId,
    required DateTime startDate,
    required DateTime endDate,
    required String reportType, // 'summary', 'detailed', 'prescription_history'
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'generate-health-report',
        body: {
          'patient_id': patientId,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          'report_type': reportType,
          'generated_at': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to generate health report: $e');
    }
  }

  /// Translate text via Edge Function
  static Future<Map<String, dynamic>> translateText({
    required String text,
    required String fromLanguage,
    required String toLanguage,
    String? context, // 'medical', 'general'
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'translate-text',
        body: {
          'text': text,
          'from_language': fromLanguage,
          'to_language': toLanguage,
          'context': context,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to translate text: $e');
    }
  }

  /// Validate prescription via Edge Function
  static Future<Map<String, dynamic>> validatePrescription({
    required Map<String, dynamic> prescriptionData,
    required String patientId,
    Map<String, dynamic>? patientAllergies,
    List<String>? currentMedications,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'validate-prescription',
        body: {
          'prescription_data': prescriptionData,
          'patient_id': patientId,
          'patient_allergies': patientAllergies,
          'current_medications': currentMedications,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to validate prescription: $e');
    }
  }

  /// Send emergency alert via Edge Function
  static Future<Map<String, dynamic>> sendEmergencyAlert({
    required String patientId,
    required String alertType,
    required Map<String, dynamic> locationData,
    required List<String> emergencyContacts,
    String? additionalInfo,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'emergency-alert',
        body: {
          'patient_id': patientId,
          'alert_type': alertType,
          'location_data': locationData,
          'emergency_contacts': emergencyContacts,
          'additional_info': additionalInfo,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to send emergency alert: $e');
    }
  }
}

/// Utility class for generating consistent channel IDs between patient and doctor apps
class ChannelUtils {
  /// Generate a consistent channel ID based on call ID or patient/doctor IDs
  static String generateChannelId({
    String? callId,
    String? patientId,
    String? doctorId,
  }) {
    // Use call ID if available (most reliable)
    if (callId != null && callId.isNotEmpty) {
      return 'call_$callId';
    }

    // Fallback to patient+doctor combination
    if (patientId != null && doctorId != null) {
      // Sort IDs to ensure consistent order regardless of who generates the channel
      final ids = [patientId, doctorId]..sort();
      return 'consultation_${ids[0]}_${ids[1]}';
    }

    // Last resort - timestamp-based (should be avoided)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'temp_$timestamp';
  }

  /// Generate consultation channel ID for a specific consultation
  static String generateConsultationChannelId(String consultationId) {
    return 'consultation_$consultationId';
  }

  /// Generate emergency channel ID
  static String generateEmergencyChannelId(String patientId) {
    return 'emergency_$patientId';
  }

  /// Validate channel ID format
  static bool isValidChannelId(String channelId) {
    // Channel ID should be 1-64 characters, alphanumeric with underscores
    final regex = RegExp(r'^[a-zA-Z0-9_]{1,64}$');
    return regex.hasMatch(channelId);
  }

  /// Extract components from channel ID
  static Map<String, String?> parseChannelId(String channelId) {
    final parts = channelId.split('_');

    if (parts.length >= 2) {
      final type = parts[0];
      final id = parts.sublist(1).join('_');

      return {
        'type': type,
        'id': id,
      };
    }

    return {'type': 'unknown', 'id': channelId};
  }
}

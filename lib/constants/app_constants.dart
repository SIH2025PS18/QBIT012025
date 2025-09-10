// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'TeleMed';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'https://your-api-endpoint.com';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userProfileKey = 'user_profile';
  static const String languageKey = 'selected_language';

  // Database Tables
  static const String profilesTable = 'profiles';
  static const String appointmentsTable = 'appointments';
  static const String doctorsTable = 'doctors';
  static const String healthRecordsTable = 'health_records';

  // File Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Languages
  static const String defaultLanguage = 'en';
  static const List<String> supportedLanguages = ['en', 'hi', 'pa'];

  // Medical Categories
  static const List<String> medicalSpecializations = [
    'General Medicine',
    'Cardiology',
    'Dermatology',
    'Gynecology',
    'Pediatrics',
    'Orthopedics',
    'Neurology',
    'Psychiatry',
    'Ophthalmology',
    'ENT',
  ];

  // Appointment Status
  static const String appointmentScheduled = 'scheduled';
  static const String appointmentCompleted = 'completed';
  static const String appointmentCancelled = 'cancelled';
  static const String appointmentInProgress = 'in_progress';

  // Error Messages
  static const String networkError = 'Network connection failed';
  static const String serverError = 'Server error occurred';
  static const String authError = 'Authentication failed';
  static const String validationError = 'Validation failed';
}

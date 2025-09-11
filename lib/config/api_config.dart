/// API Configuration for Telemedicine Backend
class ApiConfig {
  // Base URL for the main telemedicine backend
  static const String baseUrl = 'http://localhost:5001/api';

  // WebSocket URL for real-time features
  static const String socketUrl = 'http://localhost:5001';

  // API Endpoints
  static const String auth = '/auth';
  static const String doctors = '/doctors';
  static const String patients = '/patients';
  static const String consultations = '/consultations';

  // Full endpoint URLs
  static String get authLogin => '$baseUrl$auth/login';
  static String get authRegister => '$baseUrl$auth/register';
  static String get authDoctorRegister => '$baseUrl$auth/doctor/register';
  static String get authPatientRegister => '$baseUrl$auth/patient/register';
  static String get authProfile => '$baseUrl$auth/profile';
  static String get authChangePassword => '$baseUrl$auth/change-password';
  static String get authLogout => '$baseUrl$auth/logout';

  static String get doctorsList => '$baseUrl$doctors';
  static String get doctorsAvailable => '$baseUrl$doctors/available';
  static String get doctorsProfile => '$baseUrl$doctors/profile';
  static String get doctorsStatus => '$baseUrl$doctors/status';
  static String get doctorsConsultations => '$baseUrl$doctors/consultations/my';
  static String get doctorsSchedule => '$baseUrl$doctors/schedule/today';
  static String get doctorsStats => '$baseUrl$doctors/stats/dashboard';

  static String get patientsProfile => '$baseUrl$patients/profile';
  static String get patientsVitals => '$baseUrl$patients/vitals';
  static String get patientsConsultations => '$baseUrl$patients/consultations';
  static String get patientsQueue => '$baseUrl$patients/queue/status';
  static String get patientsStats => '$baseUrl$patients/dashboard/stats';

  static String get consultationsBook => '$baseUrl$consultations/book';
  static String consultationDetails(String id) => '$baseUrl$consultations/$id';
  static String consultationStart(String id) =>
      '$baseUrl$consultations/$id/start';
  static String consultationEnd(String id) => '$baseUrl$consultations/$id/end';
  static String consultationCancel(String id) =>
      '$baseUrl$consultations/$id/cancel';
  static String consultationChat(String id) =>
      '$baseUrl$consultations/$id/chat';
  static String consultationFeedback(String id) =>
      '$baseUrl$consultations/$id/feedback';

  // Helper method to get doctor by ID
  static String doctorById(String id) => '$baseUrl$doctors/$id';

  // Helper method to get available doctors by speciality
  static String availableDoctorsBySpeciality(String speciality) =>
      '$baseUrl$doctors/available/$speciality';

  // Helper method to get doctor queue
  static String doctorQueue(String doctorId) =>
      '$baseUrl$consultations/queue/doctor/$doctorId';
}

/// Environment configuration
class EnvConfig {
  // Development/Production flag
  static const bool isDevelopment = true;

  // API timeout settings
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration socketTimeout = Duration(seconds: 10);

  // Retry settings
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}

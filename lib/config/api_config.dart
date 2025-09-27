/// API Configuration for Telemedicine Backend
class ApiConfig {
  // Base API URL - can be configured via environment variables
  static String get baseUrl {
    // FORCE LOCAL DEVELOPMENT - Override for testing
    // TODO: Change this for production builds
    return 'https://telemed18.onrender.com || https://telemed18.onrender.com/api';
  }

  // WebSocket URL for real-time features
  static String get socketUrl {
    // FORCE LOCAL DEVELOPMENT - Override for testing
    // TODO: Change this for production builds
    return 'https://telemed18.onrender.com';
  }

  // API Endpoints
  static const String auth = '/auth';
  static const String doctors = '/doctors';
  static const String patients = '/patients';
  static const String appointments = '/appointments';
  static const String consultations = '/consultations';
  static const String prescriptions = '/prescriptions';
  static const String medicalRecords = '/medical-records';
  static const String videoCall = '/video-call';
  static const String chat = '/chat';
  static const String notifications = '/notifications';
  static const String admin = '/admin';

  // Auth endpoints
  static const String authLogin = '$auth/login';
  static const String authProfile = '$auth/profile';
  static const String authPatientRegister = '$auth/patient/register';
  static const String authDoctorRegister = '$auth/doctor/register';
  static const String authChangePassword = '$auth/change-password';
  static const String authLogout = '$auth/logout';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String refresh = '$auth/refresh';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';
  static const String verifyEmail = '$auth/verify-email';
  static const String resendVerification = '$auth/resend-verification';

  // Doctor endpoints
  static const String doctorProfile = '$doctors/profile';
  static const String doctorAvailability = '$doctors/availability';
  static const String doctorsList = '$doctors';
  static const String doctorsAvailable = '$doctors/available';
  static const String doctorsLive =
      '$doctors/live'; // New endpoint for live/online doctors
  static const String doctorsProfile = '$doctors/profile';
  static const String doctorsStatus = '$doctors/status';
  static const String doctorsConsultations = '$doctors/consultations';
  static const String doctorsSchedule = '$doctors/schedule';
  static const String doctorsStats = '$doctors/stats';

  // Doctor by ID endpoint method
  static String doctorById(String id) => '$doctors/$id';
  static String availableDoctorsBySpeciality(String speciality) =>
      '$doctors/available?speciality=$speciality';
  static const String doctorSchedule = '$doctors/schedule';

  // Patient endpoints
  static const String patientProfile = '$patients/profile';
  static const String patientMedicalHistory = '$patients/medical-history';

  // Appointment endpoints
  static const String bookAppointment = '$appointments/book';
  static const String cancelAppointment = '$appointments/cancel';
  static const String rescheduleAppointment = '$appointments/reschedule';

  // Video consultation endpoints
  static const String startConsultation = '$consultations/start';
  static const String endConsultation = '$consultations/end';
  static const String joinConsultation = '$consultations/join';

  // File upload endpoints
  static const String uploadAvatar = '/upload/avatar';
  static const String uploadDocument = '/upload/document';
  static const String uploadPrescription = '/upload/prescription';

  // Admin endpoints
  static const String adminDashboard = '$admin/dashboard';
  static const String adminUsers = '$admin/users';
  static const String adminStats = '$admin/stats';

  // Request timeout configurations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Get authorization header
  static Map<String, String> getAuthHeaders(String token) {
    return {...defaultHeaders, 'Authorization': 'Bearer $token'};
  }

  // Environment check
  static bool get isProduction {
    const environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );
    return environment == 'production';
  }

  static bool get isDevelopment => !isProduction;

  // Logging configuration
  static bool get enableLogging => isDevelopment;

  // API version
  static const String apiVersion = 'v1';

  // Full API URL with version
  static String get apiUrl => '$baseUrl/$apiVersion';
}

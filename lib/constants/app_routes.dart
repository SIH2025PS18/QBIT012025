// Route name constants for navigation
class AppRoutes {
  // Authentication Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Main App Routes
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String medicalDetails = '/medical-details';

  // Doctor Routes
  static const String doctorList = '/doctors';
  static const String doctorProfile = '/doctor-profile';
  static const String doctorSearch = '/doctor-search';

  // Appointment Routes
  static const String appointments = '/appointments';
  static const String appointmentBooking = '/appointment-booking';
  static const String appointmentDetails = '/appointment-details';
  static const String appointmentHistory = '/appointment-history';

  // Health Records Routes
  static const String healthRecords = '/health-records';
  static const String addHealthRecord = '/add-health-record';
  static const String viewHealthRecord = '/view-health-record';
  static const String editHealthRecord = '/edit-health-record';

  // Medical Routes
  static const String prescriptions = '/prescriptions';
  static const String medications = '/medications';
  static const String allergies = '/allergies';
  static const String immunizations = '/immunizations';

  // Consultation Routes
  static const String videoCall = '/video-call';
  static const String chat = '/chat';
  static const String consultation = '/consultation';

  // Settings Routes
  static const String settings = '/settings';
  static const String language = '/language';
  static const String notifications = '/notifications';
  static const String privacy = '/privacy';
  static const String about = '/about';

  // Emergency Routes
  static const String emergency = '/emergency';
  static const String emergencyContacts = '/emergency-contacts';

  // Utility Routes
  static const String networkTroubleshoot = '/network-troubleshoot';
  static const String offline = '/offline';
  static const String maintenance = '/maintenance';
  static const String symptomChat = '/symptom-chat';

  // Admin Routes (Future Use)
  static const String adminDashboard = '/admin';
  static const String userManagement = '/admin/users';
  static const String systemSettings = '/admin/settings';
}

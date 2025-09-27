/// Environment configuration for the Telemedicine app
class EnvConfig {
  // Base URLs
  static const String baseUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://192.168.1.7:5002',
  );

  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://192.168.1.7:5002',
  );

  // Environment
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  // API Configuration
  static const String apiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );

  // Security keys
  static const String jwtSecret = String.fromEnvironment(
    'JWT_SECRET',
    defaultValue: 'dev-secret-key',
  );

  // Database Configuration
  static const String dbHost = String.fromEnvironment(
    'DB_HOST',
    defaultValue: 'localhost',
  );

  static const String dbPort = String.fromEnvironment(
    'DB_PORT',
    defaultValue: '27017',
  );

  static const String dbName = String.fromEnvironment(
    'DB_NAME',
    defaultValue: 'telemedicine',
  );

  // External Services
  static const String agoraAppId = String.fromEnvironment(
    'AGORA_APP_ID',
    defaultValue: '98d3fa37dec44dc1950b071e3482cfae',
  );

  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );

  // Feature Flags
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get enableLogging => isDevelopment;
  static bool get enableAnalytics => isProduction;

  // API URLs
  static String get apiUrl => '$baseUrl/api/$apiVersion';
  static String get wsUrl => socketUrl.replaceFirst('http', 'ws');

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

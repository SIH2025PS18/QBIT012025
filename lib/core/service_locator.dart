import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../database/local_database.dart';
import '../database/offline_database.dart';
import '../repositories/patient_profile_repository.dart';
import '../repositories/offline_patient_profile_repository.dart';
import '../repositories/offline_appointment_repository.dart';
import '../repositories/offline_health_record_repository.dart';
import '../services/phone_auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import '../services/image_upload_service.dart';
import '../services/todo_service.dart'; // Add this import
import '../utils/network_utils.dart';
import '../providers/auth_provider.dart';
import '../providers/patient_profile_provider.dart';
import '../providers/language_provider.dart';

/// Service locator for dependency injection
/// This allows for easy testing and swapping of implementations
final GetIt serviceLocator = GetIt.instance;

/// Create the database connection with error handling for schema migrations
Future<LocalDatabase> _createLocalDatabase() async {
  try {
    return LocalDatabase();
  } catch (e) {
    // If there's a schema migration error, we'll delete the database file and recreate it
    if (e.toString().contains('schema version')) {
      print('Database schema mismatch detected. Recreating database...');
      try {
        // Get the database file path
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'telemed_local.db'));

        // Delete the existing database file
        if (await file.exists()) {
          await file.delete();
          print('Old database file deleted successfully.');
        }
      } catch (deleteError) {
        print('Error deleting database file: $deleteError');
      }

      // Try to create the database again
      return LocalDatabase();
    } else {
      // Re-throw the error if it's not a schema migration issue
      rethrow;
    }
  }
}

/// Create the offline database connection with error handling for schema migrations
Future<OfflineDatabase> _createOfflineDatabase() async {
  try {
    return OfflineDatabase();
  } catch (e) {
    // If there's a schema migration error, we'll delete the database file and recreate it
    if (e.toString().contains('schema version')) {
      print(
        'Offline database schema mismatch detected. Recreating database...',
      );
      try {
        // Get the database file path
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, 'telemed_offline.db'));

        // Delete the existing database file
        if (await file.exists()) {
          await file.delete();
          print('Old offline database file deleted successfully.');
        }
      } catch (deleteError) {
        print('Error deleting offline database file: $deleteError');
      }

      // Try to create the database again
      return OfflineDatabase();
    } else {
      // Re-throw the error if it's not a schema migration issue
      rethrow;
    }
  }
}

/// Initialize all services and dependencies
Future<void> initializeServiceLocator() async {
  // Database with error handling
  serviceLocator.registerLazySingletonAsync<LocalDatabase>(() async {
    return await _createLocalDatabase();
  });

  // Offline Database with error handling
  serviceLocator.registerLazySingletonAsync<OfflineDatabase>(() async {
    return await _createOfflineDatabase();
  });

  // Core Services
  serviceLocator.registerLazySingleton<NetworkUtils>(() => NetworkUtils());
  serviceLocator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );
  serviceLocator.registerLazySingleton<SyncService>(() => SyncService());

  // Authentication Services
  serviceLocator.registerLazySingleton<PhoneAuthService>(
    () => PhoneAuthService(),
  );

  // Repositories (Offline-first implementations)
  serviceLocator.registerLazySingleton<PatientProfileRepository>(
    () => OfflinePatientProfileRepository(),
  );
  serviceLocator.registerLazySingleton<AppointmentRepository>(
    () => OfflineAppointmentRepository(),
  );
  serviceLocator.registerLazySingleton<HealthRecordRepository>(
    () => OfflineHealthRecordRepository(),
  );

  // Other Services
  serviceLocator.registerLazySingleton<ImageUploadService>(
    () => ImageUploadService(),
  );
  serviceLocator.registerLazySingleton<TodoService>(
    // Add this line
    () => TodoService(),
  );

  // Providers (as singletons for state management)
  serviceLocator.registerLazySingleton<AuthProvider>(() => AuthProvider());
  serviceLocator.registerLazySingleton<PatientProfileProvider>(
    () => PatientProfileProvider(),
  );
  serviceLocator.registerLazySingleton<LanguageProvider>(
    () => LanguageProvider(),
  );

  // Initialize core services first
  await serviceLocator<ConnectivityService>().initialize();
  await serviceLocator<SyncService>().initialize();

  // Initialize providers
  await serviceLocator<AuthProvider>().initialize();
  await serviceLocator<LanguageProvider>().initializeLanguage();
}

/// Reset service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await serviceLocator.reset();
}

/// Get a service from the locator
T getService<T extends Object>() {
  return serviceLocator<T>();
}

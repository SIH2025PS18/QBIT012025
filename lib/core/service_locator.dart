import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
// import 'package:drift/drift.dart'; // Commented out for web compatibility
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:path_provider/path_provider.dart' if (dart.library.html) 'package:universal_html/html.dart';
import 'package:path/path.dart' as p;

import '../database/local_database.dart' if (dart.library.html) '../utils/web_stub.dart';
import '../database/offline_database.dart' if (dart.library.html) '../utils/web_stub.dart';
import '../repositories/patient_profile_repository.dart';
import '../repositories/offline_patient_profile_repository.dart' if (dart.library.html) '../utils/web_stub.dart';
import '../repositories/offline_appointment_repository.dart' if (dart.library.html) '../utils/web_stub.dart';
import '../repositories/offline_health_record_repository.dart' if (dart.library.html) '../utils/web_stub.dart';
import '../services/phone_auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart' if (dart.library.html) '../utils/web_stub.dart';
import '../services/image_upload_service.dart';
import '../services/todo_service.dart' if (dart.library.html) '../utils/web_stub.dart';
import '../utils/network_utils.dart';
import '../providers/auth_provider.dart';
import '../providers/patient_profile_provider.dart';
import '../providers/language_provider.dart';

/// Service locator for dependency injection
/// This allows for easy testing and swapping of implementations
final GetIt serviceLocator = GetIt.instance;

/// Create the database connection with error handling for schema migrations (mobile only)
Future<dynamic> _createLocalDatabase() async {
  if (kIsWeb) {
    print('🌐 Web platform: Skipping database creation');
    return null;
  }
  
  try {
    return LocalDatabase();
  } catch (e) {
    print('❌ Error creating local database: $e');
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

/// Create the offline database connection with error handling for schema migrations (mobile only)
Future<dynamic> _createOfflineDatabase() async {
  if (kIsWeb) {
    print('🌐 Web platform: Skipping offline database creation');
    return null;
  }
  
  try {
    return OfflineDatabase();
  } catch (e) {
    print('❌ Error creating offline database: $e');
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
  print('🔧 Initializing service locator for ${kIsWeb ? 'Web' : 'Mobile'} platform...');
  
  try {
    // Database with error handling (mobile only)
    if (!kIsWeb) {
      print('📱 Registering databases for mobile platform...');
      serviceLocator.registerLazySingletonAsync<LocalDatabase>(() async {
        return await _createLocalDatabase();
      });

      serviceLocator.registerLazySingletonAsync<OfflineDatabase>(() async {
        return await _createOfflineDatabase();
      });
      print('✅ Databases registered');
    }

    // Core Services (platform-independent)
    print('🌐 Registering core services...');
    serviceLocator.registerLazySingleton<NetworkUtils>(() => NetworkUtils());
    serviceLocator.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService(),
    );
    print('✅ Core services registered');

    // Platform-specific services
    if (!kIsWeb) {
      print('📱 Registering mobile-specific services...');
      serviceLocator.registerLazySingleton<SyncService>(() => SyncService());
      serviceLocator.registerLazySingleton<TodoService>(() => TodoService());
      print('✅ Mobile services registered');
    }

    // Authentication Services (platform-independent)
    print('🔐 Registering auth services...');
    serviceLocator.registerLazySingleton<PhoneAuthService>(
      () => PhoneAuthService(),
    );
    print('✅ Auth services registered');

    // Repositories (mobile only)
    if (!kIsWeb) {
      print('📱 Registering repositories for mobile platform...');
      serviceLocator.registerLazySingleton<PatientProfileRepository>(
        () => OfflinePatientProfileRepository(),
      );
      serviceLocator.registerLazySingleton<AppointmentRepository>(
        () => OfflineAppointmentRepository(),
      );
      serviceLocator.registerLazySingleton<HealthRecordRepository>(
        () => OfflineHealthRecordRepository(),
      );
      print('✅ Repositories registered');
    }

    // Other Services (platform-independent)
    print('🛠️ Registering additional services...');
    serviceLocator.registerLazySingleton<ImageUploadService>(
      () => ImageUploadService(),
    );
    print('✅ Additional services registered');

    // Providers (as singletons for state management)
    print('🎯 Registering providers...');
    serviceLocator.registerLazySingleton<AuthProvider>(() => AuthProvider());
    serviceLocator.registerLazySingleton<PatientProfileProvider>(
      () => PatientProfileProvider(),
    );
    serviceLocator.registerLazySingleton<LanguageProvider>(
      () => LanguageProvider(),
    );
    print('✅ Providers registered');

    // Initialize core services first
    print('🚀 Initializing core services...');
    await serviceLocator<ConnectivityService>().initialize();
    print('✅ Connectivity service initialized');
    
    if (!kIsWeb) {
      await serviceLocator<SyncService>().initialize();
      print('✅ Sync service initialized');
    }

    // Initialize providers
    print('🎯 Initializing providers...');
    await serviceLocator<AuthProvider>().initialize();
    await serviceLocator<LanguageProvider>().initializeLanguage();
    print('✅ Providers initialized');
    
    print('🎉 Service locator initialization completed successfully!');
  } catch (e, stackTrace) {
    print('❌ Error during service locator initialization: $e');
    print('📍 Stack trace: $stackTrace');
    rethrow;
  }
}

/// Reset service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await serviceLocator.reset();
}

/// Get a service from the locator
T getService<T extends Object>() {
  return serviceLocator<T>();
}

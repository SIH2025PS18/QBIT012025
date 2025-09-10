import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:typed_data';

/// Service for handling Supabase Storage operations
class SupabaseStorageService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Storage bucket names
  static const String profilePhotosBucket = 'profile-photos';
  static const String medicalDocumentsBucket = 'medical-documents';
  static const String prescriptionsBucket = 'prescriptions';
  static const String appointmentsBucket = 'appointment-attachments';

  /// Initialize storage buckets (call this during app setup)
  static Future<void> initializeStorage() async {
    try {
      // Create buckets if they don't exist
      await _createBucketIfNotExists(profilePhotosBucket, true);
      await _createBucketIfNotExists(medicalDocumentsBucket, false);
      await _createBucketIfNotExists(prescriptionsBucket, false);
      await _createBucketIfNotExists(appointmentsBucket, false);
    } catch (e) {
      print('Error initializing storage: $e');
    }
  }

  /// Create a bucket if it doesn't exist
  static Future<void> _createBucketIfNotExists(
    String bucketName,
    bool isPublic,
  ) async {
    try {
      await _supabase.storage.createBucket(
        bucketName,
        BucketOptions(public: isPublic),
      );
      print('Created bucket: $bucketName');
    } catch (e) {
      // Bucket might already exist, which is fine
      print('Bucket $bucketName might already exist: $e');
    }
  }

  /// Upload profile photo
  static Future<String> uploadProfilePhoto(
    String filePath,
    String userId,
  ) async {
    try {
      final file = File(filePath);
      final fileExt = file.path.split('.').last;
      final fileName = 'profile_$userId.${fileExt.toLowerCase()}';

      await _supabase.storage.from(profilePhotosBucket).upload(fileName, file);

      // Get public URL
      final publicUrl = _supabase.storage
          .from(profilePhotosBucket)
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  /// Upload medical document
  static Future<String> uploadMedicalDocument(
    String filePath,
    String userId,
    String documentType,
  ) async {
    try {
      final file = File(filePath);
      final fileExt = file.path.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName =
          '${userId}/${documentType}_$timestamp.${fileExt.toLowerCase()}';

      await _supabase.storage
          .from(medicalDocumentsBucket)
          .upload(fileName, file);

      // Generate signed URL for private access
      final signedUrl = await _supabase.storage
          .from(medicalDocumentsBucket)
          .createSignedUrl(fileName, 60 * 60 * 24 * 365); // 1 year expiry

      return signedUrl;
    } catch (e) {
      throw Exception('Failed to upload medical document: $e');
    }
  }

  /// Upload prescription
  static Future<String> uploadPrescription(
    String filePath,
    String userId,
    String appointmentId,
  ) async {
    try {
      final file = File(filePath);
      final fileExt = file.path.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName =
          '${userId}/prescriptions/${appointmentId}_$timestamp.${fileExt.toLowerCase()}';

      await _supabase.storage.from(prescriptionsBucket).upload(fileName, file);

      // Generate signed URL
      final signedUrl = await _supabase.storage
          .from(prescriptionsBucket)
          .createSignedUrl(fileName, 60 * 60 * 24 * 365);

      return signedUrl;
    } catch (e) {
      throw Exception('Failed to upload prescription: $e');
    }
  }

  /// Upload appointment attachment
  static Future<String> uploadAppointmentAttachment(
    String filePath,
    String userId,
    String appointmentId,
  ) async {
    try {
      final file = File(filePath);
      final fileExt = file.path.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName =
          '${userId}/appointments/${appointmentId}_$timestamp.${fileExt.toLowerCase()}';

      await _supabase.storage.from(appointmentsBucket).upload(fileName, file);

      // Generate signed URL
      final signedUrl = await _supabase.storage
          .from(appointmentsBucket)
          .createSignedUrl(fileName, 60 * 60 * 24 * 30); // 30 days expiry

      return signedUrl;
    } catch (e) {
      throw Exception('Failed to upload appointment attachment: $e');
    }
  }

  /// Upload from bytes (for web compatibility)
  static Future<String> uploadFromBytes(
    Uint8List bytes,
    String bucket,
    String fileName, {
    bool isPublic = false,
  }) async {
    try {
      await _supabase.storage.from(bucket).uploadBinary(fileName, bytes);

      if (isPublic) {
        return _supabase.storage.from(bucket).getPublicUrl(fileName);
      } else {
        return await _supabase.storage
            .from(bucket)
            .createSignedUrl(fileName, 60 * 60 * 24 * 365);
      }
    } catch (e) {
      throw Exception('Failed to upload from bytes: $e');
    }
  }

  /// Delete file from storage
  static Future<void> deleteFile(String bucket, String fileName) async {
    try {
      await _supabase.storage.from(bucket).remove([fileName]);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Delete profile photo
  static Future<void> deleteProfilePhoto(String userId) async {
    try {
      // Try different extensions
      final extensions = ['jpg', 'jpeg', 'png', 'gif'];
      for (final ext in extensions) {
        try {
          await deleteFile(profilePhotosBucket, 'profile_$userId.$ext');
        } catch (e) {
          // File might not exist with this extension, continue
        }
      }
    } catch (e) {
      throw Exception('Failed to delete profile photo: $e');
    }
  }

  /// List files in a bucket (for admin purposes)
  static Future<List<FileObject>> listFiles(
    String bucket, {
    String? folder,
  }) async {
    try {
      final files = await _supabase.storage.from(bucket).list(path: folder);
      return files;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  /// Get file size
  static Future<int> getFileSize(String bucket, String fileName) async {
    try {
      final files = await _supabase.storage.from(bucket).list();
      final file = files.firstWhere((f) => f.name == fileName);
      return file.metadata?['size'] ?? 0;
    } catch (e) {
      throw Exception('Failed to get file size: $e');
    }
  }

  /// Generate a new signed URL for an existing file
  static Future<String> generateSignedUrl(
    String bucket,
    String fileName,
    int expirySeconds,
  ) async {
    try {
      return await _supabase.storage
          .from(bucket)
          .createSignedUrl(fileName, expirySeconds);
    } catch (e) {
      throw Exception('Failed to generate signed URL: $e');
    }
  }
}

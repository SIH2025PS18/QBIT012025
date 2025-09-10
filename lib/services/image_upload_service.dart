import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _bucketName = 'profile-photos';

  /// Pick image from gallery or camera
  static Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// Upload profile photo to Supabase Storage
  static Future<String?> uploadProfilePhoto({
    required String userId,
    required XFile imageFile,
  }) async {
    try {
      debugPrint('🔄 Uploading profile photo for user: $userId');

      // Create unique filename
      final String fileName =
          'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = 'profiles/$fileName';

      // Read file bytes
      Uint8List fileBytes;
      if (kIsWeb) {
        fileBytes = await imageFile.readAsBytes();
      } else {
        final File file = File(imageFile.path);
        fileBytes = await file.readAsBytes();
      }

      // Upload to Supabase Storage
      await _supabase.storage
          .from(_bucketName)
          .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true, // Replace if exists
            ),
          );

      // Get public URL
      final String publicUrl = _supabase.storage
          .from(_bucketName)
          .getPublicUrl(filePath);

      debugPrint('✅ Profile photo uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      debugPrint('❌ Error uploading profile photo: $e');
      return null;
    }
  }

  /// Delete profile photo from storage
  static Future<bool> deleteProfilePhoto(String photoUrl) async {
    try {
      // Extract file path from URL
      final Uri uri = Uri.parse(photoUrl);
      final String filePath = uri.pathSegments
          .skip(2)
          .join('/'); // Skip bucket and storage path

      await _supabase.storage.from(_bucketName).remove([filePath]);

      debugPrint('✅ Profile photo deleted successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting profile photo: $e');
      return false;
    }
  }

  /// Show image picker options
  static Future<XFile?> showImagePickerOptions() async {
    try {
      // For web and mobile, we'll use gallery by default
      // In a real app, you might want to show a dialog to choose between camera and gallery
      return await pickImage(source: ImageSource.gallery);
    } catch (e) {
      debugPrint('Error in image picker: $e');
      return null;
    }
  }

  /// Validate image size and format
  static Future<bool> validateImage(XFile imageFile) async {
    try {
      final int fileSizeInBytes = await imageFile.length();
      const int maxSizeInBytes = 5 * 1024 * 1024; // 5MB limit

      if (fileSizeInBytes > maxSizeInBytes) {
        debugPrint('❌ Image too large: ${fileSizeInBytes / 1024 / 1024}MB');
        return false;
      }

      // Check file extension
      final String extension = imageFile.path.toLowerCase().split('.').last;
      const List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'webp'];

      if (!allowedExtensions.contains(extension)) {
        debugPrint('❌ Invalid image format: $extension');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('❌ Error validating image: $e');
      return false;
    }
  }

  /// Get image placeholder URL
  static String getPlaceholderImageUrl() {
    return 'https://via.placeholder.com/200x200/E0E0E0/757575?text=No+Photo';
  }

  /// Check if URL is a valid image URL
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final Uri uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}

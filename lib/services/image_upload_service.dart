import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';

class ImageUploadService {
  static const String _baseUrl = 'https://telemed18.onrender.com/api';
  static const String _uploadEndpoint = '/upload/profile-photo';

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

  /// Upload profile photo to MongoDB backend
  static Future<String?> uploadProfilePhoto({
    required String userId,
    required XFile imageFile,
  }) async {
    try {
      debugPrint('🔄 Uploading profile photo for user: $userId');

      // Create unique filename
      final String fileName =
          'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Read file bytes
      Uint8List fileBytes;
      if (kIsWeb) {
        fileBytes = await imageFile.readAsBytes();
      } else {
        final File file = File(imageFile.path);
        fileBytes = await file.readAsBytes();
      }

      // Save locally first (for offline support)
      final String? localPath = await _saveImageLocally(fileName, fileBytes);

      // Try to upload to backend
      try {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl$_uploadEndpoint'),
        );
        request.fields['userId'] = userId;
        request.files.add(
          http.MultipartFile.fromBytes('image', fileBytes, filename: fileName),
        );

        final response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final data = jsonDecode(responseData);
          final String photoUrl = data['photoUrl'];
          debugPrint('✅ Profile photo uploaded successfully: $photoUrl');
          return photoUrl;
        }
      } catch (e) {
        debugPrint('⚠️ Backend upload failed, using local path: $e');
      }

      // Fallback to local path
      return localPath;
    } catch (e) {
      debugPrint('❌ Error uploading profile photo: $e');
      return null;
    }
  }

  /// Save image locally for offline support
  static Future<String?> _saveImageLocally(
    String fileName,
    Uint8List fileBytes,
  ) async {
    try {
      if (kIsWeb) {
        // For web, return a data URL
        final String base64String = base64Encode(fileBytes);
        return 'data:image/jpeg;base64,$base64String';
      } else {
        // For mobile, save to app documents directory
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String filePath = '${appDir.path}/images/$fileName';
        final File file = File(filePath);

        // Create directory if it doesn't exist
        await file.parent.create(recursive: true);

        // Write file
        await file.writeAsBytes(fileBytes);
        return file.path;
      }
    } catch (e) {
      debugPrint('❌ Error saving image locally: $e');
      return null;
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

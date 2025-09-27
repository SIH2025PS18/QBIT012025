import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config/api_config.dart';
import '../services/auth_service.dart';

/// Service for managing patient profile operations
class PatientProfileService {
  // Use ApiConfig instead of hardcoded URL
  static String get _baseUrl => ApiConfig.baseUrl;

  /// Upload profile photo for a user
  static Future<String?> uploadProfilePhoto({
    required String userId,
    required XFile imageFile,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/patients/$userId/profile-photo');
      final request = http.MultipartRequest('POST', uri);

      // Add authentication header if available
      final authService = AuthService();
      final token = authService.authToken;
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add the image file
      final file = await http.MultipartFile.fromPath(
        'profilePhoto',
        imageFile.path,
      );
      request.files.add(file);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['profilePhotoUrl'] as String?;
      } else {
        print('Upload failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading profile photo: $e');
      return null;
    }
  }

  /// Remove profile photo
  static Future<bool> removeProfilePhoto() async {
    try {
      final authService = AuthService();
      final currentUser = await authService.getCurrentUser();

      if (currentUser == null) {
        return false;
      }

      final response = await http.delete(
        Uri.parse('$_baseUrl/patients/${currentUser.id}/profile-photo'),
        headers: {
          'Content-Type': 'application/json',
          if (authService.authToken != null)
            'Authorization': 'Bearer ${authService.authToken}',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error removing profile photo: $e');
      return false;
    }
  }

  /// Update profile photo URL in patient profile
  static Future<bool> updateProfilePhotoUrl({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      final authService = AuthService();
      final response = await http.patch(
        Uri.parse('$_baseUrl/patients/$userId'),
        headers: {
          'Content-Type': 'application/json',
          if (authService.authToken != null)
            'Authorization': 'Bearer ${authService.authToken}',
        },
        body: jsonEncode({'profilePhotoUrl': photoUrl}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating profile photo URL: $e');
      return false;
    }
  }
}

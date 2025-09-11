import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../utils/network_logger.dart';

/// Core API service for HTTP requests to the telemedicine backend
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio();
    _dio.options.connectTimeout = EnvConfig.apiTimeout;
    _dio.options.receiveTimeout = EnvConfig.apiTimeout;
    // Add logging interceptor
    _dio.interceptors.add(NetworkLogger.dioInterceptor);
  }

  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear authentication token
  void clearAuthToken() {
    _authToken = null;
    _dio.options.headers.remove('Authorization');
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final startTime = DateTime.now();

      final response = await _dio.get(endpoint, queryParameters: queryParams);

      final duration = DateTime.now().difference(startTime);

      NetworkLogger.logResponse(
        method: 'GET',
        url: endpoint,
        statusCode: response.statusCode ?? 0,
        headers: _convertHeaders(response.headers.map),
        body: response.data,
        duration: duration,
      );

      return _handleResponse<T>(response.data, fromJson);
    } on DioException catch (e) {
      _handleDioError(e);
      return ApiResponse.error(
        'Network error: ${e.message ?? e.error?.toString() ?? 'Unknown error'}',
      );
    } catch (e) {
      print('💥 Exception in ApiService.get: $e');
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      print('📡 ApiService POST request to: $endpoint');
      final startTime = DateTime.now();

      final response = await _dio.post(endpoint, data: body);

      final duration = DateTime.now().difference(startTime);

      NetworkLogger.logResponse(
        method: 'POST',
        url: endpoint,
        statusCode: response.statusCode ?? 0,
        headers: _convertHeaders(response.headers.map),
        body: response.data,
        duration: duration,
      );

      return _handleResponse<T>(response.data, fromJson);
    } on DioException catch (e) {
      _handleDioError(e);
      return ApiResponse.error(
        'Network error: ${e.message ?? e.error?.toString() ?? 'Unknown error'}',
      );
    } catch (e) {
      print('💥 Exception in ApiService.post: $e');
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final startTime = DateTime.now();

      final response = await _dio.put(endpoint, data: body);

      final duration = DateTime.now().difference(startTime);

      NetworkLogger.logResponse(
        method: 'PUT',
        url: endpoint,
        statusCode: response.statusCode ?? 0,
        headers: _convertHeaders(response.headers.map),
        body: response.data,
        duration: duration,
      );

      return _handleResponse<T>(response.data, fromJson);
    } on DioException catch (e) {
      _handleDioError(e);
      return ApiResponse.error(
        'Network error: ${e.message ?? e.error?.toString() ?? 'Unknown error'}',
      );
    } catch (e) {
      print('💥 Exception in ApiService.put: $e');
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final startTime = DateTime.now();

      final response = await _dio.delete(endpoint);

      final duration = DateTime.now().difference(startTime);

      NetworkLogger.logResponse(
        method: 'DELETE',
        url: endpoint,
        statusCode: response.statusCode ?? 0,
        headers: _convertHeaders(response.headers.map),
        body: response.data,
        duration: duration,
      );

      return _handleResponse<T>(response.data, fromJson);
    } on DioException catch (e) {
      _handleDioError(e);
      return ApiResponse.error(
        'Network error: ${e.message ?? e.error?.toString() ?? 'Unknown error'}',
      );
    } catch (e) {
      print('💥 Exception in ApiService.delete: $e');
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // Handle Dio errors
  void _handleDioError(DioException e) {
    print('💥 Dio error: ${e.message}');
    if (e.response != null) {
      print('   Status code: ${e.response?.statusCode}');
      print('   Data: ${e.response?.data}');
    }
    if (e.error != null) {
      print('   Error: ${e.error}');
    }
  }

  // Handle HTTP response
  ApiResponse<T> _handleResponse<T>(
    dynamic data,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      print('🔄 Handling API response...');

      // If data is already a Map, use it directly
      final Map<String, dynamic> jsonData = data is Map<String, dynamic>
          ? data
          : (data is String ? jsonDecode(data) : {'data': data});

      print('📄 Parsed JSON Data: ${jsonData.toString()}');

      if (jsonData['success'] == true) {
        print('🎉 API Success Response');
        final responseData = jsonData['data'];
        print('📦 Data Field Present: ${responseData != null}');

        if (fromJson != null && responseData != null) {
          print('🔄 Converting data with fromJson function...');
          return ApiResponse.success(fromJson(responseData));
        } else {
          print('🔄 Returning data as-is...');
          return ApiResponse.success(responseData as T);
        }
      } else {
        print('❌ API Error Response');
        print('💬 Error Message: ${jsonData['message']}');
        return ApiResponse.error(
          jsonData['message'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      print('💥 Exception in _handleResponse: $e');
      return ApiResponse.error('Failed to parse response: ${e.toString()}');
    }
  }

  /// Converts Map<String, List<String>> headers to Map<String, String>
  /// by joining multiple values with commas
  Map<String, String> _convertHeaders(Map<String, List<String>> headers) {
    return headers.map((key, values) => MapEntry(key, values.join(', ')));
  }
}

/// API Response wrapper class
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final String? message;

  ApiResponse._({required this.success, this.data, this.error, this.message});

  factory ApiResponse.success(T data, [String? message]) {
    return ApiResponse._(success: true, data: data, message: message);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse._(success: false, error: error);
  }

  bool get isSuccess => success;
  bool get isError => !success;
}

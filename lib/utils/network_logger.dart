import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class NetworkLogger {
  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    if (kDebugMode) {
      print('📡 NETWORK REQUEST');
      print('────────────────────────────────────────────────────────────────');
      print('Method: $method');
      print('URL: $url');
      if (headers != null) {
        print('Headers:');
        headers.forEach((key, value) {
          // Mask sensitive headers
          if (key.toLowerCase() == 'authorization') {
            print('  $key: ${value.substring(0, 10)}...');
          } else {
            print('  $key: $value');
          }
        });
      }
      if (body != null) {
        print('Body:');
        if (body is String) {
          try {
            final parsed = jsonDecode(body);
            print('  ${const JsonEncoder.withIndent('  ').convert(parsed)}');
          } catch (e) {
            print('  $body');
          }
        } else {
          print('  ${const JsonEncoder.withIndent('  ').convert(body)}');
        }
      }
      print('────────────────────────────────────────────────────────────────\n');
    }
  }

  static void logResponse({
    required String method,
    required String url,
    required int statusCode,
    Map<String, String>? headers,
    dynamic body,
    required Duration duration,
  }) {
    if (kDebugMode) {
      print('📥 NETWORK RESPONSE');
      print('────────────────────────────────────────────────────────────────');
      print('Method: $method');
      print('URL: $url');
      print('Status Code: $statusCode');
      print('Duration: ${duration.inMilliseconds}ms');
      if (headers != null) {
        print('Headers:');
        headers.forEach((key, value) {
          print('  $key: $value');
        });
      }
      if (body != null) {
        print('Body:');
        if (body is String) {
          try {
            final parsed = jsonDecode(body);
            print('  ${const JsonEncoder.withIndent('  ').convert(parsed)}');
          } catch (e) {
            print('  $body');
          }
        } else {
          print('  ${const JsonEncoder.withIndent('  ').convert(body)}');
        }
      }
      print('────────────────────────────────────────────────────────────────\n');
    }
  }

  static void logError({
    required String method,
    required String url,
    required Object error,
    StackTrace? stackTrace,
    required Duration duration,
  }) {
    if (kDebugMode) {
      print('❌ NETWORK ERROR');
      print('────────────────────────────────────────────────────────────────');
      print('Method: $method');
      print('URL: $url');
      print('Duration: ${duration.inMilliseconds}ms');
      print('Error: $error');
      if (stackTrace != null) {
        print('Stack Trace: $stackTrace');
      }
      print('────────────────────────────────────────────────────────────────\n');
    }
  }

  // Dio interceptor for automatic logging
  static DioInterceptor get dioInterceptor => DioInterceptor();
}

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('📡 DioInterceptor request to: ${options.uri.toString()}');
    NetworkLogger.logRequest(
      method: options.method,
      url: options.uri.toString(),
      headers: _convertRequestHeaders(options.headers),
      body: options.data,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    NetworkLogger.logResponse(
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      statusCode: response.statusCode ?? 0,
      headers: _convertResponseHeaders(response.headers.map),
      body: response.data,
      duration: const Duration(milliseconds: 0), // Dio doesn't provide timing directly
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    NetworkLogger.logError(
      method: err.requestOptions.method,
      url: err.requestOptions.uri.toString(),
      error: err.message ?? err.error ?? 'Unknown error',
      stackTrace: err.stackTrace,
      duration: const Duration(milliseconds: 0), // Dio doesn't provide timing directly
    );
    super.onError(err, handler);
  }
  
  /// Converts Map<String, List<String>> headers to Map<String, String>
  /// by joining multiple values with commas
  Map<String, String> _convertResponseHeaders(Map<String, List<String>> headers) {
    return headers.map((key, values) => MapEntry(key, values.join(', ')));
  }
  
  /// Converts Map<String, dynamic> headers to Map<String, String>
  Map<String, String> _convertRequestHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) => MapEntry(key, value.toString()));
  }
}
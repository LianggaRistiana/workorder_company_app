import 'package:dio/dio.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/constants/app_config.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/core/storage/token_storage.dart';
import 'dart:convert';

abstract class ApiClient {
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Options? options,
    T Function(dynamic data)? fromJson,
  });

  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  });

  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  });

  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  });

  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  });
}

class DioApiClient implements ApiClient {
  final Dio _dio;
  final TokenStorage tokenStorage;

  DioApiClient({Dio? dio, required this.tokenStorage})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: AppConfig.baseApiUrl,
              connectTimeout: Duration(seconds: AppConfig.connectTimeout),
              receiveTimeout: Duration(seconds: AppConfig.receivedTimeout),
              headers: {'Content-Type': 'application/json'},
            )) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getToken();
          options.headers['Authorization'] = token;
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioException e, handler) {
          handler.next(e);
        },
      ),
    );
    _dio.interceptors.add(LoggingInterceptor());
  }

  /// GET request
  @override
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    return _handle(() async {
      final response = await _dio.get(endpoint,
          queryParameters: queryParams, options: options);
      return _parseResponse<T>(response.data, fromJson);
    });
  }

  /// POST request
  @override
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    return _handle(() async {
      final response = await _dio.post(endpoint, data: data, options: options);
      return _parseResponse<T>(response.data, fromJson);
    });
  }

  /// PATCH request
  @override
  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    return _handle(() async {
      final response = await _dio.patch(endpoint, data: data, options: options);
      return _parseResponse<T>(response.data, fromJson);
    });
  }

  /// PUT request
  @override
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    return _handle(() async {
      final response = await _dio.put(endpoint, data: data, options: options);
      return _parseResponse<T>(response.data, fromJson);
    });
  }

  /// DELETE request
  @override
  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Options? options,
    T Function(dynamic data)? fromJson,
  }) async {
    return _handle(() async {
      final response =
          await _dio.delete(endpoint, data: data, options: options);
      return _parseResponse<T>(response.data, fromJson);
    });
  }

  /// Error handling wrapper
  Future<T> _handle<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode ?? -1;
      final message = e.response?.data?['message'] ?? e.message;
      final errors = e.response?.data?['errors'] ?? e.message;
      throw ApiException(statusCode, message, errors: errors);
    }
  }

  /// Parse response data to type T
  T _parseResponse<T>(dynamic data, T Function(dynamic data)? fromJson) {
    if (fromJson != null) return fromJson(data);
    if (T == dynamic) return data;
    if (T == Map<String, dynamic>) return (data as Map<String, dynamic>) as T;
    if (T == List) return (data as List) as T;
    throw Exception('Unsupported type $T. Provide a fromJson function.');
  }
}

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor();

  String _prettyPrintJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  // void prettyPrintJson(dynamic json) {
  //   debugPrint(encoder.convert(json));
  // }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    appLogger.i(
        "➡️ ${options.method} ${options.uri}\nHeaders: ${options.headers}\nBody: ${_prettyPrintJson(options.data)}");
    // prettyPrintJson(options.data);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    appLogger.i(
        "✅ ${response.statusCode} ${response.requestOptions.uri} \nPayload:\n${_prettyPrintJson(response.data)}");
    // _prettyPrintJson(response.data);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorData = err.response?.data;
    if (errorData != null) {
      appLogger.e("⛔ $errorData");
    } else {
      appLogger.e("⛔ ${err.message}");
    }
    super.onError(err, handler);
  }
}

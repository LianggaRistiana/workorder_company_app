import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/constants/app_config.dart';
import 'package:workorder_company_app/core/storage/token_storage.dart';

class ApiClient {
  final Dio _dio;
  final TokenStorage tokenStorage;

  ApiClient({Dio? dio, required this.tokenStorage})
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
    _dio.interceptors.add(LoggingInterceptor(Logger()));
  }

  /// GET request
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

  /// PUT request
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
      // TODO: bisa handle saja error response dari API lakukan di apiexception jadi pertimbangkan hapus error code_error dari APIresponse 
      final statusCode = e.response?.statusCode ?? -1;
      final message = e.response?.data?['message'] ?? e.message;
      throw ApiException(statusCode, message);
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
  final Logger logger;

  LoggingInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i(
        "➡️ ${options.method} ${options.uri}\nHeaders: ${options.headers}\nBody: ${options.data}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
        "✅ ${response.statusCode} ${response.requestOptions.uri}\nResponse: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(err.response?.data?['message'], error: err.message);
    super.onError(err, handler);
  }
}

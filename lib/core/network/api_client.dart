import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/error/error.dart';

class ApiClient {
  final Dio _dio;
  
  ApiClient(this._dio){
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {},
      onResponse: (response, handler) {},
      onError: (DioException error, handler) {},
      
    ));
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
      final statusCode = e.response?.statusCode ?? -1;
      final message =
          e.response?.data?['message'] ?? e.message ?? 'Unknown error';
      debugPrint('API ERROR [$statusCode]: $message');
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
  

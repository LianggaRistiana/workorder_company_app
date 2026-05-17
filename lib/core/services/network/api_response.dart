import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/result/result.dart';

class ApiResponse<T> {
  final String message;
  final T _data;

  const ApiResponse({
    required this.message,
    required T data,
  }) : _data = data;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    final rawData = json['data'];

    if (rawData == null) {
      throw NetworkException("Data is null");
    }

    return ApiResponse<T>(
      message: json['message'] ?? '',
      data: fromJsonT(rawData),
    );
  }

  T get data => _data;
}

class Empty {
  const Empty();
}

class ApiResponseWithMeta<T> {
  final String message;
  final T? data;
  final Map<String, dynamic>? meta;

  ApiResponseWithMeta({
    required this.message,
    this.data,
    this.meta,
  });

  factory ApiResponseWithMeta.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponseWithMeta<T>(
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}

extension ApiResponseMapper<T> on ApiResponseWithMeta<T> {
  Result<T> toResult({
    Map<String, ResultMeta Function(Map<String, dynamic>)>? metaFactories,
  }) {
    if (data == null) {
      throw NetworkException("Data is null");
    }

    final metaMap = <Type, ResultMeta>{};

    final rawMeta = meta;

    if (rawMeta != null && metaFactories != null) {
      rawMeta.forEach((key, value) {
        final factory = metaFactories[key];
        if (factory != null && value is Map<String, dynamic>) {
          final metaObj = factory(value);
          metaMap[metaObj.runtimeType] = metaObj;
        }
      });
    }

    return Result<T>(
      data: data as T,
      meta: metaMap,
    );
  }

  Result<T> toResultDynamic({
    Map<String, ResultMeta Function(dynamic)>? metaFactories,
  }) {
    if (data == null) {
      throw NetworkException("Data is null");
    }

    final metaMap = <Type, ResultMeta>{};
    final rawMeta = meta;

    if (rawMeta != null && metaFactories != null) {
      rawMeta.forEach((key, value) {
        final factory = metaFactories[key];
        if (factory != null) {
          final metaObj = factory(value);
          metaMap[metaObj.runtimeType] = metaObj;
        }
      });
    }

    return Result<T>(
      data: data as T,
      meta: metaMap,
    );
  }

  Result<T> toResultSingleMeta<M extends ResultMeta>({
    required M Function(Map<String, dynamic>) metaFactory,
  }) {
    if (data == null) {
      throw NetworkException("Data is null");
    }

    final metaMap = <Type, ResultMeta>{};

    if (meta != null) {
      final metaObj = metaFactory(meta!);
      metaMap[M] = metaObj;
    }

    return Result<T>(
      data: data as T,
      meta: metaMap,
    );
  }
}

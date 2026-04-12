import 'package:workorder_company_app/core/model/meta_model.dart';

class ApiResponse<T> {
  final String message;
  final T? data;

  ApiResponse({
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
    );
  }
}

class ApiResponseWithMeta<T, M extends MetaModel> {
  final String message;
  final T? data;
  final M? meta;

  ApiResponseWithMeta({
    required this.message,
    this.data,
    this.meta,
  });
  factory ApiResponseWithMeta.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json)? fromJsonT,
    M Function(Map<String, dynamic> json)? fromJsonM,
  ) {
    return ApiResponseWithMeta<T, M>(
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
      meta: fromJsonM != null && json['meta'] != null
          ? fromJsonM(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

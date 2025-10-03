class ApiResponse<T> {
  final String message;
  final T? data;
  final String? errorCode;

  ApiResponse({
    required this.message,
    this.data,
    this.errorCode,
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
      errorCode: json['error_code'],
    );
  }
}

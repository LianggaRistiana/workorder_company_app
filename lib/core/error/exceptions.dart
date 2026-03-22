///  API exception
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic errors;

  ApiException(
    this.statusCode,
    this.message, {
    this.errors,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Exception untuk error cache (misal SharedPreferences, DB lokal)
class CacheException implements Exception {
  final String? message;

  CacheException([this.message]);

  @override
  String toString() => message ?? 'CacheException';
}

/// Exception for parsing
class ParsingException implements Exception {
  final String? message;

  ParsingException([this.message]);

  @override
  String toString() => message ?? 'ParsingException';
}

/// Exception untuk error koneksi (misal no internet)
class NetworkException implements Exception {
  final String? message;

  NetworkException([this.message]);

  @override
  String toString() => message ?? 'NetworkException';
}

import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';

Future<Either<Failure, T>> safeCall<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return Right(result);
  } catch (error, stack) {
    appLogger.e(
      '❌ ERROR in safeCall',
      error: error,
      stackTrace: stack,
    );

    return Left(_mapExceptionToFailure(error));
  }
}

Failure _mapExceptionToFailure(dynamic error) {
  if (error is ApiException) {
    switch (error.statusCode) {
      // case 400:
      //   return ServerFailure(message: error.message);
      case 401:
        return AuthFailure(message: "Unauthorized");
      case 403:
        return AuthFailure(message: "Anda tidak diijinkan mengakses data ini");
      case 404:
      case 409:
        return ServerFailure(message: error.message);
      case 400:
      case 422:
        final raw = error.errors;
        final result = <String, String>{};

        if (raw is Map && raw["field"] is List) {
          for (final item in raw["field"]) {
            if (item is Map) {
              item.forEach((key, value) {
                result[key.toString()] = value.toString();
              });
            }
          }
        }

        return ValidationFailure(message: error.message, errors: result);
      case 500:
        return ServerFailure(message: "Server Sedang Gangguan");
      default:
        return UnexpectedFailure(message: "Terjadi Kesalahan Tidak Terduga");
    }
  }
  if (error is FormatException) {
    return ParsingFailure(message: "Invalid data format");
  }

  if (error is CacheException) {
    return CacheFailure(message: error.message ?? "Cache error");
  }

  if (error is NetworkException) {
    return NetworkFailure(message: error.message ?? "No internet connection");
  }

  if (error is ParsingException) {
    return ParsingFailure(message: "Invalid data format");
  }

  return UnexpectedFailure(message: error.toString());
}

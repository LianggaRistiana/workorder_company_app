import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/utils/app_logger.dart';

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
  // Logger().e(error);
  if (error is ApiException) {
    // return ServerFailure(message: error.message);
    //  TODO: Refactore all repo in data layer using this utils
    // ApiException biasanya punya code + message
    switch (error.statusCode) {
      case 400:
        return ServerFailure(message: error.message);
      case 401:
        return AuthFailure(message: "Unauthorized");
      case 403:
        return AuthFailure(message: "Forbidden");
      case 404:
        return ServerFailure(message: error.message);
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

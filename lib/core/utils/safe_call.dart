import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/core/error/error.dart';

Future<Either<Failure, T>> safeCall<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return Right(result);
  } catch (error) {
    return Left(_mapExceptionToFailure(error));
  }
}

Failure _mapExceptionToFailure(dynamic error) {
  Logger().e(error);
  if (error is ApiException) {
    return ServerFailure(message: error.message);
    //  TODO: Refactore all repo in data layer using this utils
    // ApiException biasanya punya code + message
    // switch (error.statusCode) {
    //   case 401:
    //     return AuthFailure(error.message ?? "Unauthorized");
    //   case 403:
    //     return AuthFailure(error.message ?? "Forbidden");
    //   case 404:
    //     return ServerFailure(error.message ?? "Not Found");
    //   case 500:
    //     return ServerFailure(error.message ?? "Internal Server Error");
    //   default:
    //     return ServerFailure(error.message ?? "Unexpected server error");
    // }
  }
  if (error is FormatException) {
    return ParsingFailure(message: "Invalid data format");
  }

  return UnexpectedFailure(message: error.toString());
}

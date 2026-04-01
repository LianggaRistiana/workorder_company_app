import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherList<T> = Future<Either<Failure, List<T>>>;
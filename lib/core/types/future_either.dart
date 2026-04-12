import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/result/result.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherList<T> = Future<Either<Failure, List<T>>>;

typedef FutureEitherWithMeta<T> = Future<Either<Failure, Result<T>>>;
typedef FutureEitherListWithMeta<T> = Future<Either<Failure, Result<List<T>>>>;

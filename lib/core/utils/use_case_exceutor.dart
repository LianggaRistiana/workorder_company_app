import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/policy/policy_result.dart';
import 'package:workorder_company_app/core/types/future_either.dart';

/// A utility class to standardize the execution flow of a use case.
///
/// `UseCaseExecutor` provides a structured way to execute operations with the following steps:
/// 1. Optional mapping from input or draft to domain entity.
/// 2. Optional policy check on the mapped entity.
/// 3. Repository or action call that returns an `Either<Failure, T>`.
/// 4. Optional transformation of the repository result to a different type.
///
/// This class ensures that errors at any stage (mapping, policy, repository call)
/// are captured and returned as a `Left(Failure)` for consistent error handling.
class UseCaseExecutor {
  /// Executes a use case flow.
  ///
  /// - Parameters:
  ///   - `map` (optional): A synchronous function that maps input or draft to a domain entity of type `E`.
  ///       - Throws `ValidationException` if the mapping is invalid.
  ///   - `policy` (optional): A function that evaluates business rules on the mapped entity and
  ///       returns a `PolicyResult`. If the policy returns an error, execution stops.
  ///   - `action` (required): An asynchronous function that performs the main operation (usually a repository call)
  ///       and returns `Either<Failure, T>`.
  ///       The entity from the `map` step is passed as an argument.
  ///   - `transform` (optional): A function that transforms the repository result (`Either<Failure, T>`)
  ///       to a different type `Either<Failure, R>` before returning.
  ///
  /// - Returns:
  ///   A `Future<Either<Failure, R>>` that is:
  ///     - `Left(Failure)` if any validation, policy, or repository error occurs.
  ///     - `Right(R)` with the final result if all steps succeed.
  ///
  /// - Notes:
  ///   - `map` and `policy` are optional and can be omitted if not needed.
  ///   - `transform` allows you to intercept or modify the repository result before returning.
  ///   - Errors from `map` are caught and converted to `ValidationFailure` or `UnknownFailure`.
  ///   - If `policy` fails, a `PolicyFailure` is returned.
  ///   - If no `transform` is provided, the repository result is returned as-is.
  ///
  /// // FIXME : entity should not be null
  static FutureEither<R> run<E, T, R>({
    E Function()? map,
    PolicyResult Function(E entity)? policy,
    required FutureEither<T> Function(E? entity) action,
    Either<Failure, R> Function(Either<Failure, T> result)? transform,
  }) async {
    E? entity;

    // 1️⃣ Map (optional)
    if (map != null) {
      try {
        entity = map();
      } on ValidationException catch (e) {
        return Left(ValidationFailure(
            message: e.message ?? "Terjadi Kesalahan", errors: {}));
      } catch (e) {
        return Left(UnexpectedFailure(message: e.toString()));
      }
    }

    // 2️⃣ Policy (optional)
    if (policy != null) {
      final result = policy(entity as E);
      if (result.isError) {
        return Left(PolicyFailure(result.issue.toString()));
      }
    }

    // 3️⃣ Repository/action call
    final repoResult = await action(entity);

    // 4️⃣ Optional transform
    if (transform != null) {
      return transform(repoResult);
    }

    // 5️⃣ Default return (as-is)
    return repoResult as Either<Failure, R>;
  }
}

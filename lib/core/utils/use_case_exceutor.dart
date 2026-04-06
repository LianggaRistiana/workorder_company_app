import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/types/future_either.dart';

/// A centralized executor for running use cases with optional
/// mapping, authorization, and result transformation.
///
/// This executor standardizes:
/// - Mapping raw input to entity (`map`)
/// - Authorization checks (`authorize`)
/// - Error handling (ValidationFailure, PolicyFailure, UnexpectedFailure)
/// - Optional transformation of action result
class UseCaseExecutor {
  /// Runs a use case with mapping and optional authorization.
  ///
  /// Returns `Either<Failure, R>` directly from the action.
  ///
  /// [map] is a function that maps input to a domain entity.
  /// Throws [ValidationException] if input is invalid.
  ///
  /// [authorize] is optional. If provided, it evaluates the entity
  /// using `AuthorizationResult`. If not allowed, returns `PolicyFailure`.
  ///
  /// [action] is the main use case function that returns `FutureEither<R>`.
  ///
  /// Example:
  /// ```dart
  /// final result = await UseCaseExecutor.run<MyEntity, String>(
  ///   map: () => MyEntity.fromForm(form),
  ///   authorize: (entity) => entity.canEdit(),
  ///   action: (entity) => repository.updateEntity(entity),
  /// );
  /// ```
  static FutureEither<R> run<E, R>({
    required E Function() map,
    AuthorizationResult Function(E entity)? authorize,
    required FutureEither<R> Function(E entity) action,
  }) async {
    try {
      final entity = map();

      // Authorization
      if (authorize != null) {
        final result = authorize(entity);
        if (!result.isAllowed) {
          return Left(PolicyFailure(result.message));
        }
      }

      // Action
      return await action(entity);
    } on ValidationException catch (e) {
      return Left(
        ValidationFailure(
          message: e.message ?? "Terjadi Kesalahan",
          errors: {},
        ),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(message: e.toString()),
      );
    }
  }

  /// Runs a use case with mapping, optional authorization, and result transformation.
  ///
  /// Returns `Either<Failure, R>` after applying [transform] to the
  /// action result.
  ///
  /// [transform] allows converting `Either<Failure, T>` returned by the
  /// action into `Either<Failure, R>` if you need to adapt or combine results.
  ///
  /// Example:
  /// ```dart
  /// final result = await UseCaseExecutor.runWithTransform<MyEntity, int, String>(
  ///   map: () => MyEntity.fromForm(form),
  ///   authorize: (entity) => entity.canEdit(),
  ///   action: (entity) => repository.getCount(entity),
  ///   transform: (either) => either.map((count) => "Total: $count"),
  /// );
  /// ```
  static FutureEither<R> runWithTransform<E, T, R>({
    required E Function() map,
    AuthorizationResult Function(E entity)? authorize,
    required FutureEither<T> Function(E entity) action,
    required Either<Failure, R> Function(Either<Failure, T> result) transform,
  }) async {
    final result = await run<E, Either<Failure, T>>(
      map: map,
      authorize: authorize,
      action: (entity) async => Right(await action(entity)),
    );

    // Transform the Either<Failure, T> into Either<Failure, R>
    return transform(result.fold((l) => Left(l), (r) => r));
  }
}

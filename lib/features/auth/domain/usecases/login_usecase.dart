import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/services/storage/token_storage.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  final TokenStorage tokenStorage;

  LoginUseCase(this.repository, this.tokenStorage);

  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    final result = await repository.login(params.email, params.password);
// OPTIMIZE :Move this logic into repository
    return result.fold(
      (failure) => Left(failure),
      (data) async {
        await tokenStorage.saveToken(data.token);
        try {
          final saveUserResult = await repository.saveUser(data.user);
          saveUserResult;
          return saveUserResult.fold(
            (failure) => Left(failure),
            (_) => Right(data.user),
          );
        } catch (e) {
          return Left(CacheFailure(message: 'Failed to save user: $e'));
        }
      },
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}

import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/storage/token_storage.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  final TokenStorage tokenStorage = TokenStorage();

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    if (params.email.isEmpty || params.password.isEmpty) {
      return const Left(
          ServerFailure(message: "Email dan password wajib diisi"));
    }

    final result = await repository.login(params.email, params.password);

    return result.fold(
      (failure) => Left(failure),
      (data) async {
        await tokenStorage
            .saveToken(data.token); // Belum ada kondisi jika gagal
        // await repository.saveUser(data.user);

        // return Right(data.user);
        try {
          final saveUserResult = await repository.saveUser(data.user);
          saveUserResult;
          return saveUserResult.fold(
            (failure) => Left(failure), 
            (_) => Right(data.user), // sukses
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

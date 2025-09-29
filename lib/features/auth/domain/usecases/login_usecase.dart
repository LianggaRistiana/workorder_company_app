import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase{
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    // Step 1: (Opsional) Validasi input di sini
    if (params.email.isEmpty || params.password.isEmpty) {
      return const Left(ServerFailure(message: "Email dan password wajib diisi"));
    }

    // Step 2: Panggil repository
    final result = await repository.login(params.email, params.password);

    // Step 3: Tambahkan logic business di sini (sebelum kembalikan hasil)
    return result.fold(
      (failure) => Left(failure), // kalau gagal, langsung kembalikan
      (data) async {
        // TODO: simpan token di SecureStorage/SharedPref
      
        // await _tokenStorage.saveToken(userEntity.token);

        return Right(data.user);
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

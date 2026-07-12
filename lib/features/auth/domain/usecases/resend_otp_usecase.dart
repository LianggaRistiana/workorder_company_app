import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpUsecase {
  final AuthRepository _authRepository;

  ResendOtpUsecase(this._authRepository);

  Future<Either<Failure, void>> call(String email) {
    return _authRepository.resendOtp(email);
  }
}

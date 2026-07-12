import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/otp_verification_entity.dart';
import 'package:workorder_company_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUsecase {
  final AuthRepository _authRepository;

  VerifyOtpUsecase(this._authRepository);

  Future<Either<Failure, void>> call(OtpVerificationEntity data) {
    return _authRepository.verifyOtp(data);
  }
}

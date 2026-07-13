import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/repositories/invitation_codes_repository.dart';

class ClaimInvitationCodeUsecase {
  final InvitationCodesRepository _repository;

  ClaimInvitationCodeUsecase(this._repository);

  Future<Either<Failure, void>> call(String code) async {
    return await _repository.claimInvitationCode(code);
  }
}

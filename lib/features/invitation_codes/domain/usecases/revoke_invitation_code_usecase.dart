import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/repositories/invitation_codes_repository.dart';

class RevokeInvitationCodeUsecase {
  final InvitationCodesRepository _repository;

  RevokeInvitationCodeUsecase(this._repository);

  Future<Either<Failure, void>> call(String id) async {
    return await _repository.revokeInvitationCode(id);
  }
}

import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_draft_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/repositories/invitation_codes_repository.dart';

class UpdateInvitationCodeUsecase {
  final InvitationCodesRepository _repository;

  UpdateInvitationCodeUsecase(this._repository);

  Future<Either<Failure, InvitationCodeEntity>> call(
    String id,
    InvitationCodeDraftEntity draft,
  ) async {
    return await _repository.updateInvitationCode(id, draft);
  }
}

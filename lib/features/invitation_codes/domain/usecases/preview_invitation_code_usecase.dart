import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_preview_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/repositories/invitation_codes_repository.dart';

class PreviewInvitationCodeUsecase {
  final InvitationCodesRepository _repository;

  PreviewInvitationCodeUsecase(this._repository);

  Future<Either<Failure, InvitationCodePreviewEntity>> call(String code) async {
    return await _repository.previewInvitationCode(code);
  }
}

import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/repositories/invitation_codes_repository.dart';

class GetInvitationCodesUsecase {
  final InvitationCodesRepository _repository;

  GetInvitationCodesUsecase(this._repository);

  Future<Either<Failure, List<InvitationCodeEntity>>> call() async {
    return await _repository.getInvitationCodes();
  }
}

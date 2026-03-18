import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_generate_draft_model.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';

class GenerateMembershipCodesUsecase {
  final MembershipsRepository _repository;

  GenerateMembershipCodesUsecase(this._repository);

  Future<Either<Failure, List<MembershipCodeEntity>>> call(
      MembershipCodeGenerateDraftModel draft) async {
    return await _repository.generateMembershipCodes(draft);
  }
}

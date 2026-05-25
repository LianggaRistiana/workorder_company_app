import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';

class UploadMembershipCsvFileUsecase {
  final MembershipsRepository _repository;

  UploadMembershipCsvFileUsecase(this._repository);

  FutureEitherList<MembershipCodeEntity> call(String filePath) async {
    return await _repository.uploadMembershipCsvFile(filePath);
  }
}

import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';

abstract class MembershipsRepository {
  FutureEitherList<MembershipCodeEntity> getMembershipCodes();
  FutureEitherList<MembershipCodeEntity> uploadMembershipCsvFile(
      String filePath);
  FutureEither<ExternalUserEntity> claimMembership(
    String token,
    String companyId,
  );
  FutureEither<MembershipCodeEntity> deleteMemberShipCode(String id);
  FutureEitherList<MemberEntity> getMembers();
}

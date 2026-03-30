import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_codes_generate_draft_entity.dart';

abstract class MembershipsRepository {
  FutureEitherList<MembershipCodeEntity> getMembershipCodes();
  FutureEitherList<MembershipCodeEntity> generateMembershipCodes(
      MembershipCodesGenerateDraftEntity draft);
  FutureEither<CompanyEntity> claimMembership(String code);
  FutureEither<MembershipCodeEntity> deleteMembership(String id);
  FutureEitherList<MemberEntity> getMembers();
}

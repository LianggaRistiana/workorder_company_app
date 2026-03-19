import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_codes_generate_draft_entity.dart';

abstract class MembershipsRepository {
  Future<Either<Failure, List<MembershipCodeEntity>>> getMembershipCodes();
  Future<Either<Failure, List<MembershipCodeEntity>>> generateMembershipCodes(
      MembershipCodesGenerateDraftEntity draft);
  Future<Either<Failure, CompanyEntity>> claimMembership(String code);
  Future<Either<Failure, MembershipCodeEntity>> deleteMembership(String id);
}

import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_generate_draft_model.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';

abstract class MembershipsRepository {
  Future<Either<Failure, List<MembershipCodeEntity>>> getMembershipCodes();
  Future<Either<Failure, List<MembershipCodeEntity>>> generateMembershipCodes(
      MembershipCodeGenerateDraftModel draft);
  Future<Either<Failure, CompanyEntity>> claimMembership(String code);
  Future<Either<Failure, MembershipCodeEntity>> deleteMembership(String id);
}

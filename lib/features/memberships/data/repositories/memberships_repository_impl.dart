import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/memberships/data/datasources/memberships_remote_datasource.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_codes_generate_draft_model.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_codes_generate_draft_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';

class MembershipsRepositoryImpl extends MembershipsRepository {
  final MembershipsRemoteDatasource _remoteDatasource;

  MembershipsRepositoryImpl(this._remoteDatasource);

  @override
  FutureEither<CompanyEntity> claimMembership(String code) {
    return safeCall(() async {
      final response = await _remoteDatasource.claimMembership(code);
      return response.data;
    });
  }

  @override
  FutureEither<MembershipCodeEntity> deleteMembership(String id) {
    return safeCall(() async {
      final response = await _remoteDatasource.deleteMembership(id);
      return response.data;
    });
  }

  @override
  FutureEitherList<MembershipCodeEntity> generateMembershipCodes(
      MembershipCodesGenerateDraftEntity draft) {
    return safeCall(() async {
      final response = await _remoteDatasource.generateMembershipCodes(
          MembershipCodesGenerateDraftModel.fromEntity(draft));
      return response.data;
    });
  }

  @override
  FutureEitherList<MembershipCodeEntity> getMembershipCodes() {
    return safeCall(() async {
      final response = await _remoteDatasource.getMembershipCodes();
      return response.data;
    });
  }

  @override
  FutureEitherList<MemberEntity> getMembers() {
    return safeCall(() async {
      final response = await _remoteDatasource.getMembers();
      return response.data;
    });
  }
}

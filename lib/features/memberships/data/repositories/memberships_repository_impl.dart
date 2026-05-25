import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/memberships/data/datasources/memberships_remote_datasource.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/membership_code_entity.dart';
import 'package:workorder_company_app/features/memberships/domain/repositories/memberships_repository.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';

class MembershipsRepositoryImpl extends MembershipsRepository {
  final MembershipsRemoteDatasource _remoteDatasource;

  MembershipsRepositoryImpl(this._remoteDatasource);

  @override
  FutureEither<ExternalUserEntity> claimMembership(
      String token, String companyId) {
    return safeCall(() async {
      final response =
          await _remoteDatasource.claimMembership(token, companyId);
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

  @override
  FutureEitherList<MembershipCodeEntity> uploadMembershipCsvFile(
      String filePath) {
    return safeCall(() async {
      final response =
          await _remoteDatasource.uploadMembershipCsvFile(filePath);
      return response.data;
    });
  }
}

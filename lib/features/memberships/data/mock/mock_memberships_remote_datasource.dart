import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/memberships/data/datasources/memberships_remote_datasource.dart';
import 'package:workorder_company_app/features/memberships/data/model/member_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_model.dart';
import 'package:workorder_company_app/features/system_integration/data/model/external_user_model.dart';

class MockMembershipsRemoteDatasource implements MembershipsRemoteDatasource {
  @override
  ApiFuture<MembershipCodeModel> deleteMembership(String id) {
    // TODO: implement deleteMembership
    throw UnimplementedError();
  }

  @override
  ApiFutureList<MemberModel> getMembers() {
    // TODO: implement getMembers
    throw UnimplementedError();
  }

  @override
  ApiFutureList<MembershipCodeModel> getMembershipCodes() {
    // TODO: implement getMembershipCodes
    throw UnimplementedError();
  }

  @override
  ApiFutureList<MembershipCodeModel> uploadMembershipCsvFile(String filePath) {
    // TODO: implement uploadMembershipCsvFile
    throw UnimplementedError();
  }

  @override
  ApiFuture<ExternalUserModel> claimMembership(String token, String companyId) {
    // TODO: implement claimMembership
    throw UnimplementedError();
  }
}

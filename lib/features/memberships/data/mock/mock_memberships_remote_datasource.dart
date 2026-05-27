import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/constants/app_enums/system_integration_enum.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/memberships/data/datasources/memberships_remote_datasource.dart';
import 'package:workorder_company_app/features/memberships/data/mock/member_code_mock_factory.dart';
import 'package:workorder_company_app/features/memberships/data/model/member_model.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_model.dart';
import 'package:workorder_company_app/features/system_integration/data/model/external_user_model.dart';

class MockMembershipsRemoteDatasource implements MembershipsRemoteDatasource {
  final List<MembershipCodeModel> _codes =
      MemberCodeMockFactory().createList(count: 30);

  @override
  ApiFuture<MembershipCodeModel> deleteMemberShipCode(String id) async {
    await Future.delayed(const Duration(seconds: 2));

    final index = _codes.indexWhere((e) => e.id == id);

    if (index == -1) {
      throw ApiException(404, "Code not found");
    }

    final removed = _codes.removeAt(index);

    return MockApiResponse.success(removed);
  }

  @override
  ApiFutureList<MemberModel> getMembers() {
    // TODO: implement getMembers
    throw UnimplementedError();
  }

  @override
  ApiFutureList<MembershipCodeModel> getMembershipCodes() async {
    await Future.delayed(const Duration(seconds: 2));
    return MockApiResponse.success(_codes);
  }

  @override
  ApiFutureList<MembershipCodeModel> uploadMembershipCsvFile(
      String filePath) async {
    await Future.delayed(const Duration(seconds: 2));
    _codes.addAll(MemberCodeMockFactory().createList(count: 30));
    return MockApiResponse.success(_codes);
  }

  @override
  ApiFuture<ExternalUserModel> claimMembership(
      String token, String companyId) async {
    await Future.delayed(const Duration(seconds: 2));
    return MockApiResponse.success(
      ExternalUserModel(
        id: faker.guid.guid(),
        integrationType: IntegrationType.claimCode,
        company: CompanyModel(
            id: "id", name: "name", isActive: true, isFaqActive: true),
        externalEmail: faker.internet.email(),
        externalName: faker.person.name(),
        pairedAt: DateTime.now(),
      ),
    );
  }
}

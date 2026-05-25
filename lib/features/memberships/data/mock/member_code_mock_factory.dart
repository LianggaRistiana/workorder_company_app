import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/features/memberships/data/model/membership_code_model.dart';

class MemberCodeMockFactory implements MockFactory<MembershipCodeModel> {
  final faker = Faker();

  @override
  Map<String, dynamic> createJson() {
    return {
      "_id": faker.guid.guid(),
      "token": faker.guid.guid(),
      "externalCustomerEmail": faker.internet.email(),
      "externalCustomerName": faker.person.name(),
      "claimedAt": faker.randomGenerator.boolean()
          ? faker.date.dateTime().toIso8601String()
          : null,
    };
  }

  @override
  MembershipCodeModel createModel() {
    return MembershipCodeModel.fromJson(createJson());
  }

  @override
  List<MembershipCodeModel> createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }
}

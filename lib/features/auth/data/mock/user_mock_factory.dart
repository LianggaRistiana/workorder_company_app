import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/constants/app_enums/user_enum.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';

class UserMockFactory implements MockFactory<UserModel> {
  final faker = Faker();

  @override
  Map<String, dynamic> createJson() {
    final status = faker.randomGenerator.element(UserRole.values);
    return {
      // "id": faker.randomGenerator.integer(1000),
      "name": faker.person.name(),
      "email": faker.internet.email(),
      "isActive": faker.randomGenerator.boolean(),
      "role": status.toSnakeCase(),
    };
  }

  @override
  UserModel createModel() {
    return UserModel.fromJson(createJson());
  }
}

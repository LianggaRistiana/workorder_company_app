import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

class PositionMockFactory implements MockFactory<PositionModel> {
  final faker = Faker();

  @override
  Map<String, dynamic> createJson() {
    return {
      "_id": faker.randomGenerator.integer(1000).toString(),
      "name": faker.company.name(),
      "isActive": faker.randomGenerator.boolean(),
      "description": faker.lorem.sentence(),
    };
  }

  @override
  PositionModel createModel() {
    return PositionModel.fromJson(createJson());
  }

  @override
  List<PositionModel> createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }
}

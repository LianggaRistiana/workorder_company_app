import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';

class FormsMockFactory implements MockFactory<FormModel> {
  final faker = Faker(seed: 1);

  @override
  Map<String, dynamic> createJson() {
    // TODO: implement createJson
    throw UnimplementedError();
  }

  @override
  FormModel createModel() {
    // TODO: implement createModel
    throw UnimplementedError();
  }

  @override
  List<FormModel> createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }
}

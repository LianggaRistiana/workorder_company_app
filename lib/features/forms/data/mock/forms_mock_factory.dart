import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/features/forms/data/model/field_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/option_model.dart';

class FormsMockFactory implements MockFactory<FormModel> {
  final faker = Faker();
  @override
  Map<String, dynamic> createJson() {
    final fieldFactory = FieldMockFactory();

    final generatedFields = List.generate(
      faker.randomGenerator.integer(30) + 1,
      (_) => fieldFactory.createJson(),
    );

    return {
      "_id": faker.guid.guid(),
      "title": faker.lorem.words(3).join(" "),
      "description": faker.lorem.sentence(),
      "formType": faker.randomGenerator.element(FormType.values).toSnakeCase(),
      "fields": generatedFields,
    };
  }

  @override
  FormModel createModel() {
    return FormModel.fromJson(createJson());
  }

  @override
  List<FormModel> createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }
}

class FieldMockFactory implements MockFactory<FieldModel> {
  final faker = Faker(seed: 1);

  @override
  Map<String, dynamic> createJson() {
    final min = faker.randomGenerator.integer(10) + 1;
    final max = min + faker.randomGenerator.integer(10);

    final optionCount = faker.randomGenerator.integer(5) + 1;

    return {
      "order": faker.randomGenerator.integer(100),
      "label": faker.lorem.words(2).join(" "),
      "type": faker.randomGenerator.element(FieldType.values).toSnakeCase(),
      "required": faker.randomGenerator.boolean(),
      "placeholder": faker.lorem.sentence(),
      "min": min,
      "max": max,
      "options": List.generate(
        optionCount,
        (_) => OptionMockFactory().createJson(),
      ),
    };
  }

  @override
  FieldModel createModel() {
    return FieldModel.fromJson(createJson());
  }

  @override
  List<FieldModel> createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }
}

class OptionMockFactory implements MockFactory<OptionModel> {
  final faker = Faker(seed: 1);

  @override
  Map<String, dynamic> createJson() {
    return {
      "key": faker.guid.guid(),
      "value": faker.job.title(),
    };
  }

  @override
  OptionModel createModel() {
    return OptionModel.fromJson(createJson());
  }

  @override
  List<OptionModel> createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }
}

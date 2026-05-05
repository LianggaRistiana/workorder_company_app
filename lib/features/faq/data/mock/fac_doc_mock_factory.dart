import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_doc_model.dart';
import 'package:workorder_company_app/shared/utils/string_case_utils.dart';

class FacDocMockFactory implements MockFactory<FaqDocModel> {
  final faker = Faker();

  @override
  Map<String, dynamic> createJson() {
    final type = faker.randomGenerator.element(FaqDocsType.values);
    return {
      "id": faker.guid.guid(),
      "title": faker.lorem.sentence(),
      "content": faker.lorem.sentences(50).join(" "),
      "type": type.name.toSnakeCase(),
      "url": "https://www.orimi.com/pdf-test.pdf",
      "createdAt": faker.date.dateTime().toIso8601String(),
    };
  }

  @override
  List<FaqDocModel> createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }

  @override
  FaqDocModel createModel() {
    return FaqDocModel.fromJson(createJson());
  }
}

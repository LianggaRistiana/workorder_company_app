import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_response_model.dart';

class MockFaqRemoteDatasource implements FaqRemoteDatasource {
  final faker = Faker();
  @override
  ApiFuture<FaqResponseModel> askQuestion(
      String companyId, String question) async {
    await Future.delayed(Duration(seconds: 3));
    if (faker.randomGenerator.boolean()) {
      throw ApiException(404, faker.lorem.sentences(5).join(' '));
    }

    return ApiResponse(
        message: "Succes",
        data: FaqResponseModel(answer: faker.lorem.sentences(5).join(' ')));
  }
}

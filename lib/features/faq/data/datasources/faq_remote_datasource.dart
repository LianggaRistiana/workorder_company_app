import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_response_model.dart';

abstract class FaqRemoteDatasource {
  ApiFuture<FaqResponseModel> askQuestion(
    String companyId,
    String question,
  );
}

class FaqRemoteDatasourceImpl implements FaqRemoteDatasource {
  final ApiClient _apiClient;

  FaqRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<FaqResponseModel> askQuestion(
      String companyId, String question) async {
    final response = await _apiClient.post(
      Endpoints.askQuestion,
      data: {
        "companyId": companyId,
        "question": question,
      },
    );
    return ApiResponse.fromJson(
      response,
      (json) => FaqResponseModel.fromJson(json),
    );
  }
}

import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_response_model.dart';

abstract class FaqRemoteDatasource {
  ApiFuture<FaqResponseModel> askQuestion(
    String companyId,
    String question,
  );
}

class FaqRemoteDatasourceImpl implements FaqRemoteDatasource {
  @override
  ApiFuture<FaqResponseModel> askQuestion(String companyId, String question) {
    // TODO: implement askQuestion
    throw UnimplementedError();
  }
}

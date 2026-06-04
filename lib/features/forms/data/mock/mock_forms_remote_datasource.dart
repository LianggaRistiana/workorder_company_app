import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/mock/forms_mock_factory.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';

class MockFormsRemoteDatasource implements FormsRemoteDatasource {
  @override
  ApiFuture<FormModel> createForm(FormModel form) {
    throw UnimplementedError();
  }

  @override
  ApiFutureWithMeta<FormModel> getFormById(String id) async {
    throw UnimplementedError();
  }

  @override
  ApiFutureList<FormModel> getForms() async {
    return MockApiResponse.success(FormsMockFactory().createList(count: 20));
  }

  @override
  ApiFuture<FormModel> updateForm(FormModel form) {
    throw UnimplementedError();
  }

  @override
  ApiFuture<Empty> deleteForm(FormModel form) {
    // TODO: implement deleteForm
    throw UnimplementedError();
  }
}

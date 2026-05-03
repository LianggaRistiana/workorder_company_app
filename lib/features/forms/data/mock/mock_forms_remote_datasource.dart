import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/mock/forms_mock_factory.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';

class MockFormsRemoteDatasource implements FormsRemoteDatasource {
  @override
  ApiFuture<FormModel> createForm(FormModel form) {
    // TODO: implement createForm
    throw UnimplementedError();
  }

  @override
  ApiFuture<FormModel> getFormById(String id) async {
    return MockApiResponse.success(FormsMockFactory().createModel());
  }

  @override
  ApiFutureList<FormModel> getForms() async {
    return MockApiResponse.success(FormsMockFactory().createList(count: 20));
  }

  @override
  ApiFuture<FormModel> updateForm(FormModel form) {
    // TODO: implement updateForm
    throw UnimplementedError();
  }
}

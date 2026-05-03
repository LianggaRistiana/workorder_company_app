import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/forms/data/datasources/forms_remote_datasource.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';

class MockFormsRemoteDatasource implements FormsRemoteDatasource {
  @override
  ApiFuture<FormModel> createForm(FormModel form) {
    // TODO: implement createForm
    throw UnimplementedError();
  }

  @override
  ApiFuture<FormModel> getFormById(String id) {
    // TODO: implement getFormById
    throw UnimplementedError();
  }

  @override
  ApiFutureList<FormModel> getForms() {
    // TODO: implement getForms
    throw UnimplementedError();
  }

  @override
  ApiFuture<FormModel> updateForm(FormModel form) {
    // TODO: implement updateForm
    throw UnimplementedError();
  }
}

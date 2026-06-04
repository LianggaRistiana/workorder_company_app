import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class DeleteFormUsecase {
  final FormsRepository _repository;

  DeleteFormUsecase(this._repository);

  FutureEither<Empty> call(FormEntity form) {
    return _repository.deleteForm(form);
  }
}

import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class GetFormsUsecase {
  final FormsRepository _repository;

  GetFormsUsecase(this._repository);

  FutureEitherList<FormEntity> call(
      {bool forceRefresh = false}) async {
    return _repository.getForms(
      forceRefresh: forceRefresh,
    );
  }
}

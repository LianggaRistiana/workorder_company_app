import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/forms/domain/draft/form_draft.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class UpdateFormUsecase {
  final FormsRepository _repository;

  UpdateFormUsecase(this._repository);

  FutureEither<FormEntity> call(FormDraft draft) async {
    return UseCaseExecutor.run(
      map: () => draft.toEntity(),
      action: (entity) => _repository.updateForm(entity),
    );
  }
}

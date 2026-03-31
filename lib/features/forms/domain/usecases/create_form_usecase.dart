import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/forms/domain/draft/form_draft.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class CreateFormUsecase {
  final FormsRepository _repository;

  CreateFormUsecase(this._repository);

  Future<Either<Failure, void>> call(FormDraft draft) async {
    return UseCaseExecutor.run(
      map: () => draft.toEntity(),
      action: (entity) => _repository.createForm(entity!),
    );
  }
}

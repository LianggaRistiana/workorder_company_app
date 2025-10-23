import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class PublicSubmitIntakeFormsUsecase {
  final FormsRepository _repository;

  PublicSubmitIntakeFormsUsecase(this._repository);

  Future<Either<Failure, void>> call(
      String id, List<SubmissionEntity> submissions) async {
    return await _repository.publicSubmitIntakeForms(id, submissions);
  }
}

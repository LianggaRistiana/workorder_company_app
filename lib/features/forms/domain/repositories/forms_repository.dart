import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

abstract class FormsRepository {
  FutureEitherList<FormEntity> getForms({bool forceRefresh = false});
  FutureEither<FormEntity> getForm(String id);
  FutureEither<void> createForm(FormEntity form);
  FutureEither<void> updateForm(FormEntity form);

  // TODO : Refactor this into service request feature
  Future<Either<Failure, List<OrderedFormEntity>>> publicGetServiceForms(String id);
  Future<Either<Failure, void>> publicSubmitIntakeForms(String id, List<SubmissionEntity> submissions);
}

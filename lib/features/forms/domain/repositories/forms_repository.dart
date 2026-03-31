import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

abstract class FormsRepository {
  Future<Either<Failure, List<FormEntity>>> getForms({bool forceRefresh = false});
  Future<Either<Failure, List<OrderedFormEntity>>> publicGetServiceForms(String id);
  Future<Either<Failure, void>> publicSubmitIntakeForms(String id, List<SubmissionEntity> submissions);
  Future<Either<Failure, FormEntity>> getForm(String id);
  Future<Either<Failure, void>> createForm(FormEntity form);
}

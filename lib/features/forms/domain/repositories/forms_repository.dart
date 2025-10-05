import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

abstract class FormsRepository {
  Future<Either<Failure, List<FormEntity>>> getForms();
  Future<Either<Failure, FormEntity>> getForm(String id);
  Future<Either<Failure, void>> createForm(FormEntity form);
}

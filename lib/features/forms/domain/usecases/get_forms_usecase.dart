import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class GetFormsUsecase {
  final FormsRepository _repository;

  GetFormsUsecase(this._repository);

  Future<Either<Failure, List<FormEntity>>> call() async {
    return _repository.getForms();
  }
}

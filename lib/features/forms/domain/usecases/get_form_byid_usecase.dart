import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class GetFormByIdUsecase {
  final FormsRepository _repository;

  GetFormByIdUsecase(this._repository);

  Future<Either<Failure, FormEntity>> call(String id) async {
    return _repository.getForm(id);
  }
}
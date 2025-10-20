import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/repositories/forms_repository.dart';

class PublicGetServiceFormUsecase {
  final FormsRepository _repository;

  PublicGetServiceFormUsecase(this._repository);

  Future<Either<Failure, List<OrderedFormEntity>>> call(String id) async {
    return _repository.publicGetServiceForms(id);
  }
}

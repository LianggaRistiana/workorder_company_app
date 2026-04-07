import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/repositories/workorder_repository.dart';

class SetWorkorderToStartUsecase {
  final WorkorderRepository _repository;

  SetWorkorderToStartUsecase(this._repository);

  Future<Either<Failure, void>> call(String id) async {
    return await _repository.setToStart(id);
  }
}

import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/repositories/workorder_repository.dart';

class SetWorkorderToReadyUsecase {
  final WorkorderRepository _workorderRepository;

  SetWorkorderToReadyUsecase(this._workorderRepository);

  Future<Either<Failure, void>> call(String id) async {
    return await _workorderRepository.setToReady(id);
  }
}

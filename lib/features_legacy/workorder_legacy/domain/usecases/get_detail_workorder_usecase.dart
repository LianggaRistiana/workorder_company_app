import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/entitties/workorder__entity.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/repositories/workorder_repository.dart';

class GetDetailWorkorderUsecase {
  final WorkorderRepository _workorderRepository;

  GetDetailWorkorderUsecase(this._workorderRepository);

  Future<Either<Failure, WorkorderEntity>> call(String id) async {
    return _workorderRepository.getWorkorderById(id);
  }
}

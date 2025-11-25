import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/workorder/domain/entitties/workorder__entity.dart';
import 'package:workorder_company_app/features/workorder/domain/repositories/workorder_repository.dart';

class GetWorkordersUsecases {
  final WorkorderRepository _workorderRepository;

  GetWorkordersUsecases(this._workorderRepository);

  Future<Either<Failure, List<WorkorderEntity>>> call() async {
    return _workorderRepository.getWorkorders();
  }
}

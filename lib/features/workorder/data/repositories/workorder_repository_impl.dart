import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/workorder/data/datasources/workorder_remote_datasource.dart';
import 'package:workorder_company_app/features/workorder/domain/entitties/workorder__entity.dart';
import 'package:workorder_company_app/features/workorder/domain/repositories/workorder_repository.dart';

class WorkorderRepositoryImpl implements WorkorderRepository {
  final WorkorderRemoteDatasource _workorderRemoteDatasource;

  WorkorderRepositoryImpl(this._workorderRemoteDatasource);

  @override
  Future<Either<Failure, WorkorderEntity>> getWorkorderById(String id) {
    // TODO: implement getWorkorderById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<WorkorderEntity>>> getWorkorders() {
    return safeCall(() async {
      final payload = await _workorderRemoteDatasource
          .getWorkorders();
      return payload.data ?? [];
    });
  }
}

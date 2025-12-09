import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/failures.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/workorder/data/datasources/workorder_remote_datasource.dart';
import 'package:workorder_company_app/features/workorder/domain/entitties/workorder__entity.dart';
import 'package:workorder_company_app/features/workorder/domain/repositories/workorder_repository.dart';

class WorkorderRepositoryImpl implements WorkorderRepository {
  final WorkorderRemoteDatasource _workorderRemoteDatasource;

  WorkorderRepositoryImpl(this._workorderRemoteDatasource);

  @override
  Future<Either<Failure, WorkorderEntity>> getWorkorderById(String id) {
    return safeCall(() async {
      final payload = await _workorderRemoteDatasource.getWorkorderById(id);
      return payload.data!;
    });
  }

  @override
  Future<Either<Failure, List<WorkorderEntity>>> getWorkorders() {
    return safeCall(() async {
      final payload = await _workorderRemoteDatasource.getWorkorders();
      return payload.data ?? [];
    });
  }

  @override
  Future<Either<Failure, WorkorderEntity>> setAssignedStaffs(
      String id, List<UserEntity> staffs) {
    return safeCall(() async {
      final payload = await _workorderRemoteDatasource.setAssignedStaffs(
          staffs.map((e) => e.email).toList(), id);
      return payload.data!;
    });
  }

  @override
  Future<Either<Failure, WorkorderEntity>> setSubmissions(
      String id, List<SubmissionEntity> submissions) {
    return safeCall(() async {
      final submissionsModel =
          submissions.map((e) => SubmissionsModel.fromEntity(e)).toList();
      final payload =
          await _workorderRemoteDatasource.setSubmissions(id, submissionsModel);
      return payload.data!;
    });
  }

  @override
  Future<Either<Failure, void>> setToReady(String id) {
    return safeCall(() async {
      await _workorderRemoteDatasource.setToReady(id);
      return;
    });
  }

  @override
  Future<Either<Failure, void>> setToComplete(String id) {
    // TODO: implement setToComplete
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setToStart(String id) {
    // TODO: implement setToStart
    throw UnimplementedError();
  }
}

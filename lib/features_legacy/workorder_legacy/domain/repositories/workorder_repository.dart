import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/domain/entitties/workorder__entity.dart';

abstract class WorkorderRepository {
  Future<Either<Failure, List<WorkorderEntity>>> getWorkorders();
  Future<Either<Failure, WorkorderEntity>> getWorkorderById(String id);
  Future<Either<Failure, WorkorderEntity>> setAssignedStaffs(
      String id, List<UserEntity> staffs);
  Future<Either<Failure, WorkorderEntity>> setSubmissions(
      String id, List<SubmissionEntity> submissions);
  Future<Either<Failure, void>> setToReady(String id);
  Future<Either<Failure, void>> setToComplete(String id);
  Future<Either<Failure, void>> setToStart(String id);
}

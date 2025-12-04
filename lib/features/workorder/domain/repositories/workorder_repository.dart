import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/workorder/domain/entitties/workorder__entity.dart';

abstract class WorkorderRepository {
  Future<Either<Failure, List<WorkorderEntity>>> getWorkorders();
  Future<Either<Failure, WorkorderEntity>> getWorkorderById(String id);
  Future<Either<Failure, WorkorderEntity>> setAssignedStaffs(
      String id, List<UserEntity> staffs);
}

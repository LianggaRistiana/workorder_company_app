import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/workorder/domain/entitties/workorder__entity.dart';
import 'package:workorder_company_app/features/workorder/domain/repositories/workorder_repository.dart';

class SetAssignedStaffUsecase {
  final WorkorderRepository _workorderRepository;

  SetAssignedStaffUsecase(this._workorderRepository);

  Future<Either<Failure, WorkorderEntity>> call(
      String id, List<UserEntity> staffs) async {
    return await _workorderRepository.setAssignedStaffs(id, staffs);
  }
}

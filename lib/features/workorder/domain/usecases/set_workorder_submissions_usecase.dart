import 'package:dartz/dartz.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/workorder/domain/entitties/workorder__entity.dart';
import 'package:workorder_company_app/features/workorder/domain/repositories/workorder_repository.dart';

class SetWorkorderSubmissionsUsecase {
  final WorkorderRepository _workorderRepository;
  SetWorkorderSubmissionsUsecase(this._workorderRepository);

  Future<Either<Failure, WorkorderEntity>> call(
      String id, List<SubmissionEntity> submissions) async {
    return await _workorderRepository.setSubmissions(id, submissions);
  }
}

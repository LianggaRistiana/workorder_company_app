import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

class SubmitWorkOrderSubmissionUseCase {
  final WorkOrderRepository _repository;

  SubmitWorkOrderSubmissionUseCase(this._repository);

  FutureEitherWithMeta<WorkOrderEntity> call(
    WorkOrderEntity workOrder,
    SubmissionEntity submissions,
  ) {
    return UseCaseExecutor.runDirect<WorkOrderEntity, Result<WorkOrderEntity>>(
      entity: workOrder,
      authorize: null,
      action: (entity) => _repository.submitWorkOrderSubmission(
        entity.id,
        submissions,
      ),
    );
  }
}

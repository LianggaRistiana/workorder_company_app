import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

class AssignStaffsUseCase {
  final WorkOrderRepository _repository;

  AssignStaffsUseCase(this._repository);

  FutureEitherWithMeta<WorkOrderEntity> call(
    WorkOrderEntity workOrder,
    AssignedStaffsDraft staffDraft,
  ) {
    return UseCaseExecutor.runDirect<WorkOrderEntity, Result<WorkOrderEntity>>(
      entity: workOrder,
      authorize: null,
      action: (entity) => _repository.assignStaffs(
        entity.id,
        staffDraft,
      ),
    );
  }
}

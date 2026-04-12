import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/use_case_exceutor.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

class RecreateWorkOrderUseCase {
  final WorkOrderRepository _repository;

  RecreateWorkOrderUseCase(this._repository);

  FutureEitherWithMeta<WorkOrderEntity> call(WorkOrderEntity workOrder) {
    return UseCaseExecutor.runDirect<WorkOrderEntity, Result<WorkOrderEntity>>(
      entity: workOrder,
      authorize: null,
      action: (entity) => _repository.recreateWorkOrder(entity.id),
    );
  }
}

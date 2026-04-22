import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

class CreateWorkOrderUsecase {
  final WorkOrderRepository repository;

  CreateWorkOrderUsecase(this.repository);

  FutureEitherWithMeta<WorkOrderEntity> call(String serviceId) {
    return repository.createWorkOrder(serviceId);
  }
}

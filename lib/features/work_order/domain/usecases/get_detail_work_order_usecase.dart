import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

class GetDetailWorkOrderUsecase {
  final WorkOrderRepository _repository;

  GetDetailWorkOrderUsecase(this._repository);

  FutureEitherWithMeta<WorkOrderEntity> call(String id) {
    return _repository.getWorkOrderById(id);
  }
}

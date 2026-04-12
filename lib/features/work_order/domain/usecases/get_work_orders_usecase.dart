import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

class GetWorkOrdersUsecase {
  final WorkOrderRepository _repository;

  GetWorkOrdersUsecase(this._repository);

  FutureEitherList<WorkOrderEntity> call({bool forceRefresh = false}) {
    return _repository.getWorkOrders(forceRefresh: forceRefresh);
  }
}

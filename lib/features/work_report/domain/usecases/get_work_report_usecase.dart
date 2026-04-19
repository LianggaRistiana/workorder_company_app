import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/repositories/work_report_repository.dart';

class GetWorkReportUsecase {
  final WorkReportRepository _repository;

  GetWorkReportUsecase(this._repository);

  FutureEither<WorkReportEntity> call(WorkOrderEntity workOrder) {
    return _repository.getWorkReport(workOrder.id);
  }
}

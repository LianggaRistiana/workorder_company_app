import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_order_enum.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

class WorkOrderParams extends Equatable {
  final String? search;
  final List<WorkOrderStatus>? status;
  final PositionEntity? positionOnDuty;
  final ServiceSummaryEntity? service;

  const WorkOrderParams({
    this.positionOnDuty,
    this.service,
    this.search,
    this.status,
  });

  WorkOrderParams copyWith({
    Object? search = _sentinel,
    Object? status = _sentinel,
    Object? positionOnDuty = _sentinel,
    Object? service = _sentinel,
  }) {
    return WorkOrderParams(
      positionOnDuty: positionOnDuty == _sentinel
          ? this.positionOnDuty
          : positionOnDuty as PositionEntity?,
      service: service == _sentinel
          ? this.service
          : service as ServiceSummaryEntity?,
      search: search == _sentinel ? this.search : search as String?,
      status:
          status == _sentinel ? this.status : status as List<WorkOrderStatus>?,
    );
  }

  static const _sentinel = Object();

  int get activeFilterCount {
    int count = 0;

    if (search != null && search!.trim().isNotEmpty) {
      count++;
    }

    if (status != null && status!.isNotEmpty) {
      count++;
    }

    if (positionOnDuty != null) {
      count++;
    }

    if (service != null) {
      count++;
    }

    return count;
  }

  @override
  List<Object?> get props => [
        search,
        status,
        positionOnDuty,
        service,
      ];
}

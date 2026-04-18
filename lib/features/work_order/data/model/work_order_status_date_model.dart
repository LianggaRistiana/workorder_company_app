import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_status_date_entity.dart';

class WorkOrderStatusDateModel extends WorkOrderStatusDateEntity {
  const WorkOrderStatusDateModel({
    super.createdAt,
    super.updatedAt,
    super.sentAt,
    super.approvedAt,
    super.rejectedAt,
    super.startedAt,
    super.completedAt,
    super.cancelledAt,
    super.failedAt,
  });

  factory WorkOrderStatusDateModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkOrderStatusDateModel(
      createdAt: json.field('createdAt').optDate(),
      updatedAt: json.field('updatedAt').optDate(),
      sentAt: json.field('sentAt').optDate(),
      approvedAt: json.field('approvedAt').optDate(),
      rejectedAt: json.field('rejectedAt').optDate(),
      startedAt: json.field('startedAt').optDate(),
      completedAt: json.field('completedAt').optDate(),
      cancelledAt: json.field('cancelledAt').optDate(),
      failedAt: json.field('failedAt').optDate(),
    );
  }
}

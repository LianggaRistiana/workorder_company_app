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
      createdAt: json.field('created_at').optDate(),
      updatedAt: json.field('updated_at').optDate(),
      sentAt: json.field('sent_at').optDate(),
      approvedAt: json.field('approved_at').optDate(),
      rejectedAt: json.field('rejected_at').optDate(),
      startedAt: json.field('started_at').optDate(),
      completedAt: json.field('completed_at').optDate(),
      cancelledAt: json.field('cancelled_at').optDate(),
      failedAt: json.field('failed_at').optDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'sent_at': sentAt?.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'rejected_at': rejectedAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'failed_at': failedAt?.toIso8601String(),
    };
  }
}

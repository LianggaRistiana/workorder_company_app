import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_status_date_entity.dart';

class ServiceRequestStatusDateModel extends ServiceRequestStatusDateEntity {
  const ServiceRequestStatusDateModel({
    super.createdAt,
    super.approvedAt,
    super.rejectedAt,
    super.onProgressAt,
    super.completedAt,
    super.unProcessableAt,
    super.closedAt,
    super.cancelledAt,
    super.partiallyCompletedAt,
  });

  factory ServiceRequestStatusDateModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestStatusDateModel(
      createdAt: json.field('createdAt').optDate(),
      approvedAt: json.field('approvedAt').optDate(),
      rejectedAt: json.field('rejectedAt').optDate(),
      onProgressAt: json.field('onProgressAt').optDate(),
      completedAt: json.field('completedAt').optDate(),
      unProcessableAt: json.field('unprocessableAt').optDate(),
      closedAt: json.field('closedAt').optDate(),
      cancelledAt: json.field('cancelledAt').optDate(),
      partiallyCompletedAt: json.field('partialCompletedAt').optDate(),
    );
  }
}

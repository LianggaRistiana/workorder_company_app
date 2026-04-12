import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/result/result.dart';

class WorkOrderSibling extends ResultMeta {
  final String id;
  final String code;
  final WorkOrderStatus status;

  const WorkOrderSibling({
    required this.id,
    required this.code,
    required this.status,
  });

  factory WorkOrderSibling.fromJson(Map<String, dynamic> json) {
    return WorkOrderSibling(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      status: WorkOrderStatus.fromString(json['status']),
    );
  }
}

class WorkOrderCapabilities extends ResultMeta {
  final bool canStart;
  final bool canComplete;
  final bool canFail;

  const WorkOrderCapabilities({
    required this.canStart,
    required this.canComplete,
    required this.canFail,
  });

  factory WorkOrderCapabilities.fromJson(Map<String, dynamic> json) {
    return WorkOrderCapabilities(
      canStart: json['can_start'] ?? false,
      canComplete: json['can_complete'] ?? false,
      canFail: json['can_fail'] ?? false,
    );
  }
}

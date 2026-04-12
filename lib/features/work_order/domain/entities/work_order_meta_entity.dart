import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/result/result.dart';

class WorkOrderMeta extends ResultMeta {
  final WorkOrderCapabilities capabilities;
  final List<WorkOrderSibling> siblings;

  const WorkOrderMeta({
    required this.capabilities,
    required this.siblings,
  });
}

class WorkOrderSibling {
  final String id;
  final String code;
  final WorkOrderStatus status;

  const WorkOrderSibling({
    required this.id,
    required this.code,
    required this.status,
  });
}

class WorkOrderCapabilities {
  final bool canStart;
  final bool canComplete;
  final bool canFail;

  const WorkOrderCapabilities({
    required this.canStart,
    required this.canComplete,
    required this.canFail,
  });
}

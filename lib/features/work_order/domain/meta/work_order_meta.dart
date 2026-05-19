import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

class WorkOrderSiblings extends ResultMeta {
  final List<WorkOrderSibling> siblings;
  const WorkOrderSiblings({
    required this.siblings,
  });

  factory WorkOrderSiblings.fromJson(dynamic json) {
    final list = json as List<dynamic>?;

    return WorkOrderSiblings(
      siblings: list
              ?.map((e) => WorkOrderSibling.fromJson(
                    e as Map<String, dynamic>,
                  ))
              .toList() ??
          [],
    );
  }

  bool get hasMultipleSiblings => siblings.length > 1;
}

class WorkOrderSibling extends ResultMeta {
  final String id;
  final String code;
  final WorkOrderStatus status;
  final PositionEntity position;

  const WorkOrderSibling({
    required this.id,
    required this.code,
    required this.status,
    required this.position,
  });

  factory WorkOrderSibling.fromJson(Map<String, dynamic> json) {
    return WorkOrderSibling(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      status: WorkOrderStatus.fromString(json['status']),
      position: json.field("position").reqModel(PositionModel.fromJson),
    );
  }
}

class WorkReportMeta extends ResultMeta {
  final bool isReportNeedReview;

  const WorkReportMeta({
    required this.isReportNeedReview,
  });

  factory WorkReportMeta.fromJson(Map<String, dynamic> json) {
    return WorkReportMeta(
      isReportNeedReview: json['reportNeedReview'] ?? false,
    );
  }

  factory WorkReportMeta.fromDynamic(dynamic json) {
    if (json is bool) {
      return WorkReportMeta(
        isReportNeedReview: json,
      );
    }
    if (json is Map<String, dynamic>) {
      return WorkReportMeta.fromJson(json);
    }

    return WorkReportMeta(
      isReportNeedReview: false,
    );
  }
}

class WorkOrderCapabilities extends ResultMeta {
  final bool canStart;
  final bool canComplete;
  final bool canFail;
  final bool canRecreate;
  final bool canCancel;

  const WorkOrderCapabilities({
    required this.canStart,
    required this.canComplete,
    required this.canFail,
    required this.canRecreate,
    required this.canCancel,
  });

  factory WorkOrderCapabilities.fromJson(Map<String, dynamic> json) {
    return WorkOrderCapabilities(
      canStart: json['can_start'] ?? false,
      canComplete: json['can_complete'] ?? false,
      canFail: json['can_fail'] ?? false,
      canRecreate: json['can_recreate'] ?? false,
      canCancel: json['can_cancel'] ?? false,
    );
  }
}

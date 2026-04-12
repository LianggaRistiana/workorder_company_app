import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/model/meta_model.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_meta_entity.dart';

class WorkOrderMetaModel extends WorkOrderMeta implements MetaModel {
  const WorkOrderMetaModel({
    required super.capabilities,
    required super.siblings,
  });

  factory WorkOrderMetaModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderMetaModel(
      capabilities: json
          .field('capabilities')
          .reqModel(WorkOrderCapabilitiesModel.fromJson),
      siblings:
          json.field('siblings').reqListModel(WorkOrderSiblingModel.fromJson),
    );
  }
}

class WorkOrderSiblingModel extends WorkOrderSibling {
  const WorkOrderSiblingModel({
    required super.id,
    required super.code,
    required super.status,
  });

  factory WorkOrderSiblingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkOrderSiblingModel(
      id: json.field('id').reqString(),
      code: json.field('code').reqString(),
      status: json.field('status').reqEnum(WorkOrderStatus.fromString),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'status': status.toJsonString,
    };
  }
}

class WorkOrderCapabilitiesModel extends WorkOrderCapabilities {
  const WorkOrderCapabilitiesModel({
    required super.canStart,
    required super.canComplete,
    required super.canFail,
  });

  factory WorkOrderCapabilitiesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkOrderCapabilitiesModel(
      canStart: json.field('can_start').reqBool(),
      canComplete: json.field('can_complete').reqBool(),
      canFail: json.field('can_fail').reqBool(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_start': canStart,
      'can_complete': canComplete,
      'can_fail': canFail,
    };
  }
}

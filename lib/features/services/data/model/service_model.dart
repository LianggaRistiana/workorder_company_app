import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/services/generator/random_string.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/services/data/model/service_request_config_model.dart';
import 'package:workorder_company_app/features/services/data/model/work_order_config_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    super.description,
    required super.accessType,
    required super.isActive,
    required super.serviceRequestConfig,
    required super.workOrdersConfig,
    required super.workOrderDraftingType,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json.field('_id').reqString(),
      title: json.field('title').reqString(),
      description: json.field('description').optString() ?? "",
      accessType:
          json.field('accessType').reqEnum(ServiceAccessType.fromString),
      isActive: json.field('isActive').reqBool(),
      serviceRequestConfig: json
          .field("serviceRequestConfig")
          .reqModel(ServiceRequestConfigModel.fromJson),
      workOrderDraftingType: json
          .field("draftingWorkOrderType")
          .reqEnum(WorkOrderDraftingType.fromString),
      workOrdersConfig: json
              .field("workOrdersConfig")
              .optListModel(WorkOrderConfigModel.fromJson) ??
          [],
    );
  }

  factory ServiceModel.fromJsonTemplate(Map<String, dynamic> json) {
    return ServiceModel(
      id: RandomString.generate(),
      title: json.field('title').reqString(),
      description: json.field('description').optString() ?? "",
      accessType:
          json.field('accessType').reqEnum(ServiceAccessType.fromString),
      isActive: json.field('isActive').reqBool(),
      serviceRequestConfig: json
          .field("serviceRequestConfig")
          .reqModel(ServiceRequestConfigModel.fromJsonTemplate),
      workOrderDraftingType: json
          .field("drafting_work_order_type")
          .reqEnum(WorkOrderDraftingType.fromString),
      workOrdersConfig: json
              .field("workOrdersConfig")
              .optListModel(WorkOrderConfigModel.fromJsonTemplate) ??
          [],
    );
  }

  factory ServiceModel.fromEntity(ServiceEntity entity) {
    return ServiceModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      accessType: entity.accessType,
      isActive: entity.isActive,
      workOrderDraftingType: entity.workOrderDraftingType,
      serviceRequestConfig:
          ServiceRequestConfigModel.fromEntity(entity.serviceRequestConfig),
      workOrdersConfig: entity.workOrdersConfig
          .map((e) => WorkOrderConfigModel.fromEntity(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "accessType": accessType.toSnakeCase(),
      "isActive": isActive,
      "draftingWorkOrderType": workOrderDraftingType.toSnakeCase(),
      "serviceRequestConfig":
          (serviceRequestConfig as ServiceRequestConfigModel).toJson(),
      "workOrdersConfig": workOrdersConfig
          .map((e) => (e as WorkOrderConfigModel).toJson())
          .toList()
    };
  }

  ServiceEntity toEntity() {
    return ServiceEntity(
        serviceRequestConfig: serviceRequestConfig,
        workOrdersConfig: workOrdersConfig,
        id: id,
        title: title,
        description: description,
        accessType: accessType,
        isActive: isActive,
        workOrderDraftingType: workOrderDraftingType);
  }

  ServiceSummaryEntity toSummaryEntity() {
    return ServiceSummaryEntity(
        id: id,
        title: title,
        description: description,
        accessType: accessType,
        isActive: isActive);
  }
}

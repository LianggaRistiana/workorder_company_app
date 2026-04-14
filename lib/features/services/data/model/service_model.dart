import 'package:workorder_company_app/core/constants/app_enums.dart';
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
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: safeParse<String>(json, "_id"),
      title: safeParse<String>(json, "title"),
      description:
          safeParse<String?>(json, "description", requiredField: false),
      accessType:
          ServiceAccessType.fromString(safeParse<String>(json, "accessType")),
      isActive: safeParse<bool>(json, "isActive"),
      serviceRequestConfig:
          ServiceRequestConfigModel.fromJson(json["serviceRequestConfig"]),
      workOrdersConfig: (json["workOrdersConfig"] as List<dynamic>?)
              ?.map((e) => WorkOrderConfigModel.fromJson(e))
              .toList() ??
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
        isActive: isActive);
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

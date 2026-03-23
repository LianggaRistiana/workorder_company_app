import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/services/data/model/service_request_config_model.dart';
import 'package:workorder_company_app/features/services/data/model/work_order_config_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.accessType,
    required super.isActive,
    required super.serviceRequestConfig,
    required super.workOrdersConfig,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: safeParse<String>(json, "_id"),
      title: safeParse<String>(json, "title"),
      description: safeParse<String>(json, "description"),
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

  
}

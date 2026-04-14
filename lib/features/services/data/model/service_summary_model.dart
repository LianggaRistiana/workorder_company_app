import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

class ServiceSummaryModel extends ServiceSummaryEntity {
  const ServiceSummaryModel(
      {required super.id,
      required super.title,
      super.description,
      required super.accessType,
      required super.isActive});

  factory ServiceSummaryModel.fromJson(Map<String, dynamic> json) {
    return ServiceSummaryModel(
      id: safeParse<String>(json, "_id"),
      title: safeParse<String>(json, "title"),
      description:
          safeParse<String?>(json, "description", requiredField: false),
      // description: "TEST",
      accessType:
          ServiceAccessType.fromString(safeParse<String>(json, "accessType")),
      isActive: safeParse<bool>(json, "isActive"),
    );
  }

  ServiceSummaryEntity toEntity() {
    return ServiceSummaryEntity(
      id: id,
      title: title,
      description: description,
      accessType: accessType,
      isActive: isActive,
    );
  }

  factory ServiceSummaryModel.fromServiceEntity(ServiceEntity entity) {
    return ServiceSummaryModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      accessType: entity.accessType,
      isActive: entity.isActive,
    );
  }
}

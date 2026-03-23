import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

class ServiceSummaryModel extends ServiceSummaryEntity {
  const ServiceSummaryModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.accessType,
      required super.isActive});

  factory ServiceSummaryModel.fromJson(Map<String, dynamic> json) {
    return ServiceSummaryModel(
      id: safeParse<String>(json, "_id"),
      title: safeParse<String>(json, "title"),
      description: safeParse<String>(json, "description"),
      accessType:
          ServiceAccessType.fromString(safeParse<String>(json, "accessType")),
      isActive: safeParse<bool>(json, "isActive"),
    );
  }
}

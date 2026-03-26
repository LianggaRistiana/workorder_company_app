import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_request_config_entity.dart';

class ServiceRequestConfigModel extends ServiceRequestConfigEntity {
  const ServiceRequestConfigModel(
      {required super.intakeForm,
      required super.reviewForm,
      required super.serviceRequestApprovalAccessType,
      required super.reviewNeed});

  factory ServiceRequestConfigModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestConfigModel(
      intakeForm: FormModel.fromJson(json["intakeForm"]),
      reviewForm: FormModel.fromJson(json["reviewForm"]),
      serviceRequestApprovalAccessType: ServiceRequestApprovalAccess.fromString(
          safeParse<String>(json, "serviceRequestApprovalAccessType")),
      reviewNeed: safeParse<bool>(json, "reviewNeed"),
    );
  }

  factory ServiceRequestConfigModel.fromEntity(ServiceRequestConfigEntity entity) {
    return ServiceRequestConfigModel(
      intakeForm: entity.intakeForm,
      reviewForm: entity.reviewForm,
      serviceRequestApprovalAccessType: entity.serviceRequestApprovalAccessType,
      reviewNeed: entity.reviewNeed,
    );
  }

  Map<String, dynamic> toJson() { 
    return {
      "intakeForm": (intakeForm as FormModel).toJson(),
      "reviewForm": (reviewForm as FormModel).toJson(),
      "serviceRequestApprovalAccessType": serviceRequestApprovalAccessType.toSnakeCase(),
      "reviewNeed": reviewNeed,
    };
  }

  
}

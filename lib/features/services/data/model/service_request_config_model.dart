import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_request_config_entity.dart';

class ServiceRequestConfigModel extends ServiceRequestConfigEntity {
  const ServiceRequestConfigModel({
    required super.intakeForm,
    required super.reviewForm,
    required super.serviceRequestApprovalAccessType,
    required super.reviewNeed,
  });

  factory ServiceRequestConfigModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestConfigModel(
      intakeForm: json.field("intakeForm").reqModel(FormModel.fromJson),
      reviewForm: json.field("reviewForm").reqModel(FormModel.fromJson),
      serviceRequestApprovalAccessType: json
          .field("serviceRequestApprovalAccessType")
          .reqEnum(ServiceRequestApprovalAccess.fromString),
      reviewNeed: json.field("reviewNeed").reqBool(),
    );
  }

  factory ServiceRequestConfigModel.fromJsonTemplate(
      Map<String, dynamic> json) {
    return ServiceRequestConfigModel(
      intakeForm: json.field("intakeForm").reqModel(FormModel.fromJsonTemplate),
      reviewForm: json.field("reviewForm").reqModel(FormModel.fromJsonTemplate),
      serviceRequestApprovalAccessType: json
          .field("serviceRequestApprovalAccessType")
          .reqEnum(ServiceRequestApprovalAccess.fromString),
      reviewNeed: json.field("reviewNeed").reqBool(),
    );
  }

  factory ServiceRequestConfigModel.fromEntity(
      ServiceRequestConfigEntity entity) {
    return ServiceRequestConfigModel(
      intakeForm: entity.intakeForm,
      reviewForm: entity.reviewForm,
      serviceRequestApprovalAccessType: entity.serviceRequestApprovalAccessType,
      reviewNeed: entity.reviewNeed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "intakeFormId": intakeForm.id,
      "reviewFormId": reviewForm.id,
      "serviceRequestApprovalAccessType":
          serviceRequestApprovalAccessType.toSnakeCase(),
      "reviewNeed": reviewNeed,
    };
  }
}

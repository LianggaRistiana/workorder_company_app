import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/service_request/data/model/service_request_status_date_model.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';

class ProviderServiceRequestModel extends ProviderServiceRequestEntity {
  ProviderServiceRequestModel({
    required super.id,
    required super.code,
    required super.status,
    required super.service,
    required super.requestedBy,
    required super.reviewNeed,
    required super.approvalAccess,
    super.approvedBy,
    super.intakeForm,
    super.reviewForm,
    required super.statusDate,
  });

  factory ProviderServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ProviderServiceRequestModel(
        id: json.field('_id').reqString(),
        code: json.field('code').reqString(),
        status: json.field('status').reqEnum(ServiceRequestStatus.fromString),
        service: json.field('service').reqModel(ServiceSummaryModel.fromJson),
        requestedBy: json.field('requestedBy').reqModel(UserModel.fromJson),
        approvedBy: json.field('approvedBy').optModel(UserModel.fromJson),
        reviewNeed: json.field('reviewNeed').reqBool(),
        approvalAccess: json
            .field('workOrderApprovalAccessType')
            .reqEnum(ServiceRequestApprovalAccess.fromString),
        intakeForm: json['intakeForm'] == null
            ? null
            : FilledFormModel.fromJson(
                json['intakeForm'], json['intakeSubmission']),
        reviewForm: json['reviewForm'] == null
            ? null
            : FilledFormModel.fromJson(
                json['reviewForm'], json['reviewSubmission']),
        statusDate: ServiceRequestStatusDateModel.fromJson(json));
  }
}

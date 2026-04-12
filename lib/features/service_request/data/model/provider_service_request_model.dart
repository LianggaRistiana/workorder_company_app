import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
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
    required super.createdAt,
  });

  // TODO : use safe parser for safety
  factory ProviderServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ProviderServiceRequestModel(
      id: json['_id'],
      code: json['code'],
      status: ServiceRequestStatus.fromString(json['serviceRequestStatus']),
      service: ServiceSummaryModel.fromJson(json['service']),
      requestedBy: UserModel.fromJson(json['requestedBy']),
      approvedBy: json['approvedBy'] == null
          ? null
          : UserModel.fromJson(json['approvedBy']),
      reviewNeed: safeParse<bool>(json, "reviewNeed", requiredField: true),
      // reviewNeed: false,
      approvalAccess: ServiceRequestApprovalAccess.fromString(
          json['serviceRequestApprovalAccessType']),
      intakeForm: json['intakeForm'] == null
          ? null
          : FilledFormModel.fromJson(
              json['intakeForm'], json['intakeSubmission']),
      reviewForm: json['reviewForm'] == null
          ? null
          : FilledFormModel.fromJson(
              json['reviewForm'], json['reviewSubmission']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/service_request/data/model/service_request_status_date_model.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';

class RequesterServiceRequestModel extends RequesterServiceRequestEntity {
  RequesterServiceRequestModel({
    required super.id,
    required super.code,
    required super.status,
    required super.service,
    required super.requestedBy,
    super.approvedBy,
    required super.company,
    super.intakeForm,
    super.reviewForm,
    required super.statusDate,
  });

  factory RequesterServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return RequesterServiceRequestModel(
        id: json.field('_id').reqString(),
        code: json.field('code').reqString(),
        status: json.field('serviceRequestStatus').reqEnum(ServiceRequestStatus.fromString),
        service: json.field('service').reqModel(ServiceSummaryModel.fromJson),
        requestedBy: json.field('requestedBy').reqModel(UserModel.fromJson),
        approvedBy: json.field('approvedBy').optModel(UserModel.fromJson),
        company: json.field('company').reqModel(CompanyModel.fromJson),
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

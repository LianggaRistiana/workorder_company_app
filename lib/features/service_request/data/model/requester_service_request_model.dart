import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';

class RequesterServiceRequestModel extends RequesterServiceRequestEntity {
  RequesterServiceRequestModel({
    required super.id,
    required super.code,
    required super.status,
    required super.service,
    required super.requestedBy,
    required super.company,
    super.intakeForm,
    super.reviewForm,
    required super.createdAt,
  });

  factory RequesterServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return RequesterServiceRequestModel(
      id: json['_id'],
      code: json['code'],
      status: ServiceRequestStatus.fromString(json['status']),
      service: ServiceSummaryModel.fromJson(json['service']),
      requestedBy: UserModel.fromJson(json['requestedBy']),
      company: CompanyModel.fromJson(json['company']),
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

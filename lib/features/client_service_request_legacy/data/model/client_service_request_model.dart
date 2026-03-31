import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/client_service_request_legacy/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/ordered_form_model.dart';
import 'package:workorder_company_app/features/services_legacy/data/models/service_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';

class ClientServiceRequestModel extends ClientServiceRequestEntity {
  ClientServiceRequestModel({
    required super.id,
    required super.status,
    required super.createdAt,
    required super.companyId,
    required super.client,
    required super.service,
    super.clientIntakeForms,
  });

  factory ClientServiceRequestModel.fromJson(Map<String, dynamic> json) {

    final orderedForms = (json['clientIntakeForms'] as List<dynamic>?)
        ?.map((form) => OrderedFormModel.fromJson(form))
        .toList();

    final submissions = (json['submissions'] as List<dynamic>?)
        ?.map((sub) => SubmissionsModel.fromJson(sub))
        .toList();

    final filledForms = orderedForms?.map((form) {
      final matchedSubmission =
          submissions?.where((sub) => sub.formId == form.form.id).firstOrNull;

      return FilledFormModel(
        order: form.order,
        form: form.form,
        submission: matchedSubmission,
      );
    }).toList();

    return ClientServiceRequestModel(
      // id: json['_id'] as String,
      // companyId: json['companyId'] as String,
      id : safeParse<String>(json, "_id"),
      companyId: safeParse<String>(json, "companyId"),

      status: ClientServiceRequestStatus.fromString(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      client: UserModel.fromJson(json['client']),
      service: ServiceModel.fromJson(json['service']),
      clientIntakeForms: filledForms,
    );
  }
}

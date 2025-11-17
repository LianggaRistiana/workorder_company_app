import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/client_service_request/domain/entitties/client_service_request_entity.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/services/data/models/service_model.dart';
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
    final forms = json['clientIntakeForms'] as List<dynamic>?;
    final submissions = json['submissions'] as List<dynamic>?;

    // bikin map submission berdasarkan formId biar cepat dicari
    final submissionMap = {
      for (var sub in submissions ?? []) sub['formId']: sub
    };

    int order = 1;

    // mapping form + submission jadi FilledFormModel
    final filledForms = forms?.map((form) {
      final formId = form['_id'] as String;
      final matchedSubmission = submissionMap[formId];

      return FilledFormModel(
        order:
            order++, // TODO: order sementara memakai index lokal, bukan dari backend
        form: FormModel.fromJson(form),
        submission: matchedSubmission != null
            ? SubmissionsModel.fromJson(matchedSubmission)
            : null,
      );
    }).toList();

    return ClientServiceRequestModel(
      id: json['_id'] as String,
      status: ClientServiceRequestStatus.fromString(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      companyId: json['companyId'] as String,
      client: UserModel.fromJson(json['client']),
      service: ServiceModel.fromJson(json['service']),
      clientIntakeForms: filledForms,
    );
  }
}

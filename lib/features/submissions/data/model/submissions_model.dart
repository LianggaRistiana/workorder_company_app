import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/field_data_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class SubmissionsModel extends SubmissionEntity {
  SubmissionsModel(
      {required super.id,
      required super.formId,
      required super.submissionType,
      super.status,
      super.submittedBy,
      super.fieldsData});

  factory SubmissionsModel.fromJson(Map<String, dynamic> json) {
    return SubmissionsModel(
      id: json['id'],
      formId: json['formId'],
      submissionType: FormType.fromString(json['submissionType']),
      status: json['status'],
      submittedBy: json['submittedBy'] != null
          ? UserModel.fromJson(json['submittedBy'])
          : null,
      fieldsData: (json['fieldsData'] as List<dynamic>?)
          ?.map((e) => FieldDataModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formId': formId,
      'submissionType': submissionType.toSnakeCase(),
      'status': status,
      'submittedBy': (submittedBy as UserModel?)?.toJson(),
      'fieldsData':
          fieldsData?.map((e) => (e as FieldDataModel).toJson()).toList(),
    };
  }

  factory SubmissionsModel.fromEntity(SubmissionEntity entity) {
    return SubmissionsModel(
      id: entity.id,
      formId: entity.formId,
      submissionType: entity.submissionType,
      status: entity.status,
      fieldsData: entity.fieldsData
          ?.map((e) => FieldDataModel(order: e.order, value: e.value))
          .toList(),
    );
  }
}

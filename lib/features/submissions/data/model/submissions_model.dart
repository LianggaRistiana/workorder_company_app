import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/field_data_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class SubmissionsModel extends SubmissionEntity {
  SubmissionsModel(
      {required super.id,
      required super.formId,
      required super.submissionType,
      super.status,
      super.submittedBy, // TODO : mapp from json
      super.fieldsData,
      super.createdAt,
      // super.updatedAt,
      });

  factory SubmissionsModel.fromJson(Map<String, dynamic> json) {
    return SubmissionsModel(
      id: safeParse<String>(json, "_id"),
      formId:safeParse<String>(json, "formId"),
      submissionType: FormType.fromString(json['submissionType']),
      status: json['status'] != null
          ? SubmissionStatus.fromString(json['status'])
          : null,
      fieldsData: (json['fieldsData'] as List<dynamic>?)
          ?.map((e) => FieldDataModel.fromJson(e))
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formId': formId,
      'submissionType': submissionType.toSnakeCase(),
      'status': status?.toSnakeCase(),
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

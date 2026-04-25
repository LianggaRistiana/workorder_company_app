import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/submissions/data/model/field_data_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class SubmissionsModel extends SubmissionEntity {
  SubmissionsModel({
    required super.id,
    required super.formId,
    required super.submissionType,
    super.fieldsData,
    required super.createdAt,
  });

  factory SubmissionsModel.fromJson(Map<String, dynamic> json) {
    return SubmissionsModel(
      id: safeParse<String>(json, "_id"),
      formId: safeParse<String>(json, "formId"),
      submissionType: FormType.fromString(json['submissionType']),
      fieldsData: (json['fieldsData'] as List<dynamic>?)
          ?.map((e) => FieldDataModel.fromJson(e))
          .toList(),
      createdAt: json.field('createdAt').reqDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formId': formId,
      'submissionType': submissionType.toSnakeCase(),
      'fieldsData':
          fieldsData?.map((e) => (e as FieldDataModel).toJson()).toList(),
    };
  }

  factory SubmissionsModel.fromEntity(SubmissionEntity entity) {
    return SubmissionsModel(
      id: entity.id,
      formId: entity.formId,
      submissionType: entity.submissionType,
      fieldsData: entity.fieldsData
          ?.map((e) => FieldDataModel(order: e.order, value: e.value))
          .toList(),
      createdAt: entity.createdAt,
    );
  }
}

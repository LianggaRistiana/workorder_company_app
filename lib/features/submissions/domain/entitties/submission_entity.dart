import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';

class SubmissionEntity {
  final String id;
  final String formId;
  final FormType submissionType;
  final SubmissionStatus? status;
  final UserEntity? submittedBy;
  final List<FieldDataEntity>? fieldsData;

  const SubmissionEntity({
    required this.id,
    required this.formId,
    required this.submissionType,
    this.status,
    this.submittedBy,
    this.fieldsData,
  });

  SubmissionEntity copyWith({
    String? id,
    String? formId,
    FormType? submissionType,
    SubmissionStatus? status,
    UserEntity? submittedBy,
    List<FieldDataEntity>? fieldsData,
  }) {
    return SubmissionEntity(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      submissionType: submissionType ?? this.submissionType,
      status: status ?? this.status,
      submittedBy: submittedBy ?? this.submittedBy,
      fieldsData: fieldsData ?? this.fieldsData,
    );
  }

  @override
  String toString() {
    return 'SubmissionEntity(id: $id, formId: $formId, submissionType: $submissionType, status: $status, submittedBy: $submittedBy, fieldsData: ${fieldsData?.map((e) => e.toString()).toList() ?? []})';
  }
  
}

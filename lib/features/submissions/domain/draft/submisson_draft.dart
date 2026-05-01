import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/field_data_draft.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/media_item.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/submission_entity.dart';

// TODO[FUTURE IMPROVEMENT] : Make coordinator with isDirty feature
class SubmissionDraft {
  final String formId;
  FormType submissionType;
  List<FieldDataDraft> fieldsData;

  SubmissionDraft({
    required this.formId,
    required this.submissionType,
    required this.fieldsData,
  });

  factory SubmissionDraft.fromFormEntity(FormEntity form) {
    return SubmissionDraft(
      formId: form.id,
      submissionType: form.formType,
      fieldsData: form.fields
              ?.map((f) => FieldDataDraft(order: f.order.toString()))
              .toList() ??
          [],
    );
  }

  factory SubmissionDraft.fromEntity(SubmissionEntity entity) {
    return SubmissionDraft(
      formId: entity.formId,
      submissionType: entity.submissionType,
      fieldsData: entity.fieldsData
              ?.map((f) => FieldDataDraft(order: f.order, value: f.value))
              .toList() ??
          [],
    );
  }

  void updateValue(String order, dynamic value) {
    final index = fieldsData.indexWhere((f) => f.order == order);
    if (index != -1) {
      fieldsData[index].updateValue(value);
    }
  }

  FieldDataDraft? getFieldByOrder(String order) {
    try {
      return fieldsData.firstWhere((e) => e.order == order);
    } catch (_) {
      return null;
    }
  }

  SubmissionEntity toEntity() {
    validateNoLocalMedia();

    return SubmissionEntity(
      id: "",
      formId: formId,
      submissionType: submissionType,
      fieldsData: fieldsData.map((f) => f.toEntity()).toList(),
      createdAt: DateTime.now(),
    );
  }
}

extension SubmissionDraftValidation on SubmissionDraft {
  void validateNoLocalMedia() {
    for (final field in fieldsData) {
      if (field.value is MediaItem) {
        throw ValidationException("Masih ada media belum diupload");
      }
    }
  }
}

extension SubmissionDraftClone on SubmissionDraft {
  SubmissionDraft clone() {
    return SubmissionDraft(
      formId: formId,
      submissionType: submissionType,
      fieldsData: fieldsData
          .map((f) => FieldDataDraft(
                order: f.order,
                value: f.value,
              ))
          .toList(),
    );
  }
}

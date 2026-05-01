import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/field_data_draft.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/media_item.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/submission_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_task.dart';

// TODO[FUTURE IMPROVEMENT] : Make coordinator with isDirty feature
class SubmissionDraft {
  final String formId;
  FormType submissionType;
  List<FieldDataDraft> fieldsData;

  SubmissionDraft._({
    required this.formId,
    required this.submissionType,
    required this.fieldsData,
  });

  factory SubmissionDraft.fromFormEntity(FormEntity form) {
    return SubmissionDraft._(
      formId: form.id,
      submissionType: form.formType,
      fieldsData: form.fields
              ?.map((f) => FieldDataDraft(order: f.order.toString()))
              .toList() ??
          [],
    );
  }

  factory SubmissionDraft.same({
    required String formId,
    required FormType submissionType,
    required List<FieldDataDraft> fieldsData,
  }) {
    return SubmissionDraft._(
        formId: formId, submissionType: submissionType, fieldsData: fieldsData);
  }

  factory SubmissionDraft.fromEntity(SubmissionEntity entity) {
    return SubmissionDraft._(
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
    return SubmissionEntity(
      id: "",
      formId: formId,
      submissionType: submissionType,
      fieldsData: fieldsData.map((f) => f.toEntity()).toList(),
      createdAt: DateTime.now(),
    );
  }
}

extension SubmissionDraftX on SubmissionDraft {
  List<MediaItem> get mediaItems {
    return fieldsData
        .where((f) => f.value is MediaItem && !(f.value as MediaItem).isNetwork)
        .map((f) => f.value as MediaItem)
        .toList();
  }
}

extension SubmissionDraftValidation on SubmissionDraft {
  void validateNoLocalMedia() {
    for (final field in fieldsData) {
      if (field.value is MediaItem) {
        throw Exception("Masih ada media belum diupload");
      }
    }
  }
}

extension SubmissionDraftReplace on SubmissionDraft {
  SubmissionDraft replaceMediaWithUrls(List<UploadTask> tasks) {
    final updated = fieldsData.map((field) {
      final value = field.value;

      if (value is MediaItem && !value.isNetwork) {
        final task = tasks.firstWhere(
          (t) => t.filePath == value.path,
          orElse: () => throw NetworkException(
            "Upload tidak ditemukan untuk ${value.path}",
          ),
        );

        return FieldDataDraft(
          order: field.order,
          value: task.url,
        );
      }

      return field;
    }).toList();

    return SubmissionDraft._(
      formId: formId,
      submissionType: submissionType,
      fieldsData: updated,
    );
  }
}

extension SubmissionDraftClone on SubmissionDraft {
  SubmissionDraft clone() {
    return SubmissionDraft._(
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

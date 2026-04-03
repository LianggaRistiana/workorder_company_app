import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/has_form.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';

class FilledFormWithHistoryEntity implements HasForm {
  @override
  final FormEntity form;
  final List<SubmissionEntity>? submissionHistory;

  const FilledFormWithHistoryEntity({
    required this.form,
    this.submissionHistory,
  });

  FilledFormWithHistoryEntity copyWith({
    FormEntity? form,
    List<SubmissionEntity>? submissionHistory,
  }) {
    return FilledFormWithHistoryEntity(
      form: form ?? this.form,
      submissionHistory: submissionHistory ?? this.submissionHistory,
    );
  }
}

extension FilledFormWithHistoryEntityTools on FilledFormWithHistoryEntity {
  /// History tidak pernah null
  List<SubmissionEntity> get history =>
      List.unmodifiable(submissionHistory ?? []);

  /// Apakah punya submission
  bool get hasSubmission => history.isNotEmpty;

  /// Submission terbaru (anggap paling akhir = terbaru)
  SubmissionEntity? get latestSubmission => hasSubmission ? history.last : null;

  /// Submission pertama
  SubmissionEntity? get firstSubmission => hasSubmission ? history.first : null;

  /// Ambil submission berdasarkan id
  SubmissionEntity? getSubmissionById(String id) {
    try {
      return history.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// History diurutkan terbaru → terlama
  List<SubmissionEntity> get historyDescending {
    final list = [...history];
    list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return list;
  }

  /// Tambah submission baru (append immutable)
  FilledFormWithHistoryEntity addSubmission(SubmissionEntity submission) {
    final updatedHistory = [...history, submission];

    return copyWith(
      submissionHistory: updatedHistory,
    );
  }

  /// Replace submission berdasarkan id
  FilledFormWithHistoryEntity replaceSubmission(SubmissionEntity updated) {
    final updatedHistory = history.map((e) {
      if (e.id == updated.id) return updated;
      return e;
    }).toList();

    return copyWith(
      submissionHistory: updatedHistory,
    );
  }

  /// Hapus submission berdasarkan id
  FilledFormWithHistoryEntity removeSubmission(String id) {
    final updatedHistory = history.where((e) => e.id != id).toList();

    return copyWith(
      submissionHistory: updatedHistory,
    );
  }
}

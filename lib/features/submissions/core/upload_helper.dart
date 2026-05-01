import 'dart:async';
import 'dart:math';
import 'package:workorder_company_app/features/submissions/core/file_upload_manager.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/field_data_draft.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/media_item.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_task.dart';

class UploadHelper {
  final UploadManager uploadManager;

  UploadHelper(this.uploadManager);

  Future<SubmissionDraft> processDraft(SubmissionDraft submission) async {
    final groupId = _generateGroupId();
    SubmissionDraft workingDraft = submission.clone();

    final media = _extractMedia(workingDraft);
    if (media.isEmpty) return workingDraft;

    _startUpload(media, groupId);

    final tasks =
        await _waitUploadDone(groupId).timeout(const Duration(minutes: 2));

    uploadManager.closeGroup(groupId);

    return _replaceMedia(workingDraft, tasks);
  }

  // =========================

  String _generateGroupId() {
    final rand = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${rand.nextInt(99999)}';
  }

  List<MediaItem> _extractMedia(SubmissionDraft draft) {
    return draft.fieldsData
        .where((f) => f.value is MediaItem && !(f.value as MediaItem).isNetwork)
        .map((f) => f.value as MediaItem)
        .toList();
  }

  void _startUpload(List<MediaItem> media, String groupId) {
    for (final item in media) {
      uploadManager.addUpload(
        filePath: item.path,
        groupId: groupId,
      );
    }
  }

  Future<List<UploadTask>> _waitUploadDone(String groupId) async {
    final completer = Completer<List<UploadTask>>();
    late StreamSubscription sub;

    sub = uploadManager.stream.listen((tasks) {
      final groupTasks = tasks.where((t) => t.groupId == groupId).toList();

      if (groupTasks.isEmpty) return;

      final allDone = groupTasks.every((t) => t.isDone);
      final hasError = groupTasks.any((t) => t.error != null);

      if (hasError) {
        sub.cancel();
        if (!completer.isCompleted) {
          completer.completeError(Exception("Upload gagal"));
        }
        return;
      }

      if (allDone) {
        sub.cancel();
        if (!completer.isCompleted) {
          completer.complete(groupTasks);
        }
      }
    });

    return completer.future;
  }

  SubmissionDraft _replaceMedia(
    SubmissionDraft draft,
    List<UploadTask> tasks,
  ) {
    final updated = draft.fieldsData.map((field) {
      final value = field.value;

      if (value is MediaItem && !value.isNetwork) {
        final task = tasks.firstWhere(
          (t) => t.filePath == value.path,
          orElse: () => throw Exception(
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

    return SubmissionDraft(
      formId: draft.formId,
      submissionType: draft.submissionType,
      fieldsData: updated,
    );
  }
}

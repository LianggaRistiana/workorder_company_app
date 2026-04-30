import 'dart:async';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_task.dart';
import 'package:workorder_company_app/features/submissions/domain/usecases/file_upload_usecase.dart';

class UploadManager {
  final UploadFileUseCase _useCase;

  final List<UploadTask> _tasks = [];

  final _controller = StreamController<List<UploadTask>>.broadcast();

  Stream<List<UploadTask>> get stream => _controller.stream;

  UploadManager(this._useCase);

  // 🔥 Add new upload
  void addUpload({
    required String filePath,
    required String groupId,
  }) {
    final task = UploadTask.create(
      filePath: filePath,
      groupId: groupId,
    );

    _tasks.add(task);
    _emit();

    _useCase(filePath).listen(
      (result) {
        _updateTask(task.id, result);
      },
      onError: (e) {
        _failTask(task.id, e.toString());
      },
    );
  }

  // 🔄 Update task from UploadResult
  void _updateTask(String taskId, UploadResult result) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final current = _tasks[index];

    final updated = current.copyWith(
      progress: result.progress,
      isDone: result.isDone,
      url: result.url ?? current.url,
      error: result.error,
    );

    _tasks[index] = updated;
    _emit();
  }

  void _failTask(String taskId, String error) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final current = _tasks[index];

    _tasks[index] = current.copyWith(
      isDone: true,
      error: error,
    );

    _emit();
  }

  // 📡 Emit immutable list
  void _emit() {
    _controller.add(List.unmodifiable(_tasks));
  }

  // 🎯 Helper: get tasks by group
  List<UploadTask> getByGroup(String groupId) {
    return _tasks.where((t) => t.groupId == groupId).toList();
  }

  // 📊 Helper: progress aggregate
  ({int done, int total}) getProgress(String groupId) {
    final tasks = getByGroup(groupId);

    final total = tasks.length;
    final done = tasks.where((t) => t.isDone).length;

    return (done: done, total: total);
  }

  // 🧹 Optional: clear finished tasks
  void clearCompleted(String groupId) {
    _tasks.removeWhere(
      (t) => t.groupId == groupId && t.isDone,
    );
    _emit();
  }

  void dispose() {
    _controller.close();
  }
}

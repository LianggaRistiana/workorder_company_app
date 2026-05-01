import 'dart:async';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_task.dart';
import 'package:workorder_company_app/features/submissions/domain/usecases/file_upload_usecase.dart';

class UploadManager {
  final UploadFileUseCase _useCase;

  final List<UploadTask> _tasks = [];
  final Map<String, int> _retryCount = {};

  final int maxRetry;

  final _controller = StreamController<List<UploadTask>>.broadcast();
  Stream<List<UploadTask>> get stream => _controller.stream;
  final Map<String, StreamSubscription> _subscriptions = {};

  UploadManager(this._useCase, {this.maxRetry = 3});

  void closeGroup(String groupId) {
    final tasks = _tasks.where((t) => t.groupId == groupId).toList();

    for (final t in tasks) {
      _subscriptions.remove(t.id)?.cancel();
      _retryCount.remove(t.id);
    }

    _tasks.removeWhere((t) => t.groupId == groupId);

    _emit();
  }

  void dispose() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _controller.close();
  }

  void addUpload({
    required String filePath,
    required String groupId,
  }) {
    appLogger.i("Add upload for $filePath");
    final task = UploadTask.create(
      filePath: filePath,
      groupId: groupId,
    );

    _tasks.add(task);
    _retryCount[task.id] = 0;

    _emit();
    _startUpload(task);
  }

  void _startUpload(UploadTask task) {
    _subscriptions[task.id]?.cancel();

    final sub = _useCase(task.filePath).listen(
      (result) {
        _updateTask(task.id, result);

        if (result.isDone && result.url != null) {
          _retryCount.remove(task.id);
          _subscriptions.remove(task.id)?.cancel(); // cleanup
        }
      },
      onError: (e) {
        _handleRetry(task, e.toString());
      },
    );

    _subscriptions[task.id] = sub;
  }

  Future<void> _handleRetry(UploadTask task, String error) async {
    final retry = _retryCount[task.id] ?? 0;

    if (retry < maxRetry) {
      final delay = Duration(seconds: 2 * (retry + 1));

      _retryCount[task.id] = retry + 1;

      await Future.delayed(delay);

      _startUpload(task);
    } else {
      _failTask(task.id, error);
      _retryCount.remove(task.id);
      _subscriptions.remove(task.id)?.cancel();
    }
  }

  void _updateTask(String taskId, UploadResult result) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;

    final current = _tasks[index];

    _tasks[index] = current.copyWith(
      progress: result.progress,
      isDone: result.isDone,
      url: result.url ?? current.url,
      error: result.error,
    );

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

  void _emit() {
    _controller.add(List.unmodifiable(_tasks));
  }
}

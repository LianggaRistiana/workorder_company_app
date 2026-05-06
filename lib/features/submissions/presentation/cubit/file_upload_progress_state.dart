import 'package:workorder_company_app/features/submissions/domain/entities/upload_task.dart';

class FileUploadProgressState {
  final List<UploadTask> tasks;

  const FileUploadProgressState({
    this.tasks = const [],
  });

  // =========================
  // 📊 BASIC STATS
  // =========================

  String get uploadState => hasError
      ? 'Gagal mengunggah'
      : isAllDone
          ? 'Selesai'
          : 'Mengunggah';

  String? get buttonMessage =>
      isInProgress ? "$progressMessage terunggah" : null;

  String get progressMessage => "$doneCount dari $taskCount berkas";

  int get taskCount => tasks.length;

  int get doneCount => tasks.where((t) => t.isDone).length;

  int get errorCount => tasks.where((t) => t.error != null).length;

  bool get hasError => errorCount > 0;

  bool get isAllDone => tasks.isNotEmpty && doneCount == taskCount;

  bool get isInProgress => tasks.any((t) => !t.isDone);

  // bool

  // =========================
  // 📈 PROGRESS
  // =========================

  double? get totalProgress {
    if (tasks.isEmpty) return null;

    if (tasks.length == 1) {
      return tasks.first.progress.clamp(0.0, 1.0);
    }

    final completed = tasks.where((t) => t.isDone && t.error == null).length;

    return completed / tasks.length;
  }

  // =========================
  // 🔄 COPY
  // =========================

  FileUploadProgressState copyWith({
    List<UploadTask>? tasks,
  }) {
    return FileUploadProgressState(
      tasks: tasks ?? this.tasks,
    );
  }

  // =========================
  // 🧠 EQUALITY (penting buat Bloc)
  // =========================

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileUploadProgressState &&
          runtimeType == other.runtimeType &&
          tasks == other.tasks;

  @override
  int get hashCode => tasks.hashCode;
}

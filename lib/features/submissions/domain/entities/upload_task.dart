class UploadTask {
  final String id;
  final String filePath;
  final String groupId;

  final double progress;
  final bool isDone;
  final String? url;
  final String? error;

  const UploadTask({
    required this.id,
    required this.filePath,
    required this.groupId,
    this.progress = 0,
    this.isDone = false,
    this.url,
    this.error,
  });

  factory UploadTask.initial({
    required String id,
    required String filePath,
    required String groupId,
  }) {
    return UploadTask(
      id: id,
      filePath: filePath,
      groupId: groupId,
    );
  }

  factory UploadTask.create({
    required String filePath,
    required String groupId,
  }) {
    return UploadTask(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      filePath: filePath,
      groupId: groupId,
    );
  }

  UploadTask copyWith({
    double? progress,
    bool? isDone,
    String? url,
    String? error,
  }) {
    return UploadTask(
      id: id,
      filePath: filePath,
      groupId: groupId,
      progress: progress ?? this.progress,
      isDone: isDone ?? this.isDone,
      url: url ?? this.url,
      error: error ?? this.error,
    );
  }
}


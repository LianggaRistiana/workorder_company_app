class MultipartResult<T> {
  final double progress; // 0 → 1
  final T? data;
  final bool isDone;
  final String? error;

  const MultipartResult({
    required this.progress,
    this.data,
    this.isDone = false,
    this.error,
  });

  factory MultipartResult.progress(double progress) {
    return MultipartResult(progress: progress);
  }

  factory MultipartResult.success(T data) {
    return MultipartResult(
      progress: 1,
      data: data,
      isDone: true,
    );
  }

  factory MultipartResult.failure(String message, {double progress = 0}) {
    return MultipartResult(
      progress: progress,
      error: message,
      isDone: true,
    );
  }
}

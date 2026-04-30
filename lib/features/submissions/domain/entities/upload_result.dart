class UploadResult {
  final double progress; // 0 → 1
  final String? url;
  final bool isDone;
  final String? error;

  const UploadResult({
    required this.progress,
    this.url,
    this.isDone = false,
    this.error,
  });

  factory UploadResult.progress(double progress) {
    return UploadResult(progress: progress);
  }

  factory UploadResult.success(String url) {
    return UploadResult(
      progress: 1,
      url: url,
      isDone: true,
    );
  }

  factory UploadResult.failure(String message, {double progress = 0}) {
    return UploadResult(
      progress: progress,
      error: message,
      isDone: true,
    );
  }
}

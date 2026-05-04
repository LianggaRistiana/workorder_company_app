enum UploadTextDocStatus { initial, loading, success, error }

class UploadTextDocState {
  final UploadTextDocStatus status;
  final String? message;

  const UploadTextDocState({
    required this.status,
    this.message,
  });

  factory UploadTextDocState.initial() {
    return const UploadTextDocState(
      status: UploadTextDocStatus.initial,
    );
  }

  UploadTextDocState copyWith({
    UploadTextDocStatus? status,
    String? message,
  }) {
    return UploadTextDocState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}

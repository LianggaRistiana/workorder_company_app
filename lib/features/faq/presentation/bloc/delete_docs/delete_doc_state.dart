enum DeleteDocStats {
  initial,
  loading,
  success,
  error,
}

class DeleteDocState {
  final DeleteDocStats status;
  final String? errorMessage;

  const DeleteDocState({
    this.status = DeleteDocStats.initial,
    this.errorMessage,
  });

  DeleteDocState copyWith({
    DeleteDocStats? status,
    String? errorMessage,
  }) {
    return DeleteDocState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

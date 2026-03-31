enum FormUpdateStatus {
  initial,
  loading,
  success,
  error,
}

class FormUpdateState {
  final FormUpdateStatus status;
  final String? errorMessage;

  const FormUpdateState({
    this.status = FormUpdateStatus.initial,
    this.errorMessage,
  });

  FormUpdateState copyWith({
    FormUpdateStatus? status,
    String? errorMessage,
  }) {
    return FormUpdateState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

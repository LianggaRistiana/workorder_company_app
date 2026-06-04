enum FormDeleteStatus {
  initial,
  loading,
  deleted,
  error,
}

class FormDeleteState {
  final FormDeleteStatus status;
  final String? errorMessage;

  const FormDeleteState({
    this.status = FormDeleteStatus.initial,
    this.errorMessage,
  });
}

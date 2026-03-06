class InternalUpdateCompanyState {
  final bool isSaving;
  final String? error;
  final bool success;

  const InternalUpdateCompanyState({
    this.isSaving = false,
    this.error,
    this.success = false,
  });

  InternalUpdateCompanyState copyWith({
    bool? isSaving,
    String? error,
    bool? success,
  }) {
    return InternalUpdateCompanyState(
      isSaving: isSaving ?? this.isSaving,
      error: error,
      success: success ?? this.success,
    );
  }
}
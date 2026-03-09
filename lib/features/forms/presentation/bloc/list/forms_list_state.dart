part of 'forms_list_bloc.dart';

enum FormsListStatus {
  initial,
  loading,
  loaded,
  error,
}

class FormsListState extends Equatable {
  final FormsListStatus status;
  final List<FormEntity> forms;
  final String? errorMessage;

  const FormsListState({
    this.status = FormsListStatus.initial,
    this.forms = const [],
    this.errorMessage,
  });

  FormsListState copyWith({
    FormsListStatus? status,
    List<FormEntity>? forms,
    String? errorMessage,
  }) {
    return FormsListState(
      status: status ?? this.status,
      forms: forms ?? this.forms,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        forms,
        errorMessage,
      ];
}
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
  final FormParams filter;
  final String? errorMessage;

  const FormsListState({
    this.status = FormsListStatus.initial,
    this.forms = const [],
    this.filter = const FormParams(),
    this.errorMessage,
  });

  FormsListState copyWith({
    FormsListStatus? status,
    List<FormEntity>? forms,
    FormParams? filter,
    String? errorMessage,
  }) {
    return FormsListState(
      status: status ?? this.status,
      forms: forms ?? this.forms,
      filter: filter ?? this.filter,
      errorMessage: errorMessage,
    );
  }

  List<FormEntity> get filteredForms {
    if (filter.activeFilterCount == 0) {
      return forms;
    }

    return forms.where((form) {
      // Search filter — matches against form title
      final search = filter.search?.trim().toLowerCase();
      if (search != null && search.isNotEmpty) {
        if (!form.title.toLowerCase().contains(search)) return false;
      }

      // Type filter
      if (filter.types != null &&
          filter.types!.isNotEmpty &&
          !filter.types!.contains(form.formType)) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  List<Object?> get props => [
        status,
        forms,
        filter,
        errorMessage,
      ];
}

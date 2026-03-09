import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

enum FormDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

class FormDetailState extends Equatable {
  final FormDetailStatus status;
  final FormEntity? form;
  final String? errorMessage;

  const FormDetailState({
    this.status = FormDetailStatus.initial,
    this.form,
    this.errorMessage,
  });

  FormDetailState copyWith({
    FormDetailStatus? status,
    FormEntity? form,
    String? errorMessage,
  }) {
    return FormDetailState(
      status: status ?? this.status,
      form: form ?? this.form,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, form, errorMessage];
}
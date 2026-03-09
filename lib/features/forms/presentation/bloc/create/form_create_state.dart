import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

enum FormCreateStatus {
  initial,
  loading,
  success,
  error,
}

class FormCreateState extends Equatable {
  final FormCreateStatus status;
  final FormEntity? createdForm;
  final String? errorMessage;

  const FormCreateState({
    this.status = FormCreateStatus.initial,
    this.createdForm,
    this.errorMessage,
  });

  FormCreateState copyWith({
    FormCreateStatus? status,
    FormEntity? createdForm,
    String? errorMessage,
  }) {
    return FormCreateState(
      status: status ?? this.status,
      createdForm: createdForm ?? this.createdForm,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, createdForm, errorMessage];
}
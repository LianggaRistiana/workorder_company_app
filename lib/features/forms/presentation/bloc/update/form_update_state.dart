import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

enum FormUpdateStatus {
  initial,
  loading,
  success,
  error,
}

class FormUpdateState extends Equatable {
  final FormUpdateStatus status;
  final String? errorMessage;
  final FormEntity? updatedForm;

  const FormUpdateState({
    this.status = FormUpdateStatus.initial,
    this.errorMessage,
    this.updatedForm,
  });

  FormUpdateState copyWith({
    FormUpdateStatus? status,
    String? errorMessage,
    FormEntity? updatedForm,
  }) {
    return FormUpdateState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedForm: updatedForm ?? this.updatedForm,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        updatedForm,
      ];
}

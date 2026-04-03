import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

enum RequesterGetIntakeFormStatus {
  initial,
  loading,
  loaded,
  error,
}

class RequesterGetIntakeFormState extends Equatable {
  final RequesterGetIntakeFormStatus status;
  final FormEntity? form;
  final String? errorMessage;

  const RequesterGetIntakeFormState({
    this.status = RequesterGetIntakeFormStatus.initial,
    this.form,
    this.errorMessage,
  });

  RequesterGetIntakeFormState copyWith({
    RequesterGetIntakeFormStatus? status,
    FormEntity? form,
    String? errorMessage,
  }) {
    return RequesterGetIntakeFormState(
      status: status ?? this.status,
      form: form ?? this.form,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        form,
        errorMessage,
      ];
}

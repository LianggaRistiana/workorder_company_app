import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

enum RequesterGetReviewFormStatus {
  initial,
  loading,
  loaded,
  error,
}

class RequesterGetReviewFormState extends Equatable {
  final RequesterGetReviewFormStatus status;
  final FormEntity? form;
  final String? errorMessage;

  const RequesterGetReviewFormState({
    this.status = RequesterGetReviewFormStatus.initial,
    this.form,
    this.errorMessage,
  });

  RequesterGetReviewFormState copyWith({
    RequesterGetReviewFormStatus? status,
    FormEntity? form,
    String? errorMessage,
  }) {
    return RequesterGetReviewFormState(
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

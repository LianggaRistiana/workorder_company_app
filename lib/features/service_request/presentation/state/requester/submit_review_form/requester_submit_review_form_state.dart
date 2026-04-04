import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

enum RequesterSubmitReviewFormStatus {
  initial,
  loading,
  success,
  error,
}

class RequesterSubmitReviewFormState extends Equatable {
  final RequesterSubmitReviewFormStatus status;
  final RequesterServiceRequestEntity? request;
  final String? errorMessage;

  const RequesterSubmitReviewFormState({
    this.status = RequesterSubmitReviewFormStatus.initial,
    this.request,
    this.errorMessage,
  });

  RequesterSubmitReviewFormState copyWith({
    RequesterSubmitReviewFormStatus? status,
    RequesterServiceRequestEntity? request,
    String? errorMessage,
  }) {
    return RequesterSubmitReviewFormState(
      status: status ?? this.status,
      request: request ?? this.request,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        request,
        errorMessage,
      ];
}

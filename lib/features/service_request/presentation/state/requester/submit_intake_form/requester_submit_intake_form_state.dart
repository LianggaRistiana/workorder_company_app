import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';

enum RequesterSubmitIntakeFormStatus {
  initial,
  loading,
  success,
  error,
}

class RequesterSubmitIntakeFormState extends Equatable {
  final RequesterSubmitIntakeFormStatus status;
  final RequesterServiceRequestEntity? request;
  final String? errorMessage;

  const RequesterSubmitIntakeFormState({
    this.status = RequesterSubmitIntakeFormStatus.initial,
    this.request,
    this.errorMessage,
  });

  RequesterSubmitIntakeFormState copyWith({
    RequesterSubmitIntakeFormStatus? status,
    RequesterServiceRequestEntity? request,
    String? errorMessage,
  }) {
    return RequesterSubmitIntakeFormState(
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

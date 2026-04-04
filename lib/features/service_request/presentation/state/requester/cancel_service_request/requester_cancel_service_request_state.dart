import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

enum RequesterCancelServiceRequestStatus {
  initial,
  loading,
  success,
  error,
}

class RequesterCancelServiceRequestState extends Equatable {
  final RequesterCancelServiceRequestStatus status;
  final RequesterServiceRequestEntity? request;
  final String? errorMessage;

  const RequesterCancelServiceRequestState({
    this.status = RequesterCancelServiceRequestStatus.initial,
    this.request,
    this.errorMessage,
  });

  RequesterCancelServiceRequestState copyWith({
    RequesterCancelServiceRequestStatus? status,
    RequesterServiceRequestEntity? request,
    String? errorMessage,
  }) {
    return RequesterCancelServiceRequestState(
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

import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

enum ProviderReviewServiceRequestStatus {
  initial,
  loading,
  success,
  error,
}

class ProviderActionServiceRequestState extends Equatable {
  final ProviderReviewServiceRequestStatus status;
  final ProviderServiceRequestEntity? request;
  final String? errorMessage;

  const ProviderActionServiceRequestState({
    this.status = ProviderReviewServiceRequestStatus.initial,
    this.request,
    this.errorMessage,
  });

  ProviderActionServiceRequestState copyWith({
    ProviderReviewServiceRequestStatus? status,
    ProviderServiceRequestEntity? request,
    String? errorMessage,
  }) {
    return ProviderActionServiceRequestState(
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

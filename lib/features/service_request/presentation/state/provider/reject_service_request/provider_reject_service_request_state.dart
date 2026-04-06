import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

enum ProviderRejectServiceRequestStatus {
  initial,
  loading,
  success,
  error,
}

class ProviderRejectServiceRequestState extends Equatable {
  final ProviderRejectServiceRequestStatus status;
  final ProviderServiceRequestEntity? request;
  final String? errorMessage;

  const ProviderRejectServiceRequestState({
    this.status = ProviderRejectServiceRequestStatus.initial,
    this.request,
    this.errorMessage,
  });

  ProviderRejectServiceRequestState copyWith({
    ProviderRejectServiceRequestStatus? status,
    ProviderServiceRequestEntity? request,
    String? errorMessage,
  }) {
    return ProviderRejectServiceRequestState(
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

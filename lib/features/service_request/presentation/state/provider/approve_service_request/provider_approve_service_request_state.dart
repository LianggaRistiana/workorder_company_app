import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

enum ProviderApproveServiceRequestStatus {
  initial,
  loading,
  success,
  error,
}

class ProviderApproveServiceRequestState extends Equatable {
  final ProviderApproveServiceRequestStatus status;
  final ProviderServiceRequestEntity? request;
  final String? errorMessage;

  const ProviderApproveServiceRequestState({
    this.status = ProviderApproveServiceRequestStatus.initial,
    this.request,
    this.errorMessage,
  });

  ProviderApproveServiceRequestState copyWith({
    ProviderApproveServiceRequestStatus? status,
    ProviderServiceRequestEntity? request,
    String? errorMessage,
  }) {
    return ProviderApproveServiceRequestState(
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

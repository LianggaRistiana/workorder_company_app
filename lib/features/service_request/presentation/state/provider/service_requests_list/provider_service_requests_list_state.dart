import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

enum ProviderServiceRequestsListStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProviderServiceRequestsListState extends Equatable {
  final ProviderServiceRequestsListStatus status;
  final List<ProviderServiceRequestEntity> requests;
  final String? errorMessage;

  const ProviderServiceRequestsListState({
    this.status = ProviderServiceRequestsListStatus.initial,
    this.requests = const [],
    this.errorMessage,
  });

  ProviderServiceRequestsListState copyWith({
    ProviderServiceRequestsListStatus? status,
    List<ProviderServiceRequestEntity>? requests,
    String? errorMessage,
  }) {
    return ProviderServiceRequestsListState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        requests,
        errorMessage,
      ];
}

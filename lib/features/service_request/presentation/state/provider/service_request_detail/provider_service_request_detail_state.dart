import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

enum ProviderServiceRequestDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProviderServiceRequestDetailState extends Equatable {
  final ProviderServiceRequestDetailStatus status;
  final ProviderServiceRequestEntity? request;
  final String? errorMessage;

  const ProviderServiceRequestDetailState({
    this.status = ProviderServiceRequestDetailStatus.initial,
    this.request,
    this.errorMessage,
  });

  ProviderServiceRequestDetailState copyWith({
    ProviderServiceRequestDetailStatus? status,
    ProviderServiceRequestEntity? request,
    String? errorMessage,
  }) {
    return ProviderServiceRequestDetailState(
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

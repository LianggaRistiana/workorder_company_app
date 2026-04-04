import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';

enum RequesterServiceRequestsListStatus {
  initial,
  loading,
  loaded,
  error,
}

class RequesterServiceRequestsListState extends Equatable {
  final RequesterServiceRequestsListStatus status;
  final List<RequesterServiceRequestEntity> requests;
  final String? errorMessage;

  const RequesterServiceRequestsListState({
    this.status = RequesterServiceRequestsListStatus.initial,
    this.requests = const [],
    this.errorMessage,
  });

  RequesterServiceRequestsListState copyWith({
    RequesterServiceRequestsListStatus? status,
    List<RequesterServiceRequestEntity>? requests,
    String? errorMessage,
  }) {
    return RequesterServiceRequestsListState(
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

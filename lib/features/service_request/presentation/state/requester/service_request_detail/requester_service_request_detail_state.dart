import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';

enum RequesterServiceRequestDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

class RequesterServiceRequestDetailState extends Equatable {
  final RequesterServiceRequestDetailStatus status;
  final RequesterServiceRequestEntity? request;
  final String? errorMessage;

  const RequesterServiceRequestDetailState({
    this.status = RequesterServiceRequestDetailStatus.initial,
    this.request,
    this.errorMessage,
  });

  RequesterServiceRequestDetailState copyWith({
    RequesterServiceRequestDetailStatus? status,
    RequesterServiceRequestEntity? request,
    String? errorMessage,
  }) {
    return RequesterServiceRequestDetailState(
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

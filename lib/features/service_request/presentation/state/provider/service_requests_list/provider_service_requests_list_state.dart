import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/params/service_request_params.dart';

enum ProviderServiceRequestsListStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProviderServiceRequestsListState extends Equatable {
  final ProviderServiceRequestsListStatus status;
  final List<ProviderServiceRequestEntity> requests;
  final ServiceRequestParams filter;
  final String? errorMessage;

  const ProviderServiceRequestsListState({
    this.status = ProviderServiceRequestsListStatus.initial,
    this.requests = const [],
    this.filter = const ServiceRequestParams(),
    this.errorMessage,
  });

  ProviderServiceRequestsListState copyWith({
    ProviderServiceRequestsListStatus? status,
    List<ProviderServiceRequestEntity>? requests,
    ServiceRequestParams? filter,
    String? errorMessage,
  }) {
    return ProviderServiceRequestsListState(
      status: status ?? this.status,
      requests: requests ?? this.requests,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<ProviderServiceRequestEntity> get filteredRequests {
    return requests.where((request) {
      // Search filter
      final search = filter.search?.trim().toLowerCase();
      if (search != null && search.isNotEmpty) {
        final matchCode = request.code.toLowerCase().contains(search);
        final matchService =
            request.service.title.toLowerCase().contains(search);
        if (!matchCode && !matchService) return false;
      }

      // Status Filter
      if (filter.status != null &&
          filter.status!.isNotEmpty &&
          !filter.status!.contains(request.status)) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  List<Object?> get props => [
        status,
        requests,
        filter,
        errorMessage,
      ];
}

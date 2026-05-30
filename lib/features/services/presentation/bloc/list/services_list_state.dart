import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/services/domain/params/service_params.dart';

enum ServicesListStatus {
  initial,
  loading,
  loaded,
  error,
}

class ServicesListState extends Equatable {
  final ServicesListStatus status;
  final List<ServiceSummaryEntity> services;
  final ServiceParams filter;
  final String? errorMessage;

  const ServicesListState({
    required this.status,
    required this.services,
    this.filter = const ServiceParams(),
    this.errorMessage,
  });

  ServicesListState copyWith({
    ServicesListStatus? status,
    List<ServiceSummaryEntity>? services,
    ServiceParams? filter,
    String? errorMessage,
  }) {
    return ServicesListState(
      status: status ?? this.status,
      services: services ?? this.services,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<ServiceSummaryEntity> get filteredServices {
    return services.where((service) {
      if (filter.search != null &&
          !service.title.toLowerCase().contains(filter.search!.toLowerCase())) {
        return false;
      }

      if (filter.types != null &&
          filter.types!.isNotEmpty &&
          !filter.types!.contains(service.accessType)) {
        return false;
      }

      if (filter.isActive != null && service.isActive != filter.isActive) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  List<Object?> get props => [
        status,
        services,
        errorMessage,
        filter,
      ];
}

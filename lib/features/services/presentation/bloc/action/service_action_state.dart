import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

enum ServiceActionStatus {
  initial,
  loading,
  removed,
  updated,
  error,
}

class ServiceActionState extends Equatable {
  final ServiceActionStatus? status;
  final ServiceEntity? updatedService;
  final String? errorMessage;

  const ServiceActionState({
    this.status,
    this.updatedService,
    this.errorMessage,
  });

  ServiceActionState copyWith({
    ServiceActionStatus? status,
    ServiceEntity? updatedService,
    String? errorMessage,
  }) {
    return ServiceActionState(
      status: status ?? this.status,
      updatedService: updatedService ?? this.updatedService,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        updatedService,
        errorMessage,
      ];
}

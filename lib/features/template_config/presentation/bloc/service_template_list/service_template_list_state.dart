import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_entity.dart';

enum ServiceTemplateListStatus { initial, loading, success, error }

class ServiceTemplateListState extends Equatable {
  final ServiceTemplateListStatus status;
  final List<ServiceTemplateEntity>? serviceTemplates;
  final String? errorMessage;

  bool get isSuccess => status == ServiceTemplateListStatus.success;

  const ServiceTemplateListState({
    required this.status,
    this.serviceTemplates,
    this.errorMessage,
  });

  factory ServiceTemplateListState.initial() =>
      const ServiceTemplateListState(status: ServiceTemplateListStatus.initial);

  ServiceTemplateListState copyWith({
    ServiceTemplateListStatus? status,
    List<ServiceTemplateEntity>? serviceTemplates,
    String? errorMessage,
  }) {
    return ServiceTemplateListState(
      status: status ?? this.status,
      serviceTemplates: serviceTemplates ?? this.serviceTemplates,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        serviceTemplates,
        errorMessage,
      ];
}

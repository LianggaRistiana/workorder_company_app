import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/service_template_preview_entity.dart';

enum ServicePreviewStatus { initial, loading, success, error }

class ServicePreviewState extends Equatable {
  final ServicePreviewStatus status;
  final ServiceTemplatePreviewEntity? servicePreview;
  final String? errorMessage;

  bool get isLoading => status == ServicePreviewStatus.loading;
  bool get isSuccess => status == ServicePreviewStatus.success;

  const ServicePreviewState({
    required this.status,
    this.servicePreview,
    this.errorMessage,
  });

  factory ServicePreviewState.initial() =>
      const ServicePreviewState(status: ServicePreviewStatus.initial);

  ServicePreviewState copyWith({
    ServicePreviewStatus? status,
    ServiceTemplatePreviewEntity? servicePreview,
    String? errorMessage,
  }) {
    return ServicePreviewState(
      status: status ?? this.status,
      servicePreview: servicePreview ?? this.servicePreview,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        servicePreview,
        errorMessage,
      ];
}

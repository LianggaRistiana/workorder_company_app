import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/services/domain/entities/base_service_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_request_config_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/work_order_config_entity.dart';

class ServiceEntity extends Equatable implements BaseServiceEntity {
  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final ServiceAccessType accessType;
  @override
  final bool isActive;

  final WorkOrderDraftingType workOrderDraftingType;
  final ServiceRequestConfigEntity serviceRequestConfig;
  final List<WorkOrderConfigEntity> workOrdersConfig;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.workOrderDraftingType,
    this.description,
    required this.accessType,
    required this.isActive,
    required this.serviceRequestConfig,
    required this.workOrdersConfig,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        accessType,
        isActive,
        serviceRequestConfig,
        workOrderDraftingType,
        workOrdersConfig,
      ];
}

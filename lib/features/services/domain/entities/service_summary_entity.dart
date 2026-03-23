import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/services/domain/entities/base_service_entity.dart';

class ServiceSummaryEntity extends Equatable implements BaseServiceEntity {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final ServiceAccessType accessType;
  @override
  final bool isActive;

  const ServiceSummaryEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.accessType,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        accessType,
        isActive,
      ];
}

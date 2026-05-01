import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

class ServiceTemplatePreviewEntity extends Equatable {
  final String id;
  final ServiceEntity service;
  final List<PositionEntity> positionsRequired;

  const ServiceTemplatePreviewEntity({
    required this.id,
    required this.service,
    required this.positionsRequired,
  });

  @override
  List<Object?> get props => [
        id,
        service,
        positionsRequired,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';

class ServicePriceEntity extends Equatable {
  final String id;
  final ServiceEntity service;
  final int price;

  const ServicePriceEntity({
    required this.id,
    required this.service,
    required this.price,
  });

  @override
  List<Object?> get props => [
        id,
        service,
        price,
      ];
}

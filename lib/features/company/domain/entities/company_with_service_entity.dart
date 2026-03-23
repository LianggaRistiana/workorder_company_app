import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/services_legacy/domain/entities/service_entity.dart';

class CompanyWithServiceEntity {
  final CompanyEntity company;
  final List<ServiceEntity> services;

  const CompanyWithServiceEntity({
    required this.company,
    required this.services,
  });

  CompanyWithServiceEntity copyWith({
    CompanyEntity? company,
    List<ServiceEntity>? services,
  }) {
    return CompanyWithServiceEntity(
      company: company ?? this.company,
      services: services ?? this.services,
    );
  }
}

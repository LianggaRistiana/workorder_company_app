import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_with_service_entity.dart';
import 'package:workorder_company_app/features/services_legacy/data/models/service_model.dart';

class CompanyWithServiceModel extends CompanyWithServiceEntity {
  CompanyWithServiceModel({
    required super.company,
    required super.services,
  });

  factory CompanyWithServiceModel.fromJson(Map<String, dynamic> json) {
    return CompanyWithServiceModel(
        company: CompanyModel.fromJson(json['company']),
        services: (json['services'] as List<dynamic>?)
                ?.map((e) => ServiceModel.fromJson(e))
                .toList() ??
            []);
  }

  Map<String, dynamic> toJson() {
    return {
      'company': (company as CompanyModel).toJson(),
      'services': services.map((e) => (e as ServiceModel).toJson()).toList(),
    };
  }
}

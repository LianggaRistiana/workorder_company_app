import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/company_type_entity.dart';

class CompanyTypeModel extends CompanyTypeEntity {
  const CompanyTypeModel({
    required super.id,
    required super.name,
  });

  factory CompanyTypeModel.fromEntity(CompanyTypeEntity entity) {
    return CompanyTypeModel(
      id: entity.id,
      name: entity.name,
    );
  }

  factory CompanyTypeModel.fromJson(Map<String, dynamic> json) {
    return CompanyTypeModel(
      id: json.field('_id').reqString(),
      name: json.field('name').reqString(),
    );
  }
}

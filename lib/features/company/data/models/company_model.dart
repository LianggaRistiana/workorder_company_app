import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  CompanyModel({
    required super.id,
    required super.name,
    super.address,
    super.description,
    required super.isActive,
    required super.isFaqActive,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String? ?? "",
      description: json['description'] as String? ?? "",
      isActive: json['isActive'] as bool? ?? true,
      isFaqActive: json.field("isFaqActive").reqBool(),
    );
  }

  factory CompanyModel.fromEntity(CompanyEntity entity) {
    return CompanyModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      description: entity.description,
      isActive: entity.isActive,
      isFaqActive: entity.isFaqActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'isActive': isActive,
      'isFaqActive': isFaqActive,
    };
  }
}

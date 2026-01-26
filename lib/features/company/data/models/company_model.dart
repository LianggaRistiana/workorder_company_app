import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  CompanyModel({
    required super.id,
    required super.name,
    super.address,
    super.description,
    required super.isActive,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      address: json['address'] as String? ?? "",
      description: json['description'] as String? ?? "",
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'isActive': isActive,
    };
  }
}

import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  CompanyModel({
    required super.id,
    required super.name,
    required super.address,
    required super.description,
    required super.isActive,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
      isActive: json['isActive'],
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

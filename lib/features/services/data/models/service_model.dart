import 'package:workorder_company_app/features/services/data/models/form_order_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/data/models/required_staff_model.dart';

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.requiredStaff,
    super.workOrderForms,
    super.reportForms,
    required super.accessType,
    required super.isActive,
  });

  /// Convert from JSON → Model
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      requiredStaff: (json['requiredStaff'] as List<dynamic>?)
              ?.map((e) => RequiredStaffModel.fromJson(e))
              .toList() ??
          [],
      workOrderForms: (json['workOrderForms'] as List<dynamic>?)
              ?.map((e) => FormOrderModel.fromJson(e))
              .toList() ??
          [],
      reportForms: (json['reportForms'] as List<dynamic>?)
              ?.map((e) => FormOrderModel.fromJson(e))
              .toList() ??
          [],
      accessType: json['accessType'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'requiredStaff': requiredStaff
          .map((e) => (e as RequiredStaffModel).toJson())
          .toList(),
      'workOrderForms':
          workOrderForms?.map((e) => (e as FormOrderModel).toJson()).toList(),
      'reportForms':
          reportForms?.map((e) => (e as FormOrderModel).toJson()).toList(),
      'accessType': accessType,
      'isActive': isActive,
    };
  }
    /// Convert from Entity → Model
  factory ServiceModel.fromEntity(ServiceEntity entity) {
    return ServiceModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      requiredStaff: entity.requiredStaff
          .map((e) => e is RequiredStaffModel
              ? e
              : RequiredStaffModel.fromEntity(e))
          .toList(),
      workOrderForms: entity.workOrderForms
          ?.map((e) =>
              e is FormOrderModel ? e : FormOrderModel.fromEntity(e))
          .toList(),
      reportForms: entity.reportForms
          ?.map((e) =>
              e is FormOrderModel ? e : FormOrderModel.fromEntity(e))
          .toList(),
      accessType: entity.accessType,
      isActive: entity.isActive,
    );
  }
}

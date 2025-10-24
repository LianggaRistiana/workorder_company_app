import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/service_form_entity.dart';

class ServiceFormModel extends ServiceFormEntity {
  const ServiceFormModel({
    required super.order,
    required super.form,
    required super.fillableByRoles,
    required super.fillableByPositions,
    required super.viewableByRoles,
    required super.viewableByPositions,
  });

  factory ServiceFormModel.fromJson(Map<String, dynamic> json) {
    return ServiceFormModel(
      order: json['order'],
      form: FormModel.fromJson(json['form']),
      fillableByRoles: (json['fillableByRoles'] as List<dynamic>?)
              ?.map((e) => UserRole.fromString(e))
              .toList() ??
          [],
      fillableByPositions: (json['fillableByPositions'] as List<dynamic>?)
              ?.map((e) => PositionModel.fromJson(e))
              .toList() ??
          [],
      viewableByRoles: (json['viewableByRoles'] as List<dynamic>?)
              ?.map((e) => UserRole.fromString(e))
              .toList() ??
          [],
      viewableByPositions: (json['viewableByPositions'] as List<dynamic>?)
              ?.map((e) => PositionModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'formId': (form as FormModel).id,
      // 'form': (form as FormModel).toJson(),
      'fillableByRoles': fillableByRoles.map((e) => e.toSnakeCase()).toList(),
      'fillableByPositionIds':
          fillableByPositions.map((e) => (e as PositionModel).id).toList(),
      // fillableByPositions.map((e) => (e as PositionModel).toJson()).toList(),
      'viewableByRoles': viewableByRoles.map((e) => e.toSnakeCase()).toList(),
      'viewableByPositionIds': viewableByPositions
          .map((e) => (e as PositionModel).id)
          // .map((e) => (e as PositionModel).toJson())
          .toList(),
    };
  }

  factory ServiceFormModel.fromEntity(ServiceFormEntity entity) {
    return ServiceFormModel(
      order: entity.order,
      form: FormModel.fromEntity(entity.form),
      fillableByRoles: entity.fillableByRoles,
      fillableByPositions: entity.fillableByPositions
          .map((e) => e is PositionModel ? e : PositionModel.fromEntity(e))
          .toList(),
      viewableByRoles: entity.viewableByRoles,
      viewableByPositions: entity.viewableByPositions
          .map((e) => e is PositionModel ? e : PositionModel.fromEntity(e))
          .toList(),
    );
  }
}

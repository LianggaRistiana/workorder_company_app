import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/has_form.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';

// TODO[WO DONE FIRST] : Remove Later
class ServiceFormEntity implements HasForm{
  final int order;
  @override
  final FormEntity form;
  final List<UserRole> fillableByRoles;
  final List<PositionEntity> fillableByPositions;

  final List<UserRole> viewableByRoles;
  final List<PositionEntity> viewableByPositions;

  const ServiceFormEntity({
    required this.order,
    required this.form,
    required this.fillableByRoles,
    required this.fillableByPositions,
    required this.viewableByRoles,
    required this.viewableByPositions,
  }); 

  ServiceFormEntity copyWith({
    int? order,
    FormEntity? form,
    List<UserRole>? fillableByRoles,
    List<PositionEntity>? fillableByPositions,
    List<UserRole>? viewableByRoles,
    List<PositionEntity>? viewableByPositions,
  }) {
    return ServiceFormEntity(
      order: order ?? this.order,
      form: form ?? this.form,
      fillableByRoles: fillableByRoles ?? this.fillableByRoles,
      fillableByPositions: fillableByPositions ?? this.fillableByPositions,
      viewableByRoles: viewableByRoles ?? this.viewableByRoles,
      viewableByPositions: viewableByPositions ?? this.viewableByPositions,
    );
  }
}

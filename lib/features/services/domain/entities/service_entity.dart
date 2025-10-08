import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/services/domain/entities/form_order_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<RequiredStaffEntity> requiredStaff;
  final List<FormOrderEntity>? workOrderForms;
  final List<FormOrderEntity>? reportForms;
  final String accessType;
  final bool isActive;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredStaff,
    this.workOrderForms,
    this.reportForms,
    required this.accessType,
    required this.isActive,
  });

  ServiceEntity copyWith({
    String? id,
    String? title,
    String? description,
    List<RequiredStaffEntity>? requiredStaff,
    List<FormOrderEntity>? workOrderForms,
    List<FormOrderEntity>? reportForms,
    String? accessType,
    bool? isActive,
  }) {
    return ServiceEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      requiredStaff: requiredStaff ?? this.requiredStaff,
      workOrderForms: workOrderForms ?? this.workOrderForms,
      reportForms: reportForms ?? this.reportForms,
      accessType: accessType ?? this.accessType,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        requiredStaff,
        workOrderForms,
        reportForms,
        accessType,
        isActive,
      ];
}

import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/service_form_entity.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<RequiredStaffEntity> requiredStaff;
  final List<OrderedFormEntity>? clientIntakeForms;
  final List<ServiceFormEntity>? workOrderForms;
  final List<ServiceFormEntity>? reportForms;
  final ServiceAccessType accessType;
  final bool isActive;

  const ServiceEntity({
    required this.id,
    required this.title,
    required this.description,
    this.requiredStaff = const [],
    this.clientIntakeForms,
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
    List<OrderedFormEntity>? clientIntakeForms,
    List<ServiceFormEntity>? workOrderForms,
    List<ServiceFormEntity>? reportForms,
    ServiceAccessType? accessType,
    bool? isActive,
  }) {
    return ServiceEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      requiredStaff: requiredStaff ?? this.requiredStaff,
      clientIntakeForms: clientIntakeForms ?? this.clientIntakeForms,
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
        clientIntakeForms,
        workOrderForms,
        reportForms,
        accessType,
        isActive,
      ];
}

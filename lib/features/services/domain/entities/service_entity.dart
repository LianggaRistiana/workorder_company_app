import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<RequiredStaffEntity> requiredStaff;
  final List<FormEntity>? workOrderForms;
  final List<FormEntity>? reportForms;
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

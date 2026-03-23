import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/services_legacy/domain/entities/service_entity.dart';


// TODO : fix the name of this file
class WorkorderEntity {
  final String id;
  final String companyId;
  final String? clientServiceRequestId;
  final UserEntity createdBy;
  final ServiceEntity service;
  final String? relatedWorkOrderId;
  final List<UserEntity>? assignedStaffs;
  final WorkOrderStatus status;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final List<FilledFormEntity>? workorderForms;

  WorkorderEntity({
    required this.id,
    required this.companyId,
    required this.clientServiceRequestId,
    required this.createdAt,
    required this.service,
    required this.status,
    this.relatedWorkOrderId,
    this.assignedStaffs,
    this.startedAt,
    this.completedAt,
    this.workorderForms,
    required this.createdBy,
  });
}

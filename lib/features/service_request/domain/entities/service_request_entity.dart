import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

sealed class ServiceRequestEntity {
  final String id;
  final String code;
  final ServiceSummaryEntity service;
  final ServiceRequestStatus status;
  final UserEntity requestedBy;
  final UserEntity? approvedBy;
  final FilledFormEntity? intakeForm;
  final FilledFormEntity? reviewForm;
  final DateTime createdAt;

  const ServiceRequestEntity({
    required this.id,
    required this.code,
    required this.status,
    required this.service,
    this.approvedBy,
    required this.requestedBy,
    this.intakeForm,
    this.reviewForm,
    required this.createdAt,
  });
}

class ProviderServiceRequestEntity implements ServiceRequestEntity {
  @override
  final String id;
  @override
  final String code;
  @override
  final ServiceSummaryEntity service;
  @override
  final ServiceRequestStatus status;
  @override
  final UserEntity requestedBy;
  @override
  final UserEntity? approvedBy;
  @override
  final FilledFormEntity? intakeForm;
  @override
  final FilledFormEntity? reviewForm;
  @override
  final DateTime createdAt;

  final bool reviewNeed;
  final ServiceRequestApprovalAccess approvalAccess;

  const ProviderServiceRequestEntity({
    required this.id,
    required this.code,
    required this.status,
    required this.service,
    required this.requestedBy,
    this.approvedBy,
    this.intakeForm,
    this.reviewForm,
    required this.reviewNeed,
    required this.approvalAccess,
    required this.createdAt,
  });
}

class RequesterServiceRequestEntity implements ServiceRequestEntity {
  @override
  final String id;
  @override
  final String code;
  @override
  final ServiceSummaryEntity service;
  @override
  final ServiceRequestStatus status;
  @override
  final UserEntity requestedBy;
  @override
  final UserEntity? approvedBy;
  @override
  final FilledFormEntity? intakeForm;
  @override
  final FilledFormEntity? reviewForm;
  @override
  final DateTime createdAt;

  final CompanyEntity company;

  const RequesterServiceRequestEntity({
    required this.id,
    required this.code,
    required this.status,
    required this.service,
    required this.requestedBy,
    this.approvedBy,
    this.intakeForm,
    this.reviewForm,
    required this.company,
    required this.createdAt,
  });
}

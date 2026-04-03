import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/base_service_request_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

class RequesterServiceRequestEntity implements BaseServiceRequestEntity {
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
    this.intakeForm,
    this.reviewForm,
    required this.company,
    required this.createdAt,
  });
}

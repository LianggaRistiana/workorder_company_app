import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

abstract class BaseServiceRequestEntity {
  final String id;
  final String code;
  final ServiceSummaryEntity service;
  final ServiceRequestStatus status;
  final UserEntity requestedBy;
  final FilledFormEntity? intakeForm;
  final FilledFormEntity? reviewForm;

  const BaseServiceRequestEntity({
    required this.id,
    required this.code,
    required this.status,
    required this.service,
    required this.requestedBy,
    this.intakeForm,
    this.reviewForm,
  });
}

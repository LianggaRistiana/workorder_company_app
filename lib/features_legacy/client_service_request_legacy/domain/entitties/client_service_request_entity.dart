import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/entities/service_entity.dart';

class ClientServiceRequestEntity {
  final String id;
  final ClientServiceRequestStatus status;
  final DateTime createdAt;
  final String companyId;
  final UserEntity client;
  final ServiceEntity service;
  final List<FilledFormEntity>? clientIntakeForms;

  ClientServiceRequestEntity({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.companyId,
    required this.client,
    required this.service,
    this.clientIntakeForms,
  });
}

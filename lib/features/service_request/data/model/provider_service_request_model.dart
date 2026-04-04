import 'package:workorder_company_app/features/service_request/domain/entities/provider_service_request_entity.dart';

class ProviderServiceRequestModel extends ProviderServiceRequestEntity {
  ProviderServiceRequestModel({
    required super.id,
    required super.code,
    required super.status,
    required super.service,
    required super.requestedBy,
    required super.reviewNeed,
    required super.approvalAccess,
    super.intakeForm,
    super.reviewForm,
    required super.createdAt,
  });

  // TODO : factory fromjson
}

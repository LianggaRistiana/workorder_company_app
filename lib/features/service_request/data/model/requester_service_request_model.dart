import 'package:workorder_company_app/features/service_request/domain/entities/requester_service_request_entity.dart';

class RequesterServiceRequestModel extends RequesterServiceRequestEntity {
  RequesterServiceRequestModel({
    required super.id,
    required super.code,
    required super.status,
    required super.service,
    required super.requestedBy,
    required super.company,
    super.intakeForm,
    super.reviewForm,
    required super.createdAt,
  });

  // TODO : factory fromjson
}

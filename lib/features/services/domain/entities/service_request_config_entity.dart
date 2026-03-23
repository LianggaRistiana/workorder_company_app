import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';

class ServiceRequestConfigEntity extends Equatable {
  final FormEntity intakeForm;
  final FormEntity reviewForm;
  final ServiceRequestApprovalAccess serviceRequestApprovalAccessType;
  final bool reviewNeed;

  const ServiceRequestConfigEntity({
    required this.intakeForm,
    required this.reviewForm,
    required this.serviceRequestApprovalAccessType,
    required this.reviewNeed,
  });

  @override
  List<Object?> get props => [
        intakeForm,
        reviewForm,
        serviceRequestApprovalAccessType,
        reviewNeed,
      ];
}

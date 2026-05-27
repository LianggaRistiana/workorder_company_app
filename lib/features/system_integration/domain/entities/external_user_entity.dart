import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/core/constants/app_enums/system_integration_enum.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

class ExternalUserEntity extends Equatable {
  final String id;
  final String externalEmail;
  final String externalName;
  final CompanyEntity company;
  final IntegrationType integrationType;
  final DateTime pairedAt;

  const ExternalUserEntity({
    required this.id,
    required this.externalEmail,
    required this.externalName,
    required this.company,
    required this.integrationType,
    required this.pairedAt,
  });

  @override
  List<Object?> get props => [
        id,
        externalEmail,
        externalName,
        integrationType,
        company,
        pairedAt,
      ];
}

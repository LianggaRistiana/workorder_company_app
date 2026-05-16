import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

class ExternalUserEntity extends Equatable {
  final String id;
  final String externalEmail;
  final String externalName;
  final CompanyEntity company;
  final DateTime pairedAt;

  const ExternalUserEntity({
    required this.id,
    required this.externalEmail,
    required this.externalName,
    required this.company,
    required this.pairedAt,
  });

  @override
  List<Object?> get props => [
        id,
        externalEmail,
        externalName,
        company,
        pairedAt,
      ];
}

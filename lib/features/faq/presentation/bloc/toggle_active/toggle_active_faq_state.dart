import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

class ToggleActiveFaqState extends Equatable {
  final bool isActive;
  final String? errorMessage;
  final CompanyEntity? updatedCompany;

  const ToggleActiveFaqState({
    this.isActive = false,
    this.errorMessage,
    this.updatedCompany,
  });

  @override
  List<Object?> get props => [
        isActive,
        errorMessage,
        updatedCompany,
      ];
}

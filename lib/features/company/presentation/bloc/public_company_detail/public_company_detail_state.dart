import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

enum PublicCompaniesListStatus {
  initial,
  loading,
  loaded,
  error,
}

class PublicCompanyDetailState extends Equatable {
  final PublicCompaniesListStatus status;
  final String? errorMessage;
  final CompanyEntity? company;

  const PublicCompanyDetailState({
    this.company,
    this.status = PublicCompaniesListStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        company,
      ];
}

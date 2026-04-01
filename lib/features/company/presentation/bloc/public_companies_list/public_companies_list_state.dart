import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

enum PublicCompaniesListStatus {
  initial,
  loading,
  loaded,
  error,
}

class PublicCompaniesListState extends Equatable {
  final PublicCompaniesListStatus status;
  final List<CompanyEntity> companies;
  final String? errorMessage;

  const PublicCompaniesListState({
    this.status = PublicCompaniesListStatus.initial,
    this.companies = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        status,
        companies,
        errorMessage,
      ];
}

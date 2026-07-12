import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/params/public_companies_params.dart';

enum PublicCompaniesListStatus {
  initial,
  loading,
  loaded,
  error,
}

class PublicCompaniesListState extends Equatable {
  final PublicCompaniesListStatus status;
  final PublicCompaniesParams filter;
  final List<CompanyEntity> companies;
  final String? errorMessage;

  const PublicCompaniesListState({
    this.status = PublicCompaniesListStatus.initial,
    this.companies = const [],
    this.errorMessage,
    this.filter = const PublicCompaniesParams(),
  });

  PublicCompaniesListState copyWith({
    PublicCompaniesListStatus? status,
    List<CompanyEntity>? companies,
    String? errorMessage,
    PublicCompaniesParams? filter,
  }) {
    return PublicCompaniesListState(
      status: status ?? this.status,
      companies: companies ?? this.companies,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [
        status,
        companies,
        errorMessage,
        filter,
      ];
}

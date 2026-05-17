import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';
import 'package:workorder_company_app/features/company/domain/meta/public_company_meta.dart';

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
  final PublicCompanyMeta? meta;

  const PublicCompanyDetailState({
    this.company,
    this.status = PublicCompaniesListStatus.initial,
    this.meta,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        company,
        meta,
      ];
}

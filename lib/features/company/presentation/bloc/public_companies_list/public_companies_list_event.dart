import 'package:workorder_company_app/features/company/domain/params/public_companies_params.dart';

sealed class PublicCompaniesListEvent {}

class GetPublicCompaniesRequested extends PublicCompaniesListEvent {}

class SetCompaniesFilter extends PublicCompaniesListEvent {
  final PublicCompaniesParams filter;

  SetCompaniesFilter({required this.filter});
}

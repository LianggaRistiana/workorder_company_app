part of 'company_bloc.dart';

sealed class CompanyEvent {}

class GetCompanyWithServiceRequested extends CompanyEvent {
  final String id;
  GetCompanyWithServiceRequested(this.id);
}

class GetCompaniesRequested extends CompanyEvent {}
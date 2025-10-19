part of 'company_bloc.dart';

enum CompanyStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class CompanyState extends Equatable {
  final CompanyStateStatus status;
  final List<CompanyEntity> companies;
  final CompanyWithServiceEntity? selectedCompany;
  final String? errorMessage;

  const CompanyState({
    this.status = CompanyStateStatus.initial,
    this.companies = const [],
    this.selectedCompany,
    this.errorMessage,
  });

  CompanyState copyWith({
    CompanyStateStatus? status,
    List<CompanyEntity>? companies,
    CompanyWithServiceEntity? selectedCompany,
    String? errorMessage,
  }) {
    return CompanyState(
      status: status ?? this.status,
      companies: companies ?? this.companies,
      selectedCompany: selectedCompany ?? this.selectedCompany,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        companies,
        selectedCompany,
        errorMessage,
      ];

  @override
  String toString() {
    return 'CompanyState(status: $status, '
        'companies: ${companies.length}, '
        'selectedCompany: $selectedCompany, '
        'errorMessage: $errorMessage)';
  }
}

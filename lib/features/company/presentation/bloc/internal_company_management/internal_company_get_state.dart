import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

class InternalGetCompanyState {
  final CompanyEntity? company;
  final bool isLoading;
  final String? error;

  const InternalGetCompanyState({
    this.company,
    this.isLoading = false,
    this.error,
  });

  InternalGetCompanyState copyWith({
    CompanyEntity? company,
    List<String>? warnings,
    bool? isLoading,
    String? error,
  }) {
    return InternalGetCompanyState(
      company: company ?? this.company,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

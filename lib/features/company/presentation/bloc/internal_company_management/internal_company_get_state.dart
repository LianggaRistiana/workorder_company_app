import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

class InternalCompanyState {
  final CompanyEntity? company;
  final bool isLoading;
  final String? error;

  const InternalCompanyState({
    this.company,
    this.isLoading = false,
    this.error,
  });

  InternalCompanyState copyWith({
    CompanyEntity? company,
    List<String>? warnings,
    bool? isLoading,
    String? error,
  }) {
    return InternalCompanyState(
      company: company ?? this.company,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

import 'package:workorder_company_app/features/company/domain/entities/company_entity.dart';

class InternalCompanyState {
  final CompanyEntity? company;
  final List<String> warnings;
  final bool isLoading;
  final String? error;

  const InternalCompanyState({
    this.company,
    this.warnings = const [],
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
      warnings: warnings ?? this.warnings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/template_config/domain/entities/company_type_entity.dart';

enum CompanyTypeListStatus { initial, loading, success, error }

class CompanyTypeListState extends Equatable {
  final CompanyTypeListStatus status;
  final List<CompanyTypeEntity>? companyTypes;
  final String? errorMessage;

  bool get isSuccess => status == CompanyTypeListStatus.success;

  const CompanyTypeListState({
    required this.status,
    this.companyTypes,
    this.errorMessage,
  });

  factory CompanyTypeListState.initial() =>
      const CompanyTypeListState(status: CompanyTypeListStatus.initial);

  CompanyTypeListState copyWith({
    CompanyTypeListStatus? status,
    List<CompanyTypeEntity>? companyTypes,
    String? errorMessage,
  }) {
    return CompanyTypeListState(
      status: status ?? this.status,
      companyTypes: companyTypes ?? this.companyTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        companyTypes,
        errorMessage,
      ];
}

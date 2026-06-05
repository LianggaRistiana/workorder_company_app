import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/employees/domain/meta/employee_detail_meta.dart';

enum EmployeeDetailActionStatus {
  initial,
  loading,
  loaded,
  kicked,
  kickLoading,
  error,
}

class EmployeeDetailActionState extends Equatable {
  final EmployeeDetailActionStatus status;
  final EmployeeDetailMeta? meta;
  final String? errorMessage;

  const EmployeeDetailActionState({
    required this.status,
    this.errorMessage,
    this.meta,
  });

  EmployeeDetailActionState copyWith({
    EmployeeDetailActionStatus? status,
    String? errorMessage,
    EmployeeDetailMeta? meta,
  }) {
    return EmployeeDetailActionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      meta: meta ?? this.meta,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        meta,
      ];
}

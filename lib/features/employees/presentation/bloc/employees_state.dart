part of 'employees_bloc.dart';

class EmployeesState extends Equatable {
  final List<UserEntity> employees;
  final bool isLoading;
  final String? errorMessage;
  final EmployeesParams params;

  const EmployeesState({
    this.employees = const [],
    this.isLoading = false,
    this.errorMessage,
    this.params = const EmployeesParams(),
  });

  List<UserEntity> get filteredEmployees {
    if (params.search == null || params.search!.trim().isEmpty) {
      return employees;
    }

    final search = params.search!.trim().toLowerCase();
    return employees.where((employee) {
      final matchName = employee.name.toLowerCase().contains(search);
      final matchEmail = employee.email.toLowerCase().contains(search);
      return matchName || matchEmail;
    }).toList();
  }

  EmployeesState copyWith({
    List<UserEntity>? employees,
    bool? isLoading,
    String? errorMessage,
    EmployeesParams? params,
  }) {
    return EmployeesState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      params: params ?? this.params,
    );
  }

  @override
  List<Object?> get props => [employees, isLoading, errorMessage, params];
}

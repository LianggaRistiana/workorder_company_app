part of 'employees_bloc.dart';

class EmployeesState extends Equatable {
  final List<UserEntity> employees;
  final bool isLoading;
  final String? errorMessage;

  const EmployeesState({
    this.employees = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  EmployeesState copyWith({
    List<UserEntity>? employees,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EmployeesState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [employees, isLoading, errorMessage];
}
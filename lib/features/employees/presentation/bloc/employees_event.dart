part of 'employees_bloc.dart';

sealed class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object?> get props => [];
}

class GetEmployeesRequested extends EmployeesEvent {
  final EmployeesParams? params;
  final bool forceRefresh;

  const GetEmployeesRequested({
    this.params,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [params, forceRefresh];
}

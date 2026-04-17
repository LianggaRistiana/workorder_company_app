import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/employees/presentation/widget/employees_selector.dart';

class EmployeesSelectorContainer extends StatelessWidget {
  final List<UserEntity> selectedEmployees;
  final List<UserEntity> availableEmployees;
  final void Function(UserEntity) onAdd;
  final Widget Function(
    BuildContext context,
    VoidCallback onPressed,
    bool isLoading,
  ) buttonBuilder;

  const EmployeesSelectorContainer({
    super.key,
    required this.selectedEmployees,
    required this.availableEmployees,
    required this.onAdd,
    required this.buttonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesBloc, EmployeesState>(
      builder: (context, state) {
        final isLoading = state.isLoading;
        final availableEmployees = state.employees;
        return EmployeesSelector(
            isLoading: isLoading,
            selectedEmployees: selectedEmployees,
            availableEmployees: availableEmployees,
            onAdd: onAdd,
            buttonBuilder: buttonBuilder);
      },
    );
  }
}

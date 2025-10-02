import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EmployeesBloc, EmployeesState>(
        builder: (context, state) {
          if (state is EmployeesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeesLoaded) {
            final List<UserEntity> employees = state.employees;

            if (employees.isEmpty) {
              return const Center(child: Text("No employees found"));
            }

            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  title: Text(employee.name),
                  subtitle: Text(employee.email),
                  trailing: Text(employee.role.toString()),
                );
              },
            );
          } else if (state is EmployeesError) {
            return Center(
              child: Text("Error: ${state.message}"),
            );
          }

          // initial state
          return const Center(child: Text("Employees Home"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<EmployeesBloc>().add(GetEmployeesRequested());
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

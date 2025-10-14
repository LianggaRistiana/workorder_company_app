import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/modern_app_bar.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EmployeesBloc, EmployeesState>(
        builder: (context, state) {
          if (state is EmployeesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeesLoaded) {
            final List<UserEntity> employees = state.employees;

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  ModernAppBar(
                    title: "Karyawan",
                    expandedHeight: 100,
                  ),
                ];
              },
              body: employees.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(
                        child: Text(
                          "Belum ada karyawan.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<EmployeesBloc>()
                            .add(GetEmployeesRequested());
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: employees.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final employee = employees[index];
                          return _buildEmployeeCard(context, employee);
                        },
                      ),
                    ),
            );
          }

          if (state is EmployeesError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(child: Text("Employees Home"));
        },
      ),

      // ✅ FloatingActionButton tetap
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.ownerInviteEmployees);
        },
        label: const Text('Tambah Karyawan'),
        icon: const Icon(Icons.person_add_alt_1),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, UserEntity employee) {
    return CustomCard(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: const Icon(Icons.person_outline, color: Colors.blueAccent),
        ),
        title: Text(
          employee.name,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            employee.email,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[700]),
          ),
        ),
        trailing: Chip(
          label: Text(
            employee.role.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        onTap: () {
          // nanti bisa diarahkan ke detail profil employee
        },
      ),
    );
  }
}

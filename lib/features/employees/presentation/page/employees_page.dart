import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/home/presentation/widget/user_chip.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pegawai'),
        ),
        body: BlocBuilder<EmployeesBloc, EmployeesState>(
          builder: (context, state) {
            if (state is EmployeesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EmployeesLoaded) {
              final List<UserEntity> employees = state.employees;

              return RefreshIndicator(
                child: CustomList(
                    scrollable: true,
                    items: employees,
                    itemBuilder: (item, _) {
                      return CustomCard(
                          margin: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs),
                          padding: const EdgeInsets.all(16),
                          child: UserChip(
                            user: item,
                          ));
                    }),
                onRefresh: () async {
                  context.read<EmployeesBloc>().add(GetEmployeesRequested());
                },
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
        floatingActionButton: PermissionGate(
          permission: InvitationPermission.create,
          child: FloatingActionButton.extended(
            onPressed: () {
              context.push(AppRoutes.employeeInvite);
            },
            label: const Text('Tambah Karyawan'),
            icon: const Icon(Icons.person_add_alt_1),
          ),
        ));
  }
}

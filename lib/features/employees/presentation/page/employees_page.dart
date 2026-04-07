import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features_legacy/workorder_legacy/presentation/widgets/staff_chip.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EmployeesBloc>()..add(GetEmployeesRequested()),
      child: BlocConsumer<EmployeesBloc, EmployeesState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showError(state.errorMessage!);
          }
        },
        builder: (context, state) {
          return ListPageScaffold<UserEntity>(
            title: "Pegawai",
            isLoading: state.isLoading,
            errorMessage: state.errorMessage,
            items: state.employees,
            loadingMessage: "Memuat pegawai...",
            onRefresh: () async {
              context.read<EmployeesBloc>().add(GetEmployeesRequested());
            },
            emptyWidget: const EmptyStateWidget(
              icon: Icons.group_off_outlined,
              text: "Tidak ada Pegawai",
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                context.push(AppRoutes.employeeInvite);
              },
              label: const Text('Tambah Karyawan'),
              icon: const Icon(Icons.person_add_alt_1),
            ).require(roleCan(InvitationPermission.create)),
            itemBuilder: (item) {
              return ClickableCustomCard(
                onTap: () {},
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                padding: const EdgeInsets.all(16),
                child: StaffChip(
                  user: item,
                  showPosition: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

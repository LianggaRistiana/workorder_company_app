import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/feature/invitation_permission.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/authorizer/employee_authorizer.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employee_detail_action_cubit.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employee_detail_action_state.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/employees/presentation/widget/employee_item.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';
import 'package:workorder_company_app/shared/widgets/search_bar.dart';

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
            items: state.filteredEmployees,
            loadingMessage: "Memuat pegawai...",
            onRefresh: () async {
              context
                  .read<EmployeesBloc>()
                  .add(GetEmployeesRequested(forceRefresh: true));
            },
            header: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 4, bottom: 4),
              child: AppSearchBar(
                featureName: "pegawai",
                onChanged: (value) {
                  context.read<EmployeesBloc>().add(
                        SetEmployeeSearch(value),
                      );
                },
                initialValue: state.params.search,
              ),
            ),
            emptyWidget: const EmptyStateWidget(
              icon: Icons.group_off_outlined,
              text: "Tidak ada Pegawai",
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                context.push(AppRoutes.employeeInvite);
              },
              label: const Text('Tambah Pegawai'),
              icon: const Icon(Icons.person_add_alt_1),
            ).require(roleCan(InvitationPermission.create)),
            itemBuilder: (item) {
              return EmployeeItem(
                user: item,
                showPosition: true,
                onTap: () {
                  showDetail(context, item);
                },
              );
            },
          );
        },
      ),
    );
  }

  void showDetail(BuildContext context, UserEntity employee) {
    showAppBottomSheet(context,
        content: _SheetContent(
          employee: employee,
        ));
  }
}

class _SheetContent extends StatelessWidget {
  final UserEntity employee;

  const _SheetContent({
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<EmployeeDetailActionCubit>()..getEmployeeMeta(employee.userId),
      child: BlocConsumer<EmployeeDetailActionCubit, EmployeeDetailActionState>(
        listener: (context, state) {
          if (state.status == EmployeeDetailActionStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi Kesalahan");
          }

          if (state.status == EmployeeDetailActionStatus.kicked) {
            context.showSuccess("Pegawai berhasil dikeluarkan");
            context.pop();
          }
        },
        builder: (context, state) {
          final meta = state.meta;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PropertyTitle(
                icon: AppIcon.user,
                label: "Detail Pegawai",
              ),
              const SizedBox(height: 8),
              CustomCard(
                child: PropertyDisplay(properties: [
                  PropertyItem.text(
                    label: "Nama",
                    value: employee.name,
                  ),
                  PropertyItem.text(
                    label: "Email",
                    value: employee.email,
                  ),
                  PropertyItem.widget(
                    label: "Role",
                    child: _RoleChip(user: employee),
                  ),
                  if (employee.position != null)
                    PropertyItem.text(
                      label: "Departemen",
                      value: employee.position!.name,
                    ),
                ]),
              ),
              if (state.isLoadingDetailFetch) ...[
                LoadingStateInline()
              ] else ...[
                FilledButton.icon(
                  onPressed: () async {
                    final result = await showConfirmDialog(
                        context: context,
                        icon: Icons.remove_circle,
                        type: ConfirmDialogType.danger,
                        title: "Keluarkan Pegawai",
                        message: "Anda Yakin ingin mengeluarkan pegawai ini");

                    if (!context.mounted) {
                      return;
                    }

                    if (result == true) {
                      context
                          .read<EmployeeDetailActionCubit>()
                          .kickEmployee(employee);
                    }
                  },
                  style: FilledButton.styleFrom(
                      backgroundColor: ColorScheme.of(context).errorContainer,
                      foregroundColor: ColorScheme.of(context).error,
                      iconColor: ColorScheme.of(context).error),
                  icon: const Icon(Icons.remove_circle),
                  label: Text(
                    "Keluarkan Pegawai",
                  ),
                )
                    .withInlineLoading(
                      state.status == EmployeeDetailActionStatus.kickLoading,
                    )
                    .require(
                      EmployeeAuthorizer(
                        staff: employee,
                        meta: meta,
                      ).removeEmployeeRule,
                    )
              ],
            ],
          );
        },
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final UserEntity user;

  const _RoleChip({required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        user.role.displayName,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 12,
        ),
      ),
    );
  }
}

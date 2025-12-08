import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/employees/presentation/widget/employee_selector.dart';
import 'package:workorder_company_app/features/home/presentation/widget/user_chip.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_assigned_staff_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/staff_quota_chip.dart';

class WorkorderStaffConfigPage extends StatefulWidget {
  final String workorderId;
  final List<UserEntity> assignedStaffs;
  final List<RequiredStaffEntity> requiredStaff;

  const WorkorderStaffConfigPage({
    super.key,
    required this.workorderId,
    required this.assignedStaffs,
    required this.requiredStaff,
  });

  @override
  State<WorkorderStaffConfigPage> createState() => _WorkorderStaffConfigState();
}

class _WorkorderStaffConfigState extends State<WorkorderStaffConfigPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<WorkorderAssignedStaffCubit>()
        .addInitialStaff(widget.assignedStaffs);
    context.read<EmployeesBloc>().add(GetEmployeesRequested());
  }

  @override
  Widget build(BuildContext context) {
    final employeesState = context.watch<EmployeesBloc>().state;
    final employees = employeesState is EmployeesLoaded
        ? employeesState.employees
        : <UserEntity>[];

    List<UserEntity> employeeByPositionId(String positionId) {
      return employees.where((u) => u.position?.id == positionId).toList();
    }

    return BlocConsumer<WorkorderAssignedStaffCubit, WorkorderStaffState>(
      listener: (context, state) {
        if (state.status == WorkorderStateStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil menyimpan Pegawai yang bertugas')),
          );
          context.pop(true);
        }

        if (state.status == WorkorderStateStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? "Terjadi kesalahan")),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == WorkorderStateStatus.loading;

        return Scaffold(
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: isLoading
                ? null
                : () {
                    context
                        .read<WorkorderAssignedStaffCubit>()
                        .submitStaff(widget.workorderId);
                  },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? const SizedBox(
                      key: ValueKey("fab_loading"),
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save, key: ValueKey("fab_icon")),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: CustomList(
              separatorHeight: 8,
              items: widget.requiredStaff,
              itemBuilder: (requiredItem, _) {
                final assigned =
                    state.staffByPositionId(requiredItem.position.id);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header posisi + quota
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          requiredItem.position.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        StaffQuotaChip(
                          currentCount: assigned.length,
                          min: requiredItem.minimumStaff,
                          max: requiredItem.maximumStaff,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // List staff assigned
                    CustomCard(
                      child: assignedStaffList(
                        requiredItem,
                        employeeByPositionId(requiredItem.position.id),
                        assigned,
                        (user) => context
                            .read<WorkorderAssignedStaffCubit>()
                            .removeAssignStaff(user),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget assignedStaffList(
    RequiredStaffEntity requiredStaff,
    List<UserEntity> availableEmployees,
    List<UserEntity> staffs,
    void Function(UserEntity user)? onPressed,
  ) {
    return Column(
      children: [
        CustomList(
          scrollable: false,
          separatorHeight: 4,
          items: staffs,
          itemBuilder: (item, _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UserChip(user: item),
              IconButton(
                onPressed: () => onPressed?.call(item),
                icon: const Icon(Icons.remove_circle, color: Colors.red),
              ),
            ],
          ),
        ),
        Row(
          children: [
            EmployeeSelector(
              title: requiredStaff.position.name,
              availableEmployees: availableEmployees,
              onAdd: (user) {
                context
                    .read<WorkorderAssignedStaffCubit>()
                    .addAssignStaff(user);
              },
              isLoading: false,
              selectedEmployees: staffs,
            ),
          ],
        ),
      ],
    );
  }
}

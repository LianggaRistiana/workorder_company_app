import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  const WorkorderStaffConfigPage(
      {super.key,
      required this.workorderId,
      required this.assignedStaffs,
      required this.requiredStaff});

  @override
  State<WorkorderStaffConfigPage> createState() => _WorkoredrStaffConfigState();
}

class _WorkoredrStaffConfigState extends State<WorkorderStaffConfigPage> {
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
    final employeesBloc = context.watch<EmployeesBloc>();
    final employeesState = employeesBloc.state;

    final employees = employeesState is EmployeesLoaded
        ? employeesState.employees
        : <UserEntity>[];

    List<UserEntity> employeeByPositionId(String positionId) {
      return employees
          .where((staff) => staff.position?.id == positionId)
          .toList();
    }

    return BlocBuilder<WorkorderAssignedStaffCubit, WorkorderStaffState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context
                  .read<WorkorderAssignedStaffCubit>()
                  .submitStaff(widget.workorderId);
            },
            child: const Icon(Icons.save),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: CustomList(
                separatorHeight: 8,
                items: widget.requiredStaff,
                itemBuilder: (item, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.position.name,
                                style: Theme.of(context).textTheme.titleMedium),
                            StaffQuotaChip(
                                currentCount: state
                                    .staffByPositionId(item.position.id)
                                    .length,
                                min: item.minimumStaff,
                                max: item.maximumStaff),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CustomCard(
                            child: assignedStaffList(
                                item,
                                employeeByPositionId(item.position.id),
                                state.staffByPositionId(item.position.id),
                                (user) {
                          context
                              .read<WorkorderAssignedStaffCubit>()
                              .removeAssignStaff(user);
                        })),
                      ],
                    )),
          ));
    });
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
                    UserChip(
                      user: item,
                    ),
                    IconButton(
                        onPressed: () => onPressed?.call(item),
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ))
                  ],
                )),
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
                selectedEmployees: staffs),
          ],
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/employees/domain/params/employees_params.dart';
import 'package:workorder_company_app/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:workorder_company_app/features/employees/presentation/widget/employees_selector_container.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/staff_item_editor.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/staff_quota_chip.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_property_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class WorkOrderAssignStaffsPage extends StatefulWidget {
  final WorkOrderEntity workOrder;
  const WorkOrderAssignStaffsPage({super.key, required this.workOrder});

  @override
  State<WorkOrderAssignStaffsPage> createState() =>
      _WorkOrderAssignStaffsPageState();
}

class _WorkOrderAssignStaffsPageState extends State<WorkOrderAssignStaffsPage> {
  UserEntity? staffPic;
  List<UserEntity> staffs = [];

  @override
  void initState() {
    super.initState();
    staffPic = widget.workOrder.staffPic;
    staffs = List<UserEntity>.from(widget.workOrder.assignedStaffs);
  }

  void onAddStaffPic(UserEntity staff) {
    setState(() {
      staffPic = staff;
      if (!staffs.any((e) => e.email == staff.email)) {
        staffs.add(staff);
      }
    });
  }

  void onAddStaff(UserEntity staff) {
    setState(() {
      staffs.add(staff);
    });
  }

  void onRemoveStaff(UserEntity staff) {
    setState(() {
      staffs.remove(staff);
    });
  }

  void onSubmit(BuildContext context) {
    if (staffs.isEmpty) {
      context.showError("Tidak ada pegawai yang dipilih");
      return;
    }

    context.read<FillWorkOrderCubit>().assignStaffsToWorkOrder(widget.workOrder,
        AssignedStaffsDraft(assignedStaffs: staffs, staffPic: staffPic));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<FillWorkOrderCubit>()),
          BlocProvider(
              create: (_) => sl<EmployeesBloc>()
                ..add(GetEmployeesRequested(
                    params: EmployeesParams(
                  positionId: widget.workOrder.positionOnDuty.id,
                )))),
        ],
        child: BlocConsumer<FillWorkOrderCubit, FillWorkOrderState>(
          listener: (context, state) {
            if (state.status == FillWorkOrderStatus.success) {
              context.showSuccess("Berhasil mengisi pegawai bertugas");
              context.pop<Result<WorkOrderEntity>?>(state.result);
            }
            if (state.status == FillWorkOrderStatus.error) {
              context.showError(state.errorMessage ?? "Terjadi kesalahan");
            }
          },
          builder: (context, state) {
            final isLoading = state.status == FillWorkOrderStatus.loading;
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: ButtonWithLoadingState(
                    onPressed: () => onSubmit(context),
                    isLoading: isLoading,
                    icon: AppIcon.submit,
                    label: "Simpan",
                  ),
                ),
                body: AdaptiveSplitColumn(
                  leftChildren: _staffPicArea(),
                  rightChildren: _staffArea(),
                ),
              ),
            );
          },
        ));
  }

  List<Widget> _staffPicArea() {
    return [
      WorkOrderPropertyView.shortView(workOrder: widget.workOrder),
      // NOTE : Since staff PIC in WorkOrder has been removed, Approval Work order is doesnt needed anymore
      // SectionTitle("Penanggung Jawab"),
      // EmployeesSelectorContainer(
      //     selectedEmployees: staffPic != null ? [staffPic!] : [],
      //     onAdd: onAddStaffPic,
      //     buttonBuilder: (context, onPressed, isLoading) => staffPic == null
      //         ? DashedButton(
      //             icon: AppIcon.add,
      //             onTap: onPressed,
      //             borderColor: Theme.of(context).disabledColor,
      //             color: Theme.of(context).colorScheme.primary,
      //             isLoading: isLoading,
      //             title: "Pilih Penanggung Jawab",
      //           )
      //         : ClickableCustomCard(
      //             onTap: onPressed,
      //             child: StaffItemEditor(
      //               staff: staffPic!,
      //               isPic: true,
      //             ),
      //           )),
      const SizedBox(height: AppSpacing.lg),
    ];
  }

  List<Widget> _staffArea() {
    return [
      Row(
        children: [
          SectionTitle("Pegawai Bertugas"),
          const Spacer(),
          StaffQuotaChip(
            currentCount: staffs.length,
            min: widget.workOrder.minStaff,
            max: widget.workOrder.maxStaff,
          )
        ],
      ),
      CustomCard(
          child: Column(
        children: [
          CustomList(
              separatorHeight: 8,
              emptyWidget: InformationBlock.warning("Pegawai Kosong"),
              items: staffs,
              itemBuilder: (item, _) => StaffItemEditor(
                    onRemove: onRemoveStaff,
                    staff: item,
                    isPic: item.email == staffPic?.email,
                  )),
          const SizedBox(height: AppSpacing.md),
          EmployeesSelectorContainer(
              selectedEmployees: staffs,
              onAdd: onAddStaff,
              buttonBuilder: (context, onPressed, isLoading) => DashedButton(
                    icon: AppIcon.add,
                    borderColor: Theme.of(context).disabledColor,
                    color: Theme.of(context).colorScheme.primary,
                    onTap: onPressed,
                    isLoading: isLoading,
                    title: "Pilih Pegawai",
                  ))
        ],
      ))
    ];
  }
}

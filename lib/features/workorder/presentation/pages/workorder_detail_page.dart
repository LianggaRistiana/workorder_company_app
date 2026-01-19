import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/authorization/feature/workorder_permission.dart';
import 'package:workorder_company_app/core/authorization/widget/permission_gate.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/client_name_chip.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';
import 'package:workorder_company_app/features/workorder/domain/entitties/workorder__entity.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_detail_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/widgets/workorder_action_buttons.dart';
import 'package:workorder_company_app/features/workorder/presentation/widgets/workorder_status_chip.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/staff_quota_chip.dart';

class WorkorderDetailPage extends StatefulWidget {
  final String workorderId;
  const WorkorderDetailPage({super.key, required this.workorderId});

  @override
  State<WorkorderDetailPage> createState() => _WorkorderDetailPageState();
}

class _WorkorderDetailPageState extends State<WorkorderDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkorderDetailCubit>().getWorkorderDetail(widget.workorderId);
  }

  bool isDataUpdated = false;

  void _refresh() {
    isDataUpdated = true;
    context.read<WorkorderDetailCubit>().getWorkorderDetail(widget.workorderId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WorkorderDetailCubit, WorkorderDetailState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == WorkorderStateStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi kesalahan");
          }
        },
        builder: (context, state) {
          final workorder = state.workorder;
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () {
                context.pop(isDataUpdated);
              }),
            ),
            bottomNavigationBar: workorder == null
                ? const SizedBox.shrink()
                : PermissionGate(
                    permission: WorkOrderPermissions.update,
                    child: WorkorderActionButtons(
                      workorderStatus: workorder.status,
                      workorderId: widget.workorderId,
                      onRefresh: () {
                        _refresh();
                      },
                    )),
                : PermissionGate(
                    permission: WorkOrderPermissions.update,
                    child: WorkorderActionButtons(
                      workorderStatus: workorder.status,
                      workorderId: widget.workorderId,
                      onRefresh: () {
                        _refresh();
                      },
                    )),
            body: workorder == null
                ? SizedBox.shrink()
                : _mainContent(workorder, context),
          );
        });
  }

  Widget _mainContent(WorkorderEntity workorder, BuildContext context) {
    final WorkOrderStatus woStatus = workorder.status;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _woServiceName(workorder.service.title),
          const SizedBox(height: AppSpacing.xs),
          _woStatusAndCreatedTime(
              workorder.createdBy, workorder.status, workorder.createdAt),
          const SizedBox(height: AppSpacing.md),

          // Employee worked
          Text("Pegawai bertugas",
              style: Theme.of(context).textTheme.titleMedium),

          if (woStatus == WorkOrderStatus.drafted)
            PermissionGate(
                permission: WorkOrderPermissions.update,
                child: HorizontalButton(
                  title: "Edit pegawai yang bertugas",
                  leadingIcon: Icons.person_add,
                  description:
                      "pegawai yang betugas harus sesuai dengan posisi yang dibutuhkan layanan",
                  onTap: () async {
                    final result = await context.push(
                        AppRoutes.workordersAssignStaff
                            .fillId(workorder.id),
                        extra: {
                          'requiredStaff': workorder.service.requiredStaff,
                          'assignedStaff': workorder.assignedStaffs
                        });
            PermissionGate(
                permission: WorkOrderPermissions.update,
                child: HorizontalButton(
                  title: "Edit pegawai yang bertugas",
                  leadingIcon: Icons.person_add,
                  description:
                      "pegawai yang betugas harus sesuai dengan posisi yang dibutuhkan layanan",
                  onTap: () async {
                    final result = await context.push(
                        AppRoutes.workordersAssignStaff
                            .fillId(workorder.id),
                        extra: {
                          'requiredStaff': workorder.service.requiredStaff,
                          'assignedStaff': workorder.assignedStaffs
                        });

                    if (!context.mounted) return;
                    if (!context.mounted) return;

                    if (result == true) {
                      _refresh();
                    }
                  },
                )),
                    if (result == true) {
                      _refresh();
                    }
                  },
                )),
          _woAssignedStaff(
              workorder.service.requiredStaff, workorder.assignedStaffs ?? []),

          // Work order filled form
          const SizedBox(height: AppSpacing.md),
          Text("Formulir Perintah Kerja",
              style: Theme.of(context).textTheme.titleMedium),

          if (woStatus == WorkOrderStatus.drafted)
            PermissionGate(
                permission: WorkOrderPermissions.update,
                child: HorizontalButton(
                  title: "Edit Formulir Perintah Kerja",
                  leadingIcon: Icons.assignment_outlined,
                  description:
                      "Anda dapat mengedit perintah kerja selama perintah kerja belum berstatus Siap ",
                  onTap: () async {
                    final result = await context
                        .push(AppRoutes.workordersSubmission);
                    if (!context.mounted) return;
                    if (result == true) {
                      _refresh();
                    }
                  },
                )),

          if (workorder.workorderForms != null &&
              workorder.workorderForms!.isNotEmpty)
            CustomList(
              scrollable: false,
              separatorHeight: 16,
              items: workorder.workorderForms!,
              itemBuilder: (item, _) => FilledFormView(filledForm: item),
            ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _woServiceName(String name) {
    return Row(
      children: [
        IconBox(paddingSize: AppSpacing.md, icon: Icons.assignment_outlined),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }

  Widget _woStatusAndCreatedTime(
      UserEntity createdBy, WorkOrderStatus status, DateTime createdAt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Dibuat oleh", style: Theme.of(context).textTheme.titleSmall),
            ClientNameChip(name: createdBy.name),
          ],
        ),
        Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('d MMM yyyy', 'id_ID').format(createdAt),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            WorkOrderStatusChip(status: status),
          ],
        ),
      ],
    );
  }

  Widget _woAssignedStaff(
    List<RequiredStaffEntity> requiredStaff,
    List<UserEntity> staff,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (requiredStaff.isNotEmpty)
            ...requiredStaff.map(
              (reqStaff) {
                final filteredStaff = staff
                    .where((element) =>
                        element.position?.id == reqStaff.position.id)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // posisi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reqStaff.position.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        StaffQuotaChip(
                          currentCount: filteredStaff.length,
                          min: reqStaff.minimumStaff,
                          max: reqStaff.maximumStaff,
                        )
                      ],
                    ),

                    const SizedBox(height: 6),

                    // staff yang cocok posisi
                    CustomList(
                      scrollable: false,
                      emptyWidget: EmptyStateWidget(
                        size: 40,
                        text: "Tidak ada Pegawai",
                      ),
                      separatorHeight: 4,
                      items: filteredStaff,
                      itemBuilder: (item, _) => ClientNameChip(name: item.name),
                    ),

                    const SizedBox(height: 12),
                  ],
                );
              },
            ),

          // Jika requiredStaff kosong → tampilkan semua staff
          if (requiredStaff.isEmpty)
            CustomList(
              emptyWidget: SizedBox(
                width: double.infinity,
                child: EmptyStateWidget(
                  size: 40,
                  text: "Tidak ada Pegawai",
                ),
              ),
              scrollable: false,
              separatorHeight: 4,
              items: staff,
              itemBuilder: (item, _) => ClientNameChip(name: item.name),
            ),
        ],
      ),
    );
  }
}

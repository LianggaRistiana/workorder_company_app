import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/client_name_chip.dart';
import 'package:workorder_company_app/features/services/domain/entities/required_staff_entity.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_detail_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/widgets/workorder_status_chip.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<WorkorderDetailCubit, WorkorderDetailState>(
            builder: (context, state) {
          if (state.status == WorkorderStateStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == WorkorderStateStatus.error) {
            return Center(
                child: Text(state.errorMessage ?? "Terjadi kesalahan"));
          }

          final workorder = state.workorder;
          // Logger().i(workorder?.workorderForms?.toString() ?? "null");
          if (workorder == null) return const SizedBox();

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
                HorizontalButton(
                  title: "Edit pegawai yang bertugas",
                  leadingIcon: Icons.person_add,
                  description:
                      "pegawai yang betugas harus sesuai dengan posisi yang dibutuhkan layanan",
                  onTap: () {
                    context.push(
                        AppRoutes.managerWorkorderStaffConfig
                            .byId(workorder.id),
                        extra: {
                          'requiredStaff': workorder.service.requiredStaff,
                          'assignedStaff': workorder.assignedStaffs
                        });
                  },
                ),
                _woAssignedStaff(workorder.service.requiredStaff,
                    workorder.assignedStaffs ?? []),

                // Work order filled form
                const SizedBox(height: AppSpacing.md),
                Text("Formulir Tugas Kerja",
                    style: Theme.of(context).textTheme.titleMedium),
                HorizontalButton(
                  title: "Edit Formulir Tugas Kerja",
                  leadingIcon: Icons.assignment_outlined,
                  description:
                      "Anda dapat mengedit tugas kerja selama tugas kerja belum berstatus Siap",
                  onTap: () {},
                ),

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
        }));
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

// final dummyPosition = [
//   PositionEntity(id: "1", name: "Tukang"),
//   PositionEntity(id: "2", name: "IT Suprot"),
// ];

// final dummyUsers = [
//   UserEntity(
//     name: "Aldo Pratama",
//     email: "aldo@example.com",
//     role: UserRole.managerCompany,
//     position: dummyPosition.firstWhere((p) => p.id == "1"),
//   ),
//   UserEntity(
//     name: "Sinta Lestari",
//     email: "sinta@example.com",
//     role: UserRole.staffCompany,
//     position: dummyPosition.firstWhere((p) => p.id == "1"),
//   ),
//   UserEntity(
//     name: "Bagus Saputra",
//     email: "bagus@example.com",
//     role: UserRole.staffCompany,
//     position: dummyPosition.firstWhere((p) => p.id == "1"),
//   ),
//   UserEntity(
//     name: "Dewi Ayu",
//     email: "dewi@example.com",
//     role: UserRole.staffCompany,
//     position: dummyPosition.firstWhere((p) => p.id == "1"),
//   ),
//   UserEntity(
//     name: "Rifki Hidayat",
//     email: "rifki@example.com",
//     role: UserRole.staffCompany,
//     position: dummyPosition.firstWhere((p) => p.id == "1"),
//   ),
//   UserEntity(
//     name: "Melati Rahma",
//     email: "melati@example.com",
//     role: UserRole.staffCompany,
//     position: dummyPosition.firstWhere((p) => p.id == "2"),
//   ),
// ];

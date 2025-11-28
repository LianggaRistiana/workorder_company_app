import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/widgets/client_name_chip.dart';
import 'package:workorder_company_app/features/positions/domain/entities/position_entity.dart';
import 'package:workorder_company_app/features/workorder/presentation/widgets/workorder_status_chip.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class WorkorderDetailPage extends StatefulWidget {
  final String workorderId;
  const WorkorderDetailPage({super.key, required this.workorderId});

  @override
  State<WorkorderDetailPage> createState() => _WorkorderDetailPageState();
}

class _WorkorderDetailPageState extends State<WorkorderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _woServiceName(),
            const SizedBox(height: AppSpacing.xs),
            _woStatusAndCreatedTime(),
            const SizedBox(height: AppSpacing.md),

            // Employee worked
            Text("Pegawai bertugas",
                style: Theme.of(context).textTheme.titleMedium),
            HorizontalButton(
              title: "Edit pegawai yang bertugas",
              leadingIcon: Icons.person_add,
              description:
                  "pegawai yang betugas harus sesuai dengan posisi yang dibutuhkan layanan",
              onTap: () {},
            ),
            _woAssignedStaff(),

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
          ],
        ),
      ),
    );
  }

  Widget _woServiceName() {
    return Row(
      children: [
        IconBox(paddingSize: AppSpacing.md, icon: Icons.assignment_outlined),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.workorderId,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }

  Widget _woStatusAndCreatedTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        WorkOrderStatusChip(status: WorkOrderStatus.inProgress),
        Text(
          DateFormat('d MMM yyyy', 'id_ID').format(DateTime.now()),
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _woAssignedStaff() {
    return CustomCard(
      child: Column(
        children: [
          ...dummyPosition.map(
            (e) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                CustomList(
                  scrollable: false,
                  separatorHeight: 4,
                  items: dummyUsers
                      .where((element) => element.position?.id == e.id)
                      .toList(),
                  itemBuilder: (item, _) => ClientNameChip(name: item.name),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final dummyPosition = [
  PositionEntity(id: "1", name: "Tukang"),
  PositionEntity(id: "2", name: "IT Suprot"),
];

final dummyUsers = [
  UserEntity(
    name: "Aldo Pratama",
    email: "aldo@example.com",
    role: UserRole.managerCompany,
    position: dummyPosition.firstWhere((p) => p.id == "1"),
  ),
  UserEntity(
    name: "Sinta Lestari",
    email: "sinta@example.com",
    role: UserRole.staffCompany,
    position: dummyPosition.firstWhere((p) => p.id == "1"),
  ),
  UserEntity(
    name: "Bagus Saputra",
    email: "bagus@example.com",
    role: UserRole.staffCompany,
    position: dummyPosition.firstWhere((p) => p.id == "1"),
  ),
  UserEntity(
    name: "Dewi Ayu",
    email: "dewi@example.com",
    role: UserRole.staffCompany,
    position: dummyPosition.firstWhere((p) => p.id == "1"),
  ),
  UserEntity(
    name: "Rifki Hidayat",
    email: "rifki@example.com",
    role: UserRole.staffCompany,
    position: dummyPosition.firstWhere((p) => p.id == "1"),
  ),
  UserEntity(
    name: "Melati Rahma",
    email: "melati@example.com",
    role: UserRole.staffCompany,
    position: dummyPosition.firstWhere((p) => p.id == "2"),
  ),
];

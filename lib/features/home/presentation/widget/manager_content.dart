import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class ManagerContent extends StatelessWidget {
  const ManagerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalButton(
          leadingIcon: Icons.assignment_add,
          title: "Buat Tugas Kerja Baru",
          description: "Buat tugas kerja baru khusus untuk internal perusahaan",
          onTap: () {},
        ),
        const SizedBox(height: 8),
        const SectionTitle("Menu Operasional"),
        const SizedBox(height: 12),
        MenuGrid(
          items: [
            MenuItem(
                icon: Icons.inbox_outlined,
                label: "Pengajuan Layanan",
                onTap: () {
                  context.go(AppRoutes.serviceRequestInbox);
                }),
            MenuItem(
                icon: Icons.assignment_outlined,
                label: "Perintah Kerja",
                onTap: () {
                  context.go(AppRoutes.workorders);
                }),
            MenuItem(
                icon: Icons.people_outline,
                label: "Pegawai",
                onTap: () {
                  context.push(AppRoutes.employee);
                }),
            MenuItem(
                icon: Icons.card_membership,
                label: "Pelanggan Perusahaan",
                onTap: () {}),
            MenuItem(
                icon: Icons.history_outlined,
                label: "Riwayat Pengajuan",
                onTap: () {}),
            MenuItem(
                icon: Icons.history_outlined,
                label: "Riwayat Workorder",
                onTap: () {}),
            MenuItem(
                icon: Icons.help_outline_outlined,
                label: "Bantuan",
                onTap: () {
                  context.push(AppRoutes.notFound);
                }),
          ],
        ),
      ],
    );
  }
}

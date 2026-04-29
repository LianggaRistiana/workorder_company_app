import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
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
          title: "Buat Perintah Kerja Baru",
          description:
              "Buat perintah kerja baru khusus untuk internal perusahaan",
          onTap: () {},
        ),
        const SizedBox(height: 8),
        SectionTitle(
          "Menu Operasional",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        MenuGrid(
          items: [
            MenuItem(
                icon: AppIcon.serviceRequestInbox,
                label: "Permintaan Layanan",
                onTap: () {
                  context.go(AppRoutes.serviceRequestInbox);
                }),
            MenuItem(
                icon: AppIcon.workOrder,
                label: "Perintah Kerja",
                onTap: () {
                  context.go(AppRoutes.workOrders);
                }),
            MenuItem(
                icon: AppIcon.employee,
                label: "Pegawai",
                onTap: () {
                  context.push(AppRoutes.employee);
                }),
            MenuItem(
                icon: AppIcon.membership,
                label: "Pelanggan Perusahaan",
                onTap: () {}),
            MenuItem(
                icon: AppIcon.history,
                label: "Riwayat Permintaan",
                onTap: () {}),
            MenuItem(
                icon: AppIcon.history,
                label: "Riwayat Workorder",
                onTap: () {}),
            MenuItem(
                icon: AppIcon.help,
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

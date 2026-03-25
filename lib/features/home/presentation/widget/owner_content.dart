import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class OwnerContent extends StatelessWidget {
  const OwnerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Menu Konfigurasi Perusahaan"),
        const SizedBox(height: 12),
        MenuGrid(
          items: [
            MenuItem(
                icon: AppIcon.form,
                label: "Formulir",
                onTap: () {
                  context.push(AppRoutes.forms);
                }),
            MenuItem(
                icon: AppIcon.service,
                label: "Layanan",
                onTap: () {
                  context.push(AppRoutes.services);
                }),
            MenuItem(
                icon: AppIcon.department,
                label: "Departemen",
                onTap: () {
                  context.push(AppRoutes.positions);
                }),
            MenuItem(
                icon: AppIcon.help,
                label: "Bantuan",
                onTap: () {
                  showAppBottomSheet(context,
                      content: SizedBox(
                        height: 200,
                        child: Center(
                          child: Text("Fitur ini belum tersedia"),
                        ),
                      ));
                }),
          ],
        ),
        const SizedBox(height: 12),
        const SectionTitle("Menu Operasional"),
        const SizedBox(height: 12),
        MenuGrid(
          items: [
            MenuItem(
                icon: AppIcon.serviceRequestInbox,
                label: "Pengajuan Layanan",
                onTap: () {
                  context.push(AppRoutes.serviceRequest);
                }),
            MenuItem(
                icon: AppIcon.workOrder,
                label: "Perintah Kerja",
                onTap: () {
                  context.push(AppRoutes.workorders);
                }),
            MenuItem(
                icon: AppIcon.employee,
                label: "Pegawai",
                onTap: () {
                  context.push(AppRoutes.employee);
                }),
            MenuItem(
                icon: AppIcon.help,
                label: "Bantuan",
                onTap: () {
                  showAppBottomSheet(context,
                      content: SizedBox(
                        height: 200,
                        child: Center(
                          child: Text("Fitur ini belum tersedia"),
                        ),
                      ));
                }),
          ],
        ),
        const SizedBox(height: 24),
        HorizontalButton(
          leadingIcon: AppIcon.more,
          title: "Menu lainnya",
          description:
              "Pengaturan umum seperti nama, alamat perusahaan dan lain sebagainya",
          onTap: () => context.go(AppRoutes.companyManageMenu),
        ),
      ],
    );
  }
}

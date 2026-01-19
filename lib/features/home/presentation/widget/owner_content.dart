import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
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
                icon: Icons.assignment_turned_in_outlined,
                label: "Formulir",
                onTap: () {
                  context.push(AppRoutes.forms);
                }),
            MenuItem(
                icon: Icons.build_circle_outlined,
                label: "Layanan",
                onTap: () {
                  context.push(AppRoutes.services);
                }),
            MenuItem(
                icon: Icons.badge_outlined,
                label: "Posisi Pegawai",
                onTap: () {
                  context.push(AppRoutes.positions);
                }),
            MenuItem(
                icon: Icons.help_outline_outlined,
                label: "Bantuan",
                onTap: () {}),
          ],
        ),
        const SizedBox(height: 24),
        const SectionTitle("Menu Operasional"),
        const SizedBox(height: 12),
        MenuGrid(
          items: [
            MenuItem(
                icon: Icons.inbox_outlined,
                label: "Pengajuan Layanan",
                onTap: () {}),
            MenuItem(
                icon: Icons.assignment_outlined,
                label: "Perintah Kerja",
                onTap: () {
                  context.push(AppRoutes.workorders);
                }),
            MenuItem(
                icon: Icons.people_outline,
                label: "Pegawai",
                onTap: () {
                  context.push(AppRoutes.employee);
                }),
            MenuItem(
                icon: Icons.help_outline_outlined,
                label: "Bantuan",
                onTap: () {}),
          ],
        ),
        const SizedBox(height: 24),
        HorizontalButton(
          leadingIcon: Icons.build_rounded,
          title: "Menu lainnya",
          description:
              "Pengaturan umum seperti nama, alamat perusahaan dan lain sebagainya",
          onTap: () => context.go(AppRoutes.ownerCompany),
        ),
      ],
    );
  }
}

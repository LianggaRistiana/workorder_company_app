import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
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
        SectionTitle(
          "Menu Konfigurasi Perusahaan",
          style: Theme.of(context).textTheme.titleLarge,
        ),
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
                icon: AppIcon.qna,
                label: "Konfigurasi Tanya Jawab",
                onTap: () {
                  context.push(AppRoutes.companyFaqConfig);
                }),
          ],
        ),
        const SizedBox(height: 12),
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
                  context.push(AppRoutes.serviceRequestInbox);
                }),
            MenuItem(
                icon: AppIcon.workOrder,
                label: "Perintah Kerja",
                onTap: () {
                  context.push(AppRoutes.workOrders);
                }),
            MenuItem(
                icon: AppIcon.employee,
                label: "Pegawai",
                onTap: () {
                  context.push(AppRoutes.employee);
                }),
          ],
        ),
        const SizedBox(height: 24),
        HorizontalButton(
          leadingIcon: AppIcon.more,
          title: "Menu lainnya",
          description:
              "Integrasi sistem, konfigurasi FaQ, dan lainnya",
          onTap: () => context.go(AppRoutes.companyManageMenu),
        ),
        HorizontalButton(
          key: const Key("horizontal-button-dashboard"),
          margin: EdgeInsets.all(0),
          leadingIcon: AppIcon.dashboard,
          title: "Dashboard",
          description: "Lihat statistik perusahaan",
          onTap: () {
            context.push(AppRoutes.dashboard);
          },
        ),
      ],
    );
  }
}

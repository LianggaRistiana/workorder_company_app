import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/rule/position_permission_rule/position_permission_helper.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
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
        SectionTitle(
          "Menu Konfigurasi",
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
                icon: AppIcon.servicePrice,
                label: "Harga Layanan",
                onTap: () {
                  context.push(AppRoutes.servicePrice);
                }),
            MenuItem(
                icon: AppIcon.department,
                label: "Departemen",
                onTap: () {
                  context.push(AppRoutes.positions);
                }).require(hasNoPosition()),
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
                icon: AppIcon.dashboard,
                label: "Dashboard",
                onTap: () {
                  context.push(AppRoutes.dashboard);
                }),
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
                icon: AppIcon.history,
                label: "Riwayat Undangan Pegawai",
                onTap: () {
                  context.push(AppRoutes.invitationsHistory);
                }),
          ],
        ),
      ],
    );
  }
}

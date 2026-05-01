import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class ClientContent extends StatelessWidget {
  const ClientContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HorizontalButton(
          leadingIcon: AppIcon.serviceRequestSend,
          title: "Ajukan Permintaan Layanan",
          description: "Pilih perusahaan kemudiaan ajukan permintaan layanan",
          onTap: () {
            context.go(AppRoutes.publicCompanies);
          },
        ),
        const SizedBox(height: 8),
        SectionTitle(
          "Menu",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        MenuGrid(
          items: [
            MenuItem(
                icon: AppIcon.serviceRequestSend,
                label: "Permintaan Layanan Saya",
                onTap: () => context.push(AppRoutes.serviceRequestSent)),
            MenuItem(
                icon: AppIcon.company,
                label: "Perusahaan langganan",
                onTap: () {}),
            MenuItem(
                icon: AppIcon.membership,
                label: "Aktifkan Keanggotaan",
                onTap: () => context.push(AppRoutes.membershipsClaim)),
            MenuItem(
                icon: AppIcon.history,
                label: "Riwayat Permintaan",
                onTap: () {}),
            MenuItem(
                icon: Icons.help_outline_outlined,
                label: "Bantuan",
                onTap: () {
                  context.push(AppRoutes.lab);
                }),
          ],
        ),
      ],
    );
  }
}

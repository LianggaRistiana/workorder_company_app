import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          leadingIcon: Icons.send_rounded,
          title: "Ajukan Permintaan Layanan",
          description: "Pilih perusahaan kemudiaan ajukan permintaan layanan",
          onTap: () {
            context.go(AppRoutes.publicCompanies);
          },
        ),
        const SizedBox(height: 8),
        const SectionTitle("Menu"),
        const SizedBox(height: 12),
        MenuGrid(
          items: [
            MenuItem(
                icon: Icons.assignment_outlined,
                label: "Pengajuan Layanan Saya",
                onTap: () => context.push(AppRoutes.serviceRequestClientSide)),
            MenuItem(
                icon: Icons.home_work_outlined,
                label: "Perusahaan langganan",
                onTap: () {}),
            MenuItem(
                icon: Icons.card_membership_outlined,
                label: "Aktifkan Keanggotaan",
                onTap: () => context.push(AppRoutes.membershipsClaim)),
            MenuItem(
                icon: Icons.history, label: "Riwayat Pengajuan", onTap: () {}),
            MenuItem(
                icon: Icons.help_outline_outlined,
                label: "Bantuan",
                onTap: () {}),
          ],
        ),
      ],
    );
  }
}

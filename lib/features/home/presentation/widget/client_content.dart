import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class ClientContent extends StatelessWidget {
  const ClientContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          "Menu",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        HorizontalButton(
          leadingIcon: AppIcon.company,
          title: "Ajukan Permintaan Layanan",
          description: "Pilih perusahaan kemudiaan ajukan permintaan layanan",
          onTap: () {
            context.go(AppRoutes.publicCompanies);
          },
        ),
        HorizontalButton(
            leadingIcon: AppIcon.serviceRequestSend,
            title: "Permintaan Layanan Saya",
            description: "Permintaan layanan yang anda ajukan",
            onTap: () => context.push(AppRoutes.serviceRequestSent)),
        HorizontalButton(
            leadingIcon: AppIcon.dashboard,
            title: "Dashboard",
            description: "Statistik aktifitas anda",
            onTap: () => context.push(AppRoutes.dashboard)),
        // MenuGrid(
        //   items: [
        //     MenuItem(
        //         icon: AppIcon.dashboard,
        //         label: "Dashboard",
        //         onTap: () => context.push(AppRoutes.dashboard)),
        //     MenuItem(
        //         icon: AppIcon.serviceRequestSend,
        //         label: "Permintaan Layanan Saya",
        //         onTap: () => context.push(AppRoutes.serviceRequestSent)),
        //     // MenuItem(
        //     //     icon: AppIcon.company,
        //     //     label: "Perusahaan langganan",
        //     //     onTap: () {}),
        //     MenuItem(
        //         icon: AppIcon.memberCode,
        //         label: "Klaim Kode Keanggotaan",
        //         onTap: () => context.push(AppRoutes.membershipsClaim)),
        //     // MenuItem(
        //     //     icon: AppIcon.history,
        //     //     label: "Riwayat Permintaan",
        //     //     onTap: () {}),
        //     // MenuItem(
        //     //     icon: Icons.help_outline_outlined,
        //     //     label: "Bantuan",
        //     //     onTap: () {
        //     //       context.push(AppRoutes.lab);
        //     //     }),
        //   ],
        // ),
      ],
    );
  }
}

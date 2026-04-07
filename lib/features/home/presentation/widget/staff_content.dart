import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
// import 'package:workorder_company_app/features/services/presentation/pages/services_list_page.dart';
// import 'package:workorder_company_app/features/dashboard/presentation/widgets/dashboard_stat_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class StaffContent extends StatelessWidget {
  const StaffContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        // Row(
        //   children: [
        //     Expanded(
        //       child: DashboardStatCard(
        //         icon: Icons.assignment_outlined,
        //         label: "Tugas Saya",
        //         value: 2,
        //         onTap: () {
        //           context.go(AppRoutes.workorders);
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 12),
        //     Expanded(
        //       child: DashboardStatCard(
        //         icon: Icons.assignment_outlined,
        //         label: "Tugas Aktif Saya",
        //         value: 1,
        //         onTap: () {
        //           context.go(AppRoutes.workorders);
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 8),
        const SectionTitle("Menu"),
        const SizedBox(height: 12),
        MenuGrid(
          items: [
            // MenuItem(
            //     icon: AppIcon.service,
            //     label: "Layanan",
            //     onTap: () {
            //       context.push(AppRoutes.services,
            //           extra: NextStepMode.createServiceRequest);
            //     }),
            MenuItem(
                icon: AppIcon.employee,
                label: "Rekan Kerja",
                onTap: () {
                  context.push(AppRoutes.employee);
                }),
            MenuItem(
                icon: AppIcon.serviceRequestSend,
                label: "Permintaan Layanan",
                onTap: () {
                  context.push(AppRoutes.serviceRequestSent);
                }),
            MenuItem(
                icon: AppIcon.workOrder,
                label: "Perintah Kerja",
                onTap: () {
                  context.go(AppRoutes.workorders);
                }),
            MenuItem(
                icon: AppIcon.workOrder,
                label: "Riwayat Workorder",
                onTap: () {}),
            MenuItem(icon: AppIcon.help, label: "Bantuan", onTap: () {}),
          ],
        ),
      ],
    );
  }
}

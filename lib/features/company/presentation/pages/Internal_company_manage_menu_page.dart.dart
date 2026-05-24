import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/internal_company_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class InternalCompanyManageMenuPage extends StatefulWidget {
  const InternalCompanyManageMenuPage({super.key});

  @override
  State<InternalCompanyManageMenuPage> createState() =>
      _InternalCompanyManageMenuPageState();
}

class _InternalCompanyManageMenuPageState
    extends State<InternalCompanyManageMenuPage> {
  @override
  void initState() {
    super.initState();
    context.read<InternalGetCompanyCubit>().loadCompany();
  }

  @override
  void dispose() {
    // OrientationHelper.all();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AdaptiveSplitColumn(
          heightSpacing: 0,
          leftChildren: _configMenu(),
          rightChildren: _operationalMenu(),
        ),
      ),
    );
  }

  List<Widget> _configMenu() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Hero(
          tag: "company-card",
          child: InternalCompanyCard(),
        ),
      ),
      SectionTitle(
        "Menu Konfigurasi Perusahaan",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 12),
      HorizontalButton(
        key: const Key("horizontal-button-config"),
        margin: EdgeInsets.all(0),
        leadingIcon: AppIcon.template,
        title: "Konfigurasi Cepat",
        description:
            "Konfigurasi Departemen, Formulir, Layanan dengan memilih template yang tersedia",
        onTap: () {
          context.push(AppRoutes.templateCompanyType);
        },
      ),
      const SizedBox(height: 12),
      MenuGrid(
        key: const Key("menu-grid-config"),
        items: [
          MenuItem(
              icon: AppIcon.info,
              label: "Informasi Perusahaan",
              onTap: () {
                context.push(AppRoutes.company);
              }),
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
              }),

          MenuItem(
              icon: AppIcon.memberCode,
              label: "Kode Unik Langganan",
              onTap: () {
                context.push(AppRoutes.membershipsCodes);
              }),
          MenuItem(
              icon: AppIcon.qna,
              label: "Konfigurasi Tanya Jawab",
              onTap: () {
                context.push(AppRoutes.companyFaqConfig);
              }),
          MenuItem(
              icon: AppIcon.flowBusiness,
              label: "Integrasi Sistem",
              onTap: () {
                context.push(AppRoutes.systemIntegrationConfig);
              }),
          // MenuItem(
          //     icon: AppIcon.help,
          //     label: "Bantuan",
          //     onTap: () {
          //       showAppBottomSheet(context,
          //           content: SizedBox(
          //             height: 200,
          //             child: Center(
          //               child: Text("Fitur ini belum tersedia"),
          //             ),
          //           ));
          //     }),
        ],
      ),
      const SizedBox(height: 16),
    ];
  }

  List<Widget> _operationalMenu() {
    return [
      SectionTitle(
        "Menu Operasional",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      HorizontalButton(
        key: const Key("horizontal-button-dashboard"),
        margin: EdgeInsets.all(0),
        leadingIcon: LucideIcons.pieChart,
        title: "Dashboard",
        description: "Lihat statistik perusahaan",
        onTap: () {
          context.push(AppRoutes.dashboard);
        },
      ),
      const SizedBox(height: 12),
      MenuGrid(
        key: const Key("menu-grid-operational"),
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
          MenuItem(
              icon: AppIcon.history,
              label: "Riwayat Undangan Pegawai",
              onTap: () {
                context.push(AppRoutes.invitationsHistory);
              }),
          MenuItem(
              icon: AppIcon.membership,
              label: "Pelanggan",
              onTap: () {
                context.push(AppRoutes.memberships);
              }),
          // MenuItem(
          //     icon: AppIcon.qna,
          //     label: "Chat bantuan",
          //     onTap: () {
          //       context.push(AppRoutes.chatBot);
          //     }),
        ],
      ),
    ];
  }
}

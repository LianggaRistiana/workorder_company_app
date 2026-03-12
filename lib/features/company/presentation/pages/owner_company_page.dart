import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/company/presentation/widgets/internal_company_card.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/orientation_helper.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

// TODO : Change to CompanyMenuPage
class OwnerCompanyPage extends StatefulWidget {
  const OwnerCompanyPage({super.key});

  @override
  State<OwnerCompanyPage> createState() => _OwnerCompanyPageState();
}

class _OwnerCompanyPageState extends State<OwnerCompanyPage> {
  @override
  void initState() {
    super.initState();
    OrientationHelper.portraitOnly();
  }

  @override
  void dispose() {
    OrientationHelper.all();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    // Dummy data
    final companyName = "PT Maju Jaya";
    final companyAddress = "Jl. Contoh No.123, Bali";

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 72),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- Company Card ---

            InternalCompanyCard(
                companyName: companyName, companyAddress: companyAddress),
            const SizedBox(height: 12),
            // /// --- Section Title ---
            SectionTitle("Menu Konfigurasi Perusahaan"),
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
                    icon: Icons.info_outline_rounded,
                    label: "Informasi Perusahaan",
                    onTap: () {
                      context.push(AppRoutes.company);
                    }),
                MenuItem(
                    icon: Icons.card_membership_outlined,
                    label: "Kode Unik Pelanggan",
                    onTap: () {
                      showAppBottomSheet(context,
                          content: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text("Fitur ini belum tersedia"),
                            ),
                          ));
                    }),
                MenuItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: "Konfigurasi Tanya Jawab",
                    onTap: () {
                      context.push(AppRoutes.companyFaqConfig);
                    }),
                MenuItem(
                    icon: Icons.help_outline_outlined,
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
            const SectionTitle("Menu Operasional"),
            const SizedBox(height: 12),
            MenuGrid(
              items: [
                MenuItem(
                    icon: Icons.inbox_outlined,
                    label: "Pengajuan Layanan",
                    onTap: () {
                      context.push(AppRoutes.serviceRequest);
                    }),
                MenuItem(
                    icon: Icons.assignment_outlined,
                    label: "Tugas Kerja",
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
                    icon: Icons.person_add_alt_1_outlined,
                    label: "Riwayat Undangan Pegawai",
                    onTap: () {
                      context.push(AppRoutes.invitationsHistory);
                    }),
                MenuItem(
                    icon: Icons.wallet_membership_outlined,
                    label: "Pelanggan",
                    onTap: () {
                      showAppBottomSheet(context,
                          content: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text("Fitur ini belum tersedia"),
                            ),
                          ));
                    }),
                MenuItem(
                    icon: Icons.help_outline_outlined,
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
          ],
        ),
      ),
    );
  }
}

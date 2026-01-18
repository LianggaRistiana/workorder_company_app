import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/orientation_helper.dart';
import 'package:workorder_company_app/shared/widgets/active_status_chip.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

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
    final theme = Theme.of(context);

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
            CustomCard(
              child: Row(
                children: [
                  // Company Logo / Avatar
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.apartment_rounded,
                      size: 36,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Company Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          companyName,
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          companyAddress,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        ActiveStatusChip(
                          isActive: true,
                          label: "Perusahaan",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // /// --- Section Title ---
            SectionTitle("Menu Konfigurasi Perusahaan"),
            const SizedBox(height: 12),
            MenuGrid(
              items: [
                MenuItem(
                    icon: Icons.assignment_turned_in_outlined,
                    label: "Formulir",
                    onTap: () {
                      context.push(AppRoutes.ownerForms);
                    }),
                MenuItem(
                    icon: Icons.build_circle_outlined,
                    label: "Layanan",
                    onTap: () {
                      context.push(AppRoutes.ownerServices);
                    }),
                MenuItem(
                    icon: Icons.badge_outlined,
                    label: "Posisi Pegawai",
                    onTap: () {
                      context.push(AppRoutes.ownerPositions);
                    }),
                MenuItem(
                    icon: Icons.info_outline_rounded,
                    label: "Informasi Perusahaan",
                    onTap: () {
                      context.push(AppRoutes.ownerForms);
                    }),
                MenuItem(
                    icon: Icons.card_membership_outlined,
                    label: "Kode Unik Pelanggan",
                    onTap: () {}),
                MenuItem(
                    icon: Icons.check_circle_outline,
                    label: "Status aktif perusahaan",
                    onTap: () {}),
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
                    label: "Tugas Kerja",
                    onTap: () {}),
                MenuItem(
                    icon: Icons.people_outline,
                    label: "Pegawai",
                    onTap: () {
                      context.push(AppRoutes.ownerEmployee);
                    }),
                MenuItem(
                    icon: Icons.person_add_alt_1_outlined,
                    label: "Riwayat Undangan Pegawai",
                    onTap: () {
                      context.push(AppRoutes.ownerEmployee);
                    }),
                MenuItem(
                    icon: Icons.wallet_membership_outlined,
                    label: "Pelanggan",
                    onTap: () {
                      context.push(AppRoutes.ownerEmployee);
                    }),
                MenuItem(
                    icon: Icons.help_outline_outlined,
                    label: "Bantuan",
                    onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

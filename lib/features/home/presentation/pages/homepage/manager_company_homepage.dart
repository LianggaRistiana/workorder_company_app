import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/current_user_chip.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class ManagerCompanyHomepage extends StatelessWidget {
  const ManagerCompanyHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar bisa tetap
        appBar: AppBar(
          title: CurrentUserChip(
            onTap: () {
              context.push(AppRoutes.managerProfile);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.notifications_outlined))
          ],
        ),

        // ===== Menggunakan Stack untuk background + card =====
        body: SizedBox.expand(
          child: Stack(
            children: [
              // ==========================
              // BACKGROUND IMAGE
              // ==========================
              SizedBox(
                width: double.infinity,
                height: 220,
                child: Image.asset(
                  "assets/images/home-header-internal.png",
                  fit: BoxFit.cover,
                ),
              ),

              // ==========================
              // WHITE FLOATING CARD
              // ==========================
              Positioned(
                top: 140,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: double.infinity, // WAJIB untuk memenuhi area
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 12,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HorizontalButton(
                          leadingIcon: Icons.assignment_add,
                          title: "Buat Tugas Kerja Baru",
                          description:
                              "Buat tugas kerja baru khusus untuk internal perusahaan",
                          onTap: () {},
                        ),
                        const SizedBox(height: 8),
                        const SectionTitle("Menu Operasional"),
                        const SizedBox(height: 12),
                        MenuGrid(
                          items: [
                            MenuItem(
                                icon: Icons.inbox_outlined,
                                label: "Pengajuan Layanan",
                                onTap: () {
                                  context.go(AppRoutes.managerCsr);
                                }),
                            MenuItem(
                                icon: Icons.assignment_outlined,
                                label: "Tugas Kerja",
                                onTap: () {
                                  context.go(AppRoutes.managerWorkorder);
                                }),
                            MenuItem(
                                icon: Icons.people_outline,
                                label: "Pegawai",
                                onTap: () {
                                  // context.push(AppRoutes.manager);
                                }),
                            MenuItem(
                                icon: Icons.card_membership,
                                label: "Pelanggan Perusahaan",
                                onTap: () {}),
                            MenuItem(
                                icon: Icons.history_outlined,
                                label: "Riwayat Pengajuan",
                                onTap: () {}),
                            MenuItem(
                                icon: Icons.history_outlined,
                                label: "Riwayat Workorder",
                                onTap: () {}),
                            MenuItem(
                                icon: Icons.help_outline_outlined,
                                label: "Bantuan",
                                onTap: () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

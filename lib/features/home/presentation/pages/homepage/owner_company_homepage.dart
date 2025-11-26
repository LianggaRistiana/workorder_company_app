import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/home/presentation/widget/user_chip.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class OwnerCompanyHomepage extends StatelessWidget {
  const OwnerCompanyHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar bisa tetap
        appBar: AppBar(
          title: UserChip(
              user: const UserEntity(
                  name: "Guest",
                  email: "guest@example.com",
                  role: UserRole.ownerCompany),
              onTap: () {
                context.push(AppRoutes.ownerProfile);
              }),
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
                  "assets/images/header-internal-home.png",
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
                        const SectionTitle("Menu Konfigurasi Perusahaan"),
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
                                label: "Workorder",
                                onTap: () {}),
                            MenuItem(
                                icon: Icons.people_outline,
                                label: "Pegawai",
                                onTap: () {
                                  context.push(AppRoutes.ownerEmployee);
                                }),
                            MenuItem(
                                icon: Icons.help_outline_outlined,
                                label: "Bantuan",
                                onTap: () {}),
                          ],
                        ),
                        const SizedBox(height: 24),
                        HorizontalButton(
                          leadingIcon: Icons.build_rounded,
                          title: "Menu lainnya",
                          description:
                              "Pengaturan umum seperti nama, alamat perusahaan dan lain sebagainya",
                          onTap: () => context.go(AppRoutes.ownerCompany),
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

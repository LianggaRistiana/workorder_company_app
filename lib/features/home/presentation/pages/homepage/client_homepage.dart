import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/widgets/current_user_chip.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/orientation_helper.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/menu_grid.dart';
import 'package:workorder_company_app/shared/widgets/menu_item.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class ClientHomepage extends StatefulWidget {
  const ClientHomepage({super.key});

  @override
  State<ClientHomepage> createState() => _ClientHomepageState();
}

class _ClientHomepageState extends State<ClientHomepage> {
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
    return Scaffold(
        // appBar bisa tetap
        appBar: AppBar(
          title: CurrentUserChip(
            onTap: () {
              context.push(AppRoutes.clientProfile);
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
                  "assets/images/header-home.png",
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
                          leadingIcon: Icons.send_rounded,
                          title: "Ajukan Permintaan Layanan",
                          description:
                              "Pilih perusahaan kemudiaan ajukan permintaan layanan",
                          onTap: () {
                            context.go(AppRoutes.clientCompanyPortal);
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
                                onTap: () => context
                                    .push(AppRoutes.clientServiceRequest)),
                            MenuItem(
                                icon: Icons.home_work_outlined,
                                label: "Perusahaan langganan",
                                onTap: () {}),
                            MenuItem(
                                icon: Icons.card_membership_outlined,
                                label: "Aktifkan Keanggotaan",
                                onTap: () {}),
                            MenuItem(
                                icon: Icons.history,
                                label: "Riwayat Pengajuan",
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

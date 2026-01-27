import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar dan Info Pengguna
                  CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // ----------------------
                        // Avatar with shadow
                        // ----------------------
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(8),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Text(
                              user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : "?",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // ----------------------
                        // Info (Name, email, role)
                        // ----------------------
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.onSurface,
                                    ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                user.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),

                              const SizedBox(height: 8),

                              // Custom Chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withAlpha(15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  user.position != null
                                      ? '${user.role.displayName} | ${user.position!.name}'
                                      : user.role.displayName,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TODO : add company info card later
                  // PermissionGate(
                  //     permission: CompanyPermission.view,
                  //     child: InternalCompanyCard(
                  //         companyName: "Company Name",
                  //         companyAddress: "Company Address")),

                  Divider(),
                  HorizontalButton(
                    title: "Notifikasi",
                    leadingIcon: Icons.notifications_none_outlined,
                    description:
                        "Dapatkan informasi terbaru melalui notifikasi",
                    onTap: () {
                      showAppBottomSheet(context,
                          content: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text("Fitur ini belum tersedia"),
                            ),
                          ));
                    },
                  ),
                  HorizontalButton(
                    title: "Petunjuk",
                    leadingIcon: Icons.info_outline,
                    description: "Tampilkan petunjuk penggunaan aplikasi Anda",
                    onTap: () {
                      showAppBottomSheet(context,
                          content: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text("Fitur ini belum tersedia"),
                            ),
                          ));
                    },
                  ),
                  HorizontalButton(
                    title: "Coba versi website",
                    leadingIcon: Icons.public,
                    description:
                        "Versi website disarankan untuk penggunaan desktop",
                    onTap: () {
                      showAppBottomSheet(context,
                          content: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text("Fitur ini belum tersedia"),
                            ),
                          ));
                    },
                  ),
                  HorizontalButton(
                    title: "Bantuan",
                    leadingIcon: Icons.help_outline,
                    description:
                        "Cari bantuan Anda di sini mengenai cara menggunakan aplikasi",
                    onTap: () {
                      showAppBottomSheet(context,
                          content: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text("Fitur ini belum tersedia"),
                            ),
                          ));
                    },
                  ),
                  HorizontalButton(
                    margin: const EdgeInsets.all(0),
                    title: "Keluar",
                    description: "Anda dapat masuk kembali kapan saja",
                    leadingIcon: Icons.logout,
                    isDanger: true,
                    onTap: () async {
                      final confirm = await showConfirmDialog(
                        context: context,
                        title: "Keluar",
                        message: "Anda yakin ingin keluar?",
                        icon: Icons.logout,
                        confirmText: "Logout",
                      );

                      if (confirm == false) return;
                      if (!context.mounted) return;
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                  ),
                ],
              ),
            );
          } else if (state is Unauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/login');
            });
            return const SizedBox.shrink();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

extension on Object {
  String toReadableString() {
    if (toString().contains('.')) {
      return toString().split('.').last.replaceAllMapped(
            RegExp(r'([a-z])([A-Z])'),
            (m) => '${m[1]} ${m[2]}',
          );
    }
    return toString();
  }
}

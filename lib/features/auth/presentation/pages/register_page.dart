import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                context.go(AppRoutes.login);
              },
              child: const Text("Saya sudah punya akun"),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Pilih Jenis Akun",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                HorizontalButton(
                  title: "Kustomer",
                  description:
                      "Ajukan dan pantau permintaan layanan kepada perusahaan.",
                  leadingIcon: Icons.account_circle_outlined,
                  onTap: () {
                    context.push(AppRoutes.registerAccount,
                        extra: UserRole.client);
                  },
                ),
                HorizontalButton(
                  title: "Pegawai Perusahaan",
                  description:
                      "Kelola dan kerjakan tugas operasional dalam perusahaan.",
                  leadingIcon: Icons.work_outline,
                  onTap: () {
                    context.push(AppRoutes.registerAccount,
                        extra: UserRole.staffUnassigned);
                  },
                ),
                HorizontalButton(
                  title: "Perusahaan",
                  description:
                      "Daftarkan perusahaan dan atur sistem manajemen Work Order.",
                  leadingIcon: Icons.home_work_outlined,
                  onTap: () {
                    context.push(AppRoutes.registerCompany);
                  },
                ),
                const SizedBox(height: 16),
              ]),
        ),
      ),
    );
  }
}

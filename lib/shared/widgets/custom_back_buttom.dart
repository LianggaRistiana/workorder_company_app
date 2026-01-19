import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';

class CustomBackButton extends StatelessWidget {
  final String fallbackRoute;
  final bool showConfirm;
  final String? confirmTitle;
  final String? confirmMessage;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final IconData? icon;

  const CustomBackButton({
    super.key,
    this.fallbackRoute = AppRoutes.home,
    this.showConfirm = false,
    this.confirmTitle,
    this.confirmMessage,
    this.confirmText = "Ya",
    this.cancelText = "Batal",
    this.confirmColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () async {
        // simpan navigator/router sebelum async gap
        final router = GoRouter.of(context);

        bool shouldPop = true;

        if (showConfirm) {
          shouldPop = await showConfirmDialog(
                context: context,
                title: confirmTitle ?? "Konfirmasi",
                message: confirmMessage ?? "Apakah Anda yakin ingin keluar?",
                confirmText: confirmText,
                cancelText: cancelText,
                confirmColor: confirmColor,
                icon: icon,
              ) ??
              false;
        }

        // setelah async selesai, gunakan navigator/router yang sudah disimpan
        if (shouldPop) {
          if (router.canPop()) {
            router.pop();
          } else {
            router.go(fallbackRoute);
          }
        }
      },
    );
  }
}

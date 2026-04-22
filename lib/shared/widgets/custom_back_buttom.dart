import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';

// HACK : pop up will not appear when user press back button on android (by pass flutter pop).the reason why i made this is nested shell route in route system. currently there is no longer use that mechanisms
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
    this.icon = Icons.warning_rounded,
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
                message:
                    confirmMessage ?? "Apakah anda yakin tidak melanjutkan?",
                confirmText: confirmText,
                cancelText: cancelText,
                confirmColor: confirmColor,
                icon: icon,
                type: ConfirmDialogType.warning,
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

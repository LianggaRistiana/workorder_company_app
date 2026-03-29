import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return HorizontalButton(
      margin: const EdgeInsets.all(0),
      title: "Keluar",
      description: "Anda dapat masuk kembali kapan saja",
      leadingIcon: AppIcon.logout,
      isDanger: true,
      onTap: () async {
        final confirm = await showConfirmDialog(
          context: context,
          title: "Keluar",
          message: "Anda yakin ingin keluar?",
          icon: AppIcon.logout,
          confirmText: "Ya, keluar",
          type: ConfirmDialogType.danger,
        );

        if (confirm != true) return;
        if (!context.mounted) return;

        context.read<AuthBloc>().add(LogoutRequested());
      },
    );
  }
}

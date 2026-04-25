import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_state.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({super.key});

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  @override
  Widget build(BuildContext context) {
    // return SizedBox.shrink();
    return BlocConsumer<NotificationActiveCubit, NotificationActiveState>(
      listenWhen: (previous, current) =>
          previous.actionResult != current.actionResult,
      listener: (context, state) async {
        if (state.actionResult != null &&
            state.actionResult != NotificationActionResult.success) {
          Logger().d(state.actionResult);
          final isConfirm = await showConfirmDialog(
            context: context,
            icon: AppIcon.notification,
            title: "Perizinan Diperlukan",
            message:
                "Perizinan Notifikasi diperlukan untuk melakukan fitur ini",
          );

          if (isConfirm == true) {
            await openAppSettings();
          }
        }
      },
      builder: (context, state) {
        final isEnabled = state.isEnabled;

        return HorizontalSwitch(
          margin: EdgeInsets.only(bottom: AppSpacing.xs),
          title: "Notifikasi",
          description: "Dapatkan informasi terbaru melalui notifikasi",
          leadingIcon: Icons.notifications_none_outlined,
          value: isEnabled,
          onChanged: (value) {
            context.read<NotificationActiveCubit>().toggleActive();
            // if (!context.mounted) return;
            // final newState = context.read<NotificationActiveCubit>().state;
            // if (newState.osStatus.permission ==
            //     NotificationPermissionStatus.permanentlyDenied) {
            //   showConfirmDialog(
            //       context: context,
            //       title: "Perizinan Diperlukan",
            //       message:
            //           "Perizinan Notifikasi diperlukan untuk melakukan fitur ini");
            // }
          },
        );
      },
    );
  }
}

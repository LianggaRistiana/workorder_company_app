import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/notification/domain/entitties/notification_os_status.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_state.dart';
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
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final isEnabled = state.osStatus.isEnabled;

        return HorizontalSwitch(
          title: "Notifikasi",
          description: "Dapatkan informasi terbaru melalui notifikasi",
          leadingIcon: Icons.notifications_none_outlined,
          value: isEnabled,
          onChanged: (value) async {
            await context.read<NotificationCubit>().toggleNotification(value);

            // ❌ check mounted sebelum pakai context
            if (!mounted) return;

            final newState = context.read<NotificationCubit>().state;
            if (newState.osStatus.permission ==
                NotificationPermissionStatus.permanentlyDenied) {
              showConfirmDialog(
                  context: context,
                  title: "Perizinan Diperlukan",
                  message:
                      "Perizinan Notifikasi diperlukan untuk melakukan fitur ini");
            }
          },
        );
      },
    );
  }
}

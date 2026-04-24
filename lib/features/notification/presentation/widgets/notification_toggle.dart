import 'package:flutter/material.dart';

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({super.key});

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
    // return BlocBuilder<NotificationCubit, NotificationState>(
    //   builder: (context, state) {
    //     final isEnabled = state.osStatus.isEnabled;

    //     return HorizontalSwitch(
    //       margin: EdgeInsets.only(bottom: AppSpacing.xs),
    //       title: "Notifikasi",
    //       description: "Dapatkan informasi terbaru melalui notifikasi",
    //       leadingIcon: Icons.notifications_none_outlined,
    //       value: isEnabled,
    //       onChanged: (value) async {
    //         await context.read<NotificationCubit>().toggleNotification(value);
    //         if (!context.mounted) return;
    //         final newState = context.read<NotificationCubit>().state;
    //         if (newState.osStatus.permission ==
    //             NotificationPermissionStatus.permanentlyDenied) {
    //           showConfirmDialog(
    //               context: context,
    //               title: "Perizinan Diperlukan",
    //               message:
    //                   "Perizinan Notifikasi diperlukan untuk melakukan fitur ini");
    //         }
    //       },
    //     );
    //   },
  }
}

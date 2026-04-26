import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationLogCubit, NotificationLogState>(
        listener: (context, state) {
      if (state.status == NotificationLogStatus.error) {
        context.showError(state.errorMessage ??
            "Terjadi kesalahan saat mengambil data notifikasi"); // OPTIMIZE : Move listener to app layout to avoid duplication
      }
    }, builder: (context, state) {
      return IconButton(
        onPressed: () {
          context.push(AppRoutes.notifications);
        },
        icon: Badge(
            backgroundColor: Theme.of(context).colorScheme.primary,
            isLabelVisible: state.unReadCount > 0,
            label: Text(state.unReadCount.toString()),
            child: Icon(AppIcon.notification)),
      );
    });
  }
}

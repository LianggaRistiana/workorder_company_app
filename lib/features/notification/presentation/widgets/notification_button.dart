import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationLogCubit, NotificationLogState>(
        builder: (context, state) {
      return IconButton(
        onPressed: () {
          context.push(AppRoutes.notifications);
        },
        icon: Badge(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            isLabelVisible: state.unReadCount > 0,
            label: Text(state.unReadCount.toString()),
            child: Icon(AppIcon.notification)),
      );
    });
  }
}

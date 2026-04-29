import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_state.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';

class NotificationButtonTile extends StatelessWidget {
  const NotificationButtonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationLogCubit, NotificationLogState>(
        builder: (context, state) {
      return ClickableCustomCard(
          margin: EdgeInsets.only(
              bottom: AppSpacing.sm, left: AppSpacing.sm, right: AppSpacing.sm),
          child: Row(
            children: [
              Badge(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  isLabelVisible: state.unReadCount > 0,
                  label: Text(state.unReadCount.toString()),
                  child: Icon(AppIcon.notification)),
              SizedBox(width: 8),
              Text("Notifikasi")
            ],
          ),
          onTap: () {
            context.push(AppRoutes.notifications);
          });
    });
  }
}

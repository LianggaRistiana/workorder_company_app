import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_log_entity.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_active_state.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_state.dart';
import 'package:workorder_company_app/features/notification/presentation/navigation/notification_navigator.dart';
import 'package:workorder_company_app/features/notification/presentation/ui_mapper.dart/resource_type_icon_mapper.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/list_page_scafold.dart';

class NotificationLogsPage extends StatelessWidget {
  const NotificationLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationLogCubit, NotificationLogState>(
        builder: (context, state) {
      return ListPageScaffold(
          title: "Notifikasi",
          header: _NotificationStatusWidget(),
          isLoading: state.status == NotificationLogStatus.loading,
          items: state.logs,
          emptyWidget: EmptyStateWidget(text: "Tidak ada notifikasi Terbaru"),
          onRefresh: () async =>
              unawaited(context.read<NotificationLogCubit>().fetchLogs(
                    forceRefresh: true,
                  )),
          itemBuilder: (item) => _NotificationLogItem(item: item));
    });
  }
}

class _NotificationStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationActiveCubit, NotificationActiveState>(
        builder: (context, state) {
      final showNotificationEnabledStatus = state.isEnabled;
      return showNotificationEnabledStatus
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
              ),
              child: InformationBlock.info(
                  "Aktifkan notifikasi untuk menerima pop up notifikasi dari aplikasi ini."),
            );
    });
  }
}

class _NotificationLogItem extends StatelessWidget {
  final NotificationLogEntity item;

  const _NotificationLogItem({
    required this.item,
  });

  void _goToPage(BuildContext context) {
    final navigator = sl<NotificationNavigator>();

    switch (item.resource) {
      case ResourceType.invitation:
        navigator.openInvitationsPage();
        break;

      case ResourceType.serviceRequest:
        navigator.openServiceRequestPage(item.resourceId);
        break;

      case ResourceType.workOrder:
        navigator.openWorkOrderDetailPage(item.resourceId);
        break;

      default:
        navigator.openNotificationList();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClickableCustomCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      onTap: () => _goToPage(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox.small(
            icon: item.resource.icon,
            isDisabled: item.isRead,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  item.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  DateFormat('HH:mm, d MMM yyyy')
                      .format(item.createdAt.toLocal()),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

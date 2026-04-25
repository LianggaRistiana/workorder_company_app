import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/notification/domain/entities/notification_payload_entity.dart';
import 'package:workorder_company_app/features/notification/presentation/ui_mapper.dart/resource_type_icon_mapper.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class AppMessenger {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar(
      NotificationPayloadEntity payload, VoidCallback onAction) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: SnackBarContent(
            payload: payload,
            onAction: () {
              messenger.hideCurrentSnackBar();
              onAction();
            },
          )),
    );
  }
}

class SnackBarContent extends StatelessWidget {
  final NotificationPayloadEntity payload;
  final VoidCallback? onAction;

  const SnackBarContent({super.key, required this.payload, this.onAction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClickableCustomCard(
      onTap: onAction,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox.small(icon: payload.resource.icon),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payload.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium),
                Text(payload.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

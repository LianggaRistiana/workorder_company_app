import 'package:workorder_company_app/features/notification/domain/entities/notification_payload_entity.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/features/notification/presentation/navigation/notification_navigator.dart';

class NotificationDispatcher {
  final NotificationNavigator _navigator;

  NotificationDispatcher(this._navigator);

  void dispatch(NotificationPayloadEntity payload) {
    switch (payload.resource) {
      case ResourceType.workOrder:
        _navigator.openWorkOrderDetailPage(payload.resourceId);
        break;
      case ResourceType.serviceRequest:
        _navigator.openServiceRequestPage(payload.resourceId);
        break;
      case ResourceType.invitation:
        _navigator.openInvitationsPage();
        break;
      case ResourceType.workReport:
        _handleUnknown(payload);
        break;
    }
  }

  void _handleUnknown(NotificationPayloadEntity payload) {
    _navigator.openNotificationList();
  }
}

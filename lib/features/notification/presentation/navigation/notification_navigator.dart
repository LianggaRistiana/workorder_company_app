import 'package:flutter/material.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

abstract class NotificationNavigator {
  void openWorkOrderDetailPage(String woId);
  void openServiceRequestPage(String srId);
  void openInvitationsPage();
  void openNotificationList();
}

class NotificationNavigatorImpl implements NotificationNavigator {
  final GlobalKey<NavigatorState>
      navigatorKey; // OPTIMIZE can inject app route here

  NotificationNavigatorImpl(this.navigatorKey);

  @override
  void openNotificationList() {
    navigatorKey.currentState?.pushNamed('/notification');
  }

  @override
  void openInvitationsPage() {
    navigatorKey.currentState?.pushNamed(
      AppRoutes.invitationsPending,
    );
  }

  @override
  void openServiceRequestPage(String srId) {
    navigatorKey.currentState?.pushNamed(
      AppRoutes.serviceRequestDetail,
      arguments: srId,
    );
  }

  @override
  void openWorkOrderDetailPage(String woId) {
    navigatorKey.currentState?.pushNamed(
      AppRoutes.workOrdersDetail,
      arguments: woId,
    );
  }
}

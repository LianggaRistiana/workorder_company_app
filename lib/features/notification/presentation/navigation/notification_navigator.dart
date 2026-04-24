import 'package:flutter/material.dart';

abstract class NotificationNavigator {
  void openWoUpdate(String woId);
  void openNotificationList();
}

class NotificationNavigatorImpl implements NotificationNavigator {
  final GlobalKey<NavigatorState>
      navigatorKey; // OPTIMIZE can inject app route here

  NotificationNavigatorImpl(this.navigatorKey);

  @override
  void openWoUpdate(String woId) {
    navigatorKey.currentState?.pushNamed(
      '/work-order/detail',
      arguments: woId,
    ); // FIXME : it will dont work
  }

  @override
  void openNotificationList() {
    navigatorKey.currentState?.pushNamed('/notification');
  }
}

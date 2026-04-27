import 'package:flutter/foundation.dart';
import 'package:workorder_company_app/core/services/cache/cacheable.dart';
import 'package:workorder_company_app/core/services/fcm/notification_event_bus.dart';

class NotificationCacheInvalidator {
  final NotificationEventBus bus;
  final Cacheable repo;

  NotificationCacheInvalidator(this.bus, this.repo) {
    bus.stream.listen((event) {
      debugPrint("clear cache act by Notification Cahce Invalidator");
      repo.clearCache();
    });
  }
}

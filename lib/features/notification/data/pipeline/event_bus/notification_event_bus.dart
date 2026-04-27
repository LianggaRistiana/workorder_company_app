import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';

class NotificationEventBus {
  final _controller = StreamController<ResourceType>.broadcast();

  Stream<ResourceType> get stream => _controller.stream;

  Timer? _debounce;

  void emit(ResourceType event) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      debugPrint("emit notification by event bus");
      _controller.add(event);
    });
  }
}

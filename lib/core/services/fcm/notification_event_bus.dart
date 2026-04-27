import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationEventBus {
  final _controller = StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get stream => _controller.stream;

  Timer? _debounce;

  void emit(RemoteMessage event) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      debugPrint("emit notification by event bus");
      _controller.add(event);
    });
  }
}

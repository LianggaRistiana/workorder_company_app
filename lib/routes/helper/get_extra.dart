import 'package:go_router/go_router.dart';

extension GoRouterStateX on GoRouterState {
  T? getExtra<T>() {
    final value = extra;
    if (value is T) return value;
    return null;
  }
}

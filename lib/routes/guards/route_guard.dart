import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

typedef RouteGuard = String? Function(
    BuildContext context, GoRouterState state);

RouteGuard requireParam(String key) {
  return (_, state) {
    final value = state.pathParameters[key];
    if (value == null || value.isEmpty) {
      return AppRoutes.notFound;
    }
    return null;
  };
}

RouteGuard requireExtra<T>() {
  return (_, state) {
    final extra = state.extra;
    debugPrint(extra.runtimeType.toString());
    if (extra is! T) {
      return AppRoutes.notFound;
    }
    return null;
  };
}

RouteGuard combineGuards(List<RouteGuard> guards) {
  return (context, state) {
    for (final guard in guards) {
      final result = guard(context, state);
      if (result != null) return result;
    }
    return null;
  };
}

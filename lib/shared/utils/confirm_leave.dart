import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef ConfirmLeaveCallback = Future<bool?> Function();

class BackNavigationHandler {
  static void handle({
    required BuildContext context,
    required bool isDirty,
    required ConfirmLeaveCallback onConfirmLeave,
  }) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future.delayed(const Duration(milliseconds: 50));

    if (!isDirty) {
      if (context.mounted && GoRouter.of(context).canPop()) {
        context.pop();
      }
      return;
    }

    if (!context.mounted) return;

    _confirmAndPop(
      context: context,
      onConfirmLeave: onConfirmLeave,
    );
  }

  static Future<void> _confirmAndPop({
    required BuildContext context,
    required ConfirmLeaveCallback onConfirmLeave,
  }) async {
    final shouldLeave = await onConfirmLeave();

    if (shouldLeave == true && context.mounted) {
      if (GoRouter.of(context).canPop()) {
        context.pop();
      }
    }
  }
}

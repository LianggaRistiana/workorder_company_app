import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef ConfirmLeaveCallback = Future<bool?> Function();

class BackNavigationHandler {
  static void handle({
    required BuildContext context,
    required bool isDirty,
    required ConfirmLeaveCallback onConfirmLeave,
  }) async {
    // Tutup keyboard dulu kalau ada
    // final focus = FocusManager.instance.primaryFocus;
    // if (focus != null && focus.hasFocus) {
    //   focus.unfocus();
    //   return;
    // }

    if (!isDirty) {
      if (context.mounted && GoRouter.of(context).canPop()) {
        context.pop();
      }
      return;
    }

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
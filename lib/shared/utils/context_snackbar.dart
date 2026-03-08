import 'package:flutter/material.dart';

extension ContextSnackbar on BuildContext {
  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(this).colorScheme.surface,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Theme.of(this).dividerColor.withAlpha(50))),
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Theme.of(this).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
                child: Text(message,
                    style:
                        TextStyle(color: Theme.of(this).colorScheme.primary))),
          ],
        ),
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: Theme.of(this).colorScheme.errorContainer,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            Icon(Icons.error, color: Theme.of(this).colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
                child: Text(message,
                    style: TextStyle(color: Theme.of(this).colorScheme.error))),
          ],
        ),
      ),
    );
  }
}

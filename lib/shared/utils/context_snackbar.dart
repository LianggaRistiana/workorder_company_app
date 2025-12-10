import 'package:flutter/material.dart';

extension ContextSnackbar on BuildContext {
  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(this).colorScheme.surface,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.green)),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
                child:
                    Text(message, style: const TextStyle(color: Colors.green))),
          ],
        ),
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(this).colorScheme.errorContainer,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
             Icon(Icons.error, color: Theme.of(this).colorScheme.onErrorContainer),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: TextStyle(color: Theme.of(this).colorScheme.onErrorContainer))),
          ],
        ),
      ),
    );
  }
}

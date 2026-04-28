import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

extension ContextSnackbar on BuildContext {
  void showSuccess(String message) {
    _showSnackBar(
      message: message,
      icon: Icons.check_circle,
      background: Theme.of(this).colorScheme.surface,
      textColor: Theme.of(this).colorScheme.primary,
      iconColor: Theme.of(this).colorScheme.primary,
    );
  }

  void showWarning(String message) {
    _showSnackBar(
      message: message,
      icon: AppIcon.warrning,
      background: Colors.orange.shade50,
      textColor: Colors.orange,
      iconColor: Colors.orange,
    );
  }

  void showError(String message) {
    _showSnackBar(
      message: message,
      icon: Icons.error,
      background: Theme.of(this).colorScheme.errorContainer,
      textColor: Theme.of(this).colorScheme.error,
      iconColor: Theme.of(this).colorScheme.error,
    );
  }

  void _showSnackBar({
    required String message,
    required IconData icon,
    required Color background,
    required Color textColor,
    required Color iconColor,
  }) {
    // Check the context
    if (!mounted) return;

    // Check the messanger
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;

    // delay to next frame (race condition guard)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(this).dividerColor.withAlpha(50),
            ),
          ),
          content: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: textColor),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// HACK : bring back this if something shit happen
// extension ContextSnackbar on BuildContext {
//   void showSuccess(String message) {
//     ScaffoldMessenger.of(this).showSnackBar(
//       SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Theme.of(this).colorScheme.surface,
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: BorderSide(color: Theme.of(this).dividerColor.withAlpha(50))),
//         content: Row(
//           children: [
//             Icon(Icons.check_circle, color: Theme.of(this).colorScheme.primary),
//             const SizedBox(width: 8),
//             Expanded(
//                 child: Text(message,
//                     style:
//                         TextStyle(color: Theme.of(this).colorScheme.primary))),
//           ],
//         ),
//       ),
//     );
//   }

//   void showWarning(String message) {
//     ScaffoldMessenger.of(this).showSnackBar(
//       SnackBar(
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.orange[50],
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: BorderSide(color: Theme.of(this).dividerColor.withAlpha(50))),
//         content: Row(
//           children: [
//             Icon(AppIcon.warrning, color: Colors.orange),
//             const SizedBox(width: 8),
//             Expanded(
//                 child: Text(message, style: TextStyle(color: Colors.orange))),
//           ],
//         ),
//       ),
//     );
//   }

//   void showError(String message) {
//     ScaffoldMessenger.of(this).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         elevation: 0,
//         backgroundColor: Theme.of(this).colorScheme.errorContainer,
//         margin: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         content: Row(
//           children: [
//             Icon(Icons.error, color: Theme.of(this).colorScheme.error),
//             const SizedBox(width: 8),
//             Expanded(
//                 child: Text(message,
//                     style: TextStyle(color: Theme.of(this).colorScheme.error))),
//           ],
//         ),
//       ),
//     );
//   }
// }

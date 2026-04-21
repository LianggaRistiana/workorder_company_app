import 'package:flutter/material.dart';

enum ConfirmDialogType {
  normal,
  warning,
  danger,
}

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = "Ya",
  String cancelText = "Batal",
  Color? confirmColor,
  IconData? icon,
  ConfirmDialogType type = ConfirmDialogType.normal,
}) {
  final theme = Theme.of(context);

  // default style based on type
  Color containerColor;
  Color iconColor;
  IconData defaultIcon;

  switch (type) {
    case ConfirmDialogType.warning:
      containerColor = Colors.orange.withAlpha(20);
      iconColor = Colors.orange;
      defaultIcon = Icons.warning_rounded;
      break;

    case ConfirmDialogType.danger:
      containerColor = theme.colorScheme.errorContainer;
      iconColor = theme.colorScheme.error;
      defaultIcon = Icons.delete_outline_rounded;
      break;

    case ConfirmDialogType.normal:
      containerColor = theme.colorScheme.primaryContainer;
      iconColor = theme.colorScheme.primary;
      defaultIcon = Icons.help_outline_rounded;
      break;
  }

  final finalIcon = icon ?? defaultIcon;
  final finalColor = confirmColor ?? iconColor;

  return showDialog<bool>(
    useRootNavigator: false, // THIS MF
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: containerColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    finalIcon,
                    size: 24,
                    color: finalColor,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                // Message
                Text(
                  message,
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 48),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(cancelText),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: containerColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        confirmText,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: finalColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

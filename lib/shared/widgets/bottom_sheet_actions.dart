import 'package:flutter/material.dart';

// TODO : Consider to remove this code if not used.
class BottomSheetAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDanger;

  const BottomSheetAction({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDanger = false,
  });
}

class ActionBottomSheetContent extends StatelessWidget {
  final List<BottomSheetAction> actions;

  const ActionBottomSheetContent({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: actions.map((action) {
        final isDanger = action.isDanger;

        final backgroundColor =
            isDanger ? colorScheme.errorContainer : colorScheme.surface;

        final foregroundColor = isDanger
            ? colorScheme.onErrorContainer
            : colorScheme.onSurfaceVariant;

        final iconColor = isDanger ? colorScheme.error : colorScheme.onSurface;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                action.onTap();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      action.title,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Icon(
                    action.icon,
                    color: iconColor,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

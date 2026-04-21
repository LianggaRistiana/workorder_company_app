import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final Widget? header;
  final Widget content;
  final Widget? footer;

  const AppDialog({
    super.key,
    this.header,
    required this.content,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                if (header != null) ...[
                  DefaultTextStyle(
                    style: theme.textTheme.titleMedium!,
                    child: header!,
                  ),
                  const SizedBox(height: 12),
                ],

                // CONTENT
                Flexible(
                  child: SingleChildScrollView(
                    child: content,
                  ),
                ),

                // FOOTER
                if (footer != null) ...[
                  const SizedBox(height: 16),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showAppDialog<T>(
  BuildContext context, {
  Widget? header,
  required Widget content,
  Widget? footer,
}) {
  return showDialog<T>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: true,
    builder: (context) {
      return AppDialog(
        header: header,
        content: content,
        footer: footer,
      );
    },
  );
}

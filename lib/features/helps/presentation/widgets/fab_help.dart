import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';

class FabHelp extends StatelessWidget {
  final String heroTag;
  final Widget child;
  final String title;
  const FabHelp(
      {super.key,
      required this.child,
      required this.title,
      required this.heroTag});

  void _openBottomSheet(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    showAppBottomSheet(
      context,
      header: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: darkMode
                    ? Colors.yellow.withAlpha(50)
                    : Colors.yellow.withAlpha(75),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.tips_and_updates,
                    color: darkMode ? Colors.amber : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: darkMode ? Colors.amber : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => context.pop(),
            tooltip: "Tutup",
            icon: const Icon(Icons.close),
          )
        ],
      ),
      content: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    return FloatingActionButton.small(
      heroTag: heroTag,
      tooltip: title,
      elevation: 0,
      backgroundColor:
          darkMode ? Colors.yellow.withAlpha(50) : Colors.yellow.withAlpha(75),
      foregroundColor: darkMode ? Colors.amber : Colors.black,
      onPressed: () => _openBottomSheet(context),
      child: Icon(AppIcon.tips),
    );
  }
}

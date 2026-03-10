import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/shared/widgets/info_bottom_sheet.dart';

class HelpButton extends StatelessWidget {
  final Widget child;
  // final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderWidth;
  final String title;

  // 🔥 GANTI INI
  final BorderRadius borderRadius;

  // 🔥 GANTI IN
  const HelpButton({
    super.key,
    required this.child,
    this.title = "Tips dan petunjuk",
    // required this.onTap,
    this.padding,
    this.margin,
    this.borderWidth = 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
        darkMode ? Colors.yellow.withAlpha(50) : Colors.yellow.withAlpha(75);
    final Color textColor = darkMode ? Colors.amber : Colors.black;

    return Card(
      elevation: 0,
      shadowColor: Colors.black.withAlpha(60),
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          showAppBottomSheet(context,
              header: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: borderRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tips_and_updates, color: textColor),
                    const SizedBox(width: 8),
                    Text(title,
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text("Tutup"))
                ],
              ),
              content: child);
        },
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tips_and_updates, color: textColor),
              const SizedBox(width: 8),
              Text(title,
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

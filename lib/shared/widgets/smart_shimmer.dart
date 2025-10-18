import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SmartShimmer extends StatelessWidget {
  final List<Widget>? placeholders;
  final bool? forceSingle; // Force single shimmer over all placeholders
  final bool? forceMultiple; // Force shimmer per element
  final EdgeInsetsGeometry? padding;
  

  const SmartShimmer({
    super.key,
    this.placeholders,
    this.forceSingle,
    this.forceMultiple,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // if (!isLoading) return child;

    // --- If no placeholders provided, fallback shimmer over full child layout
    if (placeholders == null || placeholders!.isEmpty) {
      return _wrapSingleShimmer(Container(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        height: 80,
      ), isDark
      );
    }

    // --- Use "smart" detection
    final bool useSingle = forceSingle == true ||
        (forceMultiple != true && placeholders!.length <= 2);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: useSingle
          ? _wrapSingleShimmer(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: placeholders!,
              ),
              isDark
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  placeholders!.map((w) => _wrapSingleShimmer(w, isDark)).toList(),
            ),
    );
  }

Widget _wrapSingleShimmer(Widget child, bool isDark) {
  return Shimmer.fromColors(
    baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
    highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
    child: child,
  );
}

}

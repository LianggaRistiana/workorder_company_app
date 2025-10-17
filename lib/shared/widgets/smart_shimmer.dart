import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A smart shimmer wrapper that can automatically choose between
/// wrapping the entire layout or using multiple shimmer placeholders.
///
/// Example:
/// ```dart
/// SmartShimmer(
///   isLoading: true,
///   child: MyContentWidget(),
///   placeholders: [
///     ShimmerPlaceholder(height: 16, width: 100),
///     SizedBox(height: 8),
///     ShimmerPlaceholder(height: 80, width: double.infinity),
///   ],
/// )
/// ```
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
    // if (!isLoading) return child;

    // --- If no placeholders provided, fallback shimmer over full child layout
    if (placeholders == null || placeholders!.isEmpty) {
      return _wrapSingleShimmer(Container(
        color: Colors.grey.shade300,
        height: 80,
      ));
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
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: placeholders!
                  .map((w) => _wrapSingleShimmer(w))
                  .toList(),
            ),
    );
  }

  Widget _wrapSingleShimmer(Widget child) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }
}

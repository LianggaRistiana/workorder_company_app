import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class AdaptiveSplitColumn extends StatelessWidget {
  final List<Widget> leftChildren;
  final List<Widget> rightChildren;

  final double breakpoint;
  final double heightSpacing;
  final double widthSpacing;
  final EdgeInsetsGeometry padding;

  const AdaptiveSplitColumn({
    super.key,
    required this.leftChildren,
    required this.rightChildren,
    this.breakpoint = 768,
    this.heightSpacing = 0,
    this.widthSpacing = AppSpacing.md,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMediumUp = constraints.maxWidth >= breakpoint;

        if (!isMediumUp) {
          return SingleChildScrollView(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _withSpacing([
                ...leftChildren,
                ...rightChildren,
              ]),
            ),
          );
        }

        return Padding(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _withSpacing(leftChildren),
                  ),
                ),
              ),
              SizedBox(width: widthSpacing),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _withSpacing(rightChildren),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _withSpacing(List<Widget> widgets) {
    if (widgets.isEmpty) return [];
    return widgets.expand((w) => [w, SizedBox(height: heightSpacing)]).toList()
      ..removeLast();
  }
}

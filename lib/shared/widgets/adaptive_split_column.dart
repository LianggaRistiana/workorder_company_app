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
    this.padding = const EdgeInsets.only(
      left: AppSpacing.md,
      right: AppSpacing.md,
      top: AppSpacing.xs,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMediumUp = constraints.maxWidth >= breakpoint;

        if (!isMediumUp) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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

enum AdaptiveVisibilityMode {
  hideBelow,
  hideAbove,
}

class AdaptiveVisibility extends StatelessWidget {
  final Widget child;
  final double breakpoint;
  final AdaptiveVisibilityMode mode;

  const AdaptiveVisibility({
    super.key,
    required this.child,
    this.breakpoint = 768,
    this.mode = AdaptiveVisibilityMode.hideAbove,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final shouldHide = switch (mode) {
      AdaptiveVisibilityMode.hideAbove => width >= breakpoint,
      AdaptiveVisibilityMode.hideBelow => width < breakpoint,
    };

    return shouldHide ? const SizedBox.shrink() : child;
  }
}

extension AdaptiveVisibilityX on Widget {
  Widget visibleOnSmallScreen({
    double breakpoint = 768,
  }) {
    return AdaptiveVisibility(
      breakpoint: breakpoint,
      mode: AdaptiveVisibilityMode.hideAbove,
      child: this,
    );
  }

  Widget visibleOnLargeScreen({
    double breakpoint = 768,
  }) {
    return AdaptiveVisibility(
      breakpoint: breakpoint,
      mode: AdaptiveVisibilityMode.hideBelow,
      child: this,
    );
  }

  Widget hideOnSmallScreen({
    double breakpoint = 768,
  }) {
    return AdaptiveVisibility(
      breakpoint: breakpoint,
      mode: AdaptiveVisibilityMode.hideBelow,
      child: this,
    );
  }

  Widget hideOnLargeScreen({
    double breakpoint = 768,
  }) {
    return AdaptiveVisibility(
      breakpoint: breakpoint,
      mode: AdaptiveVisibilityMode.hideAbove,
      child: this,
    );
  }
}

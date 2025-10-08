import 'package:flutter/material.dart';

class ModernAppBar extends StatelessWidget {
  final String title;
  final double expandedHeight;
  final VoidCallback? onBack;
  final Color backgroundColor;
  final TabBar? tabBar;

  const ModernAppBar({
    super.key,
    required this.title,
    this.expandedHeight = 160, // tambah sedikit tinggi
    this.onBack,
    this.backgroundColor = Colors.transparent,
    this.tabBar,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      // surfaceTintColor: AppBarTheme().surfaceTintColor ?? Theme.of(context).colorScheme.primary,
      forceElevated: true,
      elevation: 0,
      pinned: true,
      expandedHeight: expandedHeight,
      leading: IconButton(
        icon:
            Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final t = ((constraints.maxHeight - kToolbarHeight) /
                  (expandedHeight - kToolbarHeight))
              .clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: EdgeInsets.only(
              left: 72,
              bottom: tabBar != null ? 60 : 16,
            ),
            background: Container(
              // color: isDark
              //     ? Colors.grey.shade900
              //     : Colors.white, // solid background
            ),
            title: Transform.translate(
              offset: Offset(-24, 8 * t - 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24 - (4 * (2 - t)),
                  fontWeight: FontWeight.bold,
                  // color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
      bottom: tabBar != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                // color: isDark ? Colors.black : Colors.white,
                child: tabBar!,
              ),
            )
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';


class CustomList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final double separatorHeight;
  final Widget emptyWidget;
  final bool scrollable;
  final double emptyFooterHeight;

  const CustomList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.separatorHeight = 2,
    this.emptyWidget = const EmptyStateWidget(
      size: 60,
      text: "Tidak ada item",
    ),
    this.scrollable = false,
    this.emptyFooterHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return emptyWidget;
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: emptyFooterHeight),
      physics: scrollable
          ? AlwaysScrollableScrollPhysics()
          : NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: separatorHeight),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return SizedBox(height: emptyFooterHeight);
        }
        final item = items[index];
        return itemBuilder(item, index);
      },
    );
  }
}

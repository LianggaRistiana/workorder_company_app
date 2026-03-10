import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

class ReorderableCustomList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final void Function(int oldIndex, int newIndex) onReorder;
  final Widget emptyWidget;
  final EdgeInsets padding;

  const ReorderableCustomList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
    this.padding = EdgeInsets.zero,
    this.emptyWidget = const EmptyStateWidget(
      size: 60,
      text: "Tidak ada item",
    ),
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return emptyWidget;
    if (items.length == 1) return itemBuilder(items.first, 0);

    return ReorderableListView(
      shrinkWrap: true,
      onReorderStart: (_) => FocusScope.of(context).unfocus(),
      physics: const NeverScrollableScrollPhysics(),
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) {
        return RepaintBoundary(
          child: Material(
            color: Colors.transparent,
            elevation: 0,
            child: child,
          ),
        );
      },
      children: [
        for (int i = 0; i < items.length; i++)
          KeyedSubtree(
            key: ValueKey(items[i].hashCode),
            child: itemBuilder(items[i], i),
          ),
      ],
    );
  }
}

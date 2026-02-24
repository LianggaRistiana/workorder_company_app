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

    return ReorderableListView(
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorderStart: (_) => FocusScope.of(context).unfocus(),
      onReorder: onReorder,
      children: [
        for (int index = 0; index < items.length; index++)
          KeyedSubtree(
            key: ValueKey('$index-${items[index]}'),
            child: itemBuilder(items[index], index),
          ),
      ],
    );
  }
}
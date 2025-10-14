import 'package:flutter/material.dart';

class CustomList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final bool isReorderable;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final double separatorHeight;
  final Widget emptyWidget; // opsional, default

  const CustomList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.isReorderable = false,
    this.onReorder,
    this.separatorHeight = 2, // default 2
    this.emptyWidget = const Text('Tidak ada item'), // default
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return emptyWidget;

    if (isReorderable && onReorder != null) {
      return ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onReorder: onReorder!,
        children: [
          for (final item in items)
            KeyedSubtree(
              key: ValueKey(item),
              child: itemBuilder(item),
            )
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: separatorHeight),
      itemBuilder: (context, index) {
        final item = items[index];
        return itemBuilder(item);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

// TODO : refactor all code that use this component

class CustomList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final bool isReorderable;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final double separatorHeight;
  final Widget emptyWidget; // opsional, default
  final bool scrollable;
  final double emptyFooterHeight;

  const CustomList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.isReorderable = false,
    this.onReorder,
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

    if (isReorderable && onReorder != null) {
    
      if (items.length == 1) return itemBuilder(items.first, 0);


      return ReorderableListView(
        shrinkWrap: true,
        onReorderStart: (_) => FocusScope.of(context).unfocus(),
        physics: const NeverScrollableScrollPhysics(),
        onReorder: (oldIndex, newIndex) {
          Logger().i('REORDER START old: $oldIndex new: $newIndex');
          onReorder!(oldIndex, newIndex);
          debugPrint('REORDER END');
        },
        // onReorder: onReorder!,
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
          // for (final item in items)
          for (int i = 0; i < items.length; i++)
            KeyedSubtree(
              key: ValueKey(items[i].hashCode),
              child: itemBuilder(items[i], i),
            ),
        ],
      );
    }

    return ListView.separated(
      // key: ValueKey(items),
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

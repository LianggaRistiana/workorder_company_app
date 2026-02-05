import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

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
      return ReorderableListView(
        shrinkWrap: true,
        onReorderStart: (_) => FocusScope.of(context).unfocus(),
        physics: const NeverScrollableScrollPhysics(),
        onReorder: onReorder!,
        // proxyDecorator: (child, index, animation) {
        //   return Material(
        //     color: Colors.transparent,
        //     elevation: 0,
        //     child: child,
        //   );
        // },
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
          for (final item in items)
            KeyedSubtree(
              key: ValueKey(item),
              child: itemBuilder(item, items.indexOf(item)),
            ),
          // TODO : Remove this
          SizedBox(key: ValueKey('__buttom_space__'), height: emptyFooterHeight)
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

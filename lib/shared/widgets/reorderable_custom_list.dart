import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

class ReorderableCustomList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final void Function(int oldIndex, int newIndex) onReorder;
  final Widget emptyWidget;
  final EdgeInsets padding;

  final Widget? footer;

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
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      padding: padding,
      onReorderStart: (_) => FocusScope.of(context).unfocus(),
      // No NeverScrollableScrollPhysics anymore → list can scroll when needed
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final curved = Curves.easeOut.transform(animation.value);
            return Transform.scale(
              scale: 1.02 + (0.03 * curved),
              child: Opacity(
                opacity: 0.85 - (0.35 * curved), // smoother fade
                child: Material(
                  elevation: 16,
                  shadowColor: Colors.black.withAlpha(40),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: child,
                ),
              ),
            );
          },
          child: child,
        );
      },
      // This is the clean solution for your "add button below the items"
      header: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: emptyWidget,
            )
          : null,
      footer: footer,
      children: [
        for (int i = 0; i < items.length; i++) itemBuilder(items[i], i)
        // KeyedSubtree(
        //   key: ValueKey(itemKeyBuilder?.call(items[i]) ?? i),
        //   child: itemBuilder(items[i], i),
        // ),
      ],
    );
  }
}

// Legacy Code
// import 'package:flutter/material.dart';
// import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

// class ReorderableCustomList<T> extends StatelessWidget {
//   final List<T> items;
//   final Widget Function(T item, int index) itemBuilder;
//   final void Function(int oldIndex, int newIndex) onReorder;
//   final Widget emptyWidget;
//   final EdgeInsets padding;

//   const ReorderableCustomList({
//     super.key,
//     required this.items,
//     required this.itemBuilder,
//     required this.onReorder,
//     this.padding = EdgeInsets.zero,
//     this.emptyWidget = const EmptyStateWidget(
//       size: 60,
//       text: "Tidak ada item",
//     ),
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) return emptyWidget;
//     if (items.length == 1) return itemBuilder(items.first, 0);

//     return ReorderableListView(
//       shrinkWrap: true,
//       onReorderStart: (_) => FocusScope.of(context).unfocus(),
//       physics: const NeverScrollableScrollPhysics(),
//       onReorder: onReorder,
//       proxyDecorator: (child, index, animation) {
//         return RepaintBoundary(
//           child: Material(
//             color: Colors.transparent,
//             elevation: 0,
//             child: child,
//           ),
//         );
//       },
//       children: [
//         for (int i = 0; i < items.length; i++)
//           KeyedSubtree(
//             key: ValueKey(items[i].hashCode),
//             child: itemBuilder(items[i], i),
//           ),
//       ],
//     );
//   }
// }

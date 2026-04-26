import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_back_buttom.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class ListPageScaffold<T> extends StatelessWidget {
  final String title;

  final bool isLoading;
  final String? errorMessage;

  final List<T> items;

  final Future<void> Function() onRefresh;
  final Widget Function(T item) itemBuilder;

  final Widget? floatingActionButton;
  final PreferredSizeWidget? bottomAppBar;
  final Widget? header;
  final List<Widget>? actions;
  final Widget? emptyWidget;

  final String loadingMessage;

  const ListPageScaffold({
    super.key,
    required this.title,
    required this.isLoading,
    required this.items,
    required this.onRefresh,
    required this.itemBuilder,
    this.errorMessage,
    this.floatingActionButton,
    this.bottomAppBar,
    this.header,
    this.emptyWidget,
    this.actions,
    this.loadingMessage = "Memuat...",
  });

  bool get isFirstLoad => isLoading && items.isEmpty;
  bool get isAppending => isLoading && items.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? CustomBackButton() : null,
        title: Text(title),
        actions: actions,
        bottom: bottomAppBar,
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              /// 🔵 HEADER SELALU ADA
              if (header != null)
                SliverToBoxAdapter(
                  child: header!,
                ),

              /// 🔵 loading more indicator (bottom)
              if (isAppending)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: LoadingStateInline(isEndAlign: false),
                  ),
                ),

              /// 🔴 FIRST LOAD
              if (isFirstLoad)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppLoading(message: loadingMessage),
                  ),
                )

              /// 🔴 ERROR STATE
              else if (errorMessage != null && items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorBody(
                    errorMessage: errorMessage!,
                    onRetry: onRefresh,
                  ),
                )

              /// 🔵 EMPTY STATE
              else if (items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: emptyWidget ??
                        const EmptyStateWidget(text: "Tidak ada data"),
                  ),
                )

              /// 🟢 LOADED STATE
              else ...[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return itemBuilder(items[index]);
                    },
                    childCount: items.length,
                  ),
                ),
              ],

              /// bottom spacing (for FAB)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: floatingActionButton != null ? 96 : 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_back_buttom.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';

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

  @override
  Widget build(BuildContext context) {
    final bottomSpacing = floatingActionButton != null ? 96.0 : 24.0;
    Widget content;

    // FIRST LOAD
    if (isLoading && items.isEmpty) {
      content = Center(
        child: AppLoading(
          message: loadingMessage,
        ),
      );
    }

    // ERROR
    else if (errorMessage != null && items.isEmpty) {
      content = ErrorBody(
        errorMessage: errorMessage!,
        onRetry: onRefresh,
      );
    }

    // EMPTY
    else if (items.isEmpty) {
      content = RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (header != null) header!,
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  (header != null ? 0.5 : 0.8),
              child: Center(
                child: emptyWidget ??
                    const EmptyStateWidget(
                      text: "Tidak ada data",
                    ),
              ),
            ),
          ],
        ),
      );
    }

    // LOADED
    // FIXME[High] : Use Listview builder to lazy load and header should shown either loaded or not
    else {
      content = RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: EdgeInsets.only(bottom: bottomSpacing),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            if (header != null) header!,
            ...items.map(itemBuilder),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: context.canPop() ? CustomBackButton() : null,
        title: Text(title),
        actions: actions,
        bottom: bottomAppBar,
      ),
      floatingActionButton: floatingActionButton,
      body: SafeArea(child: content),
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset:
            (isLoading && items.isNotEmpty) ? Offset.zero : const Offset(0, 1),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: (isLoading && items.isNotEmpty) ? 1 : 0,
          child: (isLoading && items.isNotEmpty)
              ? SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 4, bottom: 16, left: 16, right: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black12,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(loadingMessage),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

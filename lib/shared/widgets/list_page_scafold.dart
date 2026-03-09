import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_back_buttom.dart';

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
    this.loadingMessage = "Memuat...",
  });

  @override
  Widget build(BuildContext context) {
    final bottomSpacing = floatingActionButton != null ? 96.0 : 24.0;
    Widget content;

    // 🔥 FIRST LOAD
    if (isLoading && items.isEmpty) {
      content = Center(
        child: AppLoading(
          message: loadingMessage,
        ),
      );
    }

    // ❌ ERROR (hanya jika tidak ada data)
    else if (errorMessage != null && items.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    // 📭 EMPTY
    else if (items.isEmpty) {
      content = RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 200),
            Center(
              child: emptyWidget ?? const Text("Belum ada data."),
            ),
          ],
        ),
      );
    }

    // ✅ LOADED
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
        leading: CustomBackButton(),
        title: Text(title),
        bottom: bottomAppBar,
      ),
      floatingActionButton: floatingActionButton,
      body: content,
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

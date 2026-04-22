import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/utils/get_initials_string_utils.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';

enum WidgetTipe {
  general,
  user,
} // OPTIMIZE : provide item builder rather than this method

// HACK : Move filter mechanism into params for repository responsibility prepare
// If the feature parameters are provided, repository fill pass the params into datasource instead of local filtering
class SelectBottomSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T) onSelect;
  final bool isLoading;
  final String? emptyMessage;

  final WidgetTipe tipe;

  const SelectBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabel,
    required this.onSelect,
    this.isLoading = false,
    this.emptyMessage,
    this.tipe = WidgetTipe.general,
  });

  // === Factory untuk UI berbeda ===
  factory SelectBottomSheet.user({
    // Key? key,
    required String title,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T) onSelect,
    bool isLoading = false,
    String? emptyMessage,
  }) {
    return SelectBottomSheet(
      // key: key,
      title: title,
      items: items,
      itemLabel: itemLabel,
      onSelect: onSelect,
      isLoading: isLoading,
      emptyMessage: emptyMessage,
      tipe: WidgetTipe.user, // <-- beda di sini
    );
  }

  @override
  State<SelectBottomSheet<T>> createState() => _SelectBottomSheetState<T>();
}

class _SelectBottomSheetState<T> extends State<SelectBottomSheet<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    // UI BERBEDA
    if (widget.tipe == WidgetTipe.user) {
      return _buildUserUI();
    }

    // UI GENERAL (UI kamu yang lama)
    return _buildGeneralUI();
  }

  // =======================================================
  // UI GENERAL (UI lama)
  // =======================================================
  Widget _buildGeneralUI() {
    final filteredItems = widget.items
        .where((item) =>
            widget.itemLabel(item).toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: widget.isLoading
                ? const Center(child: AppLoading())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Text(widget.title,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Cari...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        onChanged: (value) {
                          setState(() => _query = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filteredItems.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(widget.emptyMessage ??
                                      'Tidak ada data tersedia.'),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: filteredItems.length,
                                itemBuilder: (_, index) {
                                  final item = filteredItems[index];
                                  return ListTile(
                                    title: Text(widget.itemLabel(item)),
                                    onTap: () => widget.onSelect(item),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  // =======================================================
  // UI USER (contoh tampilan beda)
  // =======================================================
  Widget _buildUserUI() {
    final filteredItems = widget.items
        .where((item) =>
            widget.itemLabel(item).toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Text(widget.title,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Cari...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        onChanged: (value) {
                          setState(() => _query = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filteredItems.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(widget.emptyMessage ??
                                      'Tidak ada data tersedia.'),
                                ),
                              )
                            : ListView.builder(
                                // padding: EdgeInsets.all(0),
                                controller: scrollController,
                                itemCount: filteredItems.length,
                                itemBuilder: (_, index) {
                                  final item = filteredItems[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: CircleAvatar(
                                      child: Text(
                                        widget.itemLabel(item).getInitials(),
                                      ),
                                    ),
                                    title: Text(widget.itemLabel(item)),
                                    onTap: () => widget.onSelect(item),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

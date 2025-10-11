import 'package:flutter/material.dart';

class SelectBottomSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T) onSelect;
  final bool isLoading;
  final String? emptyMessage;

  const SelectBottomSheet({
    super.key,
    required this.title,
    required this.items,
    required this.itemLabel,
    required this.onSelect,
    this.isLoading = false,
    this.emptyMessage,
  });

  @override
  State<SelectBottomSheet<T>> createState() => _SelectBottomSheetState<T>();
}

class _SelectBottomSheetState<T> extends State<SelectBottomSheet<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items
        .where((item) =>
            widget.itemLabel(item).toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5, // setengah layar saat pertama buka
      minChildSize: 0.3,
      maxChildSize: 0.95, // penuh saat di-scroll
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _query = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filteredItems.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    widget.emptyMessage ??
                                        'Tidak ada data tersedia.',
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: filteredItems.length,
                                itemBuilder: (_, index) {
                                  final item = filteredItems[index];
                                  return ListTile(
                                    title: Text(widget.itemLabel(item)),
                                    onTap: () {
                                      widget.onSelect(item);
                                      // Navigator.pop(context);
                                    },
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

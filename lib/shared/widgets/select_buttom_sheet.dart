import 'package:flutter/material.dart';

class SelectBottomSheet<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
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
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(emptyMessage ?? 'Tidak ada data tersedia.'),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(itemLabel(item)),
                            onTap: () {
                              onSelect(item);
                              // Navigator.of(context, rootNavigator: false).pop();
                            },
                          );
                        },
                      ),
                    )
                ],
              ),
      ),
    );
  }
}

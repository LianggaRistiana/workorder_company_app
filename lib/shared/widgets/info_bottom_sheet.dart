import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget content;
  final Widget? header;
  final Widget? footer;

  const AppBottomSheet({
    super.key,
    required this.content,
    this.header,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            if (header != null) ...[
              header!,
              const SizedBox(height: 12),
            ],

            // CONTENT (WAJIB)
            content,

            if (footer != null) ...[
              const SizedBox(height: 24),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

void showAppBottomSheet(
  BuildContext context, {
  required Widget content,
  Widget? header,
  Widget? footer,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => AppBottomSheet(
      header: header,
      content: content,
      footer: footer,
    ),
  );
}

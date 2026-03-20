import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon / Logo
            _notFoundLogo(context),

            const SizedBox(height: 24),

            // Title
            Text(
              'Konten Tidak Ditemukan',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () {
                context.pop();
                // context.showSuccess("Test");
              },
              icon: const Icon(Icons.arrow_back),
              label: Text("Kembali"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notFoundLogo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Icon(
        Icons.warning_rounded,
        size: 24,
      ),
    );
  }
}

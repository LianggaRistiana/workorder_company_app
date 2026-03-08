import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class ForbiddenPage extends StatelessWidget {
  const ForbiddenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon / Logo
            _forbiddenLogo(context),

            const SizedBox(height: 24),

            // Title
            Text(
              'Akses Ditolak',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),

            const SizedBox(height: 8),
            // Description
            Text(
              'Anda tidak punya akses untuk halaman ini.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Back / Home button
            FilledButton(
              onPressed: () {
                context.go(AppRoutes.home);
              },
              child: const Text('Kembali Ke Halaman Beranda'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forbiddenLogo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Icon(
        Icons.block_rounded,
        size: 24,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

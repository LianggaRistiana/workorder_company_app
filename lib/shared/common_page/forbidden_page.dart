import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

class ForbiddenPage extends StatelessWidget {
  const ForbiddenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon / Logo
            Icon(
              Icons.block_rounded,
              size: 96,
              color: Colors.red.shade600,
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              'Access Denied',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              'You do not have permission to access this page.',
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
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

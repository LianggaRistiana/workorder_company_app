import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class ErrorBody extends StatelessWidget {
  final String errorTitle;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ErrorBody({
    super.key,
    this.errorTitle = "OOPS!",
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          child: Icon(
            AppIcon.error,
            size: 24,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(errorTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (errorMessage != null)
          Text(errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium),
        if (onRetry != null) ...[
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text("Coba Lagi"),
          ),
        ]
      ],
    ));
  }
}

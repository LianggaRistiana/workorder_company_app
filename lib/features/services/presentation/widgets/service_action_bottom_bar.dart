import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class ServiceActionBottomBar extends StatelessWidget {
  final bool isLoading;
  const ServiceActionBottomBar({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: isLoading
          ? LoadingState()
          : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    AppIcon.delete,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  )),
              const SizedBox(width: 8),
              FilledButton.icon(
                  onPressed: () {},
                  label: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(AppIcon.activeState),
                    const SizedBox(width: 8),
                    Text("Aktifkan Layanan")
                  ]))
            ]),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Container(
            padding: const EdgeInsets.all(4),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          'Memuat...',
          // style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

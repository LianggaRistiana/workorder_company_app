import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

class FabWorkOrderReject extends StatelessWidget {
  final VoidCallback onPressed;
  const FabWorkOrderReject({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      foregroundColor: Theme.of(context).colorScheme.error,
      onPressed: onPressed,
      child: Icon(AppIcon.reject),
    );
  }
}

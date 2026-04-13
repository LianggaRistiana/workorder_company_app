import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

class FabWorkOrderComplete extends StatelessWidget {
  final VoidCallback onPressed;
  const FabWorkOrderComplete({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        icon: Icon(AppIcon.complete),
        onPressed: onPressed,
        label: Text('Selesaikan'));
  }
}

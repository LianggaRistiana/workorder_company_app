import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

class FabWorkOrderApprove extends StatelessWidget {
  final VoidCallback onPressed;
  const FabWorkOrderApprove({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        icon: Icon(AppIcon.approve),
        onPressed: onPressed,
        label: Text('Setujui'));
  }
}

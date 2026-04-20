import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

class FabWorkReportApprove extends StatelessWidget {
  final VoidCallback onPressed;
  const FabWorkReportApprove({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        icon: Icon(AppIcon.approve),
        onPressed: onPressed,
        label: Text('Setujui'));
  }
}

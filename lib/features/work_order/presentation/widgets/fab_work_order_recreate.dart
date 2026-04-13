import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';

class FabWorkOrderRecreate extends StatelessWidget {
  final VoidCallback onPressed;
  const FabWorkOrderRecreate({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        icon: Icon(AppIcon.recreate),
        onPressed: onPressed,
        label: Text('Buat Ulang'));
  }
}

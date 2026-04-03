import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';

class UserRequesterChip extends StatelessWidget {
  final String name;

  const UserRequesterChip({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      CircleAvatar(
        radius: 12,
        child: Icon(AppIcon.user,
            size: AppRadius.medium, color: colorScheme.primary),
      ),
      const SizedBox(width: 8),
      Text(name),
    ]);
  }
}

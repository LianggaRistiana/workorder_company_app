import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';

class StaffItemEditor extends StatelessWidget {
  final UserEntity staff;
  final bool isPic;
  final ValueChanged<UserEntity>? onRemove;

  const StaffItemEditor({
    super.key,
    required this.staff,
    this.isPic = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primary,
          child: isPic
              ? Icon(AppIcon.pic)
              : Text(
                  staff.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(staff.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall),
              Text(
                staff.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        isPic
            ? const SizedBox.shrink()
            : IconButton(
                iconSize: 20,
                color: Theme.of(context).colorScheme.error,
                onPressed: onRemove == null ? null : () => onRemove!(staff),
                icon: const Icon(AppIcon.remove),
              )
      ],
    );
  }
}

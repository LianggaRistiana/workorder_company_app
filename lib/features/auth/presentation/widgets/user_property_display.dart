import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class UserPropertyDisplay extends StatelessWidget {
  final UserEntity user;

  const UserPropertyDisplay({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: PropertyDisplay(properties: [
        PropertyItem.text(
          label: "Email",
          value: user.email,
        ),
        PropertyItem.widget(
          label: "Role",
          child: _RoleChip(user: user),
        ),
        if (user.position != null)
          PropertyItem.text(
            label: "Departemen",
            value: user.position!.name,
          ),
      ]),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final UserEntity user;

  const _RoleChip({required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        user.position != null
            ? '${user.role.displayName} | ${user.position!.name}'
            : user.role.displayName,
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 12,
        ),
      ),
    );
  }
}

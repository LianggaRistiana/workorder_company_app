import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';

class ProfileUserCard extends StatelessWidget {
  final UserEntity user;

  const ProfileUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(
              user.name.isNotEmpty
                  ? user.name[0].toUpperCase()
                  : "?",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                _RoleChip(user: user),
              ],
            ),
          ),
        ],
      ),
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
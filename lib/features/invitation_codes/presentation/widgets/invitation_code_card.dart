import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/invitation_codes/domain/entities/invitation_code_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';

class InvitationCodeCard extends StatelessWidget {
  final InvitationCodeEntity code;
  final VoidCallback? onTap;

  const InvitationCodeCard({
    super.key,
    required this.code,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ClickableCustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Code + Status chip row
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      AppIcon.invitation,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      code.code,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(isClaimable: code.isClaimable),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(thickness: 0.4, height: 1),
          const SizedBox(height: 12),

          // Info rows
          _InfoRow(
            icon: AppIcon.employee,
            label: 'Peran',
            value: code.roleDisplayName,
          ),
          if (code.position != null) ...[
            const SizedBox(height: 6),
            _InfoRow(
              icon: AppIcon.department,
              label: 'Departemen',
              value: code.position!.name,
            ),
          ],
          const SizedBox(height: 6),
          _InfoRow(
            icon: AppIcon.history,
            label: 'Penggunaan',
            value: code.usageDisplay,
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: AppIcon.date,
            label: 'Kedaluwarsa',
            value: code.localizeExpiresAt(),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isClaimable;

  const _StatusChip({required this.isClaimable});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isClaimable
            ? colorScheme.primaryContainer
            : colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isClaimable ? AppIcon.activeState : AppIcon.inactiveState,
            size: 12,
            color: isClaimable
              ? colorScheme.primary
              : colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 4),
          Text(
            isClaimable ? 'Aktif' : 'Tidak Aktif',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isClaimable
                      ? colorScheme.primary
                      : colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurface.withValues(alpha: 0.5)),
        const SizedBox(width: 6),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

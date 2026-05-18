import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class SubscriptionChip extends StatelessWidget {
  final bool isMember;
  final VoidCallback? onTap;

  const SubscriptionChip({
    super.key,
    required this.isMember,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: isMember ? Colors.white : Colors.grey[800],
      fontWeight: FontWeight.w600,
    );

    final chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMember)
          const Icon(
            AppIcon.activeState,
            size: 16,
            color: Colors.white,
          ),
        if (isMember) const SizedBox(width: AppSpacing.xs),
        Text(
          isMember ? 'Berlangganan' : 'Anda belum berlangganan',
          style: textStyle,
        ),
      ],
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isMember
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.center,
                  colors: [
                    Color(0xFFFFEB97),
                    Color.fromARGB(255, 150, 124, 10),
                  ],
                )
              : null,
          color: isMember ? null : Theme.of(context).disabledColor,
          boxShadow: isMember
              ? [
                  BoxShadow(
                    color: Colors.amber.withAlpha(3),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: chipContent,
      ),
    );
  }
}

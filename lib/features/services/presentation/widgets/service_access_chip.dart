import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class ServiceAccessChip extends StatelessWidget {
  final ServiceAccessType access;
  final bool showIcon;

  const ServiceAccessChip({
    super.key,
    required this.access,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _accessColor(access);
    final icon = _accessIcon(access);
    final label = access.displayName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------
  // Styling Helper
  // ------------------------

  Color _accessColor(ServiceAccessType type) {
    switch (type) {
      case ServiceAccessType.public:
        return Colors.green;
      case ServiceAccessType.memberOnly:
        return Colors.blue;
      case ServiceAccessType.internal:
        return Colors.orange;
    }
  }

  IconData _accessIcon(ServiceAccessType type) {
    switch (type) {
      case ServiceAccessType.public:
        return Icons.public;
      case ServiceAccessType.memberOnly:
        return Icons.verified_user;
      case ServiceAccessType.internal:
        return Icons.lock;
    }
  }
}

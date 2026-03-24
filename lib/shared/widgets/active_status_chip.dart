import 'package:flutter/material.dart';

class ActiveStatusChip extends StatelessWidget {
  final bool isActive;
  final String? label;
  final VoidCallback? onTap;
  final bool showIcon;

  const ActiveStatusChip({
    super.key,
    required this.isActive,
    this.label,
    this.onTap,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final text = label != null
        ? "${label!} ${isActive ? "Aktif" : "Tidak aktif"}"
        : (isActive ? "Aktif" : "Tidak aktif");

    final icon = isActive ? Icons.check_circle : Icons.cancel;
    final iconColor = isActive ? Colors.green : Colors.grey[600];

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color:
              isActive ? Colors.green.withAlpha(30) : Colors.grey.withAlpha(30),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                icon,
                color: iconColor,
                size: 16,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.green : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

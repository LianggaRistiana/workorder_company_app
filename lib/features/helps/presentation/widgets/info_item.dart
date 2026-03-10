import 'package:flutter/material.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final EdgeInsetsGeometry? padding;

  const InfoItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBox(
            icon: icon,
            paddingSize: 8,
            borderRadius: 8,
            iconSize: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

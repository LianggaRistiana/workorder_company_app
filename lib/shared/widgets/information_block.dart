import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';

class InformationBlock extends StatelessWidget {
  final String message;
  final InformationType type;

  InformationBlock(
      {super.key, required this.message, this.type = InformationType.info})
      : assert(message.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    getColor(InformationType type) {
      switch (type) {
        case InformationType.info:
          return Theme.of(context).colorScheme.primary;
        case InformationType.warning:
          return Colors.orange;
        case InformationType.error:
          return Theme.of(context).colorScheme.error;
        case InformationType.success:
          return Colors.green;
        case InformationType.empty:
          return null;
      }
    }

    getColorbackground(InformationType type) {
      switch (type) {
        case InformationType.info:
          return Theme.of(context).colorScheme.primaryContainer;
        case InformationType.warning:
          return Colors.orange.withAlpha(20);
        case InformationType.error:
          return Theme.of(context).colorScheme.errorContainer;
        case InformationType.success:
          return Colors.green.withAlpha(10);
        case InformationType.empty:
          return Theme.of(context).colorScheme.surfaceContainerLow;
      }
    }

    getIcon(InformationType type) {
      switch (type) {
        case InformationType.info:
          return LucideIcons.info;
        case InformationType.warning:
          return LucideIcons.alertTriangle;
        case InformationType.error:
          return Icons.error_outline_rounded;
        case InformationType.success:
          return Icons.check_circle_outline_rounded;
        case InformationType.empty:
          return Icons.info_outline_rounded;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: getColorbackground(type),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            getIcon(type),
            color: getColor(type),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: getColor(type),
                ),
          )),
        ],
      ),
    );
  }

  // Helper
  static InformationBlock info(String message) {
    return InformationBlock(message: message, type: InformationType.info);
  }

  static InformationBlock warning(String message) {
    return InformationBlock(message: message, type: InformationType.warning);
  }

  static InformationBlock success(String message) {
    return InformationBlock(message: message, type: InformationType.success);
  }

  static InformationBlock error(String message) {
    return InformationBlock(message: message, type: InformationType.error);
  }

  static InformationBlock empty(String message) {
    return InformationBlock(message: message, type: InformationType.empty);
  }
}

enum InformationType { info, warning, error, success, empty }

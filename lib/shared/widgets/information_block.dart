import 'package:flutter/material.dart';

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
          return Icons.info_outline_rounded;
        case InformationType.warning:
          return Icons.warning_amber_rounded;
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: getColorbackground(type),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(getIcon(type), color: getColor(type), size: 18),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

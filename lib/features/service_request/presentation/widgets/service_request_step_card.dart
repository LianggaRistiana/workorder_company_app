import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';

class ServiceRequestStepCard extends StatefulWidget {
  final ServiceRequestStatus currentStatus;

  const ServiceRequestStepCard({super.key, required this.currentStatus});

  @override
  State<ServiceRequestStepCard> createState() =>
      _ServiceRequestStepCardAnimatedState();
}

class _ServiceRequestStepCardAnimatedState
    extends State<ServiceRequestStepCard> {
  bool isExpanded = false;

  List<ServiceRequestStatus> getStepOrder() {
    if (widget.currentStatus == ServiceRequestStatus.cancelled ||
        widget.currentStatus == ServiceRequestStatus.rejected) {
      return [
        ServiceRequestStatus.received,
        widget.currentStatus,
      ];
    }
    return [
      ServiceRequestStatus.received,
      ServiceRequestStatus.approved,
      ServiceRequestStatus.completed,
      ServiceRequestStatus.closed,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stepOrder = getStepOrder();

    // OPTIMIZE : follow work order step card for better UI
    return ClickableCustomCard(
      onTap: () => setState(() => isExpanded = !isExpanded),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan AnimatedSwitcher
          Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: !isExpanded
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              _statusColor(widget.currentStatus).withAlpha(50),
                          borderRadius: BorderRadius.circular(20), // chip style
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _statusIcon(widget.currentStatus),
                              color: _statusColor(widget.currentStatus),
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.currentStatus.displayName,
                              style: TextStyle(
                                color: _statusColor(widget.currentStatus),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(key: ValueKey(2)),
              ),
              const Spacer(),
              Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            ],
          ),

          // Step indicator dengan AnimatedContainer
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: stepOrder.map((status) {
                      final isActive = stepOrder.indexOf(status) <=
                          stepOrder.indexOf(widget.currentStatus);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.ende,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? theme.colorScheme.primary
                                      : theme.disabledColor,
                                  shape: BoxShape.circle,
                                ),
                                // child: Icon,
                              ),
                              if (status != stepOrder.last)
                                Container(
                                  width: 1.5,
                                  height: 40,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  color: isActive
                                      ? theme.colorScheme.primary
                                      : theme.disabledColor,
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              status.displayName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : theme.disabledColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // TODO : use color and icon from ui mapper by enum
  Color _statusColor(ServiceRequestStatus status) {
    switch (status) {
      case ServiceRequestStatus.received:
        return Colors.orange;
      case ServiceRequestStatus.approved:
        return Colors.blue;
      case ServiceRequestStatus.onProgress:
        return Colors.amber;
      case ServiceRequestStatus.closed:
        return Colors.blue;
      case ServiceRequestStatus.completed:
        return Colors.green;
      case ServiceRequestStatus.cancelled:
        return Colors.red;
      case ServiceRequestStatus.rejected:
        return Colors.red;
    }
  }

  IconData _statusIcon(ServiceRequestStatus status) {
    switch (status) {
      case ServiceRequestStatus.received:
        return Icons.inbox;

      case ServiceRequestStatus.approved:
        return Icons.check_circle;
      case ServiceRequestStatus.closed:
        return Icons.check_circle;
      case ServiceRequestStatus.onProgress:
        return Icons.scale;

      case ServiceRequestStatus.completed:
        return Icons.done_all;

      case ServiceRequestStatus.cancelled:
        return Icons.cancel;

      case ServiceRequestStatus.rejected:
        return Icons.block;
    }
  }
}

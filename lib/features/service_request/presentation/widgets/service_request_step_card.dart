import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
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
      ServiceRequestStatus.workOrderCreated,
      ServiceRequestStatus.completed,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stepOrder = getStepOrder();

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
                    ? Row(
                        key: const ValueKey(1),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _statusIcon(widget.currentStatus),
                              size: 18,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.currentStatus.displayName,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : const SizedBox(key: ValueKey(2)),
              ),
              const Spacer(),
              Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            ],
          ),

          // Step indicator dengan AnimatedContainer
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: stepOrder.map((status) {
                      final isActive = stepOrder.indexOf(status) <=
                          stepOrder.indexOf(widget.currentStatus);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              ),
                              if (status != stepOrder.last)
                                Container(
                                  width: 1.5,
                                  height: 40,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                                color:
                                    isActive ? Colors.black : Colors.grey[500],
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

  IconData _statusIcon(ServiceRequestStatus status) {
    switch (status) {
      case ServiceRequestStatus.received:
        return Icons.inbox;

      case ServiceRequestStatus.approved:
        return Icons.check_circle;

      case ServiceRequestStatus.workOrderCreated:
        return Icons.article; // atau Icons.playlist_add_check

      case ServiceRequestStatus.completed:
        return Icons.done_all;

      case ServiceRequestStatus.cancelled:
        return Icons.cancel;

      case ServiceRequestStatus.rejected:
        return Icons.block;
    }
  }
}

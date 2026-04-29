import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_status_date_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/ui_mappers.dart/service_request_status_color_mapper.dart';
import 'package:workorder_company_app/features/service_request/presentation/ui_mappers.dart/service_request_status_icon_mapper.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';

class ServiceRequestStepCard extends StatefulWidget {
  final ServiceRequestStatus currentStatus;
  final ServiceRequestStatusDateEntity statusDate;

  const ServiceRequestStepCard({
    super.key,
    required this.currentStatus,
    required this.statusDate,
  });

  @override
  State<ServiceRequestStepCard> createState() =>
      _ServiceRequestStepCardAnimatedState();
}

class _ServiceRequestStepCardAnimatedState
    extends State<ServiceRequestStepCard> {
  bool isExpanded = false;

  List<ServiceRequestStatus> getStepOrder() {
    const defaultFlow = [
      ServiceRequestStatus.received,
      ServiceRequestStatus.approved,
      ServiceRequestStatus.onProgress,
      ServiceRequestStatus.completed,
      ServiceRequestStatus.closed,
    ];

    const terminalStates = [
      ServiceRequestStatus.rejected,
      ServiceRequestStatus.cancelled,
      ServiceRequestStatus.partiallyCompleted,
      ServiceRequestStatus.unProcessable,
    ];

    if (terminalStates.contains(widget.currentStatus)) {
      final statusMap = {
        ServiceRequestStatus.received: widget.statusDate.createdAt,
        ServiceRequestStatus.approved: widget.statusDate.approvedAt,
        ServiceRequestStatus.rejected: widget.statusDate.rejectedAt,
        ServiceRequestStatus.onProgress: widget.statusDate.onProgressAt,
        ServiceRequestStatus.completed: widget.statusDate.completedAt,
        ServiceRequestStatus.cancelled: widget.statusDate.cancelledAt,
        ServiceRequestStatus.partiallyCompleted:
            widget.statusDate.partiallyCompletedAt,
        ServiceRequestStatus.unProcessable: widget.statusDate.unProcessableAt,
        ServiceRequestStatus.closed: widget.statusDate.unProcessableAt,
      };

      final entries = statusMap.entries.where((e) => e.value != null).toList()
        ..sort((a, b) => a.value!.compareTo(b.value!));
      return entries.map((e) => e.key).toList();
    }
    return defaultFlow;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = getStepOrder();
    final currentIndex = steps.indexOf(widget.currentStatus);

    return ClickableCustomCard(
      borderColor: Colors.transparent,
      elevation: 0,
      onTap: () => setState(() => isExpanded = !isExpanded),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.currentStatus.color.withAlpha(15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: widget.currentStatus.color.withAlpha(3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.currentStatus.icon,
                              color: widget.currentStatus.color,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.currentStatus.displayName,
                              style: TextStyle(
                                color: widget.currentStatus.color,
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
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: List.generate(steps.length, (index) {
                      final status = steps[index];
                      final isActive = index <= currentIndex;
                      final isLineActive = index < currentIndex;

                      final date = widget.statusDate.getDateString(status);

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 24, // area tetap
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (index == currentIndex) ...[
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isActive
                                          ? status.color.withAlpha(15)
                                          : theme.disabledColor.withAlpha(1),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        status.icon,
                                        size: 12,
                                        color: isActive
                                            ? status.color
                                            : theme.disabledColor,
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isActive
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : theme.disabledColor,
                                    ),
                                  ),
                                ],
                                if (index != steps.length - 1)
                                  Container(
                                    width: 2,
                                    height: 40,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    color: isLineActive
                                        ? Theme.of(context).colorScheme.primary
                                        : theme.disabledColor,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  status.displayName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isActive
                                        ? index == currentIndex
                                            ? status.color
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary
                                        : theme.disabledColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  date,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

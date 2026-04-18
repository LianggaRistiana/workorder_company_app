import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/work_order_enum.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_status_date_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';

class WorkOrderStatusStepCard extends StatefulWidget {
  final WorkOrderStatus currentStatus;
  final WorkOrderStatusDateEntity statusDate;

  const WorkOrderStatusStepCard({
    super.key,
    required this.currentStatus,
    required this.statusDate,
  });

  @override
  State<WorkOrderStatusStepCard> createState() => _WorkOrderStepCardState();
}

class _WorkOrderStepCardState extends State<WorkOrderStatusStepCard> {
  bool isExpanded = false;

  List<WorkOrderStatus> _stepOrder() {
    const defaultFlow = [
      WorkOrderStatus.drafted,
      WorkOrderStatus.sent,
      WorkOrderStatus.approved,
      WorkOrderStatus.onProgress,
      WorkOrderStatus.completed,
    ];

    const terminalStates = [
      WorkOrderStatus.rejected,
      WorkOrderStatus.cancelled,
      WorkOrderStatus.failed,
    ];

    if (terminalStates.contains(widget.currentStatus)) {
      final statusMap = {
        WorkOrderStatus.drafted: widget.statusDate.createdAt,
        WorkOrderStatus.sent: widget.statusDate.sentAt,
        WorkOrderStatus.approved: widget.statusDate.approvedAt,
        WorkOrderStatus.rejected: widget.statusDate.rejectedAt,
        WorkOrderStatus.onProgress: widget.statusDate.startedAt,
        WorkOrderStatus.completed: widget.statusDate.completedAt,
        WorkOrderStatus.cancelled: widget.statusDate.cancelledAt,
        WorkOrderStatus.failed: widget.statusDate.failedAt,
      };

      final entries = statusMap.entries.where((e) => e.value != null).toList()
        ..sort((a, b) => a.value!.compareTo(b.value!));

      return entries.map((e) => e.key).toList();
    }

    // final currentIndex = defaultFlow.indexOf(widget.currentStatus);

    // if (currentIndex == -1) {
    //   return defaultFlow;
    // }

    // return defaultFlow.sublist(0, currentIndex + 1);
    return defaultFlow;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = _stepOrder();
    final currentIndex = steps.indexOf(widget.currentStatus);

    return ClickableCustomCard(
      borderColor: Colors.transparent,
      elevation: 0,
      onTap: () => setState(() => isExpanded = !isExpanded),
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: !isExpanded
                    ? _statusChip(widget.currentStatus)
                    : const SizedBox.shrink(),
              ),
              const Spacer(),
              Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            ],
          ),

          const SizedBox(height: 8),

          /// STEPS
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Column(
                    children: List.generate(steps.length, (index) {
                      final status = steps[index];
                      final isActive = index <= currentIndex;

                      final date = widget.statusDate.getDateString(status);

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 4,
                                ),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive
                                      ? Theme.of(context).primaryColor
                                      : theme.disabledColor,
                                ),
                              ),
                              if (index != steps.length - 1)
                                Container(
                                  width: 2,
                                  height: 40,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  color: isActive
                                      ? Theme.of(context).primaryColor
                                      : theme.disabledColor,
                                ),
                            ],
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
                                        ? Theme.of(context).primaryColor
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

  Widget _statusChip(WorkOrderStatus status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(status), color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.drafted:
        return Colors.grey;
      case WorkOrderStatus.sent:
        return Colors.blue;
      case WorkOrderStatus.approved:
        return Colors.indigo;
      case WorkOrderStatus.onProgress:
        return Colors.orange;
      case WorkOrderStatus.completed:
        return Colors.green;
      case WorkOrderStatus.rejected:
        return Colors.red;
      case WorkOrderStatus.cancelled:
        return Colors.redAccent;
      case WorkOrderStatus.failed:
        return Colors.deepOrange;
    }
  }

  IconData _statusIcon(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.drafted:
        return Icons.edit_note;
      case WorkOrderStatus.sent:
        return Icons.send;
      case WorkOrderStatus.approved:
        return Icons.verified;
      case WorkOrderStatus.onProgress:
        return Icons.engineering;
      case WorkOrderStatus.completed:
        return Icons.task_alt;
      case WorkOrderStatus.rejected:
        return Icons.block;
      case WorkOrderStatus.cancelled:
        return Icons.cancel;
      case WorkOrderStatus.failed:
        return Icons.error;
    }
  }
}

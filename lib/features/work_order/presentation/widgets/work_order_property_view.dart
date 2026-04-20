import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_status_step_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class WorkOrderPropertyView extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final bool isFullView;

  const WorkOrderPropertyView.fullView({
    super.key,
    required this.workOrder,
  }) : isFullView = true;

  const WorkOrderPropertyView.shortView({
    super.key,
    required this.workOrder,
  }) : isFullView = false;

  @override
  Widget build(BuildContext context) {
    return isFullView ? _FullView(workOrder) : _SummaryView(workOrder);
  }
}

class _FullView extends StatelessWidget {
  final WorkOrderEntity workOrder;

  const _FullView(
    this.workOrder,
  );

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: PropertyDisplay(properties: [
        PropertyItem.text(
          icon: AppIcon.code,
          label: "Kode",
          value: workOrder.code,
        ),
        PropertyItem.text(
          icon: AppIcon.service,
          label: "Layanan",
          value: workOrder.service.title,
        ),
        PropertyItem.text(
            icon: AppIcon.user,
            label: "Dibuat oleh",
            value: workOrder.createdBy?.name ?? 'Sistem'),
        PropertyItem.text(
            icon: AppIcon.pic,
            label: "Penanggung Jawab",
            value: workOrder.staffPic?.name ?? '-'),
        PropertyItem.widget(
          icon: AppIcon.step,
          label: "Status",
          child: WorkOrderStatusStepCard(
              currentStatus: workOrder.status,
              statusDate: workOrder.statusDate),
        )
      ]),
    );
  }
}

class _SummaryView extends StatelessWidget {
  final WorkOrderEntity workOrder;

  const _SummaryView(
    this.workOrder,
  );

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: PropertyDisplay(properties: [
        PropertyItem.text(
          icon: AppIcon.code,
          label: "Kode",
          value: workOrder.code,
        ),
        PropertyItem.text(
          icon: AppIcon.service,
          label: "Layanan",
          value: workOrder.service.title,
        ),
      ]),
    );
  }
}

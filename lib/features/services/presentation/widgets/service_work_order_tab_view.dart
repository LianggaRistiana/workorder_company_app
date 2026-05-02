import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services/domain/entities/work_order_config_entity.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_work_order_item_view.dart';

class ServiceWorkOrderTabView extends StatelessWidget {
  final FormShowType formShowType;
  final List<WorkOrderConfigEntity> configs;
  const ServiceWorkOrderTabView({
    super.key,
    required this.configs,
    this.formShowType = FormShowType.formDetailPage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...configs.map((config) => ServiceWorkOrderItemView(
                config: config,
                formShowType: formShowType,
              ))
        ]),
      ),
    );
  }
}

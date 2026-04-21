import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/recreate/recreate_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/recreate/recreate_work_order_state.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class FabWorkOrderRecreate extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final WorkOrderCapabilities? capabilities;

  const FabWorkOrderRecreate(
      {super.key, required this.workOrder, required this.capabilities});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecreateWorkOrderCubit, RecreateWorkOrderState>(
        builder: (context, state) {
      return FloatingActionButton.extended(
              icon: Icon(AppIcon.recreate),
              onPressed: () {
                _showDialog(context, () {
                  context
                      .read<RecreateWorkOrderCubit>()
                      .recreateWorkOrder(workOrder);
                });
              },
              label: Text('Buat Ulang'))
          .withInlineLoading(state.status == RecreateWorkOrderStatus.loading);
    }).require(
        WorkOrderAuthorizer(workOrder: workOrder, capabilities: capabilities)
            .recreateWorkOrder);
  }

  void _showDialog(BuildContext context, VoidCallback onSubmit) {
    showAppDialog(
      context,
      header: Row(
        children: [
          IconBox.small(icon: AppIcon.recreate),
          const SizedBox(width: 8),
          const Text("Buat ulang perintah kerja"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InformationBlock.info(
              "Perintah kerja yang ditolak dapat dibuat ulang untuk penyusunan kembali."),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => context.pop(),
            child: const Text("Batal"),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              onSubmit();
            },
            child: const Text("Buat Ulang"),
          ),
        ],
      ),
    );
  }
}

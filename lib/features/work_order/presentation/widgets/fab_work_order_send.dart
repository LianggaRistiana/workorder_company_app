import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/send/send_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/send/send_work_order_state.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class FabWorkOrderSend extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final WorkOrderCapabilities? capabilities;

  const FabWorkOrderSend(
      {super.key, required this.workOrder, this.capabilities});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendWorkOrderCubit, SendWorkOrderState>(
        builder: (context, state) {
      return FloatingActionButton.extended(
        heroTag: null,
        icon: Icon(AppIcon.send),
        onPressed: () {
          _showDialog(context, () {
            context.read<SendWorkOrderCubit>().sendWorkOrder(workOrder);
          });
        },
        label: Text('Kirim'),
      ).withInlineLoading(
        state.status == SendWorkOrderStatus.loading,
      );
    }).require(
      WorkOrderAuthorizer(
        workOrder: workOrder,
        capabilities: capabilities,
      ).sendWorkOrder,
    );
  }

  void _showDialog(BuildContext context, VoidCallback onPressed) {
    showAppDialog(
      context,
      header: Row(
        children: [
          IconBox.small(icon: AppIcon.send),
          const SizedBox(width: 8),
          const Text("Kirim Perintah Kerja"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InformationBlock.info(workOrder.approvalAccess ==
                  WorkOrderAprrovalAccess.auto
              ? "Perintah kerja akan langsung dikirim kepada pegawai yang ditugaskan untuk dikerjakan."
              : "Perintah kerja akan dikirim kepada pegawai yang ditugaskan untuk ditinjau."),
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
              onPressed();
            },
            child: const Text("Kirim"),
          ),
        ],
      ),
    );
  }
}
